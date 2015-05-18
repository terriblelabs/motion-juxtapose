module Juxtapose
  def self.extended(base)
    if defined?(::Bacon::Specification)
      ::Bacon::Specification.class_eval do
        @@juxtapatched ||= nil

        unless @@juxtapatched
          alias_method :original_run_spec_block, :run_spec_block
          @@juxtapatched = true

          def run_spec_block
            Thread.current["CURRENT_SPEC_DESCRIPTION"] = @description
            original_run_spec_block
          end
        end
      end
    end
  end

  MAX_ATTEMPTS = 20

  def looks_like?(template, fuzz_factor=0)
    Screenshotter.new(self, template, fuzz_factor).attempt_verify(MAX_ATTEMPTS)
  end

  def it_should_look_like(template, fuzz_factor = 0)
    looks_like?(template, fuzz_factor).should.be.true
  end

  class Screenshotter
    M_PI = Math::PI
    M_PI_2 = Math::PI / 2

    attr_reader :context
    attr_reader :strategy
    attr_reader :template
    attr_reader :fuzz_factor
    attr_accessor :project_root

    def initialize(context, template, fuzz_factor = 0, project_root = nil)
      @context = context
      @template = template.gsub(' ', '-')
      @strategy = strategy_for_context(context)
      @fuzz_factor = fuzz_factor
      @project_root = project_root || default_project_root
    end

    def strategy_for_context(context)
      if defined?(::Bacon::Context) && context.is_a?(::Bacon::Context)
        Juxtapose::MacBaconStrategy.new(context)
      elsif context.respond_to? :frankly_ping
        Juxtapose::FrankStrategy.new(context)
      elsif defined?(Capybara)
        Juxtapose::CapybaraStrategy.new(context)
      elsif defined?(Appium)
        Juxtapose::AppiumStrategy.new(context)
      end
    end

    def default_project_root
      if defined? Rails
        Rails.root
      else
        ENV["RUBYMOTION_PROJECT_DIR"]
      end
    end

    def test_name
      strategy.current_spec_description.downcase.gsub(/ /, '-').gsub(/[^\w-]/, '')
    end

    def dir
      @dir ||= begin
        parts = [
          project_root,
          strategy.spec_dir,
          strategy.device_name,
          strategy.version,
          test_name,
          template
        ].map {|p| p.to_s.gsub(/ /, '-')}

        File.join(*parts).tap do |dir|
          `mkdir -p #{dir}`
        end
      end
    end

    def filename(base)
      raise "unknown filename" unless [:current, :accepted, :diff].include?(base)
      File.join dir, [base, "png"].join('.')
    end

    def timestamp
      @timestamp ||= Time.now.to_f.to_s.gsub(/\./, '')
    end

    def accept_current
      `cp #{filename(:current)} #{filename(:accepted)}`
    end

    def attempt_verify(max_attempts)
      ensure_imagemagick_installed

      attempts = 0
      while attempts < max_attempts
        return true if verify
        attempts += 1
        sleep 0.25
      end
      raise "Screenshot did not match '#{template}'"
    end

    def verify
      ensure_imagemagick_installed

      strategy.save_current filename(:current)
      accept_current if ENV['ACCEPT_ALL_SCREENSHOTS']

      success = true
      if File.exists? filename(:accepted )
        raise "Screenshots are different sizes" unless same_size?
        success = screenshots_match?
      else
        raise "No accepted screen shot for #{filename :accepted}"
      end

      success
    end

    def ensure_imagemagick_installed
      unless imagemagick_installed?
        raise "Executable for 'convert' not installed or not found on $PATH. Please install Imagemagick or add it to your $PATH."
      end
    end

    def imagemagick_installed?
      if RUBY_PLATFORM =~ /darwin/
        `command -v convert`
      else
        `which convert`
      end
      $?.success?
    end

    private

    def same_size?
      identify_command = "identify -format '%wx%h '"
      out = `#{identify_command} \"#{filename :current}\" \"#{filename :accepted}\" 2>&1`
      sizes = out.split
      sizes.length == 2 && sizes.uniq.length == 1
    end

    def create_diff
      `compare -fuzz #{fuzz_factor}% -dissimilarity-threshold 1 -subimage-search \"#{filename :current}\" \"#{filename :accepted}\" \"#{filename :diff}\" 2>&1`
    end

    def cleanup
      `rm #{filename(:current)}`
      `rm #{filename(:diff)}`
    end

    def identical_images?
      matcher = ImageMatcher.new(fuzz_factor: fuzz_factor, diff_file_name: filename(:diff))
      matcher.identical?(filename(:current), filename(:accepted))
    end

    def screenshots_match?
      if identical_images?
        cleanup
        true
      else
        create_diff
        false
      end
    end
  end
end
