class Project
  def self.accept!(filename)
    dir, name = File.split(filename)
    new_name = File.join(dir, name.sub(/current/, 'accepted'))
    FileUtils.mv(filename, new_name)

    diff_file = File.join(dir, name.sub(/current/, 'diff'))
    if File.exists? diff_file
      FileUtils.rm(diff_file)
    end
    new_name
  end

  attr_accessor :directory
  def initialize(directory)
    self.directory = directory
  end

  def specs
    spec_dirs.map do |dir|
      Spec.new directory, dir
    end
  end

  def to_json
    as_json.to_json
  end

  def as_json
    {
      specs: specs.map(&:as_json)
    }
  end

  private
  def spec_dirs
    dirs = Dir.glob(File.join(directory, '**/*.png')).map do |file|
      File.dirname(file)
    end

    dirs.uniq.select do |f|
      Dir[File.join(f, "*.png")].any?
    end
  end
end
