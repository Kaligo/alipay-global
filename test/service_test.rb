require 'test_config'

describe "AlipayGlobal::Service", "basic service config" do
  
  before do
    @alipay = AlipayGlobal
  end

  describe "#gateway" do

    describe "gateway is test environment by default" do
      it "should return test environment gateway" do
        assert_equal @alipay::Service.gateway_url, "https://mapi.alipay.net/gateway.do?"
      end
    end

    describe "gateway is in production" do
      before do
        @alipay.environment = "PRODUCTION"
      end

      it "should return production environment gateway" do
        assert_equal @alipay::Service.gateway_url, "https://mapi.alipay.com/gateway.do?"
      end

      after do
        @alipay.environment = "TEST"
      end
    end

  end

end