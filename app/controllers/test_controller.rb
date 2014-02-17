class TestController < UIViewController
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
    @label = UILabel.alloc.initWithFrame(CGRectZero)
    @label.text = "Juxtapose"
    @label.sizeToFit

    @label.center =
      [self.view.frame.size.width / 2,
       self.view.frame.size.height / 2]
      self.view.addSubview(@label)
  end
end
