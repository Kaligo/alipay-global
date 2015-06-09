# alipay-global
Unofficial gem for linking up to global.alipay for remote payment

Development of this gem is largely influenced by the unofficial alipay gem

## Configuration

If you're using MD5, the api_secret_key needs to be initialized. If RSA is used, the private_key_location needs to be initialized. DSA is currently not supported.

```ruby
AlipayGlobal.api_partner_id = 'YOUR_PID'
AlipayGlobal.api_secret_key = 'YOUR_KEY'

#AlipayGlobal.private_key_location = 'YOUR PRIVATE KEY LOCATION' #Your .pem file location

#AlipayGlobal.sign_type = 'MD5' # Available values: MD5, RSA. Default is MD5
#AlipayGlobal.debug_mode = true # Enable parameter check. Default is true.
```