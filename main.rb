require_relative 'encoder'
require 'fox16'
include Fox
class String
  def downcaserus
    alphabet_upcase = []
    ('А'..'Я').each{|chr| alphabet_upcase<<chr}
    p alphabet_upcase
    alphabet_downcase = []
    ('а'..'я').each{|chr| alphabet_downcase<<chr}
    p alphabet_downcase
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
    return result
  end
end
class Main < FXMainWindow
  def initialize(app)
    super(app,'Theory of information #1',:width =>500, :height=>400,:padding=>10)
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
    @keyword_edit.connect(SEL_VERIFY) do |sender, sel, tentative|
      if tentative =~ /^[а-я][а-я]*$/
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
    FXLabel.new(self,'Plaintext')
    @plaintextbox = FXText.new(self,:opts=>LAYOUT_FILL_X)
    @plaintextbox.visibleRows = 8
    FXLabel.new(self,'Ciphertext')
    @ciphertextbox = FXText.new(self,:opts=>LAYOUT_FILL_X)
    @ciphertextbox.visibleRows =8
  end
  def encode_button_click
    if !(@keyword_edit.text=='')
      alphabet = []
      ('а'..'я').each{|chr| alphabet<<chr}
      text =  @plaintextbox.text.to_s
      p text
      text = text.downcaserus
      p text
      encoder = Encoder.new(text,@keyword_edit.text,alphabet,@key_method.currentItem)
      ciphertext =''
      encoder.encode.each{|chr|ciphertext+=chr}
      @ciphertextbox.setText(ciphertext)
      ciphertext.gsub!(/[^а-я]/,'')
      (0...ciphertext.size-2).each{|index|
        pattern = ciphertext[index..index+2]
        is_not_founded = true
        indexies =[]
        (index+1..ciphertext.size-2).each{|index|
        substring = ciphertext[index..index+2]
        if pattern==substring
          if is_not_founded
            is_not_founded = false
            p pattern
          end
          indexies<<index
          p index
        end}
        if !(indexies.empty?)
          temp_nod = indexies[-1]
          previous_index = 0
          indexies.each{|number| temp_nod=temp_nod.gcd(number-previous_index)
          previous_index = number}
          p 'NOD'
          p temp_nod
        end
        }
    else
      FXMessageBox.new(self,'Error','Please enter keyword',:opts=>MBOX_OK).execute
    end
  end
  def open_menu_click
    p 'Open'
    file_open_dialog = FXFileDialog.new(self,'Open text file')
    file_open_dialog.execute
    p file_open_dialog.filename
    @plaintextbox.setText IO.read(file_open_dialog.filename)
  end
  def save_menu_click
    file_save_dialog = FXFileDialog.new(self,'Open text file')
    file_save_dialog.execute
    IO.write(file_save_dialog.filename, @ciphertextbox.text)
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
