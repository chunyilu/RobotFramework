coding: utf-8

*** Settings ***
Library  SeleniumLibrary
Library  String
Library  OperatingSystem
Library  RequestsLibrary
Library  Collections
Variables  ../../variables/d2d_uri.py
Variables  ../../variables/d2d_index_page.py
Resource  ../../keywords/smoke_test.robot

*** Variable ***
${publisher_txt}  //div[@class="powerSearch-module ng-scope"]/form/legend[1]
${price_txt}  //div[@class="powerSearch-module ng-scope"]/form/legend[2]
${platform_txt}  //div[@class="powerSearch-module ng-scope"]/form/legend[3]
${genre_txt}  //div[@class="powerSearch-module ng-scope"]/form/legend[4]
${rating_txt}  //div[@class="powerSearch-module ng-scope"]/form/legend[5]

${matching_games_txt}  //span[@class="text-light text-large matching-games ng-binding"]
${sort_by_txt}  //span[@class="text-light text-small"]
${sort_by_btn}  //button[@class="btn dropdown-toggle clearfix btn-select"]
${sort_by_btn_span1}  //*[@id="nav-main-view-container"]/div[2]/div/div/div[2]/div/div/div[2]/div/div[2]/div/div/div[3]/div/button/span[1]

${ff_profile_path}  ${CURDIR}/../../../ff_profile_EU
*** Test Cases ***
TS check on sale page
#    run keyword if  '${browser}'=='firefox'  open browser with ff profile
#    ...  ELSE  open browser without ff profile
    open browser with ff profile
    log to console  wait 3s
    sleep  3s
    check total items in on sale page

    #check left section
#    d2d check power search section
#
#    d2d check power search section via json

    #check browse result section
    d2d check browse result section via json
    
    check sort by filter

    custom check footer section


    [TearDown]  close browser  
    
*** Keywords ***
open browser with ff profile
    log to console  open firefox and apply ff profile
    Open browser  ${onsale_page_url}  ${browser}  ff_profile_dir=${ff_profile_path}
	Maximize Browser Window
	Set Browser Implicit Wait  10 seconds

open browser without ff profile
    Open browser  ${onsale_page_url}  ${browser}
	Maximize Browser Window
	Set Browser Implicit Wait  10 seconds

check sort by filter
    element should contain  ${sort_by_txt}  Sort by
    #this element should be button
    ${type}=  get element attribute  ${sort_by_btn}  type
    should be equal  ${type}  button
    element should contain  ${sort_by_btn_span1}  Release Date

check total items in on sale page
    Create Session  d2d  ${d2d_url}  verify=True
    ${response}=  Get Request  d2d  ${onsale_page_uri}  ${eu_request_headers}
    ${result} =  To Json  ${response.content}

    log to console  ${result["products"]["totalItems"]}
    ${cnt}  convert to integer  ${result["products"]["totalItems"]}
    ${cnt_string}  convert to string  ${result["products"]["totalItems"]}

    log to console  check on sale game number
    run keyword if  ${cnt}==0  element should contain  xpath=//div[contains(@class, 'browse-results')]//h2[@class="text-center"]  No Games Found!
    ...  ELSE  element should contain  //*[@id="nav-main-view-container"]//div[contains(@class, 'margin-bottom-default')]/div[1]/span[1]  ${cnt_string}

#d2d check power search section
#    #check publisher filter
#    page should contain element  ${publisher_txt}
#    element should contain  ${publisher_txt}  Publisher
#    #checkboxs
#    : for    ${i}    IN RANGE    1    6
#        \    page should contain element  //form[@class="ng-pristine ng-valid ng-scope"]/div[1]/label[${i}]/input
#        \    ${type}=  get element attribute  //form[@class="ng-pristine ng-valid ng-scope"]/div[1]/label[${i}]/input  type
#        \    should be equal  ${type}  checkbox
#
#    #check price filter
#    page should contain element  ${price_txt}
#    element should contain  ${price_txt}  Price
#    #checkboxs
#    : for    ${i}    IN RANGE    1    9
#        \    page should contain element  //form[@class="ng-pristine ng-valid ng-scope"]/div[2]/label[${i}]/input
#        \    ${type}=  get element attribute  //form[@class="ng-pristine ng-valid ng-scope"]/div[2]/label[${i}]/input  type
#        \    should be equal  ${type}  checkbox
#
#    #check platform filter
#    page should contain element  ${platform_txt}
#    element should contain  ${platform_txt}  Platform
#    #checkboxs
#    : for    ${i}    IN RANGE    1    7
#        \    page should contain element  //form[@class="ng-pristine ng-valid ng-scope"]/div[3]/label[${i}]/input
#        \    ${type}=  get element attribute  //form[@class="ng-pristine ng-valid ng-scope"]/div[3]/label[${i}]/input  type
#        \    should be equal  ${type}  checkbox
#
#    #check genre filter checkboxs
#    page should contain element  ${genre_txt}
#    element should contain  ${genre_txt}  Genre
#
#    #check pegi rating
#    page should contain element  ${rating_txt}
#    element should contain  ${rating_txt}  ESRB Rating
#    #checkboxs
#    : for    ${i}    IN RANGE    1    6
#        \    page should contain element  //form[@class="ng-pristine ng-valid ng-scope"]/div[5]/label[${i}]/input
#        \    ${type}=  get element attribute  //form[@class="ng-pristine ng-valid ng-scope"]/div[5]/label[${i}]/input  type
#        \    should be equal  ${type}  checkbox

