require 'spec_helper'

describe HerokuRelease do
  let(:heroku_releases) do
    json = <<-JSON
    [{"addons":[],"descr":"Initial release","env":{},"commit":"dfed7b9","created_at":"2012/10/20 00:21:04 -0700",
      "user":"testuser@koideploy.com","name":"v1","pstable":{"web":""}},{"addons":[],
      "descr":"Attach HEROKU_POSTGRESQL_ORANGE resource","env":{},"commit":"dfed7b9",
      "created_at":"2012/10/20 01:15:30 -0700","user":"testuser@koideploy.com","name":"v2","pstable":{"web":""}}]
    JSON

    JSON.parse(json)
  end

  context 'get_releases' do
    before do
      response = Object.new
      response.stub(:body).and_return(heroku_releases)
      heroku_client = Object.new
      heroku_client.should_receive(:get_releases).and_return(response)
      HerokuRelease.stub(:heroku).and_return(heroku_client)
    end

    it 'returns releases' do
      HerokuRelease.get_releases.length.should == 2
    end

    context 'release' do
      subject { HerokuRelease.get_releases.first }

      its(:descr) { should == 'Initial release' }
      its(:commit) { should == "dfed7b9" }
      its(:name) { should == 'v1' }
      its(:created_at) { should == Time.parse('2012/10/20 00:21:04 -0700') }
      its(:env) { should == nil }
      its(:addons) { should == nil }
      its(:pstable) { should == nil }

      context 'enrich with travis ci data' do
        let(:travis_response) do
          {
            "id"=>2873143,
            "repository_id"=>294130,
            "number"=>"15",
            "state"=>"finished",
            "result"=>0,
            "started_at"=>"2012-10-21T07:17:30Z",
            "finished_at"=>"2012-10-21T07:19:13Z",
            "duration"=>103,
            "commit"=>"dfed7b994a4cd59d3bdac5bafb7f34ecb45e5646",
            "branch"=>"master",
            "message"=>"List the 10 recent heroku releases.",
            "event_type"=>"push"
          }
        end

        before do
          HerokuRelease.stub(:get_travis_ci_builds).and_return([travis_response])
        end

        its(:commit_message) { should == 'List the 10 recent heroku releases.' }
        its(:travis_ci_build_number) { should == '15' }
        its(:travis_ci_build_url) { should == 'https://travis-ci.org/#!/koideploy/showcase/builds/2873143' }
      end
    end
  end
end
