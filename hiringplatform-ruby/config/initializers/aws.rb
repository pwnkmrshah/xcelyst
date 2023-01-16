aws_credentials = Aws::Credentials.new(ENV['AWS_ACCESS_KEY'], ENV['AWS_SECRET_KEY'])
BUCKET_S3 = Aws::S3::Resource.new(
    region: ENV['AWS_REGION'],
    credentials: aws_credentials
).bucket(ENV['AWS_BUCKET'])