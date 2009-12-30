require 'rubygems'
require 'sinatra'
require 'chars'
require 'haml'
require 'cgi'


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
  @long_url.first.each_char do |c|
    @temp << REVERSE_LOOKUP_TABLE[c] 
    puts "#{c} => #{REVERSE_LOOKUP_TABLE[c]}"
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
  puts "#{c} #{c.chr} => #{LOOKUP_TABLE[c.chr]}"
  LOOKUP_TABLE[c.chr] + LOOKUP_TABLE[(c % LOOKUP_TABLE.size + 32).chr]    
end

def should_be_encoded(character)
  ['$', '+', ',', ';', '?', '#', '@', '/', '&', ':', '='].include? character
end

letters = Array.new
(32..126).each do |c|
  letters.push c.chr
end
letters_random = letters.shuffle

LOOKUP_TABLE = {}
letters.each_with_index {|k,i| LOOKUP_TABLE[k] = letters_random[i]}
REVERSE_LOOKUP_TABLE = LOOKUP_TABLE.invert
LOOKUP_TABLE.each_pair {|k, c| (LOOKUP_TABLE.store(k, CGI.escape(c))) if should_be_encoded(c)}
puts LOOKUP_TABLE.inspect

class Array
  def mixup
    mixed = Array.new
  end
end
