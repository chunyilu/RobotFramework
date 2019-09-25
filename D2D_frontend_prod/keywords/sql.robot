*** Keywords ***
Initiate Database Connection
    Connect To Database Using Custom Params  ${db_type}  ${connect_string}

Get Table Columns
    [Arguments]  ${table}
    ${table}=  Convert To UpperCase  ${table}
    Set Test Variable  ${sql_command}  SELECT COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME='${table}' order by column_id
    ${columns}=  Query  ${sql_command}
    [Return]  ${columns}

Get SQL Query Return Count
    [Arguments]  ${sql_command}
    Initiate Database Connection
    ${result}=  Query  ${sql_command}
    ${count}=  Get Length  ${result}
    [Return]  ${count}
    [Teardown]  Disconnect from Database

Get Particular Column Value From DB
    [Arguments]  ${table}  ${where_conditions}  ${exist}=${True}
    Initiate Database Connection
    Set Test Variable  ${command}  select COUNT(*) from ${table} where ${where_conditions}
    log  ${command}
    ${result}=  Query  ${command}
    [Return]  ${result}
    [Teardown]  Disconnect from Database

Verify If Data Exist In DB
    [Arguments]  ${table}  ${where_conditions}  ${exist}=${True}
    Initiate Database Connection
    Set Test Variable  ${command}  select COUNT(*) from ${table} where ${where_conditions}
    log  ${command}
    ${infos}=  Query  ${command}
    ${check}=  Evaluate  ${infos[0][0]}>0
    Run Keyword If  ${exist}  Should Be True  ${check}
    Run Keyword Unless  ${exist}  Should Not Be True  ${check}
    [Teardown]  Disconnect from Database

Query DB And Generate JSON Data
    [Arguments]  ${table}  ${column}  ${value}
    ${table}=  Convert To UpperCase  ${table}
    ${column}=  Convert To UpperCase  ${column}
    Initiate Database Connection
    ${columns}=  Get Table Columns  ${table}
    log  select * from \"${table}\" where \"${column}\" = '${value}'
    ${infos}=  Query  select * from \"${table}\" where \"${column}\" = '${value}'
    ${count}=  Get Length  ${infos}
    ${json_object}=  Create List
    :FOR  ${i}  IN RANGE  0  ${count}
    \  log  ${infos[${i}]}
    \  ${tmp}=  Integrate Columns And Infos  ${columns}  ${infos[${i}]}
    \  Append To List  ${json_object}  ${tmp}
    [Teardown]  Disconnect from Database
    [Return]  ${json_object}

Query DB And Generate JSON Data With All Columns And Customized SQL
    [Arguments]  ${table}  ${customized_sql_command}
    Initiate Database Connection
    ${columns}=  Get Table Columns  ${table}
    log  ${customized_sql_command}
    ${infos}=  Query  ${customized_sql_command}
    ${count}=  Get Length  ${infos}
    ${json_object}=  Create List
    :FOR  ${i}  IN RANGE  0  ${count}
    \  log  ${infos[${i}]}
    \  ${tmp}=  Integrate Columns And Infos  ${columns}  ${infos[${i}]}
    \  Append To List  ${json_object}  ${tmp}
    Append To List  ${json_object}  ${tmp}
    [Teardown]  Disconnect from Database
    [Return]  ${json_object}

Integrate Columns And Infos
    [Arguments]  ${columns}  ${infos}
    ${column_count}=  Get Length  ${columns}
    ${tmp}=  Create Dictionary
    :FOR  ${j}  IN RANGE  0  ${column_count}
    \  Set To Dictionary  ${tmp}  ${columns[${j}][0]}  ${infos[${j}]}
    [Return]  ${tmp}

Remove Database Record
    [Arguments]  ${table}  ${column}  ${value}  ${int}=${False}
    Initiate Database Connection
    Run Keyword Unless  ${int}  Set Test Variable  ${command}  delete from ${table} where ${column}='${value}'
    Run Keyword If  ${int}  Set Test Variable  ${command}  delete from ${table} where ${column}=${value}
    log  ${command}
    Execute Sql String  ${command}
    [Teardown]  Disconnect from Database

Remove Database Records
    [Arguments]  ${table}  ${column}  ${values}  ${int}=${False}
    ${count}=  Get Length
    Initiate Database Connection
    :FOR  ${i}  IN RANGE  0  ${count}
    \  Run Keyword Unless  ${int}  Execute Sql String  delete from ${table} where ${column}='${values[${i}]}'
    \  Run Keyword If  ${int}  Execute Sql String  delete from ${table} where ${column}=${value[${i}]}
    [Teardown]  Disconnect from Database

