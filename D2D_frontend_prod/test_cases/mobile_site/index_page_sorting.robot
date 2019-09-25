coding: utf-8
*** Settings ***
Library  SeleniumLibrary
Library  String
Library  OperatingSystem
Library  RequestsLibrary
Library  Collections
Library  DateTime

*** Variable ***
${BROWSER}  chrome
${d2durl}   https://m.direct2drive.com/

#search and filter
${search_input}  //d2d-search-box/div/input
${search_icon}  //d2d-search-box/div/div/mat-icon
${search_menu_btn}  //d2d-product-search/mat-sidenav-container/mat-sidenav-content/button
${game_filter_menu}  //d2d-games-menu/div/button/span

#price filter
${price_filter_btn}  //d2d-product-search/mat-sidenav-container/mat-sidenav-content/div/div/div[1]/button[1]
${all_prices}  //*[@id="mat-option-0"]/span
${on_sale}  //*[@id="mat-option-1"]/span
${10_under}  //*[@id="mat-option-2"]/span
${20_under}  //*[@id="mat-option-3"]/span
${30_under}  //*[@id="mat-option-4"]/span
${40_under}  //*[@id="mat-option-5"]/span
${50_under}  //*[@id="mat-option-6"]/span
${over_50}  //*[@id="mat-option-7"]/span

${over_50_api}  /backend/api/productquery/findpage?pageindex=1&pagesize=5&platform[]=1100&genre[]=1&sort.direction=desc&sort.field=releasedate&price.overprice=50

*** Test Cases ***
TS price filter sorting
    [Tags]  price

    log to console  open browser
    Open browser  ${d2durl}  ${BROWSER}
	Set Window Size  1000  900
	Set Selenium Speed  0.1 seconds
	Set Browser Implicit Wait  15 seconds

    log to console  wait hero rotator elements
    Wait Until Element Is Visible  //div[contains(@class, "swiper-container-horizontal")]  9
    Sleep  1s
    Execute JavaScript  window.scrollTo(0, document.body.scrollHeight / 2)

    log to console  click elements
    click element  ${price_filter_btn}
    sleep  1s
    click element  ${over_50}
    sleep  1s

    log to console  send http request and check frontend data
    check game data via over 50 filter

    #todo:
    #add other filter test cases

    [Teardown]  Close Browser

*** Keywords ***
check game data via over 50 filter
    Create Session  d2d  ${d2durl}  verify=True
    ${response}=  Get Request  d2d  ${over_50_api}
    ${result} =  To Json  ${response.content}

    ${num}  get length  ${result["products"]["items"]}

    : FOR  ${i}  IN RANGE  1  ${num}
    \  page should contain element  //d2d-product-search/mat-sidenav-container/mat-sidenav-content/div/div/div[2]/div[${i}]//img
    \  ${title_api}  set variable  ${result["products"]["items"][${i}-1]["title"]}
    \  ${title_fr}  get text  //d2d-product-search/mat-sidenav-container/mat-sidenav-content/div/div/div[2]/div[${i}]/d2d-product-column/div/div/h4
    \  should be equal as strings  ${title_api}  ${title_fr}
