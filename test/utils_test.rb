require 'test_config'

describe "AlipayGlobal::Utils", "service functions" do
  before do
    @alipay = AlipayGlobal
  end

  describe "#stringify_keys" do
    it "should convert all keys to string values" do
      hash = { 'a' => 1, :b => 2 }
      assert_equal({ 'a' => 1, 'b' => 2 }.sort, @alipay::Utils.stringify_keys(hash).sort)
    end
  end

  describe "#write_refund_file" do
    it "should write the file correctly" do
      sample_refunds = [
        { new_transaction_id: '111222333', old_transaction_id: '444555666', currency: 'USD', refund_sum: 200.00, refund_time: '20120330235959', refund_reason: 'bello minions' },
        { new_transaction_id: '111222333', old_transaction_id: '444555667', currency: 'USD', refund_sum: 150.0, refund_time: '20120330235959' }
      ]

      assert_equal "2088101122136241|111222333|444555666|USD|200.00|20120330235959|bello minions\n2088101122136241|111222333|444555667|USD|150.00|20120330235959|", @alipay::Utils.write_refund_content(sample_refunds)
    end
  end
end