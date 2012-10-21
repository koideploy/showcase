module ApplicationHelper
  def commit_link(commit_sha)
    link_to commit_sha, "https://github.com/koideploy/showcase/commit/#{commit_sha}", :target => '_blank', :class => 'commit'
  end
end
