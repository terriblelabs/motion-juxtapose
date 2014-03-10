require 'spec_helper'

describe Spec do
  before do
    @specs_dir = 'spec/screens'

    FileUtils.rm_rf(@specs_dir) if File.directory? @specs_dir
    FileUtils.mkdir_p(@specs_dir)
  end

  it "lists all images under the given spec directory" do
    spec_dir ="#{@specs_dir}/ios7.0/user_views_home_screen"
    FileUtils.mkdir_p(spec_dir)

    FileUtils.touch("#{spec_dir}/accepted.png")
    FileUtils.touch("#{spec_dir}/current-1232422.png")

    spec = Spec.new @specs_dir, spec_dir
    expect(spec.images.length).to eq(2)
    expect(spec.images.map(&:img)).to eq [
      "#{spec_dir}/accepted.png",
      "#{spec_dir}/current-1232422.png"
    ]
  end

  it "only uses the file name to determine accepted/current/diff status" do
    spec_dir ="#{@specs_dir}/ios7.0/currently_logged_in_user"
    FileUtils.mkdir_p(spec_dir)

    FileUtils.touch("#{spec_dir}/accepted.png")

    spec = Spec.new @specs_dir, spec_dir
    expect(spec.current).to be_nil
    expect(spec.accepted.img).to eq("#{spec_dir}/accepted.png")
  end

  it "serializes to JSON" do
    spec_dir ="#{@specs_dir}/ios7.0/user_views_home_screen"
    FileUtils.mkdir_p(spec_dir)

    FileUtils.touch("#{spec_dir}/accepted.png")

    spec = Spec.new @specs_dir, spec_dir
    json = JSON.parse(spec.to_json)
    expect(json["directory"]).to eq(spec_dir)
    expect(json["accepted"]["img"]).to match(/accepted.png/)
    expect(json["current"]).to be_nil
    expect(json["diff"]).to be_nil

    FileUtils.touch("#{spec_dir}/current.1232422.png")

    json = JSON.parse(spec.to_json)
    expect(json["directory"]).to eq(spec_dir)
    expect(json["accepted"]["img"]).to match(/accepted.png/)
    expect(json["current"]["img"]).to match(/current.1232422.png/)
    expect(json["diff"]).to be_nil

    FileUtils.touch("#{spec_dir}/diff.1232422.png")
    json = JSON.parse(spec.to_json)
    expect(json["directory"]).to eq(spec_dir)
    expect(json["accepted"]["img"]).to match(/accepted.png/)
    expect(json["current"]["img"]).to match(/current.1232422.png/)
    expect(json["diff"]["img"]).to match(/diff.1232422.png/)
  end
end
