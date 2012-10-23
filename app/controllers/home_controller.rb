class HomeController < ApplicationController
  def index
    @current_release = HerokuRelease.get_releases.reverse.first
    @previous_releases = HerokuRelease.get_releases.reverse[1..10]
    @photo = FlickrPhoto::FLICKR_PHOTO
  end
end
