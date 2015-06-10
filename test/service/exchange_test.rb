require 'test_config'

describe "AlipayGlobal::Service::Exchange", "Forex exchange rates request" do
  
  before do
    @alipay = AlipayGlobal
    @alipay.api_partner_id = '2088101122136241'
    @alipay.api_secret_key = '760bdzec6y9goq7ctyx96ezkz78287de'
  end

  describe "#build_request" do

    it "should create the correct rates url" do
      assert_equal 'https://mapi.alipay.net/gateway.do?service=forex_rate_file&partner=2088101122136241&sign_type=MD5&sign=4051af1716d522b47acff927d4fb9781', @alipay::Service::Exchange.build_request()
    end 

  end

end