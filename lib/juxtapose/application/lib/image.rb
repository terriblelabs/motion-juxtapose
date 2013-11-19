class Image
  attr_accessor :img, :basedir

  def initialize(basedir, img)
    self.basedir = basedir
    self.img = img
  end

  def accepted?
    img.match /accepted/
  end

  def path
    File.join("/images", File.join(img.gsub(basedir, '')))
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
