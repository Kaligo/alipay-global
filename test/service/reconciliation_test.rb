require 'test_config'

describe "AlipayGlobal::Service::Reconciliation", "Reconciliation request check" do
  
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
      assert_equal "https://mapi.alipay.net/gateway.do?service=forex_compare_file&partner=2088101122136241&start_date=20120202&end_date=20120205&sign_type=MD5&sign=3d09abe0980696bb39bb72c6137266ca", @alipay::Service::Reconciliation.build_request(@params)
    end
  end

  describe "#request" do
    #Alipay has some weird ass success parameter
    describe "Success scenario" do
      #this test is dependent on interfacing with alipay's test environment. The data may change/disappear over time. This test will fail if we get no data for the given parameter
      it "should return the content parsed correctly" do
        assert_operator 0, :<, @alipay::Service::Reconciliation.request({
          'start_date'=> '20122340',
          'end_date'=> '20122349'
        }).length
      end
    end

    describe "Error scenarios" do

      it "return false for no records in period" do
        assert_equal false, @alipay::Service::Reconciliation.request(@params)
      end

      it "should throw an ArgumentError for date range > 10 days" do
        proc{ (@alipay::Service::Reconciliation.request({
          'start_date'=> '20120202',
          'end_date'=> '20120305'
        })).call }.must_raise(ArgumentError)
      end

      it "should throw an ArgumentError for an errorneous date range" do
        proc{ (@alipay::Service::Reconciliation.request({
          'start_date'=> '20130202',
          'end_date'=> '20120305'
        })).call }.must_raise(ArgumentError)
      end

      it "should throw an ArgumentError for no dates supplied (or nil)" do
        proc{ (@alipay::Service::Reconciliation.request({})).call }.must_raise(ArgumentError)
        proc{ (@alipay::Service::Reconciliation.request(nil)).call }.must_raise(NoMethodError)
      end

      it "should throw an ArgumentError for finish date ahead of today" do
        proc{ (@alipay::Service::Reconciliation.request({
          'start_date'=> '20151300',
          'end_date'=> '20151333'
        })).call }.must_raise(ArgumentError)
      end

      describe "Incorrect Merchant" do
        before do
          @alipay.api_partner_id = 'daftpunk'
        end

        it "should throw an ArgumentError for Merchant ID incorrect" do
          proc{ (@alipay::Service::Reconciliation.request(@params)).call }.must_raise(ArgumentError)
        end

        after do
          @alipay.api_partner_id = '2088101122136241'
        end
      end

    end
  end

end