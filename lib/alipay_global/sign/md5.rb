require 'digest/md5'

module AlipayGlobal
  module Sign
    class MD5
      #pre-signed string should not be url encoded
      def self.sign(string, secret_key)
        Digest::MD5.hexdigest("#{string}#{secret_key}")
      end

      def self.verify?(string, secret_key, sign)
        sign == sign(string, secret_key)
      end
    end
  end
end
