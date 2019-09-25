coding: utf-8
*** Settings ***
Library  SeleniumLibrary
Library  DateTime
Variables  ../variables/smoke_test_prod.py
Variables  ../variables/login_d2d_user.py

*** Variable ***
#use spin_animation to check loading status
${spin_animation}  xpath=//html/body/div[1]/div[2]/div[1]/div[2]/div[2]/div[1]/div[1]/i
${d2d_logo_xp}  //div[@class="container-fluid text-left"]//img[@class="logo-gf"]
#${d2d_logo_nav_xp}  xpath=//html/body/div[1]/div[1]/div/div/div[1]/div/ul[1]

#social
${social_tool_set}  xpath=//html/body/div[1]/div[1]/div/div/div[1]/div/ul[4]
${fb}  xpath=//html/body/div/div/div/table/tbody/tr/td/div/div/button
${twitter}  xpath=//*[@id="l"]
${subscribe}  xpath=//html/body/div[1]/div[1]/div/div/div[1]/div/ul[4]/li[3]/button

#search
${search_tool_set}  //ul[@class="nav pull-right toolset"]
${search_input}  //ul[@class="nav pull-right toolset"]//div[@class="input-append"]/input
${search_btn}  //ul[@class="nav pull-right toolset"]//button[@class="btn btn-default gf-search-btn"]

#nav menu
${menu}  //*[@id="navMenu"]
${shopping_cart_btn}  //button[@class="btn btn-cart"]
${login_element}  //div[@class="user-panel"]//strong
${support_element}  //ul[@id="navMenu"]/li[3]//strong
${corporate}  //ul[@id="navMenu"]/li[4]//strong

#d2d_client_section
#${d2d_client_section}  xpath=//html/body/div[1]/div[1]/div/div/div[2]
#${trade_in_intro_text}  //div[@class="nav d2d-client span11 text-center"]/b
#${trade_in_learn_btn}  //div[@class="nav d2d-client span11 text-center"]/a
#${close_btn}  //div[@class="row-fluid sections d2d-client-section ng-scope"]//i[@class="fa fa-times"]

#navigation section
${tab_0}  xpath=//*[@id="navDropdown"]
${tab_1}  //div[@class="row-fluid sections"]//ul[@class="nav"]/li[2]/a
${tab_2}  //div[@class="row-fluid sections"]//ul[@class="nav"]/li[3]/a
${tab_3}  //div[@class="row-fluid sections"]//ul[@class="nav"]/li[4]/a
${tab_4}  //div[@class="row-fluid sections"]//ul[@class="nav"]/li[5]/a
${tab_5}  //div[@class="row-fluid sections"]//ul[@class="nav"]/li[6]/a
${tab_6}  //div[@class="row-fluid sections"]//ul[@class="nav"]/li[7]/a
${tab_7}  //div[@class="row-fluid sections"]//ul[@class="nav"]/li[8]/a
${tab_8}  //div[@class="row-fluid sections"]//ul[@class="nav"]/li[9]/a

#footer section
${about_d2d}  //div[@class="span2 border-left pad-left"]/ul/li[1]//strong
${about_us}   //div[@class="span2 border-left pad-left"]/ul/li[2]//a
${support}    //div[@class="span2 border-left pad-left"]/ul/li[3]//a
${sitemap}    //div[@class="span2 border-left pad-left"]/ul/li[4]//a
${policy}     //div[@class="span2 border-left pad-left"]/ul/li[5]//a
${terms}      //div[@class="span2 border-left pad-left"]/ul/li[6]//a

${redeem_window_cross_btn}  //div[@id="bonus20hrsCloudPlay"]//a[@class="cancel"]

#login xpath
${login_signup}  xpath=//ul[@id='navMenu']/li[2]/div/div/a/strong

#login div
${email_input}  xpath=//input[@id='loginEmail']
${pwd_input}  xpath=//input[@id='loginPassword']
${login_btn}  //*[@id="login"]/div[2]/form[1]//button

