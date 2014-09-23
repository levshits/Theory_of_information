class Encoder
  def initialize(text, keyword, alphabet, method)
    @text = text
    @text_simpled = @text.gsub(/[^а-яё]/, '')
    @keyword = keyword
    @keychar_index = 0
    @alphabet = alphabet
    @method = method
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
    keychar = (@keyword+@text_simpled)[@keychar_index]
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
    case @method
      when(0)
        next_keychar = self.get_next_keychar_simplekey
      when(1)
        next_keychar = self.get_next_keychar_runningkey
      when(2)
        next_keychar = self.get_next_keychar_autokey
    end
      return @alphabet[(self.get_index_by_char(source_char) + next_keychar)%@alphabet.size]
  end
  def get_decodered_char(source_char)
    if !@alphabet.include?(source_char)
      return source_char
    end
    case @method
      when(0)
        next_keychar = self.get_next_keychar_simplekey
      when(1)
        next_keychar = self.get_next_keychar_runningkey
      when(2)
        next_keychar = self.get_next_keychar_autokey
    end
    return @alphabet[(self.get_index_by_char(source_char) - next_keychar+@alphabet.size)%@alphabet.size]
  end
  def encode
    ciphertext = ''
    (0...@text.size).each{|index| ciphertext+=get_encodered_char(@text[index])}
    return ciphertext
  end
  def decode(ciphertext)
    @text = ''
    @keychar_index = 0
    (0...ciphertext.size).each{|index|
      @text+=get_decodered_char(ciphertext[index])}
    return @text
  end
end
