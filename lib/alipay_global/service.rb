module AlipayGlobal
  module Service
    def self.gateway_url
      AlipayGlobal.environment == "PRODUCTION" ? "https://mapi.alipay.com/gateway.do?" : "https://mapi.alipay.net/gateway.do?"
    end

    def self.request_uri(params, options = {})
      uri = URI(gateway_url)
      uri.query = URI.encode_www_form(sign_params(params, options))
      uri
    end

    def self.sign_params(params, options = {})
      params.merge(
        'sign_type' => AlipayGlobal.sign_type.upcase,
        'sign'      => AlipayGlobal::Sign.generate(params, options)
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