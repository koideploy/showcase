class HerokuRelease < OpenStruct
  HEROKU_APP_NAME = 'koideploy-showcase'
  VALID_KEYS = %w(descr commit created_at name)
  TRAVIS_CI_BUILDS_API_URL = 'https://travis-ci.org/koideploy/showcase/builds.json'
  TRAVIS_CI_BUILD_BASE_URL = 'https://travis-ci.org/#!/koideploy/showcase/builds'

  class << self
    def get_releases
      @@heroku_releases ||= heroku.get_releases(HEROKU_APP_NAME).body.map do |release|
        new(get_attributes(release))
      end
    end

    def get_travis_ci_builds
      @@travis_ci_builds ||= HTTParty.get(TRAVIS_CI_BUILDS_API_URL)
    end

    private

    def get_attributes(release)
      release.select { |key, value| VALID_KEYS.include?(key) }
    end

    def heroku
      #initialized via ENV['HEROKU_API_KEY']
      @heroku ||= Heroku::API.new
    end
  end

  def created_at
    Time.parse super
  end

  def commit_message
    build_for_commit['message'] if build_for_commit
  end

  def travis_ci_build_number
    build_for_commit['number'] if build_for_commit
  end

  def travis_ci_build_url
    if build_for_commit
      [TRAVIS_CI_BUILD_BASE_URL, build_for_commit['id']].join('/')
    end
  end

  private

  def build_for_commit
    @build_for_commit ||= self.class.get_travis_ci_builds.detect do |build|
      build['commit'] =~ %r{^#{commit}}
    end
  end
end
