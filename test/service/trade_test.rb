require 'test_config'

describe "AlipayGlobal::Service::Trade", "Forex trade actions" do
  
  before do
    @alipay = AlipayGlobal
    @alipay.environment = 'TESTING'
    @alipay.api_partner_id = '2088101122136241'
    @alipay.api_secret_key = '760bdzec6y9goq7ctyx96ezkz78287de'
  end

  describe "#create" do

    describe "Mobile friendly interface" do
      it "total_fee_mobile: should create the correct mobile friendly url" do
        params = {
          mobile: true,
          notify_url: 'https://example.com/notify',
          subject: 'product_name',
          out_trade_no: '12345',
          total_fee: '350.45',
          currency: 'USD',
          supplier: 'company_name'
        }
        assert_equal 'https://mapi.alipay.net/gateway.do?service=create_forex_trade_wap&_input_charset=utf-8&partner=2088101122136241&notify_url=https%3A%2F%2Fexample.com%2Fnotify&subject=product_name&out_trade_no=12345&total_fee=350.45&currency=USD&supplier=company_name&sign_type=MD5&sign=c19f42a597963f118c4f99f2fc7f716f', @alipay::Service::Trade.create(params)
      end 
    end

    describe "MD5 sign" do
      #RMB_FEE mode doesn't integrate with Alipay. Awaiting response from the Alipay team
      it "rmb_fee: should create the correct url" do
        params = {
          notify_url: 'https://example.com/notify',
          subject: 'product_name',
          out_trade_no: '1234',
          rmb_fee: '500',
          currency: nil,
          supplier: 'company_name'
        }
        assert_equal 'https://mapi.alipay.net/gateway.do?service=create_forex_trade&_input_charset=utf-8&partner=2088101122136241&notify_url=https%3A%2F%2Fexample.com%2Fnotify&subject=product_name&out_trade_no=1234&rmb_fee=500&currency&supplier=company_name&sign_type=MD5&sign=72f5fc1dd947f9ca037cb6acc607474b', @alipay::Service::Trade.create(params)
      end

      it "total_fee: should create the correct url" do
        params = {
          notify_url: 'https://example.com/notify',
          subject: 'product_name',
          out_trade_no: '12345',
          total_fee: '350.45',
          currency: 'USD',
          supplier: 'company_name'
        }
        assert_equal 'https://mapi.alipay.net/gateway.do?service=create_forex_trade&_input_charset=utf-8&partner=2088101122136241&notify_url=https%3A%2F%2Fexample.com%2Fnotify&subject=product_name&out_trade_no=12345&total_fee=350.45&currency=USD&supplier=company_name&sign_type=MD5&sign=2dd75a3023c0a3a795a83109966bbc7d', @alipay::Service::Trade.create(params)
      end
    end

  end

end