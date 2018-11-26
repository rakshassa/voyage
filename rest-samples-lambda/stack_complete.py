import requests
import json

APIKey = 'fake_token_here'
base_url = 'http://73.14.0.11:12366'

def lambda_handler(event, context):
    if "Records" not in event: return "Unexpected Event: missing Records Key"
    record = event["Records"][0]

    if "Sns" not in record: return "Unexpected Event: missing Sns Key"
    sns = record['Sns']

    if "Message" not in sns: return "Unexpected Event: missing Message Key"
    message = sns["Message"]

    values = message.splitlines()

    resource_type = None
    stack_name = None
    resource_status = None

    for value in values:
      value = value.strip()
      if value.startswith('ResourceType='):
        resource_types = value.split("'")[1::2]; # get all characters between single quotes
        resource_type = resource_types[0]
      if value.startswith('StackName='):
        stack_names = value.split("'")[1::2]; # get all characters between single quotes
        stack_name = stack_names[0]
      if value.startswith('ResourceStatus='):
        resource_statuses = value.split("'")[1::2]; # get all characters between single quotes
        resource_status = resource_statuses[0]

    if resource_type == None or stack_name == None or resource_status == None:
      return "Unexpected Event: missing values."

    if resource_type != 'AWS::CloudFormation::Stack':
      return "This was a stack element."

    if resource_status != 'CREATE_COMPLETE':
      return "The stack is still constructing."

    return send_stack_completed(stack_name)

def send_stack_completed(stack_name):
    data = { 'stack_id': stack_name }
    val = json.dumps(data)
    data = { 'token': APIKey, 'aws_values': val }
    url = base_url + "/api/v1/api/stack_complete.json"

    myResponse = None
    try:
        myResponse = requests.post(url, data=data, verify=False)
    except requests.exceptions.RequestException:
        return "Unable to connect to REST API at " + str(url)

    if(myResponse.ok):
        jData = json.loads(myResponse.content)
        return "It Worked" + str(jData)
    else:
        return "It Failed" + str(myResponse.status_code) + " " + str(myResponse.reason)

# {"Records":[{"EventVersion":"1.0", "EventSubscriptionArn":"arn:aws:sns:us-west-2:952547111947:elis_example_topic:d4625af1-126c-4fce-a812-834d59c7d854", "EventSource":"aws:sns",
# "Sns":{
#   "SignatureVersion":"1", "Timestamp":"2018-11-26T20:24:31.682Z", "Signature":"FxrNVMJnDrRA/N+pRfFHMV2iQp1l8wVXEIKWjNBJlk+UnjDwBNsX+gDqKmj+7vi6h4TfcBezQO4ePONB6Rjf3Gr1P99CLbxXG8o3HSUPV0v3uhFSjIKQ4CdRQ3pVTiTTJQXMZXhJE2uyyEGxu4kLZ03JAMxNOuKb0KSQyq0f594QTq5oQ0yv5hSdHfANlI3Fyb3kfbHlVC+lqdChvdBdeR9GSuCP+s3ZqE2r/d0Ohq6QAd5MQxVZxNSlD2+f2xwMtUC2GGYqXP65SJslTIIFe8mv2RJvl3BKs90URE4zXh3pDQjHHb1Ff8gpId58d2UI0S7li9b//0sJ3jqlwiFx7w==", "SigningCertUrl":"https://sns.us-west-2.amazonaws.com/SimpleNotificationService-ac565b8b1a6c5d002d285f9598aa1d9b.pem",
#   "MessageId":"5a4a2443-a2ed-55b2-b58b-7035fa52062e",

