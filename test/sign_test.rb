require 'test_config'

describe "Sign", "signature test" do
  
  before do
    @alipay = AlipayGlobal
  end

  describe "#verify?" do
    
    before do
      @sample_notification_params = {
        notify_id: '13f1e773aeb299e26eb5d02bbb71219d50',
        notify_type: 'trade_status_sync',
        trade_no: '4061800001000100000574688',
        total_fee: 0.10,
        out_trade_no: '4028608899131221',
        currency: 'HKD',
        notify_time: '2013-09-02 10:41:43',
        trade_status: 'TRADE_FINISHED',
        sign_type: 'MD5',
        _input_charset: 'utf-8',
        sign: 'c5caea0b1e2cb8fd0cc7c19734f07dd7'
      }
    end

    it "should verify partner params correctly" do
      assert_equal true, @alipay::Sign.verify?(@sample_notification_params)
    end

  end
end