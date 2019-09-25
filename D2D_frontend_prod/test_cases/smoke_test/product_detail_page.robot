coding: utf-8

*** Settings ***
Library  SeleniumLibrary
Library  String
Library  RequestsLibrary
Variables  ../../variables/smoke_test_prod.py
Variables  ../../variables/d2d_uri.py
Variables  ../../variables/login_d2d_user.py
Resource  ../../keywords/smoke_test.robot
Resource  ../../keywords/keyword_product_detail_page.robot

*** Test Cases ***
TS check on sale product page
    [Tags]  onsale

    Open browser  ${d2d_url}  ${browser}
	Maximize Browser Window
	Set Browser Implicit Wait  10 seconds

    log to console  click On Sale tab
    ${num}  get element count  //div[@class="row-fluid sections"]//ul[@class="nav"]/li
    : for  ${i}  IN RANGE  1  ${num}
    \  ${status}  run keyword and return status  element should contain  //div[@class="row-fluid sections"]//ul[@class="nav"]/li[${i}]/a  On Sale
    \  run keyword if  ${status}==True  click element  //div[@class="row-fluid sections"]//ul[@class="nav"]/li[${i}]/a

    sleep  6s

    Create Session  d2d  ${d2d_url}  verify=True
    ${response}=  Get Request  d2d  ${Onsale_page_uri}
    ${result} =  To Json  ${response.content}
    set suite variable  ${product_num}  ${result["products"]["totalItems"]}

    run keyword if  ${product_num}==0  element should contain  xpath=//div[contains(@class, 'browse-results')]/h2  No Games Found!
    ...  ELSE  check product detail via first product id in browse result

    custom check footer section

    [TearDown]  close browser

#TS check NBA 2K19 - 20th Anniversary Edition product page
#    [Tags]  2k19
#
#    Open browser  ${nba_2k19_url}  ${browser}
#	Maximize Browser Window
#	Set Browser Implicit Wait  10 seconds
#
#    ${id}  set variable  5013463
#
#    ${uri}=  Catenate  SEPARATOR=  /backend/api/product/get/${id}
#    Create Session  d2d  ${d2d_url}  verify=True
#    ${response}=  Get Request  d2d  ${uri}
#    ${result} =  To Json  ${response.content}
#
#    ${is_onsale}  set variable  ${result["product"]["offerActions"][0]["isOnSale"]}
#
#    run keyword if  ${is_onsale}==False  check product detail  ${id}
#    ...  ELSE  check onsale product detail  ${id}
#
#    custom check footer section
#
#    [TearDown]  close browser

TS check hero product detail page
    [Tags]  hero

    Open browser  ${d2d_url}  ${browser}
	Maximize Browser Window
	Set Browser Implicit Wait  10 seconds

    click element  //*[@id="hero"]/div/div[1]/div/a/img
    sleep  3s

    ${url}  get location
    ${id}  fetch from right  ${url}  /

    ${uri}=  Catenate  SEPARATOR=  /backend/api/product/get/${id}
    Create Session  d2d  ${d2d_url}  verify=True
    ${response}=  Get Request  d2d  ${uri}
    ${result} =  To Json  ${response.content}

    ${is_onsale}  set variable  ${result["product"]["offerActions"][0]["isOnSale"]}

    run keyword if  ${is_onsale}==False  check product detail  ${id}
    ...  ELSE  check onsale product detail  ${id}

    custom check footer section

    [TearDown]  close browser

TS check hero product 2 detail page
    [Tags]  hero2

    Open browser  ${d2d_url}  ${browser}
	Maximize Browser Window
	Set Browser Implicit Wait  10 seconds
    sleep  3s

    click element  //*[@id="carousel-selector-1"]/div/img
    sleep  1s
    click element  //*[@id="hero"]/div/div[2]/div/a/img
    sleep  3s

    ${url}  get location
    ${id}  fetch from right  ${url}  /

    ${uri}=  Catenate  SEPARATOR=  /backend/api/product/get/${id}
    Create Session  d2d  ${d2d_url}  verify=True
    ${response}=  Get Request  d2d  ${uri}
    ${result} =  To Json  ${response.content}

    ${is_onsale}  set variable  ${result["product"]["offerActions"][0]["isOnSale"]}

    run keyword if  ${is_onsale}==False  check product detail  ${id}
    ...  ELSE  check onsale product detail  ${id}

    custom check footer section

    [TearDown]  close browser