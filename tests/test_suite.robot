*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    json

*** Variables ***
${baseurl}    http://httpbin.org

*** Test Cases ***
Get Wrong URL
    Create Session    httpbin    ${baseurl}
    ${response}=    Get Request    httpbin    /notexisting
    Should Be Equal As Strings    ${response.status_code}    404

Post Wrong URL
    Create Session    httpbin    ${baseurl}
    ${request_data}=    Set Variable    {"testing_key": "testing value"}
    ${response}=    Post Request    httpbin    /notexisting    data=${request_data}
    Should Be Equal As Strings    ${response.status_code}    404

Get request
    Create Session    httpbin    ${baseurl}
    ${arguments}=    Create Dictionary    argument1=textvalue    argument2=12345
    ${response}=    Get Request    httpbin    /get    params=${arguments}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal As Strings    ${response.headers['Content-Type']}    application/json
    Dictionaries Should Be Equal    ${response.json()['args']}    ${arguments}

Post request
    Create Session    httpbin    ${baseurl}
    ${request_dict}=    Create Dictionary    testing_key=testing value    testing_int=${12345}
    ${request_json}=    Evaluate    json.dumps(${request_dict})    json
    ${response}=    Post Request    httpbin    /post    data=${request_json}
    Log    ${response.json()}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal As Strings    ${response.headers['Content-Type']}    application/json
    Dictionaries Should Be Equal     ${response.json()['json']}    ${request_dict}
    Should Be Equal As Strings    ${response.json()['data']}    ${request_json}