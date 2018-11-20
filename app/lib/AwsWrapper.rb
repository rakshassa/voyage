require 'aws-sdk-s3'  # v2: require 'aws-sdk'

class AwsWrapper
  def initialize
  end

  def list_s3_buckets
    s3 = Aws::S3::Resource.new(region: 'us-west-2')

    buckets = s3.buckets.limit(10)
    buckets
  end

  def list_all_s3_buckets
    s3 = Aws::S3::Client.new

    bucket_response = s3.list_buckets
    # bucket_response.owner exists as well.
    return bucket_response.buckets
  end

  # Example of how to assume a role and pass creds into the AWS clients.
  # def assume_role
  #   role_credentials = Aws::AssumeRoleCredentials.new(
  #     client: Aws::STS::Client.new,
  #     role_arn: "linked::account::arn",
  #     role_session_name: "session-name"
  #   )

  #   s3 = Aws::S3::Client.new(credentials: role_credentials)
  # end

  # NOTE: we can use wait_until mechanics to poll until something is done
  # https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/using-waiters.html

  # NOTE: invoke lambda functions
  # https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/lambda-ruby-example-run-function.html

  # Full documentation of every supported class and method
  # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Bucket.html

  # NOTE: need AWS creds in the ENV variables for authentication until we start running on an EC2 instance with roles.

end
