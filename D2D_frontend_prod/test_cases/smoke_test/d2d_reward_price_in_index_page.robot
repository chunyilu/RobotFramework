coding: utf-8

*** Settings ***
Library  SeleniumLibrary
Library  String
Library  RequestsLibrary
Variables  ../../variables/smoke_test_prod.py
Variables  ../../variables/d2d_uri.py
#Variables  ../../variables/login_d2d_user.py
Resource  ../../keywords/smoke_test.robot
#Library  ../../libs/transporter.py
Library  ../../libs/atgames.py

*** Variable ***
${email}  enter_your_email
${pwd}  enter_your_password
#hero rotator and square banner
${hero_module}  xpath=//div[@class='hero-module panel pad']
${hero_rotator}  xpath=//*[@id="hero"]
${square_banner_img}  //img[@class='squareImage']
${no_result_element}  //div[@class="text-center pad-large"]

#feature section top
${featured_tab}      //div[contains(@class, "featured-module")]/div/ul/li[1]/a
${popular_tab}       //div[contains(@class, "featured-module")]/div/ul/li[2]/a
${new_tab}           //div[contains(@class, "featured-module")]/div/ul/li[3]/a
${on_sale_tab}       //div[contains(@class, "featured-module")]/div/ul/li[4]/a
${pre_purchase_tab}  //div[contains(@class, "featured-module")]/div/ul/li[5]/a
${under_10_tab}      //div[contains(@class, "featured-module")]/div/ul/li[6]/a
${under_30_tab}      //div[contains(@class, "featured-module")]/div/ul/li[7]/a

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

#temp
${was_price}  0
${now_price}  0
${vip_price}  0
${reward_price}  0

${next}  //*[@id="nav-main-view-container"]/div[2]/div/div/div[2]/div/div/div[2]/div/div[3]/div[26]/a[2]

*** Test Cases ***
# need to login to check vip price
TS login an account with d2d member and check index page price
    [Tags]  index  reward  login

    log to console  open browser
    Open browser  https://www.direct2drive.com/#!/pc  ${browser}
	Maximize Browser Window
	Set Browser Implicit Wait  10 seconds

    log to console  login
    Login User on frontend  ${email}  ${pwd}

    log to console  send request
    Create Session  d2d  ${d2d_url}  verify=True
    ${mer_response}=  Get Request  d2d  ${merchandising_uri}
    ${mer_result} =  To Json  ${mer_response.content}

    log to console  check hero rotator reward price
    check hero items price  ${mer_result}

    log to console  check square banners price
    check square banners price  ${mer_result}

    log to console  check featured products top row
    check featured products top row  ${mer_result}

    log to console  check featured products top row other tab
    check featured products top row other tab

    log to console  check featured products bottom row
    check featured products bottom row  ${mer_result}

    log to console  check browse module

#    Create Session  d2d  ${d2d_url}  verify=True
    ${All_game_list_response}=  Get Request  d2d  ${All_game_list_uri}
    ${All_game_list_result} =  To Json  ${All_game_list_response.content}

    : FOR    ${i}    IN RANGE    0    25
    \  ${browse_title}  get text  //div[@class="row-fluid browse-results"]/child::div[${i+1}]//div[contains(@class, 'title')]//h4
    \  log to console  ${browse_title}
    \  ${gb}=  set variable  ${All_game_list_result["products"]["items"][${i}]["offerActions"][0]["vipPrice"]["vip"]["gb"]}
    \  browse module element price  ${i}  ${gb}

    [TearDown]  close browser

*** Keywords ***
check featured products bottom row
    [Arguments]    ${result}

    #group 2 -> feature products bottom
    : FOR    ${i}    IN RANGE    0    5
    \  ${pvid}=  set variable  ${result["groups"][2]["items"][${i}]["product"]["productVariantId"]}
    \  ${pvid_str}  convert to string  ${pvid}
    \  ${title}=  set variable  ${result["products"]["${pvid_str}"]["title"]}
    \  ${isOnSale}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["isOnSale"]}
    \  ${totalPercentOff}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["totalPercentOff"]}
    \  ${vip_price}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["vipPrice"]["amount"]}
    \  ${dR}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["vipPrice"]["vip"]["dR"]}
    \  ${gb}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["vipPrice"]["vip"]["gb"]}
    \  ${now_price}  get text  xpath=//*[@id="featured-fix"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[1]/div[2]/div[2]
    \  ${vip_price}  get text  xpath=//*[@id="featured-fix"]/div[1]/div/child::div[${i+1}]//div[starts-with(@class, 'vip_color')]
    \  ${now_price}  Fetch From Right  ${now_price}  $
    \  ${vip_price}  Fetch From Right  ${vip_price}  $
    \  ${status}  check d2d reward discount py  ${now_price}  ${vip_price}  ${gb}
    \  run keyword if  ${status}==0  log  fail the d2d reward discount test  warn

