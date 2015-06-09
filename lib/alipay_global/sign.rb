module AlipayGlobal
  module Sign
    @alipay_rsa_public_key = File.read("#{File.dirname __dir__}/../keys/alipay_public_key.pem")

    def self.generate(params)
      params = Utils.stringify_keys(params)
      sign_type = AlipayGlobal.sign_type.upcase
      key = AlipayGlobal.api_secret_key
      string = params_to_string(params)

      case sign_type
      when 'MD5'
        MD5.sign(string, key)
      when 'RSA'
        RSA.sign(string)
      when 'DSA'
        DSA.sign(string, key)
      else
        raise ArgumentError, "invalid sign_type #{sign_type}, allow value: 'MD5', 'RSA', 'DSA'"
      end
    end

    def self.verify?(params)
      params = Utils.stringify_keys(params)

      sign_type = params.delete('sign_type')
      signature = params.delete('sign')
      string = params_to_string(params)

      case sign_type
      when 'MD5'
        key = AlipayGlobal.api_secret_key
        MD5.verify?(string, key, signature)
      when 'RSA'
        RSA.verify?(string, @alipay_rsa_public_key, signature)
      when 'DSA'
        DSA.verify?(string, signature)
      else
        false
      end
    end

    def self.params_to_string(params)
      params.sort.map { |item| item.join('=') }.join('&')
    end
  end
end