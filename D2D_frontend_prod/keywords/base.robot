*** Keywords ***
Get The Last User From Testdata List
    [Arguments]
    ${FILE_CONTENT}=   Get File    ${EXECDIR}/testdata/file_with_new_user_info.txt
    Log    File Content: ${FILE_CONTENT}
    @{LINES}=    Split To Lines    ${FILE_CONTENT}
    @{new_user_data}=    Split String  @{LINES}[-1]  ,
    # ${last_email}=  @{new_user_data}[-2]
    # ${last_pwd}=  @{new_user_data}[-1]
    Set Test Variable  ${last_email}  @{new_user_data}[-2]
    Set Test Variable  ${last_pwd}  @{new_user_data}[-1]
    
Open Confirm Link
    [Arguments]    ${confirm_link}
    Open browser  ${confirm_link}  ${BROWSER}
    Wait Until Element Is Visible  ${verified_email_msg_xpath}
    Page Should Contain  ${verified_email_msg}
    
Clear And Input Text
    [Arguments]  ${the_xpath}  ${the_value}
    Clear Element Text  ${the_xpath}
    Input Text  ${the_xpath}  ${the_value}
    
Create New Random Account Value
   [Arguments]  ${qa_user}
   ${add_id_random4} =  Generate Random String  4  [NUMBERS]
   Set Test Variable  ${new_user_id}  ${qa_user}${add_id_random4}
   Set Test Variable  ${new_user_email}  ${qa_user}${add_id_random4}@gmail.com
   ${add_pwd_random8} =  Generate Random String  8  [NUMBERS]
   Set Test Variable  ${password}  ${add_pwd_random8}
   
   # [Return]  ${new_user_id}
Create New Random Account
    [Arguments]  ${login_url}  ${username}  ${password}   ${email}
    Go To  ${login_url}
    Maximize Browser Window
    Sleep  2s
    Click Element  ${rl_button_xpath}
    Clear And Input Text  ${reg_username_xpath}  ${username}
    Clear And Input Text  ${reg_email_xpath}  ${email}
    Clear And Input Text  ${reg_password_xpath1}  ${password}
    Clear And Input Text  ${reg_password_xpath2}  ${password}
    Click Element  ${reg_submit_button_xpath}
    Sleep  5s
    Wait Until Element Is Visible  ${reg_success_msg_xpath1}
    Page Should Contain  ${reg_email_xpath_success_msg1}
    Page Should Contain  ${reg_email_xpath_success_msg2}    
    
Login New User
    [Arguments]  ${login_url}  ${username}  ${password}
    # Initiate Context Dictionary
    Go To  ${login_url}
    Maximize Browser Window
    Sleep  2s
    Click Element  ${rl_button_xpath}
    Clear And Input Text  ${username_xpath}  ${username}
    Clear And Input Text  ${password_xpath}  ${password}
    Click Element  ${submit_button_xpath}
    Sleep  5s

Clear And Input Text
    [Arguments]  ${the_xpath}  ${the_value}
    Clear Element Text  ${the_xpath}
    Input Text  ${the_xpath}  ${the_value}
    
Wait And Click Link
    [Arguments]  ${link}
    Sleep  5s
    Wait Until Element Is Visible  link=${link}
    Click Element  link=${link}
    
Write_variable_in_file
    [Arguments]  ${variable1} 
    Append To File  ${EXECDIR}/testdata/file_with_new_user_info.txt  ${variable1}

Get The Last User From Testdata List
    [Arguments]
    ${FILE_CONTENT}=   Get File    ${EXECDIR}/testdata/file_with_new_user_info.txt
    Log    File Content: ${FILE_CONTENT}
    @{LINES}=    Split To Lines    ${FILE_CONTENT}
    @{new_user_data}=    Split String  @{LINES}[-1]  ,
    # ${last_email}=  @{new_user_data}[-2]
    # ${last_pwd}=  @{new_user_data}[-1]
    Set Test Variable  ${last_email}  @{new_user_data}[-2]
    Set Test Variable  ${last_pwd}  @{new_user_data}[-1]
    
