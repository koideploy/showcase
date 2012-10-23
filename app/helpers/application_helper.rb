module ApplicationHelper
  def commit_link(commit_sha, link_text = nil)
    link_to link_text || commit_sha, "https://github.com/koideploy/showcase/commit/#{commit_sha}", :target => '_blank', :class => 'commit'
  end

  def license_link(photo)
    link_to @photo[:license_name], @photo[:license_url], :class => 'license', :target => '_blank'
  end

  def flickr_photo_backlink(photo)
    link_text = "#{@photo[:username]} - \"#{@photo[:title]}\""
    link_to link_text, @photo[:url_photopage], :target => '_blank'
  end
end
