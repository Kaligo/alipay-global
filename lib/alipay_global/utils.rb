module AlipayGlobal
  module Utils
    def self.stringify_keys(hash)
      new_hash = {}
      hash.each do |key, value|
        case key
        when :total_fee, :rmb_fee, :refund_sum, :return_rmb_amount, :return_amount
          value = '%.2f' % value
        end
        new_hash[(key.to_s rescue key) || key] = value
      end
      new_hash
    end

    def self.write_refund_content(refunds)
      raise ArgumentException, "Refund content should contain at least 1 refund object" if refunds.length == 0
      file_content = ""
      refunds.each do |refund|
        refund = stringify_keys(refund)
        refund_reason = refund['refund_reason'] || ""
        line_ending = stringify_keys(refunds.last) == refund ? "" : "\n"
        raise ArgumentException, "Refund reason (#{refund_reason} cannot be more than 255 characters long)" if refund_reason.length > 255
        file_content += "#{AlipayGlobal.api_partner_id}|#{refund['new_transaction_id']}|#{refund['old_transaction_id']}|#{refund['currency']}|#{refund['refund_sum']}|#{refund['refund_time']}|#{refund_reason}#{line_ending}"
      end
      file_content
    end

  end
end
