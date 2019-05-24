describe 'screenshot testing under bacon' do
  extend Juxtapose

  tests TestController

  it "raises an error when no accepted screenshot is present" do
    error = nil
    begin
      it_should_look_like "no accepted screenshot"
    rescue RuntimeError => e
      error = e
    end
    error.should.not.be.nil
    error.message.should =~ /No accepted screen shot for/
  end

  it "passes when there is an identical accepted screenshot" do
    it_should_look_like "accepted screenshot"
  end

  it "raises an error and produces diffs on failure" do
    Dispatch::Queue.main.async do
      view("Juxtapose").text = "Changed!"
    end

    wait 1.0 do
      error = nil
      begin
        it_should_look_like "going to differ screenshot"
      rescue RuntimeError => e
        error = e
      end
      error.should.not.be.nil
      error.message.should =~ /Screenshot did not match/

      spec_dir = "spec/screens/iphone-retina-6/ios_12.2/screenshot-testing-under-bacon-raises-an-error-and-produces-diffs-on-failure/going-to-differ-screenshot"

      File.should.exist(File.join( ENV["RUBYMOTION_PROJECT_DIR"], spec_dir, "current.png"))
      File.should.exist(File.join( ENV["RUBYMOTION_PROJECT_DIR"], spec_dir, "diff.png"))
    end
  end

  it "raises an error when screens are different sizes" do
    error = nil
    begin
      it_should_look_like "different sized screenshot"
    rescue RuntimeError => e
      error = e
    end
    error.should.not.be.nil
    error.message.should =~ /Screenshots are different sizes/
  end
end
