if defined?(Capybara::Session)
  class Capybara::Session
    include Juxtapose
  end
end