check featured products top row
    [Arguments]    ${result}

    #group 1 -> feature products top
    : FOR    ${i}    IN RANGE    0    5
    \  ${pvid}=  set variable  ${result["groups"][1]["items"][${i}]["product"]["productVariantId"]}
    \  ${pvid_str}  convert to string  ${pvid}
    \  ${title}=  set variable  ${result["products"]["${pvid_str}"]["title"]}
    \  ${isOnSale}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["isOnSale"]}
    \  ${totalPercentOff}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["totalPercentOff"]}
    \  ${vip_price}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["vipPrice"]["amount"]}
    \  ${dR}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["vipPrice"]["vip"]["dR"]}
    \  ${gb}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["vipPrice"]["vip"]["gb"]}
    \  ${now_price}  get text  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[1]/div[2]/div[2]
    \  ${vip_price}  get text  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//div[starts-with(@class, 'vip_color')]
    \  ${now_price}  Fetch From Right  ${now_price}  $
    \  ${vip_price}  Fetch From Right  ${vip_price}  $
    \  ${status}  check d2d reward discount py  ${now_price}  ${vip_price}  ${gb}
    \  run keyword if  ${status}==0  log  fail the d2d reward discount test  warn

check featured products top row other tab
    #create session
    Create Session  d2d  ${d2d_url}  verify=True

    log to console  test popular_tab
    #send request
#    ${response}=  Post Request  d2d  /backend/api/merchandising/shelves  data=${shelves_popular_data}  headers=${shelves_headers}
    ${response}=  Get Request  d2d  ${Bestselling_uri}
    ${result} =  To Json  ${response.content}

    click element  ${popular_tab}
    sleep  1s
    featured products discount test  ${result}
    #-----------------------------------------------------------------------------------------------------------------------------
    log to console  test new_tab
    #send request
#    ${response}=  Post Request  d2d  /backend/api/merchandising/shelves  data=${shelves_new_data}  headers=${shelves_headers}
    ${response}=  Get Request  d2d  ${New_uri}
    ${result} =  To Json  ${response.content}

    click element  ${new_tab}
    sleep  1s

    featured products discount test  ${result}
    #-----------------------------------------------------------------------------------------------------------------------------
    log to console  test on_sale_tab
    #send request
#    ${response}=  Post Request  d2d  /backend/api/merchandising/shelves  data=${shelves_onsale_data}  headers=${shelves_headers}
    ${response}=  Get Request  d2d  ${Onsale_uri}
    ${result} =  To Json  ${response.content}

    click element  ${on_sale_tab}
    sleep  1s

    featured products discount test  ${result}
    #-----------------------------------------------------------------------------------------------------------------------------
    log to console  test pre_purchase_tab
    #send request
#    ${response}=  Post Request  d2d  /backend/api/merchandising/shelves  data=${shelves_preorder_data}  headers=${shelves_headers}
    ${response}=  Get Request  d2d  ${Pre_purchase_uri}
    ${result} =  To Json  ${response.content}

    click element  ${pre_purchase_tab}
    sleep  1s

    featured products discount test  ${result}
    #-----------------------------------------------------------------------------------------------------------------------------
    log to console  test under_10_tab

#    ${response}=  Post Request  d2d  /backend/api/merchandising/shelves  data=${shelves_under10_data}  headers=${shelves_headers}
    ${response}=  Get Request  d2d  ${Under_10_Uri}
    ${result} =  To Json  ${response.content}

    click element  ${under_10_tab}
    sleep  1s

    featured products discount test  ${result}
    #-----------------------------------------------------------------------------------------------------------------------------
    log to console  test under_30_tab