*** Keywords ***
custom get rounded number
    [Arguments]    ${price}
    ${price}=  Convert To Number  ${price}
    ${price}=  Evaluate  ${price} + 0.0001  #add 0.0001 to rounded this number
    ${price}=  Convert To Number  ${price}  2
    log  ${price}
    ${price_str}  convert to string  ${price}
    [Return]  ${price_str}

Free trial event check
    page should contain element  xpath=//div[@id="freeSubscriptionTrial"]
    element should contain  xpath=//div[@id="freeSubscriptionTrial"]//div[@class="bonus-message"]  Try out D2D+ Subscription for FREE!
    element should contain  xpath=//div[@id="freeSubscriptionTrial"]//div[@class="bonus-message"]  Subscribe now and begin playing instantly!
    Run Keyword And Ignore Error  element should contain  xpath=//div[@id="freeSubscriptionTrial"]//div[@class="event-info ng-binding"]  This promotion runs from 11-02-2018 15:00:00 to 11-17-2018 15:59:00.
    page should contain element  xpath=//div[@id="freeSubscriptionTrial"]//a[@class="redeem"]
    #close free subscription window
    click element  xpath=//div[@id="freeSubscriptionTrial"]//a[@class="cancel"]
    sleep  1s

# ex: return 08/02/2018
Rearrange Release Date String 
    [Arguments]    ${date}
    ${python_date}=  Convert Date  ${date}  result_format=%m/%d/%Y
    [Return]  ${python_date}
    
#                   year-month-day
#json date format = 2018-08-10T00:00:00.000Z
Rearrange Release Date String MDY
    [Arguments]    ${date}
    ${python_date}=  Convert Date  ${date}  datetime
    ${m}=  Convert To String  ${python_date.month}
    ${d}=  Convert To String  ${python_date.day}
    ${y}=  Convert To String  ${python_date.year}
    ${ret}=  Catenate  SEPARATOR=  ${m}  /
    ${ret}=  Catenate  SEPARATOR=  ${ret}  ${d}
    ${ret}=  Catenate  SEPARATOR=  ${ret}  /
    ${ret}=  Catenate  SEPARATOR=  ${ret}  ${y}
    [Return]  ${ret}

close redeem window
    Run Keyword And Ignore Error  Click Element  ${redeem_window_cross_btn}

Add Needed Image Path
    Add Image Path    ${IMAGE_DIR}

#180925
# Login User and Get Token
    # [Arguments]  ${login_user_data}
    # ${login_headers_tmp}=  Create Dictionary  Content-Type=application/x-www-form-urlencoded  devise=D2D Desktop  fp=MjY5NzE5NjkxMg==  remote-ip=3.255.255.255
    # Create Session  d2d  ${d2d_url}   verify=True
    # ${login_resp}=  Post Request  d2d  ${login_uri}  data=${login_user_data}  headers=${login_headers_tmp}
    # ${login_resp_result} =  To Json  ${login_resp.content}
    # Set Suite Variable   ${login_user_token}   Bearer ${login_resp_result["account"]["token"]}
    # ${login_user_toke_headers}=   Create Dictionary   Authorization=${login_user_token}
    # [Return]  ${login_user_toke_headers}


Set Product detail with ID
    [Arguments]      ${label}      ${product_id}    ${headers}
    Create Session  d2d  ${d2d_url}   verify=True
    ${response}=  Get Request  d2d  ${getdisplay_uri}  headers=${headers}
    ${result} =  To Json  ${response.content}
    Set Suite Variable  ${${label}_title}  ${result["products"]["${product_id}"]["title"]}
    Set Suite Variable  ${${label}_purchaseprice}  ${result["products"]["${product_id}"]["offerActions"][0]["purchasePrice"]["amount"]}
    Set Suite Variable  ${${label}_suggestedprice}  ${result["products"]["${product_id}"]["offerActions"][0]["suggestedPrice"]["amount"]}
    Set Suite Variable  ${${label}_vipprice}  ${result["products"]["${product_id}"]["offerActions"][0]["vipPrice"]["amount"]}
    Set Suite Variable  ${${label}_viptier}  ${result["products"]["${product_id}"]["offerActions"][0]["vipPrice"]["vip"]["tier"]}
    Set Suite Variable  ${${label}_vipname}  ${result["products"]["${product_id}"]["offerActions"][0]["vipPrice"]["vip"]["name"]}
    Set Suite Variable  ${${label}_isOnSale}  ${result["products"]["${product_id}"]["offerActions"][0]["isOnSale"]}
    Set Suite Variable  ${${label}_isPreorderOffer}  ${result["products"]["${product_id}"]["offerActions"][0]["isPreorderOffer"]}
    Set Suite Variable  ${${label}_buyableFromCountry}  ${result["products"]["${product_id}"]["offerActions"][0]["buyableFromCountry"]}
    Set Suite Variable  ${${label}_totalPercentOff}  ${result["products"]["${product_id}"]["offerActions"][0]["totalPercentOff"]}

