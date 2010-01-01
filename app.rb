require 'rubygems'
require 'sinatra'
require 'haml'
require 'cgi'
require 'net/http'
require 'uri'
require 'helpers/application'

before do
  generate_lookup_tables
end

get '/' do
  haml :index
end

post '/lengthify' do
  @base_url = 'http://localhost:4567/'
  @long_url = ''
  @original_url = params[:original_url]
  @original_url.each_byte do |c|
    @long_url << transliterate(c)
  end
  haml :lengthify
end

post '/decode' do
  @short_url = URI.parse params[:short_url]
  @long_url = nil
  response = Net::HTTP.get_response @short_url
  @long_url = response['location'] if (300..307).include? response.code.to_i
  haml :decode
end

get '/*' do
  puts 'this happens'
  @long_url = params[:splat]
  @original_url, @temp = '', ''
  @long_url.first.each_char do |c|
    @temp << @reverse_lookup_table[c] 
  end 
  strip = true
  @temp.each_byte do |c|
    @original_url << c.chr if strip
    strip = !strip
  end
  (@original_url = 'http://' + @original_url) unless @original_url.match(/^https?:\/\//)
  puts 'error happens'
  redirect @original_url, 307
end
