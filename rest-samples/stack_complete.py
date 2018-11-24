import json
import requests
import datetime

APIKey = 'fake_token_here'
base_url = 'http://localhost:3000'

def stack_complete(criteria):

    val = json.dumps(criteria)
    data = { 'token': APIKey, 'aws_values': val }
    url = base_url + "/api/v1/api/stack_complete.json"

    myResponse = requests.post(url, data=data, verify=False)

    if(myResponse.ok):
        jData = json.loads(myResponse.content)
        return jData
    else:
        print myResponse.reason
        print myResponse.status_code
        return False

########################################


criteria = { 'stack_id': 'fake_stack_id' }

result = stack_complete(criteria)
if not result:
    print "Unable to complete stack."
else:
    if 'error' in result and result['error'] == None:
        print str(result)
        print "Success!"
    else:
        print "Unexpected result"
        print str(result)