Set Product detail with ID in findpage
    [Arguments]      ${label}      ${item_id}    ${findpage_uri}    ${headers}
    Create Session  d2d  ${d2d_url}   verify=True
    ${response}=  Get Request  d2d  ${findpage_uri}  headers=${headers}
    ${result} =  To Json  ${response.content}
    Set Suite Variable  ${${label}_title}  ${result["products"]["items"][${item_id}]["title"]}
    Set Suite Variable  ${${label}_purchaseprice}  ${result["products"]["items"][${item_id}]["offerActions"][0]["purchasePrice"]["amount"]}
    Set Suite Variable  ${${label}_suggestedprice}  ${result["products"]["items"][${item_id}]["offerActions"][0]["suggestedPrice"]["amount"]}
    Set Suite Variable  ${${label}_vipprice}  ${result["products"]["items"][${item_id}]["offerActions"][0]["vipPrice"]["amount"]}
    Set Suite Variable  ${${label}_viptier}  ${result["products"]["items"][${item_id}]["offerActions"][0]["vipPrice"]["vip"]["tier"]}
    Set Suite Variable  ${${label}_vipname}  ${result["products"]["items"][${item_id}]["offerActions"][0]["vipPrice"]["vip"]["name"]}
    Set Suite Variable  ${${label}_isOnSale}  ${result["products"]["items"][${item_id}]["offerActions"][0]["isOnSale"]}
    Set Suite Variable  ${${label}_isPreorderOffer}  ${result["products"]["items"][${item_id}]["offerActions"][0]["isPreorderOffer"]}
    Set Suite Variable  ${${label}_buyableFromCountry}  ${result["products"]["items"][${item_id}]["offerActions"][0]["buyableFromCountry"]}
    Set Suite Variable  ${${label}_totalPercentOff}  ${result["products"]["items"][${item_id}]["offerActions"][0]["totalPercentOff"]}
    Set Suite Variable  ${${label}_publisher}  ${result["products"]["items"][${item_id}]["publisher"]}
    Set Suite Variable  ${${label}_allow_trade_in}  ${result["products"]["items"][${item_id}]["allow_trade_in"]}
    Set Suite Variable  ${${label}_drmType}  ${result["products"]["items"][${item_id}]["drmType"]}
    Set Suite Variable  ${${label}_genre0}  ${result["products"]["items"][${item_id}]["genres"][0]["name"]}
    # skip this since format different
    # Set Suite Variable  ${${label}_release_date}  ${result["products"]["items"][${item_id}]["releaseDate"]["text"]}

