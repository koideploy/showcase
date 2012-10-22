class FlickrPhoto
  FLICKR_PHOTO_PATH = Rails.root.join(*%w(config flickr_photo.yml))
  FLICKR_PHOTO = YAML::load(IO.read(FLICKR_PHOTO_PATH))
end
