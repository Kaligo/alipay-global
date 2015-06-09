# alipay-global
Unofficial gem for linking up to global.alipay for remote payment

Development of this gem is largely influenced by the [unofficial alipay gem](https://github.com/chloerei/alipay)

## Configuration

If you're using MD5, the api_secret_key needs to be initialized. If RSA is used, the private_key_location needs to be initialized. DSA is currently not supported.

```ruby
AlipayGlobal.api_partner_id = 'YOUR_PID'
AlipayGlobal.api_secret_key = 'YOUR_KEY'

#AlipayGlobal.private_key_location = 'YOUR PRIVATE KEY LOCATION' #Your .pem file location

#AlipayGlobal.sign_type = 'MD5' # Available values: MD5, RSA. Default is MD5
#AlipayGlobal.debug_mode = true # Enable parameter check. Default is true.
```

## Usage

### Service

#### Service::Trade

```ruby
create
```

#### Definition

```ruby
AlipayGlobal::Service::Trade.create({ARGUMENTS})
```

#### Example

```ruby
AlipayGlobal::Service::Trade.create(
  out_trade_no: '20150401000-0001',
  subject: 'Subject',
  currency: 'USD',
  total_fee: '10.00',
  notify_url: 'https://example.com/orders/20150401000-0001/notify'
)
# => 'https://mapi.alipay.com/gateway.do?service=create_forex_trade...' #for production
```

#### ARGUMENTS

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| out_trade_no | required | Order number in your application. (Unique inside the partner system) |
| subject | required | The name of the goods. Cannot contain special symbols |
| currency | required | The settlement currency merchant named in contract. Refer to abbreviation of currencies |
| total_fee | required * | A floating number ranging 0.01~1000000.00 If use the rmb_fee, don’t use the total_fee |
| notify_url | required | The URL for receiving notifications after the payment process |
| rmb_fee | optional | 0.01~1000000.00 Use this parameter to replace total_fee if partner wish to price their product in RMB. If use the total_fee, don’t use the rmb_fee. |
| return_url | optional | After the payment transaction is done, the result is returned via the URL (only suitable for interfaces with directly returned results). |
| body | optional | A detailed description of the goods. Cannot contain special symbols |
| order_gmt_create | optional | YYYY-MM-DD HH:MM:SS please use China local time in order to sync with Alipay sustem, this parameter can only be used with order_valid_time together in order to control the valid time from redirect to login |
| order_valid_time | optional | Maximum is 21600,unit is second,this parameter can only be used with order_gmt_create together in order to control the valid time from redirection to login |
| timeout_rule | optional | Options: 5m 10m 15m 30m 1h 2h 3h 5h 10h 12h. default is 12h. this parameter control the valid time from login to completion, please contact Alipay technical service if you want to enable this param |
| auth_token | optional | The secure token from accessing express login API Mandatory for express login |
| supplier | optional | seller name shown in the cashier |
| seller_id | optional* | For PSG only The unique ID for PSG to identify a sub-merchant. |
| seller_name | optional* | For PSG only. The name of sub-merchant who initiate the request. |
| seller_industry | optional* | For PSG only The industry type of sub-merchant who initiate the request. |

\* Normal Mechant: optional. FOR PSG: compulsory
\*\*\* Attention1:In the case a merchant wish to price their products in RMB, the merchant shall not change the value of the currency parameter, instead he shall just replace the total_fee with rmb_fee, and then his trade will appears in RMB in front of user.
\*\*\* Attention2:The request parameters can only be accepted by the Alipay system if they are signed according to the signature mechanism specified in this document.The parameter “timeout_rule”, the default value is 12h. If you want to use this parameter to change timing, you need to contact Alipay technical. Otherwise you will have an error.
