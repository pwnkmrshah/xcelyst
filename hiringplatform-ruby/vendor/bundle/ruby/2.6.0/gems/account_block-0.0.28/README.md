# AccountBlock
Short description and motivation.

## Configuring SMS OTP

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

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'account_block'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install account_block
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