Check Confirm Email
    Open Mailbox    host=imap.googlemail.com	user=${email_qa_gmail_user}    password=${email_qa_gmail_user_pwd}
    ${LATEST} =    Wait For Email   recipient=${last_email}    timeout=300
    @{all_links}=  Get Links From Email  ${LATEST}
    Set Test Variable  ${confirm_link}  @{all_links}[0]
    Should Contain  ${confirm_link}  ${email_confirm_prefix_url}
    ${Body}=  Get Email Body  ${LATEST}
    ${username}=  Remove String  ${last_email}  @gmail.com
    Should Contain  ${Body}.decode('utf-8')  ${username}  
    Log   ${Body}
    Close Mailbox

Open Confirm Link
    [Arguments]    ${confirm_link}
    Open browser  ${confirm_link}  ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible  ${verified_email_msg_xpath}
    Page Should Contain  ${verified_email_msg}
    Close browser    

Convert Values And Compare Values
    [Arguments]  ${valuea}  ${valueb}
    ${valuea}=  Convert To String  ${valuea}
    ${valueb}=  Convert To String  ${valueb}
    ${valuea}=  Convert To Uppercase  ${valuea}
    ${valueb}=  Convert To Uppercase  ${valueb}
    Should Be Equal  ${valuea}  ${valueb}

Check If Key Existed
    [Arguments]  ${objecta}  ${objectb}  ${keya}  ${keyb}
    ${checka}=  Run Keyword And Return Status  Get From Dictionary  ${objecta}  ${keya}
    ${checkb}=  Run Keyword And Return Status  Get From Dictionary  ${objectb}  ${keyb}
    ${checkboth}=  Evaluate  ${checka}&${checkb}
    [Return]  ${checkboth}

Compare Sub Actions
    [Arguments]  ${objecta}  ${objectb}  ${keya}  ${keyb}  ${not_case_sensitive}
    ${valuea}=  Get From Dictionary  ${objecta}  ${keya}
    ${valueb}=  Get From Dictionary  ${objectb}  ${keyb}
    log  ${valuea}
    log  ${valueb}
    ${valuea}=  Convert To String  ${valuea}
    ${valueb}=  Convert To String  ${valueb}
    Run Keyword If  ${not_case_sensitive}  Convert Values And Compare Values  ${valuea}  ${valueb}
    Run Keyword Unless  ${not_case_sensitive}  Should Be Equal  ${valuea}  ${valueb}

