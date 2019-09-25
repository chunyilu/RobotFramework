coding: utf-8
*** Settings ***
Library  SeleniumLibrary
Library  String
Library  OperatingSystem
Library  RequestsLibrary
Library  Collections
Variables  ../../variables/d2d_uri.py
Resource  ../../keywords/smoke_test.robot

*** Variable ***
${email}  enter_your_email
${pwd}  enter_your_password
#list elements from top to down, left to right
${d2d_streaming_logo}  xpath=//section[@class="streaming-top"]/header/img[1]

${client_description}  xpath=//section[@class="streaming-top"]/div[1]/div/div[1]/span
${download_btn}  xpath=//section[@class="streaming-top"]/div[1]/div/div[1]/a/b
${download_img}  xpath=//section[@class="streaming-top"]/div[1]/div/div[1]/a/b/img

${lightbulb_img}  xpath=//section[@class="streaming-top"]/div[1]/div/div[2]/img
${lhtudcp_str}  xpath=//section[@class="streaming-top"]/div[1]/div/div[2]/b/i
${learn_how_info_btn}  xpath=//section[@class="streaming-top"]/div[1]/div/div[2]/span/a

${instant_play_img}  xpath=//section[@class="streaming-top"]/div[2]/div[1]/div/header/img
${instant_play_info_btn}  xpath=//section[@class="streaming-top"]/div[2]/div[1]/div/header/span/a
${cs_txt}  xpath=//section[@class="streaming-top"]/div[2]/div[1]/div/div/div/p

#div cloud-play
${cloud_play_img}  //div[@class="cloud-play"]/header[1]/img
${cloud_play_info_btn}  //div[@class="cloud-play"]/header[1]/span/a
${cloud_play_msg}  //div[@class="cloud-play"]//p[@class="cloud-play-message ng-scope"]
${cloud_play_spend_msg}  //div[@class="cloud-play"]//p[@class="spend ng-scope"]
${cloud_play_fastend_msg}  //div[@class="cloud-play"]//small[@class="fastened"]
${cloud_play_smaller_msg1}  //div[@class="panel malibu-cloud-play"]//p[@class="cloudplay-section-text smaller"]
${cloud_play_smaller_msg2}  //div[@class="panel malibu-cloud-play"]//p[@class="smaller"]
${d2d_support_link}  //div[@class="panel malibu-cloud-play"]//p[@class="smaller"]/a

${get_notified_img}  xpath=//section[@class="streaming-top"]/div[2]/div[2]/div/header[2]/h3
${get_notified_btn}  xpath=//section[@class="streaming-top"]/div[2]/div[2]/div/div[2]/div/a/b
${get_notified_str}  xpath=//section[@class="streaming-top"]/div[2]/div[2]/div/div[2]/div
${question_mark}  xpath=//section[@class="streaming-top"]/div[2]/div[2]/div/div[2]/div/i

${streaming_freehours_title}  //div[@class="cloud-play"]//header[@class="sub-titles ng-scope"]/h3
${freehours_btn_text}  //div[@class="cloud-play"]//a[@class="c-btn btn-click-here"]/b
${freehours_div}  //div[@class="cloud-play"]//div[@class="spend ng-binding"]

#section displayed after login
#bonus-play-section
${remaining_time_text}  //div[@class="bonus-play-section ng-scope"]//small[@class="remaining-playtime-title"]
${bonus_time_q_mark}  //div[@class="bonus-play-section ng-scope"]//i[@class="fa fa-2x fa-question-circle-o qmark-middle"]
${hours_element}  //div[@class="remaining-playtime"]/strong[1]
${hours_text_element}  //div[@class="remaining-playtime"]/span[1]
${mins_element}  //div[@class="remaining-playtime"]/strong[2]
${mins_text_element}  //div[@class="remaining-playtime"]/span[2]
${bonus_expires_date}  //div[@class="bonus-play-section ng-scope"]//small[@class="remaining-playtime-expire-date ng-binding"]
#launch cloud play desktops
${launch_play_img}  //div[@class="ng-scope" and @ng-if="able2Launch()"]/p/img
${windows}  //a[@class="btn1 btn-danger1 ng-scope ng-isolate-scope" and @title="Launch Malibu Cloud Play™ Client - Windows"]
${steam}  //a[@class="btn1 btn-danger1 ng-scope ng-isolate-scope" and @title="Launch Malibu Cloud Play™ Client - Steam"]
${origin}  //a[@class="btn1 btn-danger1 ng-scope ng-isolate-scope" and @title="Launch Malibu Cloud Play™ Client - Origin"]
${blizzard}  //a[@class="btn1 btn-danger1 ng-scope ng-isolate-scope" and @title="Launch Malibu Cloud Play™ Client - Blizzard"]

