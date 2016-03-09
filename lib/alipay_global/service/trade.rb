require "net/http"
require "rest-client"
require "uri"
require "nokogiri"

module AlipayGlobal
  module Service
    module Trade
      BOUNDARY = "AaB03x"
      CREATE_QUERY_REQUIRED_PARAMS = %w( out_trade_no )
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

      def self.status(params)
        resp = Net::HTTP.get(build_query_uri(params))

        alipay_results = Nokogiri::XML(resp).at_xpath('//alipay')

        alipay_success = alipay_results.at_xpath('//is_success').content == "T"

        status_response = process_alipay_trade_response(alipay_success,alipay_results) 

        { success: alipay_success , message: status_response }
      end

      def self.process_alipay_trade_response(success, alipay_xml)
        if success
          response_xml = alipay_xml.at_xpath('//response').at_xpath('//trade')
          {
            trade_no: response_xml.at_xpath('//trade_no').content,
            out_trade_no: response_xml.at_xpath('//out_trade_no').content,
            subject: response_xml.at_xpath('//subject').content,
            trade_status: response_xml.at_xpath('//trade_status').content
          }
        else
          alipay_xml.at_xpath('//error').content
        end
      end

      def self.refund(params)
        resp = Net::HTTP.get(build_refund_uri(params))

        alipay_results = Nokogiri::XML(resp).at_xpath('//alipay')

        alipay_success = alipay_results.at_xpath('//is_success').content == "T"

        alipay_reason = alipay_success ? "" : alipay_results.at_xpath('//error').content

        { success: alipay_success , message: alipay_reason }
      end

      def self.batch_refund(refunds)
        #DISABLED
        file = build_refund_file(refunds)

        params = {
          'service'         => 'forex_refund_file',
          'partner'         => AlipayGlobal.api_partner_id
        }

        uri = AlipayGlobal::Service.request_uri(params)

        form_params = { 'partner' => AlipayGlobal.api_partner_id, 'service' => 'forex_refund_file', 'refund_file' => File.read(file.path) }

        resp = RestClient.post uri.to_s, :partner => AlipayGlobal.api_partner_id, :file => File.new(file.path, 'rb'), :service => 'forex_refund_file'

        alipay_resp = Nokogiri::XML(resp.body)

        alipay_results = alipay_resp.at_xpath('//alipay')

        file.unlink
      end

      def self.build_query_uri(params)
        params = AlipayGlobal::Utils.stringify_keys(params)
        AlipayGlobal::Service.check_required_params(params, CREATE_QUERY_REQUIRED_PARAMS)

        params = {
          'service'         => 'single_trade_query',
          '_input_charset'  => 'utf-8',
          'partner'         => AlipayGlobal.api_partner_id
        }.merge(params)

        AlipayGlobal::Service.request_uri(params)
      end

      def self.build_refund_file(refunds)
        file = Tempfile.new(['refund','.txt'])
        refund_content = AlipayGlobal::Utils.write_refund_content(refunds)
        file.write(refund_content)
        file.close
        file
      end

      def self.build_refund_uri(refund)
        refund[:reason] = "no_reason" if !refund[:reason] 
        refund[:reason] = "no_reason" if refund[:reason].strip.length == 0
        params = {
          'service'         => 'forex_refund',
          '_input_charset'  => 'utf-8',
          'partner'         => AlipayGlobal.api_partner_id
        }.merge(refund)

        AlipayGlobal::Service.request_uri(params)
      end
    end
  end
end