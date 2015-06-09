require 'test_config'

describe "AlipayGlobal::Sign::DSA", "dsa not implemented test" do

  before do
    @alipay = AlipayGlobal
  end

  describe "RSA#sign" do
    it "should throw a NotImplementedError when DSA based sign is called" do
      exception = proc{ (@alipay::Sign::DSA.sign("no_content","no_key")).call }.must_raise(NotImplementedError)
      exception.message.must_include "DSA is not implemented"
    end
  end

  describe "DSA#verify?" do
    it "should throw a NotImplementedError when DSA based verify is called" do
      exception = proc{ (@alipay::Sign::DSA.verify?("no_content","no_key")).call }.must_raise(NotImplementedError)
      exception.message.must_include "DSA is not implemented"
    end
  end

end