Remove Rule Completely
    [Arguments]  ${rule_id}
    Initiate Database Connection
    Execute Sql String  delete from rule_detail_lookup where rule_id='${rule_id}'
    Execute Sql String  delete from rule_definition where rule_id='${rule_id}'
    Execute Sql String  delete from rule_definition_hist where rule_id='${rule_id}'
    Execute Sql String  delete from rule_detail where rule_det_id in (select rule_det_id from rule_detail_lookup_hist where rule_id='${rule_id}')
    Execute Sql String  delete from rule_detail_lookup_hist where rule_id='${rule_id}'
    [Teardown]  Disconnect from Database

Query Database For Single Column
    [Arguments]  ${sql_command}
    Initiate Database Connection
    ${result}=  Query  ${sql_command}
    ${count}=  Get Length  ${result}
    Should Be Equal As Integers  ${count}  ${1}
    [Return]  ${result[0][0]}
    [Teardown]  Disconnect from Database

Query DB With Customized SQL command
    [Arguments]  ${customized_sql_command}
    Initiate Database Connection
    log  ${customized_sql_command}
    ${infos}=  Query  ${customized_sql_command}
    Log  ${infos}
    [Teardown]  Disconnect from Database
    [Return]  ${infos}

Integrate Single Column And Infos
    [Arguments]  ${column}  ${infos}
    ${info_count}=  Get Length  ${infos}
    ${tmp}=  Create Dictionary
    :FOR  ${j}  IN RANGE  0  ${info_count}
    \  Set To Dictionary  ${tmp}  ${column}  ${infos[${j}]}
    [Return]  ${tmp}

Query DB And Generate JSON Data With Customized SQL Columns
    [Arguments]   ${column}  ${customized_sql_command}
    Initiate Database Connection
    log  ${customized_sql_command}
    ${infos}=  Query  ${customized_sql_command}
    ${count}=  Get Length  ${infos}
    ${json_object}=  Create List
    ${column}=  Convert To UpperCase  ${column}
    :FOR  ${i}  IN RANGE  0  ${count}
    \  log  ${infos[${i}]}
    \  ${tmp}=  Integrate Single Column And Infos  ${column}  ${infos[${i}]}
    \  Append To List  ${json_object}  ${tmp}
    Append To List  ${json_object}  ${tmp}
    [Teardown]  Disconnect from Database
    [Return]  ${json_object}

Compare Json Response With Customized SQL Query
    [Arguments]  ${jsona}  ${listb}  ${sub_dict}
    ${keys_dict}=  Get From Dictionary  ${query_map}  ${sub_dict}
    Log  ${keys_dict}
    ${keys}=  Get Dictionary keys  ${keys_dict}
    Log  ${keys}
    :FOR  ${i}  IN  @{keys}
    \  Set Test Variable  ${index}  ${keys_dict[\'${i}\']}
    \  Should Be Equal As Strings  ${jsona[\'${i}\']}  ${listb[${index}]}

Execute Customized Sql Script
    [Arguments]   ${sqlfile}
    Initiate Database Connection
    log  ${sqlfile}
    Execute Sql Script  ${sqlfile}
    [Teardown]  Disconnect from Database

Remove Transaction Completely From DB
    [Arguments]  ${transaction_id}
    Initiate Database Connection
    Execute Sql String  delete from DOCUMENT_MANAGEMENT_DETAIL where TRANSACTION_ID='${transaction_id}'
    Execute Sql String  delete from DOCUMENT_MANAGEMENT where TRANSACTION_ID='${transaction_id}'
    [Teardown]  Disconnect from Database

Remove Group Completely
    [Arguments]  ${group_id}
    Initiate Database Connection
    Execute Sql String  delete from GROUP_DEFINITION where GROUP_ID='${group_id}'
    [Teardown]  Disconnect from Database

Remove Group and Group Rule Associations Completely
    [Arguments]  ${group_id}  ${cloned_group_id}  ${rule_id}  ${group_rule_id}
    Initiate Database Connection
    Execute Sql String  delete from rule_detail_lookup where rule_id='${rule_id}'
    Execute Sql String  delete from rule_definition where rule_id='${rule_id}'
    Execute Sql String  delete from group_rule_map where GROUP_ID in (${group_id},${cloned_group_id})
    Execute Sql String  delete from GROUP_DEFINITION where GROUP_ID in (${group_id},${cloned_group_id})
    [Teardown]  Disconnect from Database

Execute Stored Procedure
    [Arguments]  ${SPName}  ${ParamList}
    Initiate Database Connection  
     @{QueryResults} =  Call Stored Procedure  ${SPName}  ${ParamList}
     [Return]  ${QueryResults}
     [Teardown]  Disconnect from Database

    