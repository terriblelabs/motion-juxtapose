if defined?(RSpec::Matchers)
  RSpec::Matchers.define :look_like do |expected|
    match do |actual|
      if actual.respond_to?(:looks_like?)
        actual.looks_like?(expected) == true
      else
        ImageMatcher.new.identical?(expected, actual)
      end
    end
  end
end
