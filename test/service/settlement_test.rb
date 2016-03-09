require 'test_config'

describe "AlipayGlobal::Service::Settlement", "Settlement request check" do
  
  before do
    @alipay = AlipayGlobal
    @alipay.api_partner_id = '2088101122136241'
    @alipay.api_secret_key = '760bdzec6y9goq7ctyx96ezkz78287de'

    @params = {
      'start_date'=> '20120202',
      'end_date'=> '20120205'
    }
  end

  describe "#build_request" do
    it "should get params correctly" do
      assert_equal "https://mapi.alipay.net/gateway.do?service=forex_liquidation_file&partner=2088101122136241&start_date=20120202&end_date=20120205&sign_type=MD5&sign=68c26fcba73dc3134bc88bb04a8be865", @alipay::Service::Settlement.build_request(@params)
    end
  end

  describe "#request" do
    describe "Error scenarios" do

      it "return false for no records in period" do
        assert_equal false, @alipay::Service::Settlement.request(@params)
      end

      it "should throw an AlipayGlobal::Service::Settlement::RequestError for date range > 10 days" do
        proc{ (@alipay::Service::Settlement.request({
          'start_date'=> '20120202',
          'end_date'=> '20120305'
        })).call }.must_raise(AlipayGlobal::Service::Settlement::RequestError)
      end

      it "should throw an AlipayGlobal::Service::Settlement::RequestError for an errorneous date range" do
        proc{ (@alipay::Service::Settlement.request({
          'start_date'=> '20130202',
          'end_date'=> '20120305'
        })).call }.must_raise(AlipayGlobal::Service::Settlement::RequestError)
      end

      it "should throw an AlipayGlobal::Service::Settlement::RequestError for no dates supplied (or nil)" do
        proc{ (@alipay::Service::Settlement.request({})).call }.must_raise(AlipayGlobal::Service::Settlement::RequestError)
        proc{ (@alipay::Service::Settlement.request(nil)).call }.must_raise(NoMethodError)
      end

      it "should throw an AlipayGlobal::Service::Settlement::RequestError for finish date ahead of today" do
        proc{ (@alipay::Service::Settlement.request({
          'start_date'=> '20151300',
          'end_date'=> '20151333'
        })).call }.must_raise(AlipayGlobal::Service::Settlement::RequestError)
      end

      describe "Incorrect Merchant" do
        before do
          @alipay.api_partner_id = 'daftpunk'
        end

        it "should throw an AlipayGlobal::Service::Settlement::RequestError for Merchant ID incorrect" do
          proc{ (@alipay::Service::Settlement.request(@params)).call }.must_raise(AlipayGlobal::Service::Settlement::RequestError)
        end

        after do
          @alipay.api_partner_id = '2088101122136241'
        end
      end

    end
  end

end