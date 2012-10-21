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
    end
  end
end