#d2d check power search section via json
#    #read json file to frontend data compare
#    Create Session  d2d  ${d2d_url}  verify=True
#    #Genre
#    ${genres_response}=  Get Request  d2d  ${genres_uri}  ${eu_request_headers}
#    ${genres_result} =  To Json  ${genres_response.content}
#    : for    ${i}    IN RANGE    0    ${genres_result["paging"]["count"]}
#        \    Set Test Variable  ${genre}  ${genres_result["items"][${i}]["genre_name"]}
#        \    element should contain  //form[@class="ng-pristine ng-valid ng-scope"]/div[4]/label[${i+1}]  ${genre}
#    #Platform
#    ${plat_response}=  Get Request  d2d  ${platform_uri}  ${eu_request_headers}
#    ${plat_result} =  To Json  ${plat_response.content}
#    #no platform num in json
#    : for    ${i}    IN RANGE    0    6
#        \    Run Keyword If  ${i}!=0
#        \    ...    element should contain  //form[@class="ng-pristine ng-valid ng-scope"]/div[3]/label[${i+1}]  ${plat_result["platforms"][${i+1}]["platform"]}
#        \    Run Keyword If  ${i}==0
#        \    ...    element should contain  //form[@class="ng-pristine ng-valid ng-scope"]/div[3]/label[${i+1}]  ${plat_result["platforms"][${i}]["platform"]}

d2d check browse result section via json
    log to console  read json file to frontend data compare
    Create Session  d2d  ${d2d_url}  verify=True
    ${response}=  Get Request  d2d  ${Onsale_page_uri}  ${eu_request_headers}
    ${result} =  To Json  ${response.content}
    set test variable  ${totalItems}  ${result["products"]["totalItems"]}

    log to console  check x matching games element
    ${mg_str}=  Catenate  ${totalItems}  matching games
    element should contain  ${matching_games_txt}  ${mg_str}

    #return keyword if game num == 0
    run keyword if  ${totalItems}==0  Return From Keyword  ${-1}

    #only check one page, if total items over 25 products, set count to 25
    ${count}  set variable if  ${totalItems}>24  24  ${totalItems}
    ${count}  convert to integer  ${count}

    : for    ${i}    IN RANGE    0    ${count}
        \  log to console  ${result["products"]["items"][${i}]["title"]}
        \  Set Test Variable  ${was_price}  ${result["products"]["items"][${i}]["offerActions"][0]["suggestedPrice"]["amount"]}
        \  ${was_price}  custom get rounded number  ${was_price}
        \  Set Test Variable  ${now_price}  ${result["products"]["items"][${i}]["offerActions"][0]["purchasePrice"]["amount"]}
        \  ${now_price}  custom get rounded number  ${now_price}
#        \  element should contain  //div[contains(@class, 'browse-results')]/div[${i+1}]/a/div[2]/div/h4  ${game_title}
        \  ${element_title}  get text  //div[contains(@class, 'browse-results')]/div[${i+1}]/a/div[2]/div/h4
        \  check game title  ${element_title}  ${result["products"]["items"][${i}]["title"]}
        \  log  check browse result element
        \  page should contain element  //div[contains(@class, 'browse-results')]/div[${i+1}]/a/div[1]/img
        \  log  check was price
        \  element should contain  //div[contains(@class, 'browse-results')]/div[${i+1}]//table/tbody/tr/td[1]/div[2]/div[2]  ${was_price}
        \  log  check now price
        \  element should contain  //div[contains(@class, 'browse-results')]/div[${i+1}]//table/tbody/tr/td[2]/div/div[2]  ${now_price}

check game title
    [Arguments]  ${element_title}  ${api_title}

    ${t1}  remove string  ${element_title}  ${EMPTY}
    ${t2}  remove string  ${api_title}  ${EMPTY}
    should be equal  ${t1}  ${t2}
