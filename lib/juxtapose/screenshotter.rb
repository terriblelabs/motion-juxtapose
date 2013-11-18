class Juxtapose
  def self.it_should_look_like(template)
    Screenshotter.new(self, template).verify.should === true
  end

  class Screenshotter
    M_PI = Math::PI
    M_PI_2 = Math::PI / 2

    attr_reader :context
    attr_reader :template

    def initialize(context, template)
      @context = context
      @template = template
    end

    def resolution
      @resolution ||= UIScreen.mainScreen.bounds
    end

    def version
      @version ||= "ios_#{Device.ios_version}"
    end

    def width
      resolution.width
    end

    def height
      resolution.height
    end

    def dir
      @dir ||= "#{File.dirname(__FILE__)}/../../spec/screens/#{version}/#{template}".tap do |dir|
        `mkdir -p #{dir}`
      end
    end

    def filename(base)
      raise "unknown filename" unless [:current, :accepted, :diff].include?(base)
      components = [base]
      components << timestamp unless base == :accepted
      components += ["#{width}x#{height}", "png"]

      File.join dir, components.join('.')
    end

    def timestamp
      @timestamp ||= Time.now.to_f.to_s.gsub(/\./, '')
    end

    def save_current
      application = UIApplication.sharedApplication
      windows = application.windows

      currentOrientation = application.statusBarOrientation

      scale = UIScreen.mainScreen.scale
      size = UIScreen.mainScreen.bounds.size

      if [:landscape_right, :landscape_left].include?(Device.orientation)
        size = CGSizeMake(size.height, size.width);
      end

      UIGraphicsBeginImageContextWithOptions(size, false, scale)
      context = UIGraphicsGetCurrentContext()

      if currentOrientation == UIInterfaceOrientationLandscapeLeft
        CGContextTranslateCTM(context, size.width / 2.0, size.height / 2.0)
        CGContextRotateCTM(context, M_PI_2)
        CGContextTranslateCTM(context, - size.height / 2.0, - size.width / 2.0)
      elsif currentOrientation == UIInterfaceOrientationLandscapeRight
        CGContextTranslateCTM(context, size.width / 2.0, size.height / 2.0)
        CGContextRotateCTM(context, -M_PI_2)
        CGContextTranslateCTM(context, - size.height / 2.0, - size.width / 2.0)
      elsif currentOrientation == UIInterfaceOrientationPortraitUpsideDown
        CGContextTranslateCTM(context, size.width / 2.0, size.height / 2.0)
        CGContextRotateCTM(context, M_PI)
        CGContextTranslateCTM(context, -size.width / 2.0, -size.height / 2.0)
      end

      windows.each do |window|
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, window.center.x, window.center.y)
        CGContextConcatCTM(context, window.transform)
        CGContextTranslateCTM(context,
                              - window.bounds.size.width * window.layer.anchorPoint.x,
                              - window.bounds.size.height * window.layer.anchorPoint.y)

        window.layer.presentationLayer.renderInContext(UIGraphicsGetCurrentContext())

        CGContextRestoreGState(context)
      end

      image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      UIImagePNGRepresentation(image).writeToFile(filename(:current), atomically: true)
    end

    def accept_current
      `cp #{filename(:current)} #{filename(:accepted)}`
    end

    def verify
      save_current
      accept_current if ENV['ACCEPT_ALL_SCREENSHOTS']

      success = true
      if File.exists? filename(:accepted )
        compare_command = "compare -metric AE -dissimilarity-threshold 1 -subimage-search"
        out = `#{compare_command} \"#{filename :current}\" \"#{filename :accepted}\" \"#{filename :diff}\" 2>&1`
        out.chomp!
        (out == '0').tap do |verified|
          if verified
            `rm #{filename(:current)}`
            `rm #{filename(:diff)}`
          else
            success = false
            puts "Screenshot verification failed (current: #{filename :current}, diff: #{filename :diff})"
          end
        end
      else
        raise "No accepted screen shot for #{filename :accepted}"
      end

      success
    end
  end
end
