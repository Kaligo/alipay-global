require "net/http"
require "uri"
require "nokogiri"

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
          'partner'         => AlipayGlobal.api_partner_id
        }.merge(params)

        AlipayGlobal::Service.request_uri(params).to_s
      end

      def self.refund(refunds)
        file = build_refund_file(refunds)

        params = {
          'service'         => 'forex_refund_file',
          'partner'         => AlipayGlobal.api_partner_id
        }

        uri = AlipayGlobal::Service.request_uri(params)

        p uri.to_s

        form_params = { 'partner' => AlipayGlobal.api_partner_id, 'service' => 'forex_refund_file', 'refund_file' => IO.read(file.path) }

        p form_params

        resp = Net::HTTP.post_form(uri, form_params)

        p resp.body

        alipay_resp = Nokogiri::XML(resp.body)

        alipay_results = alipay_resp.at_xpath('//alipay')
        #puts "success   = " + alipay_results.at_xpath('//is_success').content
        #puts "error = " + alipay_results.at_xpath('//error').content

        file.unlink
      end

      def self.build_refund_file(refunds)
        file = Tempfile.new(['refund_file','.txt'])
        refund_content = AlipayGlobal::Utils.write_refund_content(refunds)
        file.write(refund_content)
        file.close
        file
      end
    end
  end
end