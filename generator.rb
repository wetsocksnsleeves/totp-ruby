require 'openssl'
require_relative 'modules/config'

class Generator
  include Config

  def initialize(key)
    # counter value, 8 byte big endian
    @time_now = Time.now.to_i
    @counter = [((@time_now - start_time) / time_step).floor].pack("Q>")
    @expiry = @time_now + time_step
    @key = key
  end

  def compute_raw
    # puts "counter size: #{get_counter.bytesize}"
    OpenSSL::HMAC.digest('sha1', @key, @counter)
  end

  def dynamic_truncation
    raw = compute_raw
    offset = raw.bytes[-1] & 0x0F
    selection = raw[offset, offset + 3].unpack1('N') & 0x7FFFFFFF
  end

  def otp_value
    code = dynamic_truncation % code_length
    { "code": code, "expiry": @expiry }
  end
end
