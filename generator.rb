require 'openssl'
require_relative 'modules/config'

class Generator
  include Config

  def initialize(key)
    # counter value, 8 byte big endian
    @counter = [((Time.now.to_i - start_time) / time_step).floor].pack("Q>")
    @key = key
  end

  def get_key
    @key
  end

  def get_counter
    @counter
  end

  def compute_raw
    # puts "counter size: #{get_counter.bytesize}"
    OpenSSL::HMAC.digest('sha1', get_key, get_counter)
  end

  def dynamic_truncation
    raw = compute_raw
    offset = raw.bytes[-1] & 0x0F
    selection = raw[offset, offset + 3].unpack1('N') & 0x7FFFFFFF
  end

  def otp_value
    dynamic_truncation % code_length
  end
end