#instant play open beta section
${instant_play_intro}  xpath=//div[@id="streaming"]/section[2]/div[2]/div
${icon_cloud_pad}  xpath=//div[@id="streaming"]/section[2]/div[2]/div/section[1]/div/ul/li[1]
${icon_cart}  xpath=//div[@id="streaming"]/section[2]/div[2]/div/section[1]/div/ul/li[2]
${is_play_intro_step2}  xpath=//div[@id="streaming"]/section[2]/div[2]/div/section[2]/div/dl/dd[2]/p

#cloud play open beta
${m_cloud_play_img}  xpath=//section[@id="malibu-cloud-play"]/div[1]/img
${hdiw_str}  xpath=//section[@id="malibu-cloud-play"]/div[2]/div/section[1]/div/h3
${hdiw_step3}  xpath=//section[@id="malibu-cloud-play"]/div[2]/div/section[1]/div/dl/dd[3]/p
${pc_spec}  xpath=//section[@id="malibu-cloud-play"]/div[2]/div/section[2]/div/h3
${ram}  xpath=//section[@id="malibu-cloud-play"]/div[2]/div/section[2]/div/dl/dt[3]/strong
${press_f12_option}  xpath=//section[@id="malibu-cloud-play"]/div[2]/div/section[2]/div/p


${htudcp_title_img}  xpath=//section[@id="how-to-use"]/div[1]/img
${htudcp_img1}  xpath=//section[@id="how-to-use"]/div[2]/div/ul/li[4]/img
${htudcp_img2}  xpath=//section[@id="how-to-use"]/div[2]/div/ul/li[6]/img
${htudcp_step9}  xpath=//section[@id="how-to-use"]/div[2]/div/ul/li[12]

#malibu instant play panel
${playable}  False
${is_item1_img}  xpath=//html/body/div[1]/div[2]/div/section[1]/div[2]/div[1]/div/div/div/ul/li/div/div[1]/img
${is_item1_title}  xpath=//html/body/div[1]/div[2]/div/section[1]/div[2]/div[1]/div/div/div/ul/li/div/h3
${is_item1_description}  xpath=//html/body/div[1]/div[2]/div/section[1]/div[2]/div[1]/div/div/div/ul/li/div/p
${is_item1_price}  xpath=//html/body/div[1]/div[2]/div/section[1]/div[2]/div[1]/div/div/div/ul/li/div/div[2]/span
${is_buy_btn}  xpath=//html/body/div[1]/div[2]/div/section[1]/div[2]/div[1]/div/div/div/ul/li/div/div[3]/a


${tmp}  "What is Bonus Play Time?"

${free_hours}  0
*** Test Cases ***
TS check streaming page without login
    [Tags]  logout

    Open browser  ${streaming_page_url}  ${browser}
	Maximize Browser Window
	Set Browser Implicit Wait  10 seconds
    
    #check top three rows items
    check common items
    
    page should contain element  ${d2d_streaming_logo}
    
    d2d check download client section
    
    page should contain element  ${lightbulb_img}
    page should contain element  ${lhtudcp_str}
    element should contain  ${lhtudcp_str}  LEARN HOW TO USE D2D CLOUD PLAY
    page should contain element  ${learn_how_info_btn}
    element should contain  ${learn_how_info_btn}  MORE INFO
    
    d2d check instant play section
    
    log  check cloud play section    
    page should contain element  ${cloud_play_img}
    page should contain element  ${cloud_play_info_btn}
    page should contain element  ${cloud_play_msg}
    element should contain  ${cloud_play_msg}  Play your games on a powerful cloud computer! D2D provides you with an easy way to play hardware intensive games without the headache and cost of buying your own to
    page should contain element  ${cloud_play_spend_msg}
    element should contain  ${cloud_play_spend_msg}  you spend in one transaction on D2D
    page should contain element  ${cloud_play_fastend_msg}
    page should contain element  ${cloud_play_smaller_msg1}
    page should contain element  ${cloud_play_smaller_msg2}
    page should contain element  ${d2d_support_link}
    
    log  check notification section
    page should contain element  ${get_notified_img}
    page should contain element  ${get_notified_btn}
    page should contain element  ${get_notified_str}
    element should contain  ${get_notified_str}  to sign up for streaming event notifications.  
    page should contain element  ${question_mark}

    streaming check bonus hours

    log  check instant play intro section
    page should contain element  ${instant_play_intro}
    page should contain element  ${icon_cloud_pad}
    page should contain element  ${icon_cart}
    page should contain element  ${is_play_intro_step2}
    
    log  check malibu cloud play intro section
    #check title img
    page should contain element  ${m_cloud_play_img}
    #check icons
    : FOR    ${i}    IN RANGE    1    5
        \    page should contain element  xpath=//section[@id="malibu-cloud-play"]/div[2]/section/div/ul/li[${i}]
    page should contain element  ${hdiw_str}
    page should contain element  ${hdiw_step3}
    page should contain element  ${pc_spec}
    page should contain element  ${ram}
    page should contain element  ${press_f12_option}
    
    log  check hwo to use d2d cloud play section
    page should contain element  ${htudcp_title_img}
    page should contain element  ${htudcp_img1}
    page should contain element  ${htudcp_img2}
    page should contain element  ${htudcp_step9}
    
    custom check footer section
    
    [TearDown]  close browser  

