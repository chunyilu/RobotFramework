coding: utf-8

*** Settings ***
Library  SeleniumLibrary
Library  String
Library  OperatingSystem
Library  RequestsLibrary
Variables  ../../variables/d2d_uri.py
Variables  ../../variables/login_d2d_user.py
Variables  ../../variables/smoke_test_prod.py
Resource  ../../keywords/smoke_test.robot
Resource  ../../keywords/keyword_index_page_without_login.robot

*** Variable ***
${browser}  firefox

${skin}  xpath=//a[@class='skin']
${hero_module}  xpath=//div[@class='hero-module panel pad']

${footer_module}  xpath=//html/body/div[2]

#hero rotator and square banner
${hero_rotator}  xpath=//*[@id="hero"]
${square_banner_img}  //img[@class='squareImage']
${no_result_element}  //div[@class="text-center pad-large"]

#feature section bottom
${feature_product_headline}  //div[@class="fixed-title text-center ng-binding"]

#browse section
${price_filter_btn}  //div[class="row-fluid margin-bottom-small"]//div[@filter="price"]//span[@class="filter-option pull-left"]
${release_date_filter_btn}  //div[class="row-fluid margin-bottom-small"]//div[@filter="releaseDate"]//span[@class="filter-option pull-left"]
${esrb_filter_btn}  //div[class="row-fluid margin-bottom-small"]//div[@filter="esrb"]//span[@class="filter-option pull-left"]
${match_games_num_txt}  //span[@class="text-light text-large matching-games ng-binding"]
${sort_by_txt}  //div[@class="row-fluid margin-bottom-default"]//span[@class="text-light text-small"]
${sort_by_filter}  //div[@class="btn-group bootstrap-select span12 show-tick ng-pristine ng-untouched ng-valid"]//span

${browse_result}  xpath=//html/body/div[1]/div[2]/div[1]/div[3]/div/div[2]/div/div[3]

${page_info_element}  //div[@class="row-fluid browse-results"]//div[@class="paging-info ng-binding"]

${close_redeem_window}  xpath=//html/body/div[3]/div[2]/div/a[1]

*** Test Cases ***
TS check index page without login
    [Tags]  prod  logout

    log to console  launch browser
    Open browser  ${d2d_url}  ${browser}
	Maximize Browser Window
	Set Browser Implicit Wait  10 seconds

    log to console  check navigation section
    check common items
    Navigation Section Test In Prod env

    log to console  check hero rotator
    page should contain element  ${hero_module}
    page should contain element  ${hero_rotator}

    log to console  check hero rotator from api
    Check Hero Rotator Info without login

    log to console  check feature products top section
    Check Feature Section Top Row
    
    Create Session  d2d  ${d2d_url}  verify=True
    ${response}=  Post Request  d2d  ${shelves_uri}  data=${shelves_payloadData}  headers=${shelves_headers}
    ${result} =  To Json  ${response.content}  

    log to console  popular tab    
    Check Feature Section Popular Tab Items  ${result["shelves"][0]}
    log to console  new tab        
    Check Feature Section New Tab Items  ${result["shelves"][1]}
    log to console  on sale tab        
    Check Feature Section OnSale Tab Items  ${result["shelves"][2]}
    log to console  pre-purchase tab        
    Check Feature Section PrePurchase Tab Items  ${result["shelves"][3]}
    log to console  under 10 tab    
    Check Feature Section Under10 Tab Items  ${result["shelves"][4]}
    log to console  under 30 tab    
    Check Feature Section Under30 Tab Items  ${result["shelves"][5]}

    log to console  check feature products bottom section
    check feature section buttom section without login

    log to console  check browse module
    Check browse module section without login

    page should contain element  ${footer_module}
    custom check footer section

    [TearDown]  close browser