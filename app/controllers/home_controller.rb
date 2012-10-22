class HomeController < ApplicationController
  def index
    @releases = HerokuRelease.get_releases.reverse[0..10]
    @photo = FlickrPhoto::FLICKR_PHOTO
  end
end
