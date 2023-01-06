# BxBlockPosts
Short description and motivation.

## Configuring remote file storage

In order to use remote file storage, the application needs the following configuration:

#### Changes in `app-deploy/values.yaml`

```yaml
appExtConfig:
  ...
  STORAGE_ACCESS_KEY: "access-key"
  STORAGE_SECRET_ACCESS_KEY: "secret-key"
  STORAGE_ENDPOINT: "http://storage.endpoint"
  STORAGE_REGION: "your-region"
  STORAGE_BUCKET: "your-bucket"
```

The right values for the app need to be asked to the Ops team.

#### Changes in `template-app/config/storage.yml`

A new storage service needs to be set as follows:

```yaml
minio:
  service: S3
  access_key_id: <%= ENV['STORAGE_ACCESS_KEY'] %>
  secret_access_key: <%= ENV['STORAGE_SECRET_ACCESS_KEY'] %>
  region: <%= ENV['STORAGE_REGION'] %>
  bucket: <%= ENV['STORAGE_BUCKET'] %>
  endpoint: <%= ENV['STORAGE_ENDPOINT'] %>
  force_path_style: true
```

#### Changes in `template-app/config/environments/production.rb`

The new service needs to be configured to be used in production environment:

```ruby
  config.active_storage.service = :minio
```

#### Changes in `template-app/Gemfile`

```ruby
gem 'aws-sdk-s3', require: false
```

After this, `bundle` needs to be run to update the `Gemfile.lock` file.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'bx_block_posts'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install bx_block_posts
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
