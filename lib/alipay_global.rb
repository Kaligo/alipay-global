require 'alipay_global/sign'
require 'alipay_global/sign/md5'
require 'alipay_global/sign/rsa'
require 'alipay_global/sign/dsa'

require 'alipay_global/utils'

require 'alipay_global/service'
require 'alipay_global/service/trade'
require 'alipay_global/service/exchange'
require 'alipay_global/service/notification'
require 'alipay_global/service/reconciliation'
require 'alipay_global/service/settlement'

module AlipayGlobal
  
  @debug_mode = true
  @sign_type = "MD5"
  @environment = "TEST"

  #default alipay test credentials
  @api_partner_id = "2088101122136241"
  @api_secret_key = "760bdzec6y9goq7ctyx96ezkz78287de"

  class << self
    attr_accessor :api_partner_id, :api_secret_key, :sign_type, :debug_mode, :private_key_location, :environment

    def debug_mode?
      !!@debug_mode
    end

  end
end