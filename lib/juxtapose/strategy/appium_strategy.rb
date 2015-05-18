module Juxtapose
  class AppiumStrategy
    attr_accessor :context
    attr_accessor :project_root
    def self.setup
      Cucumber::RbSupport::RbDsl.register_rb_hook('before', [], Proc.new {|scenario, block| @__scenario = scenario })
    end

    def initialize(context)
      self.context = context
    end

    def spec_dir
      "features/screens"
    end

    def device_name
      context.driver_attributes[:caps][:deviceName].gsub(" ","-").downcase
    end

    def version
      context.driver_attributes[:caps][:platformVersion]
    end

    def current_spec_description
      context.instance_variable_get('@__scenario').name
    end

    def save_current(filename)
      context.screenshot(filename)
    end
  end
end
