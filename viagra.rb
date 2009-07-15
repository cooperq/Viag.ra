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
    @long_url << transliterate(c)
  end
  haml :lengthify
end

get '/*' do
  @long_url = params[:splat]
  @original_url, @temp = '', ''
  @long_url.first.each_byte do |c|
    @temp << (LOOKUP_TABLE.index(c.chr) + 32).chr #find the index of the returned character and add 32 and that is the decimal ascii code for our char.
  end
  strip = true
  @temp.each_byte do |c|
    @original_url << c.chr if strip
    strip = !strip
  end
  (@original_url = 'http://' + @original_url) unless @original_url.match(/^https?:\/\//)
  redirect @original_url, 307
end

def transliterate(c)
  puts "#{c} #{c.chr} => #{LOOKUP_TABLE[c-32]}"
  LOOKUP_TABLE[c-32] + LOOKUP_TABLE[LOOKUP_TABLE.length & c]    
end

LOOKUP_TABLE = 
["!", "V", "x", "|", ";", "m", "/", "c", "L", "=", "Z", "g", "l", "W", "Q", "q", "4", "p", "<", "7", "u", "K", "8", "2", "k", "t", "e", "r", "*", "n", "j", "}", ")", "]", "s", "w", "I", "@", "v", "O", "3", "d", "0", ":", "o", "`", ",", "\\", "F", "Y", "D", "(", "^", ">", " ", "B", "_", "A", "{", "X", "z", "5", "6", "-", "H", "i", "N", "R", "S", "'", "b", "M", "T", "y", "~", "G", "P", "a", "9", "1", ".", "+", "E", "J", "\"", "$", "C", "f", "[", "h", "U"]


