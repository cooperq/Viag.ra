require 'helpers/array_helper'

def transliterate(c)
  @lookup_table[c.chr] + @lookup_table[(c % @lookup_table.size + 32).chr]    
end

def should_be_encoded(character)
  ['$', '>', '<', '!', '+', ',', '|', ';', '?', '#', '@', '/', '&', ':', '=', '\'', '"', '%'].include? character
end

def generate_lookup_tables
  @letters = ascii_printable_chars
  @lookup_table = {}
  @letters_random = @letters.satan_shuffle

  @letters.each_with_index {|k,i| @lookup_table[k] = @letters_random[i]}
  
  @reverse_lookup_table = @lookup_table.invert
  @lookup_table.each_pair {|k, c| (@lookup_table.store(k, CGI.escape(c))) if should_be_encoded(c)}
end

def ascii_printable_chars
  letters = Array.new
  (32..126).each do |c|
    letters.push c.chr
  end
  letters
end
