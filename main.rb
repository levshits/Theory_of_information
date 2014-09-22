require_relative 'encoder'
class Main
end
alphabet = []
('a'..'z').each{|chr| alphabet<<chr}
p alphabet
encoder = Encoder.new('Abbccddeejjzz'.downcase!,'sun',alphabet)
p encoder.encode