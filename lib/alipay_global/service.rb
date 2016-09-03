module AlipayGlobal
  module Service
    def self.gateway_url
      AlipayGlobal.environment == "PRODUCTION" ? "https://mapi.alipay.com/gateway.do?" : "https://openapi.alipaydev.com/gateway.do?"
    end

    def self.request_uri(params, sign = true)
      uri = URI(gateway_url)
      processed_params = sign ? sign_params(params) : params
      uri.query = URI.encode_www_form(AlipayGlobal::Utils.stringify_keys(processed_params))
      uri
    end

    def self.sign_params(params)
      params.merge(
        'sign_type' => AlipayGlobal.sign_type.upcase,
        'sign'      => AlipayGlobal::Sign.generate(params)
      )
    end

    def self.check_required_params(params, names)
      return if !AlipayGlobal.debug_mode?

      names.each do |name|
        warn("AlipayGlobal Warn: missing required option: #{name}") unless params.has_key?(name)
      end
    end

    def self.check_optional_params(params, names)
      return if !AlipayGlobal.debug_mode?

      warn("AlipayGlobal Warn: must specify either #{names.join(' or ')}") if names.all? {|name| params[name].nil? }
    end
  end
end