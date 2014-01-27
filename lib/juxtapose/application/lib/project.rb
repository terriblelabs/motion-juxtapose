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

  attr_accessor :directories
  def initialize(directories)
    self.directories = Array(directories)
  end

  def specs
    spec_dirs.map do |root, dirs|
      next if dirs.empty?
      dirs.map do |dir|
        Spec.new root, dir
      end
    end.compact.flatten
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
    dirs = {}
    directories.each do |directory|
      dirs[directory] = Dir.glob(File.join(directory, '**/*.png')).map do |file|
        Dir[File.dirname(file)]
      end.flatten.uniq
    end
    dirs
  end
end
