# BxBlockPushNotifications
Short description and motivation.

## Usage

First you need to configure your provider. Right now, we only support
[OneSignal](onesignal.com).

Add the following to your `config/application.rb` (or `config/environments/desired-enviroment.rb`)

### Configuring to use OneSignal

```
  config.x.push_notifications.provider = :one_signal
  config.x.push_notifications.application_id = 'Your OneSignal App ID'
  config.x.push_notifications.auth_token = 'Your REST API Key'
```

## Sending a push notification

Once the configuration is done you can send a Push Notification by calling:

```ruby
BxBlockPushNotifications::SendPushNotification.new(
  title: 'Test notification title',
  message: 'Test notification body',
  app_url: 'app://app-url',
  user_ids: [ # list of user ids (player id in OneSignal terms)
    '0e1d2dbf-ff19-4cbd-87a1-2f3591079991'
  ]
).call
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'bx_block_push_notifications'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install bx_block_push_notifications
```

## Contributing
Contribution directions go here.
