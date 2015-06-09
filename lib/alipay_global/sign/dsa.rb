module AlipayGlobal
  module Sign
    class DSA
      def self.sign(string, private_key)
        raise NotImplementedError, 'DSA is not implemented'
      end

      def self.verify?(string, sign)
        raise NotImplementedError, 'DSA is not implemented'
      end
    end
  end
end