coding: utf-8

*** Settings ***
Library  SeleniumLibrary
Documentation    Suite description


*** Keywords ***
Loop_I Check Purchase History Validation
    [Arguments]    ${purchaseHistory_result}  ${counts}
    # ${counts}    Get Length  ${purchaseHistory_result["payments"]}
    : for    ${i}    IN RANGE    0    ${counts}
    \  log  ${i}
    \  ${order_id}  convert to string  ${purchaseHistory_result["payments"][${i}]["id"]}
    \  Element Should Contain  //div[${i+1}][@class="gf-repeat-animation ng-scope"]//div[@class="row"]//div[1]  ${order_id}
    \  Element Should Contain  //div[${i+1}][@class="gf-repeat-animation ng-scope"]//div[@class="row block-title"]//div[1]//h4  Order #
    \  Element Should Contain  //div[${i+1}][@class="gf-repeat-animation ng-scope"]//div[@class="row block-title"]//div[3]//h4  Title
    \  Element Should Contain  //div[${i+1}][@class="gf-repeat-animation ng-scope"]//div[@class="row block-title"]//div[4]//h4  Date of Purchase
    \  Element Should Contain  //div[${i+1}][@class="gf-repeat-animation ng-scope"]//div[@class="row block-title"]//div[5]//h4  Price
    \  ${j_counts}  Get Length  ${purchaseHistory_result["payments"][${i}]["products"]}
    \  Loop_J   ${i}   ${j_counts}  ${purchaseHistory_result}

Loop_J
     [Arguments]     ${i}   ${j_counts}  ${purchaseHistory_result}
    : for    ${j}    IN RANGE    0    ${j_counts}
    \  log  ${purchaseHistory_result["payments"][${i}]["products"][${j}]["title"]}
    \  Page Should Contain Element  //div[${i+1}][@class="gf-repeat-animation ng-scope"]//div[@class="row"]//div[${j+2}]//div[1]//img
    \  Element Should Contain  //div[${i+1}][@class="gf-repeat-animation ng-scope"]//div[@class="row"]//div[${j+2}]//div[2]//h4  ${purchaseHistory_result["payments"][${i}]["products"][${j}]["title"]}
    \  Element Should Contain  //div[${i+1}][@class="gf-repeat-animation ng-scope"]//div[@class="row"]//div[${j+2}]//div[3]//span[1]  Purchase:
    \  Element Should Contain  //div[${i+1}][@class="gf-repeat-animation ng-scope"]//div[@class="row"]//div[${j+2}]//div[4]//div  ${purchaseHistory_result["payments"][${i}]["products"][${j}]["price"]}
    \  Date Should Equal   //div[${i+1}][@class="gf-repeat-animation ng-scope"]//div[@class="row"]//div[${j+2}]//div[3]//div//div   ${purchaseHistory_result["payments"][${i}]["payment_date"]}
    \  ${tradeinstatus}  Run Keyword And Return Status  Element Should Contain  //div[${i+1}][@class="gf-repeat-animation ng-scope"]//div[@class="row"]//div[${j+2}]//div[3]//span[2]  Trade-in:
    \  Run Keyword If  ${tradeinstatus}==True  Tradein Date Convert  ${purchaseHistory_result["payments"][${i}]["payment_date"]}  ${purchaseHistory_result["payments"][${i}]["products"][${j}]["trade_in"]["trade_in_date"]}
    \  Run Keyword If  ${tradeinstatus}==True  Element Should Contain  //div[${i+1}][@class="gf-repeat-animation ng-scope"]//div[@class="row"]//div[${j+2}]//div[4]//div//div//span[3]  ${purchaseHistory_result["payments"][${i}]["products"][${j}]["trade_in"]["trade_in_price"]}
    \  Run Keyword If  ${tradeinstatus}==True  Should Equal   //div[${i+1}][@class="gf-repeat-animation ng-scope"]//div[@class="row"]//div[${j+2}]//div[3]//div//div   ${tradein_datenew}
    \  Run Keyword If  ${tradeinstatus}==False  Date Should Equal  //div[${i+1}][@class="gf-repeat-animation ng-scope"]//div[@class="row"]//div[${j+2}]//div[3]//div//div  ${purchaseHistory_result["payments"][${i}]["payment_date"]}

