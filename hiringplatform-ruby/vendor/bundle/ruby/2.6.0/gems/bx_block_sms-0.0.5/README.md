# BxBlockSms
Short description and motivation.

## Usage

First you need to configure your provider. Right now, we support 
[twilio](https://www.twilio.com) and [karix](https://www.karix.com/). We also support a testing
provider that stores messages in memory.

Add the following to your `config/application.rb` (or `config/environments/desired-enviroment.rb`)

### Configuring to use Twilio

```
  config.x.sms.provider = :twilio
  config.x.sms.account_id = 'account-id'
  config.x.sms.auth_token = 'your-token'
  config.x.sms.from = '+44777777777777'
```

### Configuring to use Karix

```
  config.x.sms.provider = :karix
  config.x.sms.account_id = 'account-id'
  config.x.sms.auth_token = 'your-token'
  config.x.sms.from = 'FROM-NAME-OR-NUMBER'
```

### Configuring to use Test backend (does not send a SMS, it's just for testing)

```
  config.x.sms.provider = :test
  config.x.sms.from = 'FROM-NAME-OR-NUMBER'
```

You can access sent messages with

```
BxBlockSms::Providers::Test.messages
```

## Sending a message

Once the configuration is done you can send an SMS by calling:

```
BxBlockSms::SendSms.new(phone_number, text_content).call
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'bx_block_sms'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install bx_block_sms
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
