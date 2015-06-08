module AlipayGlobal
  
  @debug_mode = true
  @sign_type = 'MD5'

  class << self
    attr_accessor :pid, :key, :sign_type, :debug_mode

    def debug_mode?
      !!@debug_mode
    end

    def helloworld
      puts "AlipayGlobal: Hello world!"
    end
  end
end