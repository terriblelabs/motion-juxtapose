if defined?(RSpec::Matchers)
  RSpec::Matchers.define :look_like do |predicate|
    match do |page|
      page.looks_like?(predicate) == true
    end
  end
end
