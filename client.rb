require 'generator'

class Client
  def initialize()
    @codes = []
  end

  def get_codes()
    @codes
  end

  def generate_otp(code)
    code = Generator.new(code).otp_value()
    @codes.append(code) if !@codes.any? { |u| u[:code] == code[:code] }
  end
end
