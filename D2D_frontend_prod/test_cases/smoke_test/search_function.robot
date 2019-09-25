coding: utf-8
*** Settings ***
Library  SeleniumLibrary
Library  String
Library  OperatingSystem
Library  RequestsLibrary
Library  Collections
Variables  ../../variables/d2d_uri.py
Resource  ../../keywords/smoke_test.robot

*** Test Cases ***
TS check search function
    Open browser  ${reward_page_url}  ${browser}
	Maximize Browser Window
	Set Browser Implicit Wait  10 seconds

    Create Session  d2d  ${d2d_url}  verify=True    
    ${response}=  Get Request  d2d  ${darksider_result_uri}
    ${result} =  To Json  ${response.content}
    
    Click Element  ${search_input}
    Input Text  ${search_input}  darksider
    Sleep  1s
    Press Key  ${search_input}  \\13
    Sleep  5s

    : FOR    ${i}    IN RANGE    0    ${result["products"]["count"]}
    \    ${title}  Set Variable  ${result["products"]["items"][${i}]["title"]}
    \    Element Should Contain  //div[@class='row-fluid browse-results']/div[${i+1}]/a/div[2]/div/h4  ${title}
    
    [TearDown]  close browser  
