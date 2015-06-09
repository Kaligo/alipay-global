require 'test_config'

describe "AlipayGlobal::Sign::RSA", "rsa signature test" do
  
  before do
    @alipay = AlipayGlobal

    @params = "_input_charset=gbk&out_trade_no=6741334835157966&partner=2088101568338364&payment_type=1&return_url=http://www.test.com/alipay/return_url.asp&currency=USD&service=create_forex_trade&subject=a book&bodu=nice book&total_fee=100"

    @rsa_signature = "i6GcANd+q8dTGY5kif3ClSqQbysmvPwf+gFowbB+ukKLKdcd4dlEUAWKlirK\nBviHoJwydMkUwavi5XvUieU6582UdqrlZgz1UlRSgL5NHSv7DWckhnYL7IKL\n2sTHb5derwrhjcJD/diYSnAMA0K+sRwVZ6Rs4fvQH3NN7sY4x0rb5W54QkPe\nCLqI+MzTggrcfqme2Grx19jOXSigETGWAm74CoI2lztlNgEjBpuqTmXHaBz1\nJ968XI9hVBj2mGnHU4EXj5hPSY/bFK2gVItOQ3w5RbTQCgjdpBYkM1LwTOlc\nu1/BlmWuUh82NGEK/qBrmne6z/W4GnG+6sqoAERA4g==\n"

    @test_rsa_private_key = File.read("#{File.dirname __dir__}/../keys/test_private_key.pem")
    @test_rsa_public_key = File.read("#{File.dirname __dir__}/../keys/test_public_key.pem")
  end

  describe "RSA#sign" do
    describe "AlipayGlobal.private_key_location is empty" do
      before do
        @alipay.private_key_location = nil
      end

      it "should throw an Argument Error when private_key is not supplied :: #sign(params)" do
        exception = proc{ (@alipay::Sign::RSA.sign(@params)).call }.must_raise(ArgumentError)
        exception.message.must_equal "Assign valid location for RSA private key location :: #AlipayGlobal.private_key_location = #{@alipay.private_key_location}"
      end

      it "should generate the correct signature :: #sign(params, private_key)" do
        assert_equal @rsa_signature, @alipay::Sign::RSA.sign(@params, @test_rsa_private_key)
      end
    end

    describe "AlipayGlobal.private_key_location is invalid" do
      before do
        @alipay.private_key_location = "#{File.dirname __dir__}/../keys/test_private_key.danger.pem"
      end

      it "should throw an Argument Error when private_key is not supplied :: #sign(params)" do
        exception = proc{ (@alipay::Sign::RSA.sign(@params)).call }.must_raise(Errno::ENOENT)
        exception.message.must_include "No such file or directory"
      end
    end

    describe "AlipayGlobal.private_key_location is filled with a valid location" do
      before do
        @alipay.private_key_location = "#{File.dirname __dir__}/../keys/test_private_key.pem"
      end

      it "should generate the correct signature :: #sign(params)" do
        assert_equal @rsa_signature, @alipay::Sign::RSA.sign(@params)
      end
    end
  end

  describe "RSA#verify?" do
    it "should return true for the correct signature match" do
      @alipay::Sign::RSA.verify?(@params, @test_rsa_public_key, @rsa_signature).must_equal true
    end

    it "should return false for incorrect signature match" do
      @alipay::Sign::RSA.verify?(@params, @test_rsa_public_key, "mike#{@rsa_signature}").must_equal false
    end
  end

end