Date Should Equal
    [Arguments]   ${xpath}   ${json}
    ${converted_date}  Rearrange Release Date String  ${json}
    Element Should Contain   ${xpath}  ${converted_date}

update password test
    #current pw correct

    #success
    Input Text  ${current_pw_input}  12345678
    Input Text  ${new_pw_input}  12345678
    Input Text  ${confirm_pw_input}  12345678
    click element  //*[@id="changePasswordForm"]/div[6]/button
    Element Should Contain  //div[@class="alert alert-success ng-binding"]  Your password updated successfully


Validate data in D2D wallet
    [Arguments]  ${request_headers}

    Create Session  d2d  ${d2d_url}
    ${response}=  Get Request  d2d  /backend/api/account/wallet  headers=${request_headers}
    ${wallet_result} =  To Json  ${response.content}

    click element  link=My D2D Wallet
    Wait Until Element Contains    css=span.wallet-balance.ng-binding    ${wallet_result["balance"]}
    Page Should Contain Element    xpath=//div[@id='my-account']/div/div[2]/div/div[2]/div/div[2]/img
    Element Should Contain    css=p.wallet-section-text    What is My D2D Wallet?
    Element Should Contain    css=p.text-grey    The D2D Wallet shows any remaining funds that you can apply to the purchase of your next tradable game.
    Element Should Contain    css=small.wallet-balance-title    Your Current D2D Wallet Balance:
    Element Should Contain    css=p.wallet-section-history-title    Trade In History

    ${len}  get length  ${wallet_result["history"]}
    #if history->N->action deposit   (trade in)
    #                      withdraw  (used)
    : for    ${i}    IN RANGE    0    ${len}
    \  run keyword if  ${i}>9  scroll down wallet history
    \  ${order_id_str}  Convert To String  ${wallet_result["history"][${i}]["payment"]["orderId"]}
    \  ${status}  Run Keyword And Return Status  Should Be Equal  ${wallet_result["history"][${i}]["action"]}  withdraw
    \  log  trade in/used
    \  Run Keyword If  ${status}==True  Element Should Contain  xpath=//*[@class="mCSB_container"]/div/div[${i+1}]/div/div[1]/div/span  USED
    \  ...  ELSE  Element Should Contain  xpath=//*[@class="mCSB_container"]/div/div[${i+1}]/div/div[1]/div/span  TRADE IN
    \  log  desc
    \  Run Keyword If  ${status}==True  Element Should Contain  //div[@class="mCSB_container"]/div/div[${i+1}]//div[@class="span6 history-info ng-binding"]  ${order_id_str}
    \  ...  ELSE  Element Should Contain  //div[@class="mCSB_container"]/div/div[${i+1}]//div[@class="span6 history-info ng-binding"]  ${wallet_result["history"][${i}]["product"]["title"]}
    \  log  trans date:
    \  log  ${wallet_result["history"][${i}]["transactionDate"]}
    \  ${frontend_date}=  Rearrange Release Date String  ${wallet_result["history"][${i}]["transactionDate"]}
    \  Element Should Contain  xpath=//*[@class="mCSB_container"]/div/div[${i+1}]/div/div[3]  ${frontend_date}
    \  log  trans amount
    \  Element Should Contain  xpath=//*[@class="mCSB_container"]/div/div[${i+1}]/div/div[4]  ${wallet_result["history"][${i}]["transactionAmount"]}
    #----------------------------

scroll down wallet history
    Assign Id To Element  //div[@class="mCustomScrollBox mCS-minimal mCSB_vertical mCSB_outside"]  myidout

    Execute Javascript    window.scrollTo(0,300);
    sleep  3s

    Run Keyword And Ignore Error   Execute Javascript  var a=document.getElementById("myidout"); a.scrollTo(0,300);
    sleep  3s

