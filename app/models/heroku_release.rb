class HerokuRelease < OpenStruct
  HEROKU_APP_NAME = 'koideploy-showcase'
  VALID_KEYS = %w(descr commit created_at name)

  class << self
    def get_releases
      heroku.get_releases(HEROKU_APP_NAME).body.map do |release|
        new(get_attributes(release))
      end
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
end
