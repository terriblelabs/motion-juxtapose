module Juxtapose
  class MacBaconStrategy
    attr_accessor :context
    def initialize(context)
      self.context = context
    end

    def version
      @version ||= "ios_#{UIDevice.currentDevice.systemVersion}"
    end

    def current_spec_description
      "#{context.name}-#{Thread.current["CURRENT_SPEC_DESCRIPTION"]}"
    end

    def device_name
      UIDevice.currentDevice.name.split(' ').join('-').downcase
    end

    def save_current(filename)
      application = UIApplication.sharedApplication
      windows = application.windows

      currentOrientation = application.statusBarOrientation

      scale = UIScreen.mainScreen.scale
      size = UIScreen.mainScreen.bounds.size

      if [UIInterfaceOrientationLandscapeLeft, UIInterfaceOrientationLandscapeRight].include? currentOrientation
        size = CGSizeMake(size.height, size.width);
      end

      UIGraphicsBeginImageContextWithOptions(size, false, scale)
      context = UIGraphicsGetCurrentContext()

      if currentOrientation == UIInterfaceOrientationLandscapeLeft
        CGContextTranslateCTM(context, size.width / 2.0, size.height / 2.0)
        CGContextRotateCTM(context, (Math::PI/2))
        CGContextTranslateCTM(context, - size.height / 2.0, - size.width / 2.0)
      elsif currentOrientation == UIInterfaceOrientationLandscapeRight
        CGContextTranslateCTM(context, size.width / 2.0, size.height / 2.0)
        CGContextRotateCTM(context, -(Math::PI/2))
        CGContextTranslateCTM(context, - size.height / 2.0, - size.width / 2.0)
      elsif currentOrientation == UIInterfaceOrientationPortraitUpsideDown
        CGContextTranslateCTM(context, size.width / 2.0, size.height / 2.0)
        CGContextRotateCTM(context, Math::PI)
        CGContextTranslateCTM(context, -size.width / 2.0, -size.height / 2.0)
      end

      windows.each do |window|

        CGContextSaveGState(context)
        CGContextTranslateCTM(context, window.center.x, window.center.y)
        CGContextConcatCTM(context, window.transform)
        CGContextTranslateCTM(context,
                              - window.bounds.size.width * window.layer.anchorPoint.x,
                              - window.bounds.size.height * window.layer.anchorPoint.y)

        window.drawViewHierarchyInRect(window.bounds, afterScreenUpdates:true)

        CGContextRestoreGState(context)
      end

      image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      UIImagePNGRepresentation(image).writeToFile(filename, atomically: true)
    end

    def spec_dir
      "spec/screens"
    end

    private
    def resolution
      @resolution ||= UIScreen.mainScreen.bounds
    end

    def width
      resolution.size.width
    end

    def height
      resolution.size.height
    end

    def retina?
      UIScreen.mainScreen.scale > 1
    end

  end
end