Validate data in my streaming
#    assertText    css=div.remaining-playtime > strong.ng-binding    ${login_user_cloud_time_remain_hr}
#    assertText    css=div.remaining-playtime > strong.ng-binding    ${login_user_cloud_time_remain_hr}
#    assertText    xpath=//div[@id='streaming']/section/div[2]/div[2]/div/div/div/div/strong[2]    ${login_user_cloud_time_remain_min}
    Element Should Contain    xpath=//div[@id='streaming']/section/div[2]/div[2]/div/div/div/div/span[2]    minutes
    Element Should Contain    css=div.remaining-playtime > span.ng-binding    hour
    Page Should Contain Element    css=img.launch-btn-img.launch_windows
    Page Should Contain Element    css=img.launch-btn-img.launch_steam
    Page Should Contain Element    css=img.launch-btn-img.launch_origin
    Page Should Contain Element    css=img.launch-btn-img.launch_blizzard
    Page Should Contain Element    css=img.launch-btn-img.launch_windows
    Element Should Contain    css=p.cloudplay-section-text.smaller    Direct2Drive does not record or retain any user infomation, including account logins.
    Element Should Contain    xpath=//div[@id='streaming']/section/div[2]/div[2]/div/div/div[3]/p[2]    For more Cloud Play™ terms and conditions, please visit D2D support page.
    Page Should Contain Element    css=img.launch-btn-img.launch_steam
    # assertText    css=p.contact-support    There is currently no Instant Play™ Spotlight active. For more information please contact support.
    Element Should Contain    link=My Games    My Games
    Element Should Contain    link=My D2D Wallet    My D2D Wallet
    Element Should Contain    link=Account Info    Account Info
    Element Should Contain    link=Purchase History    Purchase History
    Page Should Contain Element    css=div.instant-play > header > img
    Page Should Contain Element    css=img.membership-text
    Page Should Contain Element    css=img.membership-icon

Validate data in my game
    [Arguments]  ${request_headers}
    Execute Javascript    window.scrollTo(0,0);
    click element   link=My Games
    Wait Until Element Contains    xpath=//div[@id='my-account']/div/div[2]/div/div[2]/div/div/div[2]/div[2]/table/thead/tr/th[2]    Title
    Element Should Contain  //div[@class="gamelist-table-container"]//table/thead/tr/th[2]  Title
    Element Should Contain  //div[@class="gamelist-table-container"]//table/thead/tr/th[3]  DRM
    Element Should Contain  //div[@class="gamelist-table-container"]//table/thead/tr/th[4]  Type
    Element Should Contain  //div[@class="gamelist-table-container"]//table/thead/tr/th[5]  Acquired Date
    Element Should Contain  //div[@class="gamelist-table-container"]//table/thead/tr/th[6]  Actions

    Create Session  d2d  ${d2d_url}
    ${All_game_list_response}=  Get Request  d2d  /backend/api/account/inventories?page=1&per_page=10  headers=${request_headers}
    ${result} =  To Json  ${All_game_list_response.content}

    ${count}=  get variable value  ${result["paging"]["count"]}

    : for    ${i}    IN RANGE    0    ${count}
    \  Page Should Contain Element  //div[@class="gamelist-table-container"]/table/tbody/tr[${i+1}]/td[1]/img
    \  Element Should Contain  //div[@class="gamelist-table-container"]/table/tbody/tr[${i+1}]/td[2]/h4  ${result["items"][${i}]["product_item"]["title"]}
    \  ${date}  Rearrange Release Date String  ${result["items"][${i}]["payment_date"]}
    \  Element Should Contain  //div[@class="gamelist-table-container"]/table/tbody/tr[${i+1}]/td[5]/span  ${date}

login with token and generate request headers
    log  post request login and get token
    ${login_user_data}=   Create Dictionary   email=${login_user}  password=${loginPassword}

    ${login_headers_tmp}=  Create Dictionary  Content-Type=application/x-www-form-urlencoded  devise=D2D Desktop  fp=MjY5NzE5NjkxMg==  remote-ip=3.255.255.255
    Create Session  d2d  ${d2d_url}
    ${response}=  Post Request  d2d  ${login_uri}   data=${login_user_data}  headers=${login_headers_tmp}
    ${result} =  To Json  ${response.content}
    ${token}  Set Variable  ${result["account"]["token"]}

    #generate correct token
    ${whole_token}=  Catenate  SEPARATOR=${SPACE}  Bearer  ${token}
    ${request_headers}=  Create Dictionary  Authorization=${whole_token}  Host=www.direct2drive.com
    [Return]  ${request_headers}


