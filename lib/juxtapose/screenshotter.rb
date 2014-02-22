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

  def it_should_look_like(template, fuzz_factor = 0)
    Screenshotter.new(self, template, fuzz_factor).attempt_verify(MAX_ATTEMPTS).should.be.true
  end

  class Screenshotter
    M_PI = Math::PI
    M_PI_2 = Math::PI / 2

    attr_reader :context
    attr_reader :strategy
    attr_reader :template
    attr_reader :fuzz_factor

    def initialize(context, template, fuzz_factor = 0)
      @context = context
      @template = template.gsub(' ', '-')
      @strategy = strategy_for_context(context)
      @fuzz_factor = fuzz_factor
    end

    def strategy_for_context(context)
      if defined?(::Bacon::Context) && context.is_a?(::Bacon::Context)
        Juxtapose::MacBaconStrategy.new(context)
      elsif context.respond_to? :frankly_ping
        Juxtapose::FrankStrategy.new(context)
      end
    end

    def project_root
      ENV["RUBYMOTION_PROJECT_DIR"]
    end

    def test_name
      strategy.current_spec_description.downcase.gsub(/ /, '-').gsub(/[^\w-]/, '')
    end

    def dir
      @dir ||= File.join(project_root,
                         strategy.spec_dir,
                         strategy.device_name,
                         strategy.version,
                         test_name,
                         template).tap do |dir|
        `mkdir -p #{dir}`
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
      attempts = 0
      while attempts < max_attempts
        return true if verify
        attempts += 1
        sleep 0.25
      end
      raise "Screenshot did not match '#{template}'"
    end

    def verify
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

    private

    def same_size?
      identify_command = "identify -format '%wx%h '"
      out = `#{identify_command} \"#{filename :current}\" \"#{filename :accepted}\" 2>&1`
      sizes = out.split
      sizes.length == 2 && sizes.uniq.length == 1
    end

    def screenshots_match?
      match = true
      compare_command = "compare -fuzz #{fuzz_factor}% -metric AE -dissimilarity-threshold 1 -subimage-search"
      out = `#{compare_command} \"#{filename :current}\" \"#{filename :accepted}\" \"#{filename :diff}\" 2>&1`
      out.chomp!
      (out == '0').tap do |verified|
        if verified
          `rm #{filename(:current)}`
          `rm #{filename(:diff)}`
        else
          match = false
        end
      end
      match
    end
  end
end