Set Product detail with ID in Rewards
    [Arguments]      ${label}      ${item_id}    ${findpage_uri}    ${headers}
    Create Session  d2d  ${d2d_url}   verify=True
    ${response}=  Get Request  d2d  ${findpage_uri}  headers=${headers}
    ${result} =  To Json  ${response.content}
    Set Suite Variable  ${${label}_title}  ${result["reward_offers"]["products"][${item_id}]["title"]}
    Set Suite Variable  ${${label}_purchaseprice}  ${result["reward_offers"]["products"][${item_id}]["offerActions"][0]["purchasePrice"]["amount"]}
    Set Suite Variable  ${${label}_suggestedprice}  ${result["reward_offers"]["products"][${item_id}]["offerActions"][0]["suggestedPrice"]["amount"]}
    Set Suite Variable  ${${label}_vipprice}  ${result["reward_offers"]["products"][${item_id}]["offerActions"][0]["vipPrice"]["amount"]}
    Set Suite Variable  ${${label}_viptier}  ${result["reward_offers"]["products"][${item_id}]["offerActions"][0]["vipPrice"]["vip"]["tier"]}
    Set Suite Variable  ${${label}_vipname}  ${result["reward_offers"]["products"][${item_id}]["offerActions"][0]["vipPrice"]["vip"]["name"]}
    Set Suite Variable  ${${label}_isOnSale}  ${result["reward_offers"]["products"][${item_id}]["offerActions"][0]["isOnSale"]}
    Set Suite Variable  ${${label}_isPreorderOffer}  ${result["reward_offers"]["products"][${item_id}]["offerActions"][0]["isPreorderOffer"]}
    Set Suite Variable  ${${label}_buyableFromCountry}  ${result["reward_offers"]["products"][${item_id}]["offerActions"][0]["buyableFromCountry"]}
    Set Suite Variable  ${${label}_totalPercentOff}  ${result["reward_offers"]["products"][${item_id}]["offerActions"][0]["totalPercentOff"]}
    Set Suite Variable  ${${label}_publisher}  ${result["reward_offers"]["products"][${item_id}]["publisher"]}
    Set Suite Variable  ${${label}_allow_trade_in}  ${result["reward_offers"]["products"][${item_id}]["allow_trade_in"]}
    Set Suite Variable  ${${label}_drmType}  ${result["reward_offers"]["products"][${item_id}]["drmType"]}


Set Stream detail with User info
    [Arguments]      ${label}      ${item_id}    ${request_uri}    ${headers}
    Create Session  d2d  ${d2d_url}   verify=True
    ${response}=  Get Request  d2d  ${request_uri}  headers=${headers}
    ${result} =  To Json  ${response.content}
    Set Suite Variable  ${${label}_bouns}  ${result["streaming"][${item_id}]["bonus"]}
    Set Suite Variable  ${${label}_expire_period}  ${result["streaming"][${item_id}]["expire_period"]}
    Set Suite Variable  ${${label}_hours}  ${result["streaming"][${item_id}]["time_left"]["hours"]}
    Set Suite Variable  ${${label}_minutes}  ${result["streaming"][${item_id}]["time_left"]["minutes"]}

custom check footer section
    page should contain element  ${about_d2d}
    element should contain  ${about_d2d}  About Direct2Drive
    page should contain element  ${about_us}
    element should contain  ${about_us}  About Us
    page should contain element  ${support}
    element should contain  ${support}  Support
    page should contain element  ${sitemap}
    element should contain  ${sitemap}  Sitemap
    page should contain element  ${policy}
    element should contain  ${policy}  Privacy Policy
    page should contain element  ${terms}
    element should contain  ${terms}  Terms of Use

check common items
    #need wait more time to chceck
    sleep  6s  wait page loading
    #check d2d direct2drive image
#    Page Should Contain Element    ${d2d_logo_nav_xp}
    Page Should Contain Element    ${d2d_logo_xp}

    #check social tool set
    # page should contain element  ${social_tool_set}
    # page should contain element  ${fb}
    # page should contain element  ${twitter}
    # page should contain element  ${subscribe}
    #check search tool set
    page should contain element  ${search_tool_set}
    page should contain element  ${search_input}
    #check placeholder
    ${placeholder}  Get Element Attribute  ${search_input}  placeholder
    should be equal  ${placeholder}  Search Store
    # element should contain  ${search_input}  Search PC Store
    page should contain element  ${search_btn}
    #check right menu item
    page should contain element  ${menu}
    page should contain element  ${shopping_cart_btn}
    page should contain element  ${login_element}
    element should contain  ${login_element}  Login/Sign Up
    page should contain element  ${support_element}
    element should contain  ${support_element}  Support
    page should contain element  ${corporate}
    element should contain  ${corporate}  Corporate


