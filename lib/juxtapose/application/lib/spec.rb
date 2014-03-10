class Spec
  attr_accessor :path, :basedir

  def initialize(basedir, path)
    self.basedir = basedir
    self.path = path
  end

  def images
    Dir.glob(File.join(path, '*.png')).map do |img|
      Image.new(basedir, img)
    end
  end

  def name
    path.gsub(basedir, '')
  end

  def to_json
    as_json.to_json
  end

  def accepted
    images.select(&:accepted?).first
  end

  def current
    images.select(&:current?).first
  end

  def diff
    images.select(&:diff?).first
  end

  def as_json
    {
      directory: path,
      accepted: accepted,
      current: current,
      diff: diff
    }
  end
end
