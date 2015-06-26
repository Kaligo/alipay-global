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
          total_fee: 350.45,
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
          out_trade_no: '12345',
          rmb_fee: 0.10,
          currency: 'USD',
          supplier: 'company_name'
        }
        assert_equal 'https://mapi.alipay.net/gateway.do?service=create_forex_trade&_input_charset=utf-8&partner=2088101122136241&notify_url=https%3A%2F%2Fexample.com%2Fnotify&subject=product_name&out_trade_no=12345&rmb_fee=0.10&currency=USD&supplier=company_name&sign_type=MD5&sign=4986b31c8febb978ee6d6c45f76614ac', @alipay::Service::Trade.create(params)
      end

      it "total_fee: should create the correct url" do
        params = {
          notify_url: 'https://example.com/notify',
          subject: 'product_name',
          out_trade_no: '12345',
          total_fee: 350.45,
          currency: 'USD',
          supplier: 'company_name'
        }
        assert_equal 'https://mapi.alipay.net/gateway.do?service=create_forex_trade&_input_charset=utf-8&partner=2088101122136241&notify_url=https%3A%2F%2Fexample.com%2Fnotify&subject=product_name&out_trade_no=12345&total_fee=350.45&currency=USD&supplier=company_name&sign_type=MD5&sign=2dd75a3023c0a3a795a83109966bbc7d', @alipay::Service::Trade.create(params)
      end
    end

  end

  describe "#status" do
    it "should reject non-existent trade" do
      params = {
        out_trade_no: "SAMPLE_TRANSACTION_ID"
      }
      expected_result = { success: false, message: "TRADE_NOT_EXIST" }

      assert_equal "https://mapi.alipay.net/gateway.do?service=single_trade_query&_input_charset=utf-8&partner=2088101122136241&out_trade_no=SAMPLE_TRANSACTION_ID&sign_type=MD5&sign=d4d3825356fd0799ee16829acffc1460", @alipay::Service::Trade.build_query_uri(params).to_s
      assert_equal expected_result, @alipay::Service::Trade.status(params)
    end

    it "should reject uri with missing out_trade_no" do
      params = { }
      expected_result = { success: false, message: "ILLEGAL_ARGUMENT" }

      assert_equal "https://mapi.alipay.net/gateway.do?service=single_trade_query&_input_charset=utf-8&partner=2088101122136241&sign_type=MD5&sign=af7007238531b0b0917f3972e24c6c64", @alipay::Service::Trade.build_query_uri(params).to_s
      assert_equal expected_result, @alipay::Service::Trade.status(params)
    end
  end

  describe "#refund" do
    it "should refund correctly for a valid refund url" do
      params = {
        out_return_no: "SAMPLE_REFUND_ID",
        out_trade_no: "SAMPLE_TRANSACTION_ID",
        return_rmb_amount: 200.00,
        reason: "hello",
        gmt_return: (Time.parse("2015-03-20 12:00").getlocal("+08:00")).strftime("%Y%m%d%H%M%S"),
        currency: "USD"
      }
      expected_result = { success: false, message: "PURCHASE_TRADE_NOT_EXIST" }

      assert_equal "https://mapi.alipay.net/gateway.do?service=forex_refund&_input_charset=utf-8&partner=2088101122136241&out_return_no=SAMPLE_REFUND_ID&out_trade_no=SAMPLE_TRANSACTION_ID&return_rmb_amount=200.00&reason=hello&gmt_return=20150320120000&currency=USD&sign_type=MD5&sign=a77e894e71491f41e73ebe40319cc300", @alipay::Service::Trade.build_refund_uri(params).to_s
      assert_equal  expected_result, @alipay::Service::Trade.refund(params)
    end

    it "should handle nil reason correctly" do
      params = {
        out_return_no: "SAMPLE_REFUND_ID",
        out_trade_no: "SAMPLE_TRANSACTION_ID",
        return_rmb_amount: 200.00,
        gmt_return: (Time.parse("2015-03-20 12:00").getlocal("+08:00")).strftime("%Y%m%d%H%M%S"),
        currency: "USD"
      }
      expected_result = { success: false, message: "PURCHASE_TRADE_NOT_EXIST" }

      assert_equal "https://mapi.alipay.net/gateway.do?service=forex_refund&_input_charset=utf-8&partner=2088101122136241&out_return_no=SAMPLE_REFUND_ID&out_trade_no=SAMPLE_TRANSACTION_ID&return_rmb_amount=200.00&gmt_return=20150320120000&currency=USD&reason=no_reason&sign_type=MD5&sign=c4c09ca3fc78d04b88d9459b02673b1b", @alipay::Service::Trade.build_refund_uri(params).to_s
      assert_equal  expected_result, @alipay::Service::Trade.refund(params)
    end

    it "should handle empty reason correctly" do
      params = {
        out_return_no: "SAMPLE_REFUND_ID",
        out_trade_no: "SAMPLE_TRANSACTION_ID",
        return_rmb_amount: 200.00,
        gmt_return: (Time.parse("2015-03-20 12:00").getlocal("+08:00")).strftime("%Y%m%d%H%M%S"),
        reason: " ",
        currency: "USD"
      }
      expected_result = { success: false, message: "PURCHASE_TRADE_NOT_EXIST" }

      assert_equal "https://mapi.alipay.net/gateway.do?service=forex_refund&_input_charset=utf-8&partner=2088101122136241&out_return_no=SAMPLE_REFUND_ID&out_trade_no=SAMPLE_TRANSACTION_ID&return_rmb_amount=200.00&gmt_return=20150320120000&reason=no_reason&currency=USD&sign_type=MD5&sign=c4c09ca3fc78d04b88d9459b02673b1b", @alipay::Service::Trade.build_refund_uri(params).to_s
      assert_equal  expected_result, @alipay::Service::Trade.refund(params)
    end
  end

  describe "#batch_refund" do
    it "should transact refund correctly" do
      sample_refunds = [
        { new_transaction_id: '111222333', old_transaction_id: '444555666', currency: 'USD', refund_sum: 200.00, refund_time: '20120330235959', refund_reason: 'bello minions' },
        { new_transaction_id: '111222333', old_transaction_id: '444555667', currency: 'USD', refund_sum: 150.00, refund_time: '20120330235959', refund_reason: 'monkey' }
      ]

      @alipay::Service::Trade.batch_refund(sample_refunds)
    end
    
  end

end