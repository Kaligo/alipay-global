require 'test_config'

describe "AlipayGlobal::Service::Notification", "Notification request check" do
  
  before do
    @alipay = AlipayGlobal
    @alipay.api_partner_id = '2088101122136241'
    @alipay.api_secret_key = '760bdzec6y9goq7ctyx96ezkz78287de'

    @params = {
      notify_id: 'abcdefghijklmnopqrst'
    }
  end

  describe "#check" do
    it "should get params correctly" do
      assert_equal "false", @alipay::Service::Notification.check(@params)
    end
  end

end