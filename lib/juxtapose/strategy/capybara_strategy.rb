if defined?(Capybara)
  module Juxtapose
    class CapybaraStrategy

      attr_accessor :context
      def initialize(context)
        self.context = context
      end

      def version
        @version ||= "web"
      end

      def current_spec_description
        "spec-description"
        #context.instance_variable_get('@__scenario').name
      end

      def device_name
        "capybara"
      end

      def save_current(filename)
        Capybara.save_screenshot filename
      end

      def spec_dir
        "spec/screens"
      end

    end
  end
end
