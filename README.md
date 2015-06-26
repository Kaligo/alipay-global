# alipay-global
Unofficial gem for linking up to global.alipay for remote payment

Development of this gem is largely influenced by the [unofficial alipay gem](https://github.com/chloerei/alipay). Code structure has been replicated from here in some areas.

You can find the docs for global.alipay's Cross Border Payment service [here](http://global.alipay.com/product/mobilepayments.htm)

## Configuration

If you're using MD5, the api_secret_key needs to be initialized. If RSA is used, the private_key_location needs to be initialized. DSA is currently not supported.

```ruby
AlipayGlobal.api_partner_id = 'YOUR_PID'
AlipayGlobal.api_secret_key = 'YOUR_KEY'

#AlipayGlobal.private_key_location = 'YOUR PRIVATE KEY LOCATION' #Your .pem file location

#AlipayGlobal.sign_type = 'MD5' # Available values: MD5, RSA. Default is MD5
#AlipayGlobal.debug_mode = true # Enable parameter check. Default is true.
```

## Note

### Operational Functions

| Feature | Description |
| ------- | ----------- |
| AlipayGlobal::Service::Trade.create | |
| AlipayGlobal::Service::Trade.refund | |
| AlipayGlobal::Service::Notification.check | |
| AlipayGlobal::Service::Reconciliation.request | |
| AlipayGlobal::Service::Exchange.current_rates | |

### Incomplete/ Untested Functions

| Feature | Description |
| ------- | ----------- |
| AlipayGlobal::Sign | RSA | Not tested. I do not have an RSA based relationship with Alipay at the moment to test requests via RSA signing |
| AlipayGlobal::Sign | DSA | Not implemented |
| AlipayGlobal::Service::Trade.batch_refund | Awaiting verification and support from Alipay: Issue with signing for multipartforms |

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

1. create
  1. RSA integration: User needs to work with Alipay team to exchange RSA public keys to properly test the content
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

| Key | Requirement | Data Type | Description |
| --- | ----------- | --------- | ----------- |
| mobile | optional **(unique to this gem)** | boolean | true/false boolean value. Tells the gem whether you want to direct the user to Alipay's mobile friendly site | 
| out_trade_no | required | string | Order number in your application. (Unique inside the partner system) |
| subject | required | string | The name of the goods. Cannot contain special symbols |
| currency | required | string | The settlement currency merchant named in contract. Refer to abbreviation of currencies |
| total_fee | required * | float | A floating number ranging 0.01~1000000.00 If use the rmb_fee, don’t use the total_fee |
| notify_url | required | string | The URL for receiving notifications after the payment process |
| rmb_fee | optional | float | 0.01~1000000.00 Use this parameter to replace total_fee if partner wish to price their product in RMB. If use the total_fee, don’t use the rmb_fee. |
| return_url | optional | string | After the payment transaction is done, the result is returned via the URL (only suitable for interfaces with directly returned results). |
| body | optional | string | A detailed description of the goods. Cannot contain special symbols |
| order_gmt_create | optional | string | YYYY-MM-DD HH:MM:SS please use China local time in order to sync with Alipay sustem, this parameter can only be used with order_valid_time together in order to control the valid time from redirect to login |
| order_valid_time | optional | string | Maximum is 21600,unit is second,this parameter can only be used with order_gmt_create together in order to control the valid time from redirection to login |
| timeout_rule | optional | string | Options: 5m 10m 15m 30m 1h 2h 3h 5h 10h 12h. default is 12h. this parameter control the valid time from login to completion, please contact Alipay technical service if you want to enable this param |
| auth_token | optional | string | The secure token from accessing express login API Mandatory for express login |
| supplier | optional | string | seller name shown in the cashier |
| seller_id | optional* | string | For PSG only The unique ID for PSG to identify a sub-merchant. |
| seller_name | optional* | string | For PSG only. The name of sub-merchant who initiate the request. |
| seller_industry | optional* | string | For PSG only The industry type of sub-merchant who initiate the request. |

\* Normal Mechant: optional. FOR PSG: compulsory

\*\*\* Attention1:In the case a merchant wish to price their products in RMB, the merchant shall not change the value of the currency parameter, instead he shall just replace the total_fee with rmb_fee, and then his trade will appears in RMB in front of user.

\*\*\* Attention2:The request parameters can only be accepted by the Alipay system if they are signed according to the signature mechanism specified in this document.The parameter “timeout_rule”, the default value is 12h. If you want to use this parameter to change timing, you need to contact Alipay technical. Otherwise you will have an error.

```ruby
status
```

#### Definition

```ruby
AlipayGlobal::Service::Trade.status({ARGUMENTS})
```

#### Example

```ruby
AlipayGlobal::Service::Trade.status(
  out_trade_no: "SAMPLE_TRANSACTION_ID"
)
# success => { success: true, message {
  trade_no: "ALIPAYS_INTERNAL_TRADE_NO",
  out_trade_no: "YOUR_TRADE_NO_USED",
  subject: "SUBJECT CONTENT USED IN TRANSACTION",
  trade_status: "WAIT_BUYER_PAY/TRADE_FINISHED/TRADE_CLOSED"
} }
# error => { success: false, message: "ERROR_CODE. # See below" }
#for production
```

#### ARGUMENTS

| Key | Requirement | Data Type | Description |
| --- | ----------- | --------- | ----------- |
| out_trade_no | required | string | The ID for the original transaction. |

#### RESPONSE

##### Success response

| Trade status | Description |
| ------------ | ----------- |
| WAIT_BUYER_PAY | The buyer is expected to make the payment |
| TRADE_FINISHED | The payment has been made, transaction closes. |
| TRADE_CLOSED | Transaction closed without payment. |

##### Error response
Shown when there's an issue with the payment uri created or if the transaction does not exist

| Error Code | Description |
| ---------- | ----------- |
| TRADE_NOT_EXIST | This trade number does not exist in Alipay's transaction DB |
| ILLEGAL_ARGUMENT | Illegal parameters |
| ILLEGAL_SIGN | Illegal signature |
| HASH_NO_PRIVILEGE | No sufficient rights to complete the query |
| ILLEGAL_SERVICE | Service Parameter is incorrect |
| ILLEGAL_PARTNER | Incorrect Partner ID |
| ILLEGAL_SIGN_TYPE | Signature is of wrong type. |
| ILLEGAL_CHARSET | Illegal charset |


```ruby
refund
```

#### Definition

```ruby
AlipayGlobal::Service::Trade.refund({ARGUMENTS})
```

#### Example

```ruby
AlipayGlobal::Service::Trade.refund(
  out_return_no: "SAMPLE_REFUND_ID",
  out_trade_no: "SAMPLE_TRANSACTION_ID",
  return_rmb_amount: 200.00,
  reason: "hello",
  gmt_return: (Time.parse("2015-03-20 12:00").getlocal("+08:00")).strftime("%Y%m%d%H%M%S"),
  currency: "USD"
)
# => 'https://mapi.alipay.net/gateway.do?service=forex_refund...' #for production
```

#### ARGUMENTS

| Key | Requirement | Data Type | Description |
| --- | ----------- | --------- | ----------- |
| out_return_no | required | string | The new ID which created for refund. |
| out_trade_no | required | string | The ID for the original transaction. |
| return_amount | required | float |  |
| currency | required | string |  |
| reason | required | string | Reason for refund, out of supply e.g. |
| return_rmb_amount | optional* | float | This parameter related the RMB price function in the payment interface |

\* return_rmb_amount: if used, then leave return_amount empty

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

Hash contains objects representing each currency. Each object is represented by it's named currency code.

| Attribute | Data Type | Description |
| --------- | --------- | ----------- |
| time | DateTime | When Alipay retrieved the date and time of this currency rate |
| rate | float | Rate for 1 FOREX Unit : Units of RMB/CNY  |


#### Service::Notification

It is necessary for the partner system to verify the integrity and correctness of Alipay’snotification. Intheinterestofsystem’shealthiness,itisstrongly recommended that the partner system apply such verification mechanism.

In order to guarantee the interface will be used legally, the partner system can only verify the notifications within the last 1 minute (this configuration is subject to change, and such change will not be notified).

```ruby
check
```

#### Definition

```ruby
AlipayGlobal::Service::Notification.check({
  notify_id: 'your_notification_id_received'
})
```

#### Example

```ruby
AlipayGlobal::Service::Notification.check({
  notify_id: 'your_notification_id_received'
})

# Results: Alipay will respond with whether this notification is valid or not?
# => "false"
```

#### Parameters

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| notify_id | required | The ID of Alipay system’s notification. |

\* Provided: provisioned by setting these environment variables from the start

#### Results

Notification verification output result list:

| Result | Description |
| ------ | ----------- |
| invalid | The input parameter is invalid. |
| true | Authentication passed. |
| false | Authentication failed. |

#### Service::Reconciliation

After certain period of time, the oversea merchant partner needs to verify the past transaction details in order to make sure the correctness and integrity of transaction records. This can be performed by using the reconciliation file downloading interface. The starting and end dates should be provided within a 10-day interval. Same-day transaction details cannot be accessed by this interface.

```ruby
check
```

#### Definition

```ruby
AlipayGlobal::Service::Reconciliation.request({
  'start_date'=> '20120202',
  'end_date'=> '20120205'
})
```

#### Parameters

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| start_date | required | The start date of the reconciliation period, formatted as YYYYMMDD |
| end_date | required | The end date of the reconciliation period, formatted as YYYYMMDD |

#### Example

```ruby
AlipayGlobal::Service::Reconciliation.request({
  'start_date'=> '20120202',
  'end_date'=> '20120205'
})

# Results: Alipay will respond with either the file's array of results, false, or throw an ArgumentError?
# => "false"
```



#### Results

**Failure Case 1** : No transactions found
```ruby
AlipayGlobal::Service::Reconciliation.request(params)

# Results: If no transaction records found
# => "false"
```

**Failure Case 2** : Errors in arguments
Argument Error with the following messages will be thrown

| Error Message | Description |
| ------------- | ----------- |
| File download failed:Over 10 days to Date period | The supplied date range exceeds 10 days |
| <?xml version=\"1.0\" encoding=\"GBK\"?>\n<alipay><is_success>F</is_success><error>ILLEGAL_PARTNER</error></alipay> | Partner id that is set does not exist in Alipay's system/ or isn't active in the production/testing environment yet |
| File download failed:Finish date ahead of begin date | Invalid date types supplied |
| File download failed:Illegal Date period! | No date/ Invalid date data |
| File download failed:Finish date not ahead of today | Dates supplied for reconciliations should be before current date (Alipay's probably) |

**Untested Cases**
The following cases have yet to be tested

| Errors | Description |
| ------ | ----------- |
| Date format incorrect YYYYMMDD | Unable to recreate scenario |
| System exception |  |
| Internet connected exception ,please try later |  |

**Success Case** : Array containing the results of transactions in these periods.

```ruby
AlipayGlobal::Service::Reconciliation.request(params)

# Results: If no transaction records found
# => [
{:partner_transaction_id=>"20131219-144657-234", :amount=>"0.11", :currency=>"EUR", :transaction_time=>#<DateTime: 2013-12-19T21:52:28+00:00 ((2456646j,78748s,0n),+0s,2299161j)>, :settlement_time=>"", :transaction_type=>"P", :service_charge=>"0.00", :status=>"P", :remarks=>"Test"}, 
{:partner_transaction_id=>"1326557", :amount=>"2125.25", :currency=>"HKD", :transaction_time=>#<DateTime: 2013-12-19T17:58:40+00:00 ((2456646j,64720s,0n),+0s,2299161j)>, :settlement_time=>"", :transaction_type=>"P", :service_charge=>"21.25", :status=>"P", :remarks=>"Grey Hours Limited (Testing)"}, 
{:partner_transaction_id=>"1326555", :amount=>"2125.25", :currency=>"HKD", :transaction_time=>#<DateTime: 2013-12-19T17:56:37+00:00 ((2456646j,64597s,0n),+0s,2299161j)>, :settlement_time=>"", :transaction_type=>"P", :service_charge=>"21.25", :status=>"P", :remarks=>"Grey Hours Limited (Testing)"}, 
{:partner_transaction_id=>"1326244", :amount=>"0.01", :currency=>"HKD", :transaction_time=>#<DateTime: 2013-12-19T16:11:26+00:00 ((2456646j,58286s,0n),+0s,2299161j)>, :settlement_time=>"", :transaction_type=>"P", :service_charge=>"0.00", :status=>"P", :remarks=>"MICROS-Fidelio Information Systems Co. Limited (Testing)"}
]
```

### Contributing

Feel free to fork this repo and make a PR.