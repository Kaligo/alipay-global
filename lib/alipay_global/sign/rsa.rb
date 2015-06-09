require 'openssl'
require 'base64'

module AlipayGlobal
  module Sign
    class RSA
      def self.private_key
        raise ArgumentError, "Assign valid location for RSA private key location :: #AlipayGlobal.private_key_location = #{AlipayGlobal.private_key_location}" if !AlipayGlobal.private_key_location
        File.read(AlipayGlobal.private_key_location)
      end

      def self.sign(string, supplied_private_key = nil)
        key = supplied_private_key || private_key
        rsa = OpenSSL::PKey::RSA.new(key)
        Base64.encode64(rsa.sign(OpenSSL::Digest::SHA256.new, string))
      end

      def self.verify?(string, public_key, sign)
        rsa = OpenSSL::PKey::RSA.new(public_key)
        rsa.verify(OpenSSL::Digest::SHA256.new, Base64.decode64(sign), string)
      end
    end
  end
end
