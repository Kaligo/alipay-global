require 'net/http'

module AlipayGlobal
  module Service
    module Notification

      def self.check(params)
        params = {
          'service'         => 'notify_verify',
          'partner'         => AlipayGlobal.api_partner_id,
        }.merge(params)

        Rails.logger.debug "AlipayGlobal Gem"
        Rails.logger.debug AlipayGlobal::Service.request_uri(params,false)
        Rails.logger.debug Net::HTTP.get(AlipayGlobal::Service.request_uri(params,false))
        Rails.logger.debug "AlipayGlobal Gem"

        Net::HTTP.get(AlipayGlobal::Service.request_uri(params,false))
      end
      
    end
  end
end