Compare
    [Arguments]  ${objecta}  ${objectb}  ${sub_dict}  ${not_case_sensitive}=${False}
    ${keys_dict}=  Get From Dictionary  ${vars_dict}  ${sub_dict}
    ${keys}=  Get Dictionary keys  ${keys_dict}
    ${count}=  Get Length  ${keys}
    :FOR  ${i}  IN RANGE  0  ${count}
    \  Set Test Variable  ${keya}  ${keys[${i}]}
    \  Set Test Variable  ${keyb}  ${keys_dict[\'${keya}\']}
    \  ${checkboth}=  Check If Key Existed  ${objecta}  ${objectb}  ${keya}  ${keyb}
    \  Run Keyword If  ${checkboth}  Compare Sub Actions  ${objecta}  ${objectb}  ${keya}  ${keyb}  ${not_case_sensitive}

Add Test Steps Back To Jira
    [Arguments]  ${jira_id}  ${test_cases}
    Set Test Variable  ${testing_result}  Pass
    Import Library  ${base_dir}/libs/jira_api.py  ip=${jira_ip}  port=${jira_port}  username=${jira_username}  password=${jira_password}
    API Login Jira
    ${status_code}  ${result}=  API Get Jira  /browse/${jira_id}  ${False}  ${True}
    log  ${result}
    ${regex_result}=  Should Match Regexp  ${result}  &atl_token=(.+)\">Dashboard
    Set Test Variable  ${token}  ${regex_result[1]}
    ${regex_result}=  Should Match Regexp  ${result}  <span id=\"(\\d+)\"
    Set Test Variable  ${project_id}  ${regex_result[1]}
    ${regex_result}=  Should Match Regexp  ${result}  <input name=\"id\" type=\"hidden\" value=\"(\\d+)\">
    Set Test Variable  ${issue_id}  ${regex_result[1]}
    ${regex_result}=  Should Match Regexp  ${result}  title=\"loggedInUser\" value=\"(.+)\">
    Set Test Variable  ${assignee}  ${regex_result[1]}
    ${status_code}  ${result}  API Get Jira  ${zapi_url}?issueId=${issue_id}  ${True}  ${True}
    log  ${result}
    ${data}=  Create Dictionary
    ...  step=${test_cases}
    ${status_code}  ${result}=  API Post Jira  /rest/api/2/issue/CHPS-2195/comment  ${data}  ${True}  ${True}
    [Teardown]  API Logout Jira  ${token}


Add comment To Jira
    [Arguments]  ${jira_id}  ${msg}
    Set Test Variable  ${testing_result}  Pass
    Import Library  ${base_dir}/libs/jira_api.py  ip=${jira_ip}  port=${jira_port}  username=${jira_username}  password=${jira_password}
    API Login Jira
    ${status_code}  ${result}=  API Get Jira  /browse/${jira_id}  ${False}  ${True}
    log  ${result}
    ${regex_result}=  Should Match Regexp  ${result}  &atl_token=(.+)\">Dashboard
    Set Test Variable  ${token}  ${regex_result[1]}
    ${regex_result}=  Should Match Regexp  ${result}  <span id=\"(\\d+)\"
    Set Test Variable  ${project_id}  ${regex_result[1]}
    ${regex_result}=  Should Match Regexp  ${result}  <input name=\"id\" type=\"hidden\" value=\"(\\d+)\">
    Set Test Variable  ${issue_id}  ${regex_result[1]}
    ${regex_result}=  Should Match Regexp  ${result}  title=\"loggedInUser\" value=\"(.+)\">
    Set Test Variable  ${assignee}  ${regex_result[1]}
    ${status_code}  ${result}  API Get Jira  ${zapi_url}?issueId=${issue_id}  ${True}  ${True}
    log  ${result}
    ${data}=  Create Dictionary
    ...  body=${msg}
    ${status_code}  ${result}=  API Post Jira  /rest/api/2/issue/${jira_id}/comment  ${data}  ${True}  ${True}
    [Teardown]  API Logout Jira  ${token}


Create New Zephyr Record
    [Arguments]  ${issue_id}  ${project_id}  ${assignee}  ${sprint}  ${version_id}
    ${data}=  Create Dictionary
    ...  cycleId=${cycle_id}
    ...  issueId=${issue_id}
    ...  projectId=${project_id}
    ...  versionId=${version_id}
    ...  assigneeType=assignee
    ...  assignee=${assignee}
    ${status_code}  ${result}=  API Post Jira  ${zapi_url}  ${data}  ${True}  ${True}
    ${keys}=  Get Dictionary keys  ${result}
    [Return]  ${keys[0]}


Post Test Result Back To Jira
    [Arguments]  ${jira_id}  ${testing_result}  ${sprint}=Ad hoc  ${jira_id_result_list}=${null}
    Run Keyword If  '${sprint}'=='Ad hoc'  Log  Sprint cycle set to default: Ad hoc, pass the cycle name to your JIRA keyword  WARN
    Run Keyword If  ${jira_id_result_list}!=${null}  Append To List  ${jira_id_result_list}  ${testing_result}
    ${fail_count}=  Run Keyword If  ${jira_id_result_list}!=${null}  Count Values In List  ${jira_id_result_list}  Fail
    Run Keyword If  ${jira_id_result_list}!=${null}  Run Keyword If  ${fail_count}==${0}  Set Suite Variable  ${testing_result}  Pass
    Run Keyword If  ${jira_id_result_list}!=${null}  Run Keyword Unless  ${fail_count}==${0}  Set Suite Variable  ${testing_result}  Fail
    Import Library  ${base_dir}/libs/jira_api.py  ip=${jira_ip}  port=${jira_port}  username=${jira_username}  password=${jira_password}
    API Login Jira
    ${status_code}  ${result}=  API Get Jira  /browse/${jira_id}  ${False}  ${True}
    log  ${result}
    ${regex_result}=  Should Match Regexp  ${result}  &atl_token=(.+)\">Dashboard
    Set Test Variable  ${token}  ${regex_result[1]}
    ${regex_result}=  Should Match Regexp  ${result}  <span id=\"(\\d+)\"
    Set Test Variable  ${project_id}  ${regex_result[1]}
    ${regex_result}=  Should Match Regexp  ${result}  <input name=\"id\" type=\"hidden\" value=\"(\\d+)\">
    Set Test Variable  ${issue_id}  ${regex_result[1]}
    ${regex_result}=  Should Match Regexp  ${result}  title=\"loggedInUser\" value=\"(.+)\">
    Set Test Variable  ${assignee}  ${regex_result[1]}
    ${status_code}  ${issue_details}  API Get Jira  /rest/agile/1.0/issue/${jira_id}  ${True}  ${True}
    Set Test Variable  ${sprint_list}  ${issue_details['fields']['customfield_10000'][-1]}
    ${regex_results}=  Should Match Regexp  ${sprint_list}  id=(\\d+)
    Set Test Variable  ${sprint_id}  ${regex_results[-1]}
    ${status_code}  ${versions}  API Get Jira  /rest/api/latest/project/${project_id}/versions  ${True}  ${True}
    Log  ${versions}
    ${version_id1}  Get Id By Name  ${versions}  ${version_name}
    Set Test Variable  ${version_id}  ${version_id1}
    Run Keyword If  ${version_id}==${null}  Set Test Variable  ${version_id}  -1
    ${status_code}  ${cycles}  API Get Jira  /rest/zapi/latest/cycle?projectId=${project_id}&versionId=${version_id}  ${True}  ${True}
    ${cycle_ids}   Get KeyList For JSON  ${cycles}
    Log  ${cycle_ids}
    ${cycle_id1}  Get CycleID By Name  ${cycles}  ${sprint}
    Set Test Variable  ${cycle_id}  ${cycle_id1}
    Run Keyword If  ${cycle_id}==${-1}  Set Test Variable  ${version_id}  -1
    ${status_code}  ${result}  API Get Jira  ${zapi_url}?issueId=${issue_id}  ${True}  ${True}
    ${execution_id}=  Run Keyword if  ${result['recordsCount']}==0  Create New Zephyr Record  ${issue_id}  ${project_id}  ${assignee}  ${sprint}  ${version_id}
    Run Keyword Unless  ${result['recordsCount']}==0  Set Test Variable  ${execution_id}  ${result['executions'][0]['id']}
    ${status_code}  ${result}  API Get Jira  ${zapi_url}?issueId=${issue_id}  ${True}  ${True}
    Log  ${result}
    ${cycleExist}=  Convert To String  ${result['executions'][0]['cycleName']}
    ${cycleInput}=  Convert To String  ${sprint}
    ${execution_id}=  Run Keyword Unless  "${cycleExist}"=="${cycleInput}"  Create New Zephyr Record  ${issue_id}  ${project_id}  ${assignee}  ${sprint}  ${version_id}
    Run Keyword if  "${cycleExist}"=="${cycleInput}"  Set Test Variable  ${execution_id}  ${result['executions'][0]['id']}
    Run Keyword If  '${testing_result}'=='Pass'  Set Test Variable  ${result_code}  1
    Run Keyword If  '${testing_result}'=='Fail'  Set Test Variable  ${result_code}  2
    Run Keyword If  '${testing_result}'=='Wip'  Set Test Variable  ${result_code}  3
    Run Keyword If  '${testing_result}'=='Blocked'  Set Test Variable  ${result_code}  4
    Run Keyword If  '${testing_result}'=='Unexecuted'  Set Test Variable  ${result_code}  -1
    ${data}=  Create Dictionary
    ...  status=${result_code}
    ${status_code}  ${result}=  API Put Jira  ${zapi_url}/${execution_id}/execute  ${data}  ${True}  ${True}
    Log  ${data}
    Should Be Equal  ${status_code}  ${200}
    Should Be Equal  ${result['id']}  ${${execution_id}}
    Should Be Equal  ${result['issueId']}  ${${issue_id}}
    [Teardown]  API Logout Jira  ${token}

Post Test Result Back To Jira Elvis
    [Arguments]  ${jira_id}  ${testing_result}  ${jira_id_result_list}=${null}
    Run Keyword If  ${jira_id_result_list}!=${null}  Append To List  ${jira_id_result_list}  ${testing_result}
    ${fail_count}=  Run Keyword If  ${jira_id_result_list}!=${null}  Count Values In List  ${jira_id_result_list}  Fail
    Run Keyword If  ${jira_id_result_list}!=${null}  Run Keyword If  ${fail_count}==${0}  Set Suite Variable  ${testing_result}  Pass
    Run Keyword If  ${jira_id_result_list}!=${null}  Run Keyword Unless  ${fail_count}==${0}  Set Suite Variable  ${testing_result}  Fail
    Import Library  ${base_dir}/libs/jira_api.py  ip=${jira_ip}  port=${jira_port}  username=${jira_username}  password=${jira_password}
    API Login Jira
    ${status_code}  ${result}=  API Get Jira  /browse/${jira_id}  ${False}  ${True}
    ${regex_result}=  Should Match Regexp  ${result}  &atl_token=(.+)\">Dashboard
    Set Test Variable  ${token}  ${regex_result[1]}
    ${regex_result}=  Should Match Regexp  ${result}  <span id=\"(\\d+)\"
    Set Test Variable  ${project_id}  ${regex_result[1]}
    ${regex_result}=  Should Match Regexp  ${result}  <input name=\"id\" type=\"hidden\" value=\"(\\d+)\">
    Set Test Variable  ${issue_id}  ${regex_result[1]}
    ${regex_result}=  Should Match Regexp  ${result}  title=\"loggedInUser\" value=\"(.+)\">
    Set Test Variable  ${assignee}  ${regex_result[1]}
    ${status_code}  ${result}  API Get Jira  ${zapi_url}?issueId=${issue_id}  ${True}  ${True}
    ${execution_id}=  Run Keyword If  ${result['recordsCount']}==0  Create New Zephyr Record  ${issue_id}  ${project_id}  ${assignee}
    Run Keyword Unless  ${result['recordsCount']}==0  Set Test Variable  ${execution_id}  ${result['executions'][0]['id']}
    Run Keyword If  '${testing_result}'=='Pass'  Set Test Variable  ${result_code}  1
    Run Keyword If  '${testing_result}'=='Fail'  Set Test Variable  ${result_code}  2
    Run Keyword If  '${testing_result}'=='Wip'  Set Test Variable  ${result_code}  3
    Run Keyword If  '${testing_result}'=='Blocked'  Set Test Variable  ${result_code}  4
    Run Keyword If  '${testing_result}'=='Unexecuted'  Set Test Variable  ${result_code}  -1
    ${data}=  Create Dictionary
    ...  status=${result_code}
    ${status_code}  ${result}=  API Put Jira  ${zapi_url}/${execution_id}/execute  ${data}  ${True}  ${True}
    Should Be Equal  ${status_code}  ${200}
    Should Be Equal  ${result['id']}  ${${execution_id}}
    Should Be Equal  ${result['issueId']}  ${${issue_id}}
    [Teardown]  API Logout Jira  ${token}

Download File And Verify
    [Arguments]  ${remote_url}  ${local_file_name}  ${file_size}=${False}
    ${result}=  download_file  ${remote_url}  ${local_file_name}  ${file_size}
    Should Be True  ${result}

Open Connection And Log In
    Open Connection  ${IP}
    Login With Public Key  ${server_username}  ${ssh_key_pair}


Verify Messages and Status in Response Body: Status 200
    [Arguments]  ${get_returned_json_object}
    Should Be Equal  ${get_returned_json_object['status']}  ${success_status}
    Should Be Equal  ${get_returned_json_object['statusCode']}  ${200}
    Should Not Be Empty  ${get_returned_json_object['messages']['success']}
    Should Be Empty  ${get_returned_json_object['messages']['error']}
    Should Be Empty  ${get_returned_json_object['messages']['warning']}
    Should Be Empty  ${get_returned_json_object['messages']['info']}
    Should Not Be Equal  ${get_returned_json_object['data']}  ${null}

Verify Messages and Status in Response Body: Status 400
    [Arguments]  ${get_returned_json_object}
    # Should Be Equal  ${get_returned_json_object['status']}  ${error_status}
    Should Be Equal  ${get_returned_json_object['statusCode']}  ${400}
    Should Not Be Empty  ${get_returned_json_object['messages']['error']}
    Should Be Empty  ${get_returned_json_object['messages']['success']}
    Should Be Empty  ${get_returned_json_object['messages']['warning']}
    Should Be Empty  ${get_returned_json_object['messages']['info']}
    ${check1}=  Run Keyword And Return Status  Should Be Equal  ${get_returned_json_object['data']}  ${null}
    Run Keyword Unless  ${check1}  Should Be Empty  ${get_returned_json_object['data']}

Verify Messages and Status in Not Found: Status 404
    [Arguments]  ${get_returned_json_object}
    # Should Be Equal  ${get_returned_json_object['status']}  ${error_status3}
    Should Be Equal  ${get_returned_json_object['statusCode']}  ${404}
    Should Not Be Empty  ${get_returned_json_object['messages']['error']}
    Should Be Empty  ${get_returned_json_object['messages']['success']}
    Should Be Empty  ${get_returned_json_object['messages']['warning']}
    Should Be Empty  ${get_returned_json_object['messages']['info']}
    ${check1}=  Run Keyword And Return Status  Should Be Equal  ${get_returned_json_object['data']}  ${null}
    Run Keyword Unless  ${check1}  Should Be Empty  ${get_returned_json_object['data']}

Verify Messages and Status in Response Body: Bad Request
    [Arguments]  ${get_returned_json_object}
    ${check1}=  Run Keyword And Return Status  Should Be Equal  ${get_returned_json_object['status']}  ${error_status}
    Run Keyword Unless  ${check1}  Should Be Equal  ${get_returned_json_object['status']}  ${error_status2}
    Should Be Equal  ${get_returned_json_object['status']}  ${error_status2}
    Should Be Equal  ${get_returned_json_object['statusCode']}  ${400}
    Should Not Be Empty  ${get_returned_json_object['messages']['error']}
    Should Be Empty  ${get_returned_json_object['messages']['success']}
    Should Be Empty  ${get_returned_json_object['messages']['warning']}
    Should Be Empty  ${get_returned_json_object['messages']['info']}
    Should Be Equal  ${get_returned_json_object['data']}  ${null}

Verify Messages and Status in Response Body: Not Found
    [Arguments]  ${get_returned_json_object}
    ${check1}=  Run Keyword And Return Status  Should Be Equal  ${get_returned_json_object['status']}  ${error_status}
    Run Keyword Unless  ${check1}  Should Be Equal  ${get_returned_json_object['status']}  ${error_status3}
    Should Be Equal  ${get_returned_json_object['status']}  ${error_status3}
    Should Be Equal  ${get_returned_json_object['statusCode']}  ${404}
    Should Not Be Empty  ${get_returned_json_object['messages']['error']}
    Should Be Empty  ${get_returned_json_object['messages']['success']}
    Should Be Empty  ${get_returned_json_object['messages']['warning']}
    Should Be Empty  ${get_returned_json_object['messages']['info']}
    Should Be Equal  ${get_returned_json_object['data']}  ${null}
    
Verify Messages and Status in Response Body: 200 OK With No Content
    [Arguments]  ${get_returned_json_object}
    Should Be Equal  ${get_returned_json_object['status']}  ${success_status}
    Should Be Equal  ${get_returned_json_object['statusCode']}  ${200}
    Should Not Be Empty  ${get_returned_json_object['messages']['success']}
    Should Be Empty  ${get_returned_json_object['messages']['error']}
    Should Be Empty  ${get_returned_json_object['messages']['warning']}
    Should Be Empty  ${get_returned_json_object['messages']['info']}
    Should Be Equal  ${get_returned_json_object['data']}  ${null}

Verify Messages and Status in Response Body: 200 OK With INFO message
    [Arguments]  ${get_returned_json_object}
    Should Be Equal  ${get_returned_json_object['status']}  ${success_status}
    Should Be Equal  ${get_returned_json_object['statusCode']}  ${200}
    Should Be Empty  ${get_returned_json_object['messages']['success']}
    Should Be Empty  ${get_returned_json_object['messages']['error']}
    Should Be Empty  ${get_returned_json_object['messages']['warning']}
    Should Not Be Empty  ${get_returned_json_object['messages']['info']}
    Should Be Equal  ${get_returned_json_object['data']}  ${null}

Verify Return Status 200 with Specific Message
    [Arguments]  ${get_returned_json_object}  ${expected_success_message}
    Should Be Equal  ${get_returned_json_object['statusCode']}  ${200}
    Should Be Equal  ${get_returned_json_object['status']}  ${success_status}
    Should Be Equal  ${get_returned_json_object['messages']['success'][0]}  ${expected_success_message}
    Should Be Empty  ${get_returned_json_object['messages']['error']}
    Should Be Empty  ${get_returned_json_object['messages']['warning']}
    Should Be Empty  ${get_returned_json_object['messages']['info']}

Verify Return Status 200 with Specific Warning
    [Arguments]  ${get_returned_json_object}  ${expected_warning_message}
    Should Be Equal  ${get_returned_json_object['statusCode']}  ${200}
    Should Be Equal  ${get_returned_json_object['status']}  ${success_status}
    Should Be Empty  ${get_returned_json_object['messages']['success']}
    Should Be Empty  ${get_returned_json_object['messages']['error']}
    Should Be Equal  ${get_returned_json_object['messages']['warning'][0]}  ${expected_warning_message}
    Should Be Empty  ${get_returned_json_object['messages']['info']}

Verify Return Status 200 with Specific Error
    [Arguments]  ${get_returned_json_object}  ${expected_error_message}
    Should Be Equal  ${get_returned_json_object['statusCode']}  ${200}
    Should Be Equal  ${get_returned_json_object['status']}  ${success_status}
    Should Be Equal  ${get_returned_json_object['messages']['error'][0]}  ${expected_error_message}
    Should Be Empty  ${get_returned_json_object['messages']['success']}
    Should Be Empty  ${get_returned_json_object['messages']['warning']}
    Should Be Empty  ${get_returned_json_object['messages']['info']}
    
Verify Response Data Contains
    [Arguments]  ${json_response}  ${expected_elem}
    Set Test Variable  ${elem_found}  ${False}
    ${count}=  Get Length  ${json_response['data']}
    :FOR  ${i}  IN RANGE  0  ${count}
    \  Set Test Variable  ${elem}  ${json_response['data'][${i}]}
    \  Run Keyword If  ${elem}==${expected_elem}  Set Test Variable  ${elem_found}  ${True}
    Should Be Equal  ${elem_found}  ${True}


Pop Data From Json Response and Verify Json body
    [Arguments]  ${json_object}  ${body_sample_to_compare}
    ${data}=  Pop From Dictionary  ${json_object}  data
    Should Be Equal  ${json_response_body_200}  ${body_sample49713358
        _to_compare}
    [return]  ${data}

Login Into Server
    [Arguments]  ${IP}  ${username}  ${password}
    Open Connection  ${IP}
    Login  ${username}  ${password}


Trigger The Job
    [Arguments]  ${IP}  ${queue_of_message_to_job}  ${queue_of_message_from_job}  ${distribution}  ${username}=${dev_vm_username}  ${password}=${dev_vm_password}  ${timeout}=20 seconds
    Set Default Configuration  timeout=${timeout}
    Login Into Server    ${IP}  ${username}  ${password}
    ${ls}=  Execute Command  ls -al
    Execute Command  rm -rf /home/chps_dev/${distribution}/logs/job-${osuser}*
    Write  cd ${distribution}/lib
    Write  PID=`echo $$`
    Write  java -cp job-1.0.0.jar:../config/job com.changehealthcare.r2d2.job.JobRunner ${queue_of_message_to_job} ${queue_of_message_from_job} >> "../logs/job-${osuser}$PID.log"
    ${cli_log}=  Read Until  $
    ${job_log}=  Execute Command  cat /home/chps_dev/${distribution}/logs/job-${osuser}*.log
    Log  ${ls}
    Log  ${cli_log}
    Log  ${job_log}


    