#   "Message":
#     """StackId='arn:aws:cloudformation:us-west-2:952547111947:stack/eli-create-team-2/0cc76cc0-f1b9-11e8-b3db-0a473bf201de'\n
#      Timestamp='2018-11-26T20:24:31.640Z'\n
#      EventId='48286210-f1b9-11e8-96f5-503ac9ec2461'\n
#      LogicalResourceId='eli-create-team-2'\n
#      Namespace='952547111947'\n
#      PhysicalResourceId='arn:aws:cloudformation:us-west-2:952547111947:stack/eli-create-team-2/0cc76cc0-f1b9-11e8-b3db-0a473bf201de'\n
#      PincipalId='AIDAJW3U2N6XRDKRPRQ56'\n
#      ResourceProperties='null'\n
#      ResourceStatus='CREATE_COMPLETE'\n
#      ResourceStatusReason=''\n
#      ResourceType='AWS::CloudFormation::Stack'\n
#      StackName='eli-create-team-2'\n
#      ClientRequestToken='null'\n""",

#   "MessageAttributes":{}, "Type":"Notification", "UnsubscribeUrl":"https://sns.us-west-2.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:us-west-2:952547111947:elis_example_topic:d4625af1-126c-4fce-a812-834d59c7d854", "TopicArn":"arn:aws:sns:us-west-2:952547111947:elis_example_topic", "Subject":"AWS CloudFormation Notification"}}]}

# =====JSON Version below=======

# {"Records":[{"EventVersion":"1.0", "EventSubscriptionArn":"arn:aws:sns:us-west-2:952547111947:elis_example_topic:d4625af1-126c-4fce-a812-834d59c7d854", "EventSource":"aws:sns",
# "Sns":{
#   "SignatureVersion":"1", "Timestamp":"2018-11-26T20:24:31.682Z", "Signature":"FxrNVMJnDrRA/N+pRfFHMV2iQp1l8wVXEIKWjNBJlk+UnjDwBNsX+gDqKmj+7vi6h4TfcBezQO4ePONB6Rjf3Gr1P99CLbxXG8o3HSUPV0v3uhFSjIKQ4CdRQ3pVTiTTJQXMZXhJE2uyyEGxu4kLZ03JAMxNOuKb0KSQyq0f594QTq5oQ0yv5hSdHfANlI3Fyb3kfbHlVC+lqdChvdBdeR9GSuCP+s3ZqE2r/d0Ohq6QAd5MQxVZxNSlD2+f2xwMtUC2GGYqXP65SJslTIIFe8mv2RJvl3BKs90URE4zXh3pDQjHHb1Ff8gpId58d2UI0S7li9b//0sJ3jqlwiFx7w==", "SigningCertUrl":"https://sns.us-west-2.amazonaws.com/SimpleNotificationService-ac565b8b1a6c5d002d285f9598aa1d9b.pem",
#   "MessageId":"5a4a2443-a2ed-55b2-b58b-7035fa52062e",

#   "Message": "StackId='arn:aws:cloudformation:us-west-2:952547111947:stack/eli-create-team-2/0cc76cc0-f1b9-11e8-b3db-0a473bf201de'\nTimestamp='2018-11-26T20:24:31.640Z'\nEventId='48286210-f1b9-11e8-96f5-503ac9ec2461'\nLogicalResourceId='eli-create-team-2'\nNamespace='952547111947'\nPhysicalResourceId='arn:aws:cloudformation:us-west-2:952547111947:stack/eli-create-team-2/0cc76cc0-f1b9-11e8-b3db-0a473bf201de'\nPincipalId='AIDAJW3U2N6XRDKRPRQ56'\nResourceProperties='null'\nResourceStatus='CREATE_COMPLETE'\nResourceStatusReason=''\nResourceType='AWS::CloudFormation::Stack'\nStackName='eli-create-team-2'\nClientRequestToken='null'\n",

#   "MessageAttributes":{}, "Type":"Notification", "UnsubscribeUrl":"https://sns.us-west-2.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:us-west-2:952547111947:elis_example_topic:d4625af1-126c-4fce-a812-834d59c7d854", "TopicArn":"arn:aws:sns:us-west-2:952547111947:elis_example_topic", "Subject":"AWS CloudFormation Notification"}}]
# }

