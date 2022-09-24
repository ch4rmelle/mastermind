require_relative 'display'

# initialize computer class, generate a secret code
class Computer
  include Display
  attr_accessor :name

  def initialize
    @name = 'Computer'
  end

  def generate_code
    code = []
    4.times do
      code << (rand * 6 + 1).floor
    end
    code
  end
end