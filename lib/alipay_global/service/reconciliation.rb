require 'open-uri'

module AlipayGlobal
  module Service
    module Reconciliation

      RECONCILIATION_REQUIRED_PARAMS = %w( start_date end_date )

      RECONCILIATION_ERROR_MESSAGES = [
        "Over 10 days to Date period",
        "Over limit balance amount record",
        "System exception",
        "<alipay><is_success>F</is_success><error>ILLEGAL_PARTNER</error></alipay>",
        "Finish date not ahead of today",
        "Finish date ahead of begin date",
        "Illegal Date period!",
        "Date format incorrect YYYYMMDD",
        "Internet connected exception ,please try later"
      ]

      def self.request(params)
        reconciliation_resp = []
        open(build_request(params)) do |data|
          results = data.read

          return false if results.include? "No balance account data in the period"
          raise ArgumentError, "#{results}" if error_check(results)

          results.each_line do |line|
            line = line.strip
            transaction = line.split("|")

            reconciliation_resp << {
              partner_transaction_id: transaction[0],
              amount: transaction[1],
              currency: transaction[2],
              transaction_time: valid_alipay_date(transaction[3]) ? DateTime.strptime(transaction[3],"%Y%m%d%H%M%S") : '',
              settlement_time: valid_alipay_date(transaction[4]) ? DateTime.strptime(transaction[4],"%Y%m%d%H%M%S") : '',
              transaction_type: transaction[5],
              service_charge: transaction[6],
              status: transaction[7],
              remarks: transaction[8] ? transaction[8] : ''
            }
          end

        end
        reconciliation_resp
      end

      def self.build_request(params)
        AlipayGlobal::Service.check_required_params(params, RECONCILIATION_REQUIRED_PARAMS)

        params = AlipayGlobal::Utils.stringify_keys(params)

        params = {
          'service'         => 'forex_compare_file',
          'partner'         => AlipayGlobal.api_partner_id,
        }.merge(params)

        AlipayGlobal::Service.request_uri(params).to_s
      end

      def self.error_check(data)
        RECONCILIATION_ERROR_MESSAGES.any? { |w| data =~ /#{w}/ }
      end

      def self.valid_alipay_date(raw_date)
        raw_date && raw_date.length > 0
      end
      
    end
  end
end