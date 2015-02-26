if defined?(RSpec)
  describe "rspec matchers" do
    require_relative '../../lib/juxtapose/image_matcher'
    require_relative '../../lib/juxtapose/rspec'

    it "passes true if files are identical" do
      dog1 = File.join(File.dirname(__FILE__), "../files/dog1.jpg")
      dog2 = File.join(File.dirname(__FILE__), "../files/dog2.jpg")
      expect(dog1).to look_like(dog2)
    end

    it "passes with a fuzzy threshold" do
      dog1 = File.join(File.dirname(__FILE__), "../files/dog1.jpg")
      dog2 = File.join(File.dirname(__FILE__), "../files/dog_fuzzy.jpg")
      expect(dog1).to look_like(dog2, fuzz_factor: 78.0)
    end
  end
end