#    ${response}=  Post Request  d2d  /backend/api/merchandising/shelves  data=${shelves_under30_data}  headers=${shelves_headers}
    ${response}=  Get Request  d2d  ${Under_30_Uri}
    ${result} =  To Json  ${response.content}

    click element  ${under_30_tab}
    sleep  1s

    featured products discount test  ${result}

featured products discount test
    [Arguments]    ${result}

    ${status}  run keyword and return status  element should contain  //div[contains(@class, 'featured-module')]/div[2]/div[1]/div  No results to display
    return from keyword if  ${status}==True  0

    ${len}  get length  ${result["products"]["items"]}
    ${num}  set variable if  ${len}>5  5  ${len}

    : FOR    ${i}    IN RANGE    0    ${num}
    \  ${title}=  set variable  ${result["products"]["items"][${i}]["title"]}
    \  ${gb}=  set variable  ${result["products"]["items"][${i}]["offerActions"][0]["vipPrice"]["vip"]["gb"]}
    \  ${amount}=  set variable  ${result["products"]["items"][${i}]["offerActions"][0]["vipPrice"]["amount"]}
    \  ${now_price}  get text  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[1]/div[2]/div[2]
    \  ${vip_price}  get text  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//div[starts-with(@class, 'vip_color')]
    \  ${now_price}  Fetch From Right  ${now_price}  $
    \  ${vip_price}  Fetch From Right  ${vip_price}  $
    \  ${status}  check d2d reward discount py  ${now_price}  ${vip_price}  ${gb}
    \  run keyword if  ${status}==0  log  fail the d2d reward discount test  warn

check square banners price
    [Arguments]    ${result}

    #group 4 -> squares
    : FOR    ${i}    IN RANGE    0    1
    \  ${pvid}=  set variable  ${result["groups"][4]["items"][${i}]["square"]["url_or_id"]}
    \  ${pvid_str}  convert to string  ${pvid}
    \  ${is_url}  run keyword and return status  get regexp matches  ${pvid_str}  http
    \  continue for loop if  ${is_url}==True
    \  ${title}=  set variable  ${result["products"]["${pvid_str}"]["title"]}
    \  ${isOnSale}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["isOnSale"]}
    \  ${totalPercentOff}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["totalPercentOff"]}
    \  ${vip_price}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["vipPrice"]["amount"]}
    \  ${dR}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["vipPrice"]["vip"]["dR"]}
    \  ${gb}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["vipPrice"]["vip"]["gb"]}
    \  ${now_price}  get text  //div[@class="promotion ng-scope"]/div[${i+1}]//table/tbody/tr/td[1]/div[2]/div[2]
    \  ${vip_price}  get text  //div[@class="promotion ng-scope"]/div[${i+1}]//table/tbody/tr/td[2]/div[2]
    \  ${now_price}  Fetch From Right  ${now_price}  $
    \  ${vip_price}  Fetch From Right  ${vip_price}  $
    \  ${status}  check d2d reward discount py  ${now_price}  ${vip_price}  ${gb}
    \  run keyword if  ${status}==0  log  fail the d2d reward discount test  warn


check hero items price
    [Arguments]    ${result}

    #group 0 -> hero rotator
    : FOR    ${i}    IN RANGE    0    5
    \    ${pvid}=  set variable  ${result["groups"][0]["items"][${i}]["product"]["productVariantId"]}
    \    ${pvid_str}  convert to string  ${pvid}
    \    ${title}=  set variable  ${result["products"]["${pvid_str}"]["title"]}
    \    ${isOnSale}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["isOnSale"]}
    \    ${totalPercentOff}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["totalPercentOff"]}
    \    ${vip_price}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["vipPrice"]["amount"]}
    \    ${dR}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["vipPrice"]["vip"]["dR"]}
    \    ${gb}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["vipPrice"]["vip"]["gb"]}
    \    Click Element  //ul[@class='carousel-thumbnails inline']/li/a[${i+1}]/div/img
    \    Sleep  2s
    \    hero rotator onsale element price  ${i}  ${gb}

