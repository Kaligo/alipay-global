module AlipayGlobal
  module Service
    module Trade

      CREATE_TRADE_REQUIRED_PARAMS = %w( notify_url subject out_trade_no currency )
      CREATE_TRADE_OPTIONAL_PARAMS = %w( return_url body total_fee rmb_fee order_gmt_create order_valid_time timeout_rule auth_token supplier seller_id seller_name seller_industry )

      def self.create(params)
        is_mobile = params.delete(:mobile) || params.delete("mobile")
        service_type = is_mobile ? "create_forex_trade_wap" : "create_forex_trade"

        params = AlipayGlobal::Utils.stringify_keys(params)
        AlipayGlobal::Service.check_required_params(params, CREATE_TRADE_REQUIRED_PARAMS)
        AlipayGlobal::Service.check_optional_params(params, CREATE_TRADE_OPTIONAL_PARAMS)

        params = {
          'service'         => service_type,
          '_input_charset'  => 'utf-8',
          'partner'         => AlipayGlobal.api_partner_id,
        }.merge(params)

        AlipayGlobal::Service.request_uri(params).to_s
      end

    end
  end
end