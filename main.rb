require_relative 'encoder'
require 'fox16'
include Fox
class String
  def downcaserus
    alphabet_upcase = []
    ('А'..'Е').each{|chr|
      alphabet_upcase<<chr}
    alphabet_upcase<<'Ё'
    ('Ж'..'Я').each{|chr| alphabet_upcase<<chr}
    alphabet_downcase = []
    ('а'..'е').each{|chr| alphabet_downcase<<chr}
    alphabet_downcase<<'ё'
    ('ж'..'я').each{|chr| alphabet_downcase<<chr}
    result =''
    (0...self.size).each{|j|
    index = -1
    alphabet_upcase.each_index { |i| if alphabet_upcase[i]==self[j]
                                       index = i
                                       break
                                     end}
    if index == -1
      result+=self[j]
    else
      result+=alphabet_downcase[index]
    end
    }
    result
  end
end
class Main < FXMainWindow
  def initialize(app)
    super(app,'Theory of information #1',:width =>600, :height=>400,:padding=>10)
    add_controls
  end
  def create
    super
    show(PLACEMENT_SCREEN)
  end
  private
  def add_controls
    menu_bar = FXMenuBar.new(self,:opts=>LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
    file_menu = FXMenuPane.new(menu_bar)
    FXMenuTitle.new(menu_bar,'File',:popupMenu => file_menu)
    open_menu = FXMenuCommand.new(file_menu,'Open')
    open_menu.connect(SEL_COMMAND)do
      open_menu_click
    end
    save_menu = FXMenuCommand.new(file_menu, 'Save')
    save_menu.connect(SEL_COMMAND)do
      save_menu_click
    end
    exit_menu = FXMenuCommand.new(file_menu,'Exit')
    exit_menu.connect(SEL_COMMAND)do
      exit_menu_click
    end
    buttons_frame = FXHorizontalFrame.new(self,:opts=>LAYOUT_FILL_X)
    FXLabel.new(buttons_frame,'Keyword')
    @keyword_edit = FXTextField.new(buttons_frame,10)
    @keyword_edit.connect(SEL_VERIFY) do |_, _, tentative|
      if tentative =~ /^[а-яё][а-яё]*$/
        false
      else
        true
      end
    end
    @key_method = FXComboBox.new(buttons_frame,20)
    @key_method.fillItems(%w(Simple Progress Autokey))
    @key_method.editable = false
    encode_button = FXButton.new(buttons_frame,'Encode')
    encode_button.connect(SEL_COMMAND)do
      encode_button_click
    end
    decode_button = FXButton.new(buttons_frame,'Decode')
    decode_button.connect(SEL_COMMAND)do
      decode_button_click
    end
    kasiski_button = FXButton.new(buttons_frame,'Kasiski')
    kasiski_button.connect(SEL_COMMAND)do
      kasiski_button_click
    end
    FXLabel.new(self,'Source')
    @sourcetextbox = FXText.new(self,:opts=>LAYOUT_FILL_X)
    @sourcetextbox.visibleRows = 8
    FXLabel.new(self,'Result')
    @resulttextbox = FXText.new(self,:opts=>LAYOUT_FILL_X)
    @resulttextbox.visibleRows =8
  end
  def encode_button_click
    unless @keyword_edit.text==''
      alphabet = []
      ('а'..'е').each{|chr| alphabet<<chr}
      alphabet<<'ё'
      ('ж'..'я').each{|chr| alphabet<<chr}
      text = @sourcetextbox.text.to_s
      text = text.downcaserus
      encoder = Encoder.new(text, @keyword_edit.text, alphabet, @key_method.currentItem)
      ciphertext = encoder.encode
      @resulttextbox.setText(ciphertext)
    else
      FXMessageBox.new(self, 'Error', 'Please enter keyword', :opts => MBOX_OK).execute
    end
  end
  def decode_button_click
    alphabet = []
    ('а'..'е').each{|chr| alphabet<<chr}
    alphabet<<'ё'
    ('ж'..'я').each{|chr| alphabet<<chr}
    text = @sourcetextbox.text.to_s
    text = text.downcaserus
    encoder = Encoder.new('', @keyword_edit.text, alphabet, @key_method.currentItem)
    plaintext = encoder.decode(text)
    @resulttextbox.setText(plaintext)
  end
  def kasiski_button_click
    ciphertext = @sourcetextbox.text.to_s
    ciphertext.gsub!(/[^а-яё]/, '')
    used_patterns = []
    (2..7).each{|size|
    (0...ciphertext.size-size).each { |index|
      pattern = ciphertext[index..index+size]
    if !(used_patterns.include?(pattern))
      is_not_founded = true
      indexies =[]
      pattern_result =''
      prev_index = index
      (index+1..ciphertext.size-size).each { |index|
        substring = ciphertext[index..index+size]
        if pattern==substring
          if is_not_founded
            is_not_founded = false
            p pattern
            pattern_result +=pattern
            used_patterns<<pattern
          end
          indexies<<(index-prev_index)
          pattern_result +=' '+indexies[-1].to_s
        end }

      if indexies.size>0
        temp_nod = indexies[0]
        indexies.each { |number| temp_nod=temp_nod.gcd(number) }
        @resulttextbox.appendText(pattern_result+' NOD' + " #{temp_nod}"+"\n")
      end
    end}}
  end
  def open_menu_click
    p 'Open'
    file_open_dialog = FXFileDialog.new(self,'Open text file')
    file_open_dialog.execute
    p file_open_dialog.filename
    @sourcetextbox.setText IO.read(file_open_dialog.filename)
  end
  def save_menu_click
    file_save_dialog = FXFileDialog.new(self,'Open text file')
    file_save_dialog.execute
    IO.write(file_save_dialog.filename, @resulttextbox.text)
  end
  def exit_menu_click
    p 'Close'
    self.close
  end
end
app = FXApp.new
Main.new(app)
app.create
app.run