custom open browser and waiting
    Open browser  ${d2d_url}  ${BROWSER}

#	...  desired_capabilities=browserName:${BROWSER}
	Maximize Browser Window
	# Set Selenium Speed  0.5 seconds
	Set Browser Implicit Wait  10 seconds
	#wait page loading
    # wait until element is not visible  ${spin_animation}

open url with chrome browser and waiting
    [Arguments]  ${url}

    Open browser  ${url}  chrome
	Maximize Browser Window
	# Set Selenium Speed  0.5 seconds
	Set Browser Implicit Wait  10 seconds

Navigation Section Test In Prod env
    #180707, tab content
    #Games, D2D Rewards, On Sale, Trade In, Flashback Zone, Streaming, PlayStation Network
    #tab 0
    page should contain element  ${tab_0}
    element text should be  ${tab_0}  Games
    #tab 1
    page should contain element  ${tab_1}
    element should contain  ${tab_1}  D2D Rewards
    #tab 2
    page should contain element  ${tab_2}
    element should contain  ${tab_2}  D2D Plus
    #tab 3
    page should contain element  ${tab_3}
    element should contain  ${tab_3}  On Sale
    #tab 4
    page should contain element  ${tab_4}
    element should contain  ${tab_4}  Flashback Zone
    #tab 5
    page should contain element  ${tab_5}
    element should contain  ${tab_5}  Streaming
    #tab 6
    page should contain element  ${tab_6}
    element should contain  ${tab_6}  PlayStation
    element should contain  ${tab_6}  Network

Login User on frontend
    [Arguments]  ${email}  ${pwd}

    Click Element  xpath=//ul[@id='navMenu']/li[2]/div/div/a/strong
    Sleep  3s
    Wait Until Element Contains  //form[@id='registerForm']/div[3]/div[2]/div/div/span   Yes! Add me to Direct2Drive's mailling list to get the latest offers and sweet gaming deals!
    Wait Until Element Contains  //a[contains(text(),'Forgot your password?')]    Forgot your password?
    Element Should Contain  xpath=//div[@id='login']/div[2]/form/div/h3    Login
    Input Text  xpath=//input[@id='loginEmail']    ${email}
    Input Text  xpath=//input[@id='loginPassword']    ${pwd}
    Sleep  1s
    Click Element  //*[@id="login"]/div[2]/form[1]//button
    sleep  5s

check browse result products
    [Arguments]  ${game_list_result}

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
        \  run keyword if  ${stauts}==True  verify release date in date format  ${id}  ${rd_date}
#        \  ...  run keyword and ignore error
#        \  ...  Reassemble Release Date String  ${rd_date}
#        \  ...  AND  log  ${custom_date}
#        \  ...  AND  element should contain  xpath=//*[@id="${id}"]/div[6]/strong  ${custom_date}
        \  log  release date [text]
        \  run keyword if  ${stauts}==False  element should contain  xpath=//*[@id="${id}"]/div[6]/strong  ${game_list_result["products"]["items"][${i}]["releaseDate"]["text"]}
        \  log  purchase price
        \  element should contain  xpath=//*[@id="${id}"]/div[7]//table/tbody/tr/td[1]/div[2]/div  Now
        \  element should contain  xpath=//*[@id="${id}"]/div[7]//table/tbody/tr/td[2]/div/div  ${game_list_result["products"]["items"][${i}]["offerActions"][0]["purchasePrice"]["amount"]}

verify release date in date format
    [Arguments]  ${id}  ${date}
    ${year}=  Get Substring  ${date}  0  4
    ${day}=  Get Substring  ${date}  5  7
    ${month}=  Get Substring  ${date}  8  10
    #day/month/year....frontend release date
    ${custom_date}=  Catenate  SEPARATOR=  ${day}  /
    ${custom_date}=  Catenate  SEPARATOR=  ${ret}  ${month}
    ${custom_date}=  Catenate  SEPARATOR=  ${ret}  /
    ${custom_date}=  Catenate  SEPARATOR=  ${ret}  ${year}

    element should contain  xpath=//*[@id="${id}"]/div[6]/strong  ${custom_date}