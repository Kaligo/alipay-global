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

#### Issues (awaiting resolution)

1. create_forex_trade
  1. rmb_fee issues with MD5 Signature (awaiting Alipay tech response)
  2. RSA integration: User needs to work with Alipay team to exchange RSA public keys to properly test the content
2. testing environment
  1. Alipay mobile site for testing is down. works in production.

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
| mobile | optional **(unique to this gem)** | true/false boolean value. Tells the gem whether you want to direct the user to Alipay's mobile friendly site | 
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


#### Service::Exchange

```ruby
current_rates
```

#### Definition

```ruby
AlipayGlobal::Service::Exchange.current_rates()
```

#### Example

```ruby
AlipayGlobal::Service::Exchange.current_rates()

# Results: hash with following content
# => {"AUD"=>{:time=>#<DateTime: 2012-03-30T11:25:37+00:00 ((2456017j,41137s,0n),+0s,2299161j)>, :rate=>6.4485}, "CAD"=>{:time=>#<DateTime: 2012-03-30T11:25:37+00:00 ((2456017j,41137s,0n),+0s,2299161j)>, :rate=>6.6682}, "CHF"=>{:time=>#<DateTime: 2012-04-24T11:25:37+00:00 ((2456042j,41137s,0n),+0s,2299161j)>, :rate=>6.829}, "DKK"=>{:time=>#<DateTime: 2012-04-24T11:25:37+00:00 ((2456042j,41137s,0n),+0s,2299161j)>, :rate=>2.0}, "EUR"=>{:time=>#<DateTime: 2012-04-24T11:25:37+00:00 ((2456042j,41137s,0n),+0s,2299161j)>, :rate=>8.3364}, "GBP"=>{:time=>#<DateTime: 2013-07-01T11:06:35+00:00 ((2456475j,39995s,0n),+0s,2299161j)>, :rate=>10.6744}, "HKD"=>{:time=>#<DateTime: 2012-02-27T12:55:00+00:00 ((2455985j,46500s,0n),+0s,2299161j)>, :rate=>0.8145}, "JPY"=>{:time=>#<DateTime: 2012-12-24T17:43:59+00:00 ((2456286j,63839s,0n),+0s,2299161j)>, :rate=>0.05638}, "KRW"=>{:time=>#<DateTime: 2012-10-18T14:07:10+00:00 ((2456219j,50830s,0n),+0s,2299161j)>, :rate=>0.001111}, "SEK"=>{:time=>#<DateTime: 2012-02-27T12:55:00+00:00 ((2455985j,46500s,0n),+0s,2299161j)>, :rate=>0.9375}, "SGD"=>{:time=>#<DateTime: 2012-02-27T12:55:00+00:00 ((2455985j,46500s,0n),+0s,2299161j)>, :rate=>4.938}, "USD"=>{:time=>#<DateTime: 2013-11-22T11:25:37+00:00 ((2456619j,41137s,0n),+0s,2299161j)>, :rate=>6.5487}}
```

#### Results

Hash contains objects representing each currency

| Attribute | Data Type | Description |
| time | DateTime | When Alipay retrieved the date and time of this currency rate |
| rate | float | Rate for 1 FOREX Unit : Units of RMB/CNY  |