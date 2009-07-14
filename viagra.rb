require 'rubygems'
require 'sinatra'
require 'chars'
require 'haml'


get '/' do
  haml :index
end

post '/lengthify' do
  @base_url = 'http://localhost:4567/'
  @long_url = ''
  @original_url = params[:original_url]
  @original_url.each_byte do |c|
    @long_url << transliterate(c - 32)
  end
  haml :lengthify
end

get '/*' do
  @long_url = params[:splat]
  @original_url, @temp = '', ''
  @long_url.first.each_byte do |c|
    @temp << (LOOKUP_TABLE.index(c.chr) + 32).chr
  end
  strip = true
  @temp.each_char do |c|
    @original_url << c if strip
    strip = !strip
  end
  haml "%div= @original_url"
  redirect @original_url, 307
end

def transliterate(c)
  LOOKUP_TABLE[c] + LOOKUP_TABLE[LOOKUP_TABLE.length % c]    
end

LOOKUP_TABLE = 
["!", "V", "x", "|", ";", "m", "/", "c", "L", "=", "Z", "g", "l", "W", "Q", "q", "4", "p", "<", "7", "u", "K", "8", "2", "k", "t", "e", "r", "*", "n", "j", "}", ")", "]", "s", "w", "I", "@", "v", "O", "3", "d", "0", ":", "o", "`", ",", "\\", "F", "Y", "D", "(", "^", ">", " ", "B", "_", "A", "{", "X", "z", "5", "6", "-", "H", "i", "N", "R", "S", "'", "b", "M", "T", "y", "~", "G", "P", "a", "9", "1", ".", "+", "E", "J", "\"", "$", "C", "f", "[", "h", "U"]


