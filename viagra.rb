require 'rubygems'
require 'sinatra'
require 'chars'
require 'haml'
require 'cgi'
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

get '/*' do
  @long_url = params[:splat]
  @original_url, @temp = '', ''
  puts @reverse_lookup_table.inspect
  @long_url.first.each_char do |c|
    @temp << @reverse_lookup_table[c] 
    puts "#{c} => #{@reverse_lookup_table[c]}"
  end 
  strip = true
  @temp.each_byte do |c|
    @original_url << c.chr if strip
    strip = !strip
  end
  (@original_url = 'http://' + @original_url) unless @original_url.match(/^https?:\/\//)
  redirect @original_url, 307
end
