module Juxtapose
  class FrankStrategy
    def self.setup
      Cucumber::RbSupport::RbDsl.register_rb_hook('before', [], Proc.new {|scenario, block| @__scenario = scenario })
    end

    attr_accessor :context
    def initialize(context)
      self.context = context
    end

    def version
      @version ||= "ios_#{context.app_exec("ios_version").first}"
    end

    def current_spec_description
      context.instance_variable_get('@__scenario').name
    end

    def retina?
      width > 320
    end

    def save_current(filename)
      context.frankly_screenshot(filename, nil, false)
    end

    private
    def server
      @_server ||= Frank::Cucumber::Gateway.new( context.base_server_url )
    end

    def resolution
      @resolution ||= JSON.parse(server.send_get('resolution'))
    end

    def width
      resolution['width']
    end

    def height
      resolution['height']
    end
  end
end
