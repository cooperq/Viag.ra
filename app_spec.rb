require 'app'
require 'spec'
require 'rack/test'

Spec::Runner.configure do |conf|
    conf.include Rack::Test::Methods
end

describe "url lengthener" do

  def app
    Sinatra::Application
  end

  it "should respond to the index" do
    get '/'
    last_response.should be_ok
  end

  it "should have a form in the index" do
    get '/'
    last_response.body.include?('<form ')
  end

  it "should lengthify a url" do
    post '/lengthify', params={:original_url => 'http://hackbloc.org'}
    last_response.should be_ok
    last_response.body.include? 'd%25IPIP%26pv%7CRgRgd%257)4i}z lWGy{4iGFy{kr%27Y'
  end
end
