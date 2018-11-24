require 'aws-sdk-ec2'  # v2: require 'aws-sdk'

class AwsKeyPairs
  def initialize
    @ec2 = Aws::EC2::Client.new(region: 'us-west-2')
  end

  def create_key_pair(key_pair_name)
    begin
      key_pair = @ec2.create_key_pair({
        key_name: key_pair_name
      })
      puts "Created key pair '#{key_pair.key_name}'."
      puts "\nSHA-1 digest of the DER encoded private key:"
      puts "#{key_pair.key_fingerprint}"
      puts "\nUnencrypted PEM encoded RSA private key:"
      puts "#{key_pair.key_material}"
      puts "Store this into a file for SSH usage!"
      return key_pair
    rescue Aws::EC2::Errors::InvalidKeyPairDuplicate
      puts "A key pair named '#{key_pair_name}' already exists."
    end
    nil
  end

  def list_key_pairs
    key_pairs_result = @ec2.describe_key_pairs()

    if key_pairs_result.key_pairs.count > 0
      puts "\nKey pair names:"
      key_pairs_result.key_pairs.each do |key_pair|
        puts key_pair.key_name
      end
    end
    key_pairs_result
  end

  def delete_key_pair
    @ec2.delete_key_pair({
      key_name: key_pair_name
    })
    nil
  end
end
