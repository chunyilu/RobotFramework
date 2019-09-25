coding: utf-8
*** Settings ***
Library  SeleniumLibrary
Library  String
Library  OperatingSystem
Library  RequestsLibrary
Library  Collections
Variables  ../../variables/smoke_test_prod.py
Variables  ../../variables/d2d_uri.py
Resource  ../../keywords/smoke_test.robot

*** Variable ***
${paging_info}  //*[@id="nav-main-view-container"]//div[contains(@class, 'paging-info')]

*** Test Cases ***
TS01 check page element
    Open browser  ${d2d_url}  ${browser}
	Maximize Browser Window
	Set Browser Implicit Wait  10 seconds
    sleep  5s

    check common items

    click element  ${tab_4}
    sleep  3s

    #get item count
    Create Session  d2d  ${d2d_url}  verify=True
    ${game_list_response}=  Get Request  d2d  ${flashback_zone_uri}
    ${game_list_result} =  To Json  ${game_list_response.content}

    Set Suite Variable  ${products_cnt}  ${game_list_result["products"]["count"]}

    : FOR    ${i}    IN RANGE    0    ${products_cnt}
        \  ${id}  set variable  ${game_list_result["products"]["items"][${i}]["id"]}
        \  log  image
        \  page should contain element  xpath=//*[@id="${id}"]/div[1]/img
        \  log  title
        \  element should contain  xpath=//*[@id="${id}"]/div[2]/div/h4  ${game_list_result["products"]["items"][${i}]["title"]}
        \  log  genre
        \  element should contain  xpath=//*[@id="${id}"]/div[3]/div  ${game_list_result["products"]["items"][${i}]["genres"][0]["name"]}
        \  log  drm type
        \  ${drm}  get element attribute  xpath=//*[@id="${id}"]/div[4]/div/img  title
        \  log  platform
        \  ${platform}  get element attribute  xpath=//*[@id="${id}"]/div[5]/i  title
        \  log  release date [date]
        \  ${stauts}  Run keyword And Return Status  Set Suite Variable  ${rd_date}  ${game_list_result["products"]["items"][${i}]["releaseDate"]["date"]}
        \  run keyword if  ${stauts}==True  check date element  ${id}  ${rd_date}
        \  log  release date [text]
        \  run keyword if  ${stauts}==False  element should contain  xpath=//*[@id="${id}"]/div[6]/strong  ${game_list_result["products"]["items"][${i}]["releaseDate"]["text"]}
        \  log  purchase price
        \  ${is_on_sale}  set variable  ${game_list_result["products"]["items"][${i}]["offerActions"][0]["isOnSale"]}
        \  run keyword if  ${is_on_sale}==False  check normal product elements  ${id}  ${game_list_result["products"]["items"][${i}]["offerActions"][0]["purchasePrice"]["amount"]}
        \  run keyword if  ${is_on_sale}==True  check onsale product elements  ${id}  ${game_list_result["products"]["items"][${i}]["offerActions"][0]["purchasePrice"]["amount"]}


    page should contain element  ${paging_info}

    #check footer section
    custom check footer section

    [TearDown]  close browser

*** Keywords ***
check date element
    [Arguments]  ${id}  ${rd_date}

    ${date}  Rearrange Release Date String  ${rd_date}
    page should contain element  xpath=//*[@id="${id}"]/div[6]/strong
    run keyword and ignore error  element should contain  xpath=//*[@id="${id}"]/div[6]/strong  ${date}

check normal product elements
    [Arguments]  ${id}  ${amount}

    element should contain  xpath=//*[@id="${id}"]/div[7]//table/tbody/tr/td[1]/div[2]/div  Now
    element should contain  xpath=//*[@id="${id}"]/div[7]//table/tbody/tr/td[2]/div/div  ${amount}

check onsale product elements
    [Arguments]  ${id}  ${amount}

    element should contain  xpath=//*[@id="${id}"]/div[7]//table/tbody/tr/td[1]/div[2]/div[1]  Was
    element should contain  xpath=//*[@id="${id}"]/div[7]//table/tbody/tr/td[1]/div[2]/div[2]  ${amount}
    element should contain  xpath=//*[@id="${id}"]/div[7]//table/tbody/tr/td[2]/div/div[1]  Now
    element should contain  xpath=//*[@id="${id}"]/div[7]//table/tbody/tr/td[2]/div/div[2]  ${amount}