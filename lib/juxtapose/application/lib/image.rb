class Image
  attr_accessor :img, :basedir

  def initialize(basedir, img)
    self.basedir = basedir
    self.img = img
  end

  def accepted?
    File.basename(img).match /accepted/
  end

  def current?
    File.basename(img).match /current/
  end

  def diff?
    File.basename(img).match /diff/
  end

  def path
    File.join("/images", img)
  end

  def to_json(options={})
    as_json.to_json
  end

  def as_json
    {
      path: path,
      img: img
    }
  end
end
