require 'helpers/array_helper'

def transliterate(c)
  #the ascii code for the ^ character which is not included in our table
  return "Why the hell would you put a ^ in your URL, nobody does this, NOBODY" if c == 94 
  @lookup_table[c.chr] + @lookup_table[(c % @lookup_table.size + 32).chr]    
end

def generate_lookup_tables
  @letters = ascii_printable_chars
  @lookup_table = {}
  #satan shuffe will shuffle the letters in the same way each time.
  @letters_random = @letters.satan_shuffle
  #we delete ^ from being encoded and / from being encoded to because if there is a / in the URL passenger treates it as a real slash even if it is urlencoded
  @letters.delete_if{|c| c == '^' }
  @letters_random.delete_if{|c| c == '/' }

  @letters.each_with_index {|k,i| @lookup_table[k] = @letters_random[i]}
  @reverse_lookup_table = @lookup_table.invert
  @lookup_table.each_pair {|k, c| (@lookup_table.store(k, CGI.escape(c))) if should_be_encoded(c)}
end

def should_be_encoded(character)
  ['$', '>', '<', '!', '+', ',', '|', ';', '?', '#', '@', '/', '&', ':', '=', '\'', '"', '%'].include? character
end

def ascii_printable_chars
  letters = Array.new
  (32..126).each do |c|
    letters.push c.chr
  end
  letters
end
