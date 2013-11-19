require 'spec_helper'

describe "Project" do
  before do
    @specs_dir = 'spec/screens'

    FileUtils.rm_rf(@specs_dir) if File.directory? @specs_dir
    FileUtils.mkdir_p(@specs_dir)
  end

  it "returns an empty list of specs when there are no specs" do
    expect(Project.new(@specs_dir).specs).to be_empty
  end

  it "lists one spec per directory when there are multiple images" do
    spec ="#{@specs_dir}/ios7.0/user_views_home_screen"
    FileUtils.mkdir_p(spec)

    FileUtils.touch("#{spec}/accepted.png")
    FileUtils.touch("#{spec}/current-1232422.png")

    specs = Project.new(@specs_dir).specs
    expect(specs.length).to eq(1)
  end

  it "lists manys specs per directory when there are many directories with multiple images" do
    spec ="#{@specs_dir}/ios7.0/user_views_home_screen"
    FileUtils.mkdir_p(spec)

    FileUtils.touch("#{spec}/accepted.png")
    FileUtils.touch("#{spec}/current-1232422.png")

    spec ="#{@specs_dir}/ios7.0/user_logs_in/"
    FileUtils.mkdir_p(spec)

    FileUtils.touch("#{spec}/accepted.png")

    specs = Project.new(@specs_dir).specs
    expect(specs.length).to eq(2)
  end

  it "serializes to JSON" do
    spec ="#{@specs_dir}/ios7.0/user_views_home_screen"
    FileUtils.mkdir_p(spec)

    FileUtils.touch("#{spec}/accepted.png")
    FileUtils.touch("#{spec}/current-1232422.png")

    spec ="#{@specs_dir}/ios7.0/user_logs_in/"
    FileUtils.mkdir_p(spec)

    FileUtils.touch("#{spec}/accepted.png")

    json = JSON.parse(Project.new(@specs_dir).to_json)
    expect(json["specs"].length).to eq(2)
  end

  it "accepts files" do
    specs_dir ="#{@specs_dir}/ios7.0/user_views_home_screen/home_screen"
    FileUtils.mkdir_p(specs_dir)

    file = "#{specs_dir}/current.retina.png"
    diff_file = "#{specs_dir}/diff.retina.png"
    FileUtils.touch(file)

    Project.accept! file

    expect(File.exists?(file)).to be_false
    expect(File.exists?(diff_file)).to be_false
    expect(File.exists?("#{specs_dir}/accepted.retina.png")).to be_true
  end
end
