require 'AwsWrapper'

class AwssamplersController < ApplicationController
  before_action :ensure_admin

  def list_s3_buckets
    aws = AwsWrapper.new
    @buckets = aws.list_all_s3_buckets
  end
end