TS login and check streaming page
    [Tags]  login

    log to console  go to streaming page
    Open browser  ${streaming_page_url}  ${browser}
	Maximize Browser Window
	Set Browser Implicit Wait  10 seconds

    #check top two rows items
    check common items

    login user on frontend  ${email}  ${pwd}

    #close redeem window
    close redeem window
    Sleep  3s

    #check bonus-play-section
    ${tmp}  Get Element Attribute  ${bonus_time_q_mark}  popover-html
    ${ret}  Get Lines Containing String  ${tmp}  What is Bonus Play Time?
    Should Not Be Empty  ${ret}

    ${ret}  Get Lines Containing String  ${tmp}  Bonus Play time is rewarded to you when you participate in D2D Streaming events
    Should Not Be Empty  ${ret}

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

    Create Session  d2d  ${d2d_url}  verify=True
    ${response}=  Get Request  d2d  ${stream_info_uri}  headers=${request_headers}
    ${result} =  To Json  ${response.content}
    ${hours}  set variable  ${result["streaming"][0]["time_left"]["hours"]}
    ${mins}  set variable  ${result["streaming"][0]["time_left"]["minutes"]}

    element should contain  ${hours_element}  ${hours}
    element should contain  ${hours_text_element}  hour
    element should contain  ${mins_element}  ${mins}
    element should contain  ${mins_text_element}  minutes

    ${ele_hours_str}  get text  ${hours_element}

    element should contain  ${bonus_expires_date}  Bonus Play time expires on:

    ${date}  stream Rearrange Release Date String  ${result["streaming"][0]["expire_period"]}
    element should contain  ${bonus_expires_date}  ${date}

    ${ret1}  run keyword and return status  should be equal as strings  ${hours}  00
    ${ret2}  run keyword and return status  should be equal as strings  ${mins}  00

    run keyword if  ${ret1}==False or ${ret2}==False
    ...  run keywords
    ...  page should contain element  ${launch_play_img}
    ...  AND  page should contain element  ${windows}
    ...  AND  page should contain element  ${steam}
    ...  AND  page should contain element  ${origin}
    ...  AND  page should contain element  ${blizzard}

    custom check footer section

    [TearDown]  close browser

*** Keywords ***
stream Rearrange Release Date String
    [Arguments]    ${date}
    ${python_date}=  Convert Date  ${date}  result_format=%m/%d/%Y
    [Return]  ${python_date}

streaming check bonus hours
    Create Session  d2d  ${d2d_url}  verify=True
    ${response}=  Get Request  d2d  ${campaign_uri}
    ${result} =  To Json  ${response.content}

    ${status}  run keyword and return status  ${free_hours}  set variable  ${result["campaign"]["bonusHours"]}
    run keyword if  ${status}==False  log  no streaming event now
    ...  ELSE  check free time elements  ${free_hours}

check free time elements
    [Arguments]    ${free_hours}
    ${freehours_str}  convert to string  ${free_hours}
    run keyword if  ${free_hours}>0
    ...  run keywords
    ...  element should contain  ${streaming_freehours_title}  ${freehours_str}
    ...  AND  element should contain  ${streaming_freehours_title}  HOURS OF CLOUD PLAY™ FREE!
    ...  AND  element should contain  ${freehours_btn_text}  Click Here
    ...  AND  element should contain  ${freehours_div}  ${freehours_str}
    ...  AND  element should contain  ${freehours_div}  free hours of Cloud Play™

d2d check download client section
    page should contain element  ${client_description}
    element should contain  ${client_description}  The D2D streaming Client is required to use both Cloud Play
    page should contain element  ${download_btn}
    page should contain element  ${download_img}
    
d2d check instant play section
    #check instant play section
    page should contain element  ${instant_play_img}
    page should contain element  ${instant_play_info_btn}
    #check instant play api code 
    Create Session  d2d  ${d2d_url}  verify=True    
    ${response}=  Get Request  d2d  ${instant_play_uri}
    ${result} =  To Json  ${response.content}
    #check element exist or not

    run keyword if  ${result["code"]}==1001  element should contain  ${cs_txt}  There is currently no Instant Play
    ...  ELSE  check instant play game

check instant play game
    run keyword if  ${status}==  Set Suite Variable  ${playable}  ${result["instantPlay"]["any_instant_playable"]}
    #if there is a instant play item in streaming page...check elements
    run keyword if  ${playable}==True
    ...    run keywords
    ...    page should contain element  ${is_item1_img}
    ...    AND  page should contain element  ${is_item1_title}  
    ...    AND  page should contain element  ${is_item1_description}  
    ...    AND  page should contain element  ${is_item1_price}  
    ...    AND  page should contain element  ${is_buy_btn}  



    