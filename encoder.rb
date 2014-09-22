class Encoder
  def initialize(text, keyword, alphabet)
    @text = text
    @keyword = keyword
    @keychar_index = 0
    @alphabet = alphabet
  end
  def get_index_by_char(char)
    index = 0
    @alphabet.each_index { |i| if @alphabet[i]==char
                                 index = i
                                 break
                               end}
    return index
  end
  def get_next_keychar_simplekey
    keychar = @keyword[@keychar_index]
    @keychar_index = (@keychar_index+1)%@keyword.size
    return self.get_index_by_char(keychar)
  end

  def get_next_keychar_autokey
    keychar = (@keyword+@text)[@keychar_index]
    @keychar_index+=1
    return self.get_index_by_char(keychar)
  end
  def get_next_keychar_runningkey
    index = self.get_index_by_char(@keyword[@keychar_index%@keyword.size])
    index +=@keychar_index/@keyword.size
    index =index%@alphabet.size
    @keychar_index+=1
    return index
  end
  def get_encodered_char(source_char)
    if !@alphabet.include?(source_char)
      return source_char
    end
      return @alphabet[(self.get_index_by_char(source_char) + self.get_next_keychar_runningkey)%@alphabet.size]
  end
  def encode
    ciphertext = []
    (0...@text.size).each{|index| ciphertext<<get_encodered_char(@text[index])}
    return ciphertext
  end
end