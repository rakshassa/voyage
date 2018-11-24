require 'aws-sdk-s3'  # v2: require 'aws-sdk'

class AwsWrapper
  def initialize
    @s3 = Aws::S3::Client.new
  end

  def list_s3_buckets
    s3 = Aws::S3::Resource.new(region: 'us-west-2')

    buckets = s3.buckets.limit(10)
    buckets
  end

  def list_all_s3_buckets
    bucket_response = @s3.list_buckets
    return bucket_response.buckets
  end

  def create_bucket(bucket_name)
    begin
      resp = @s3.create_bucket(
        bucket: bucket_name,
        create_bucket_configuration: {
          location_constraint: "us-west-2",
        },
        acl: "public-read" # accepts private, public-read, public-read-write, authenticated-read
      )
    rescue Aws::S3::Errors::BucketAlreadyOwnedByYou
      return true
    end

    if resp.blank? or resp.location.blank?
      Rails.logger.error "Unable to create bucket: " + bucket_name
      return false
    end

    Rails.logger.error "Created Bucket: " + resp.location.to_s
    true
  end

  def write_to_s3(bucket_name, file_key, file_content)
    @s3.put_object(bucket: bucket_name, key: file_key, body: file_content)
  end

  def signed_url(bucket_name, file_key)
    signer = Aws::S3::Presigner.new(options: { client: @s3 })
    signer.presigned_url(:get_object, bucket: bucket_name, key: file_key, expires_in: 600)
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
