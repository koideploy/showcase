module ApplicationHelper
  def commit_link(commit_sha)
    link_to commit_sha, "https://github.com/koideploy/showcase/commit/#{commit_sha}", :target => '_blank', :class => 'commit'
  end

  def flickr_photo_backlink(photo)
    link_text = "#{@photo[:username]} - \"#{@photo[:title]}\""
    link_to link_text, @photo[:url_photopage], :target => '_blank'
  end
end
