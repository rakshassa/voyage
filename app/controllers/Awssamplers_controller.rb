require 'AwsWrapper'
require 'AwsKeyPairs'
require 'AwsCloudFormation'

class AwssamplersController < ApplicationController
  before_action :ensure_admin
  before_action :set_team, only: %i[create_keypair check_status delete_stack]

  def index
    # TODO: add list_s3_buckets
  end

  def list_s3_buckets
    aws = AwsWrapper.new
    @buckets = aws.list_all_s3_buckets
  end

  # http://localhost:3000/awssampler/create_keypair?team_id=9
  def create_keypair
    key_name = 'elis-example-team-' + @team.id.to_s
    bucket_name = key_name
    key_file_name = "your_ssh_key.pem"

    # Make a key pair
    aws = AwsKeyPairs.new
    key_pair = aws.create_key_pair(key_name)

    # Only save the data if the key pair was created.
    # If it already existed, then it's already in S3.
    s3 = AwsWrapper.new
    if key_pair.present?
      # Store into S3
      s3.create_bucket(bucket_name)
      s3.write_to_s3(bucket_name, key_file_name, key_pair.key_material)
    end

    @url = s3.signed_url(bucket_name, key_file_name)

    cf = AwsCloudFormation.new
    stack_name = cf.team_created(@team.id, key_name)

    @team.keypair_name = key_name
    @team.keypair_filename = key_file_name
    @team.bucket_name = bucket_name
    @team.stack_name = stack_name
    @team.save

    @status = "Never checked"
  end

  def check_status
    @url = params['url']

    cf = AwsCloudFormation.new
    @status = cf.stack_status(@team.stack_name)

    @output = nil
    if @status == 'CREATE_COMPLETE'
      outputs = cf.stack_outputs(@team.stack_name)
      @output = cf.parse_output(outputs, "URL")
    end

    render 'create_keypair'
  end

  def delete_stack
    cf = AwsCloudFormation.new
    cf.delete_stack(@team.stack_name)
    @status = cf.stack_status(@team.stack_name)
    @url = nil
    @output = nil
    render 'create_keypair'
  end

  private

  def set_team
    team = params['team_id']
    return redirect_to root_path if team.blank?
    teams = Team.where(id: team)
    return redirect_to root_path unless teams.present?
    @team = teams.first
    true
  end
end
