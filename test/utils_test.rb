require 'test_config'

describe "AlipayGlobal::Utils", "service functions" do
  describe "stringify_keys" do
    it "should convert all keys to string values" do
      hash = { 'a' => 1, :b => 2 }
      assert_equal({ 'a' => 1, 'b' => 2 }.sort, AlipayGlobal::Utils.stringify_keys(hash).sort)
    end
  end
end