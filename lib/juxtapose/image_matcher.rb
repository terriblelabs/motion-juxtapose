class ImageMatcher
  attr_reader :fuzz_factor, :diff_file_name
  def initialize(options={})
    @fuzz_factor = options.fetch(:fuzz_factor, 0)
    @diff_file_name = options.fetch(:diff_file_name, './temp.png')
  end

  def identical?(source, target)
    compare_command = "compare -fuzz #{fuzz_factor}% -metric AE -dissimilarity-threshold 1 -subimage-search"
    out = `#{compare_command} \"#{source}\" \"#{target}\" \"#{diff_file_name}\" 2>&1`
    out.chomp!
    out.start_with?('0')
  end

  def cleanup
    if File.exist?(diff_file_name)
      `rm #{diff_file_name}`
    end
  end
end

