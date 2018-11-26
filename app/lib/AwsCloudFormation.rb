require 'aws-sdk-cloudformation'
require 'aws-sdk-s3'

class AwsCloudFormation
  def initialize
    @cf = Aws::CloudFormation::Client.new(region: 'us-west-2')
  end

  def team_created(team_id, key_pair_name)
    s3 = Aws::S3::Resource.new(region: 'us-west-2')

    # TODO: config file for bucket name and template object name
    template_bucket = s3.bucket('elis-examples-voyage')
    return nil unless template_bucket.exists?
    template = template_bucket.object('ElisExampleStack.json')
    return nil unless template.exists?

    stack_name = 'eli-create-team-' + team_id.to_s

    # see if this stack was already created.
    stack = Aws::CloudFormation::Stack.new(stack_name, @cf)
    return stack.name if stack.exists?

    stack = @cf.create_stack(
      { stack_name: stack_name, template_url: template.public_url,
        :parameters => [
          {
            parameter_key: "KeyName",
            parameter_value: key_pair_name,
            use_previous_value: false
          },
          {
            parameter_key: "SSHLocation",
            parameter_value: "0.0.0.0/0",
            use_previous_value: false
          },
          {
            parameter_key: "InstanceType",
            parameter_value: 't2.small',
            use_previous_value: false
          }
        ],
        :notification_arns => [ 'arn:aws:sns:us-west-2:952547111947:elis_example_topic' ]
      }
    )
    # TODO: app config should house the notification_arn

    # my lambda function ARN:
    # arn:aws:lambda:us-west-2:952547111947:function:ElisTest

    # SNS topic that forwards to lambda
    # arn:aws:sns:us-west-2:952547111947:elis_example_topic

    return stack_name
  end

  def stack_outputs(stack_name)
    stack = Aws::CloudFormation::Stack.new(stack_name, @cf)
    return nil unless stack.exists?
    return nil unless stack.stack_status == 'CREATE_COMPLETE'

    stack.outputs
  end

  def parse_output(outputs, key_name)
    # [#<struct Aws::CloudFormation::Types::Output output_key="URL", output_value="http://18.237.249.228", description="Newly created application URL", export_name=nil>]
    outputs.each do |output|
      return output.output_value if output.output_key == key_name
    end

    nil
  end

  def stack_status(stack_name)
    stack = Aws::CloudFormation::Stack.new(stack_name, @cf)
    return nil unless stack.exists?

    stack.stack_status
  end

  def delete_stack(stack_name)
    stack = Aws::CloudFormation::Stack.new(stack_name, @cf)
    return nil unless stack.exists?
    # TODO: make sure the stack is done creating? or can we start delete while it runs?
    token = stack_name + "-delete-token"
    stack.delete({ client_request_token: token })

    true
  end
end
