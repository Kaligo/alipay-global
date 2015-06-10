require 'open-uri'

module AlipayGlobal
  module Service
    module Exchange

      def self.current_rates
        exchange_rates_resp = {}
        open(build_request) do |file|
          file.each_line do |line|
            line = line.strip
            rate_results = line.split("|")

            exchange_rates_resp[rate_results[2]] = {
              time: DateTime.strptime("#{rate_results[0]} #{rate_results[1]}","%Y%m%d %H%M%S"),
              rate: rate_results[3].to_f
            }
          end
        end
        exchange_rates_resp
      end

      def self.build_request
        params = {
          'service'         => 'forex_rate_file',
          'partner'         => AlipayGlobal.api_partner_id,
        }

        AlipayGlobal::Service.request_uri(params).to_s
      end

    end
  end
end