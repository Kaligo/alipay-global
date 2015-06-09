require 'test_config'

describe "AlipayGlobal::Sign::MD5", "md5 signature test" do
  
  before do
    @alipay = AlipayGlobal
    @alipay.api_partner_id = '2088101122136241'
    @alipay.api_secret_key = '760bdzec6y9goq7ctyx96ezkz78287de'

    @params = "_input_charset=gbk&out_trade_no=6741334835157966&partner=2088101568338364&payment_type=1&return_url=http://www.test.com/alipay/return_url.asp&currency=USD&service=create_forex_trade&subject=a book&bodu=nice book&total_fee=100"

    @md5_signature = "db017da14ac139afef3bb7357bb284b2"
  end

  describe "MD5#sign" do
    it "should generate the correct signature" do
      assert_equal @md5_signature, @alipay::Sign::MD5.sign(@params, @alipay.api_secret_key)
    end
  end

  describe "MD5#verify?" do
    it "should return true for the correct signature match" do
      @alipay::Sign::MD5.verify?(@params, @alipay.api_secret_key, @md5_signature).must_equal true
    end

    it "should return false for incorrect signature match" do
      @alipay::Sign::MD5.verify?(@params, @alipay.api_secret_key, "mike#{@md5_signature}").must_equal false
    end
  end

end