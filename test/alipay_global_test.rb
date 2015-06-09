require 'test_config'

describe "AlipayGlobal", "basic gem config" do
  
  before do
    @alipay = AlipayGlobal
  end

  it "has a basic debug mode default" do
    assert @alipay.debug_mode?
  end

  it "has a default MD5 mode" do
    assert_equal 'MD5', @alipay.sign_type
  end

  describe "api_partner_id & api_secret_key assignment" do

    before do
      @alipay.api_partner_id = '2088101122136241'
      @alipay.api_secret_key = '760bdzec6y9goq7ctyx96ezkz78287de'
    end

    it "has assigned api_partner_id and api_secret_key" do
      @alipay.api_partner_id.wont_be_nil true
      @alipay.api_secret_key.wont_be_nil true
    end

  end

end