require 'alipay_global/sign'
require 'alipay_global/sign/md5'
require 'alipay_global/sign/rsa'

module AlipayGlobal
  
  @debug_mode = true
  @sign_type = 'MD5'

  class << self
    attr_accessor :api_partner_id, :api_secret_key, :sign_type, :debug_mode, :private_key_location

    def debug_mode?
      !!@debug_mode
    end

    def helloworld
      puts "AlipayGlobal: Hello world!"
    end
  end
end