check frontend price
    [Arguments]    ${result}

    : FOR    ${i}    IN RANGE    0    25
    \  log to console  ${i}
    \  ${id}  set variable  ${result["products"]["items"][${i}]["id"]}
    \  ${title}  get text  xpath=//*[@id="${id}"]/div[2]/div/h4
    \  log to console  ${title}
    \  ${dR}=  set variable  ${result["products"]["items"][${i}]["offerActions"][0]["vipPrice"]["vip"]["dR"]}
    \  ${gb}=  set variable  ${result["products"]["items"][${i}]["offerActions"][0]["vipPrice"]["vip"]["gb"]}
    \  ${now_price}  get text  //*[@id="${id}"]//table/tbody/tr/td[1]/div[2]/div[2]
    \  ${vip_price}  get text  //*[@id="${id}"]//table/tbody/tr/td[2]/div[2]
    \  ${now_price}  Fetch From Right  ${now_price}  $
    \  ${vip_price}  Fetch From Right  ${vip_price}  $
    \  ${status}  check d2d reward discount py  ${now_price}  ${vip_price}  ${gb}
    \  run keyword if  ${status}==0  log  fail the d2d reward discount test  warn

browse module element price
    [Arguments]  ${i}  ${gb}
    ${now_price}  get text  //div[contains(@class, 'browse-results')]/child::div[${i+1}]//table/tbody/tr/td[1]/div[2]/div[2]
    ${vip_price}  get text  //div[contains(@class, 'browse-results')]/child::div[${i+1}]//div[starts-with(@class, 'vip_color')]
    ${now_price}  Fetch From Right  ${now_price}  $
    ${vip_price}  Fetch From Right  ${vip_price}  $
    ${status}  check d2d reward discount py  ${now_price}  ${vip_price}  ${gb}
    run keyword if  ${status}==0  log  fail the d2d reward discount test  warn

featured products bottom row element price
    [Arguments]    ${result}

    #group 2 -> feature products bottom
    : FOR    ${i}    IN RANGE    0    5
    \  ${pvid}=  set variable  ${result["groups"][2]["items"][${i}]["product"]["productVariantId"]}
    \  ${pvid_str}  convert to string  ${pvid}
    \  ${title}=  set variable  ${result["products"]["${pvid_str}"]["title"]}
    \  ${isOnSale}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["isOnSale"]}
    \  ${totalPercentOff}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["totalPercentOff"]}
    \  ${vip_price}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["vipPrice"]["amount"]}
    \  ${dR}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["vipPrice"]["vip"]["dR"]}
    \  ${gb}=  set variable  ${result["products"]["${pvid_str}"]["offerActions"][0]["vipPrice"]["vip"]["gb"]}
    \  ${now_price}  get text  xpath=//*[@id="featured-fix"]/div[1]/div[1]/child::div[${i+1}]//table/tbody/tr/td[1]/div[2]/div[2]
    \  ${vip_price}  get text  xpath=//*[@id="featured-fix"]/div[1]/div/child::div[${i+1}]//div[starts-with(@class, 'vip_color')]
    \  ${now_price}  Fetch From Right  ${now_price}  $
    \  ${vip_price}  Fetch From Right  ${vip_price}  $
    \  ${status}  check d2d reward discount py  ${now_price}  ${vip_price}  ${gb}
    \  run keyword if  ${status}==0  log  fail the d2d reward discount test  warn

#featured products top row element price
#    [Arguments]    ${i}
#    ${now_price}  get text  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[1]/div[2]/div[2]
#    ${vip_price}  get text  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//div[starts-with(@class, 'vip_color')]
#
#    ${now_price}  Fetch From Right  ${now_price}  $
#    ${vip_price}  Fetch From Right  ${vip_price}  $
#
#    check d2d reward discount py  ${now_price}  ${vip_price}  0

hero rotator onsale element price
    [Arguments]    ${i}  ${gb}
    ${was_price}  get text  //div[@class='carousel-inner']/div[${i+1}]//table/tbody/tr/td[1]/div[2]/div[1]
    ${now_price}  get text  //div[@class='carousel-inner']/div[${i+1}]//table/tbody/tr/td[1]/div[2]/div[2]
    ${vip_price}  get text  //div[@class='carousel-inner']/div[${i+1}]//div[contains(@class, 'vip_color')]

    ${now_price}  Fetch From Right  ${now_price}  $
    ${vip_price}  Fetch From Right  ${vip_price}  $

    ${status}  check d2d reward discount py  ${now_price}  ${vip_price}  ${gb}
    run keyword if  ${status}==0  log  fail the d2d reward discount test  error

