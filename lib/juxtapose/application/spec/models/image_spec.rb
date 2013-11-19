require 'spec_helper'
require 'json'

describe Image do
  before do
    @specs_dir = 'spec/screens'

    FileUtils.rm_rf(@specs_dir) if File.directory? @specs_dir
    FileUtils.mkdir_p(@specs_dir)

    @spec ="#{@specs_dir}/ios7.0/user_views_home_screen"
    FileUtils.mkdir_p(@spec)

    @image_path = "#{@spec}/accepted.png"
    FileUtils.touch(@image_path)
  end

  it "seralizes to JSON" do
    image = Image.new(@specs_dir, @image_path)
    json = JSON.parse(image.to_json)
    expect(json).to eq({
      "path" => image.path,
      "img" => image.img
    })
  end
end
