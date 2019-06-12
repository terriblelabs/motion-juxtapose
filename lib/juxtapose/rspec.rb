if defined?(RSpec) && defined?(RSpec::Matchers)
  RSpec::Matchers.define :look_like do |expected, options={}|
    match do |actual|
      if actual.respond_to?(:looks_like?)
        actual.looks_like?(expected, options[:fuzz_factor]) == true
      else
        matcher = ImageMatcher.new(options)
        matcher.identical?(expected, actual).tap do
          matcher.cleanup
        end
      end
    end
  end
end
