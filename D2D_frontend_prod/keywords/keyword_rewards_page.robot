*** Settings ***
Documentation    Suite description

*** Variable ***
${d2d_rewards_img}  //*[@id="nav-main-view-container"]//header[@class="rewards-head ng-scope"]/img

#what is d2d rewards
${widr_string}  //*[@id="nav-main-view-container"]//div[@class="rewards-title ng-scope"]/h2
${widr_description}  //*[@id="nav-main-view-container"]//div[@class="rewards-intro"]//div[@class="text-intro"]/p
${FAQ_link}  //*[@id="nav-main-view-container"]//div[@class="rewards-intro"]//div[@class="text-intro"]/p/a[1]
${terms_link}  //*[@id="nav-main-view-container"]//div[@class="rewards-intro"]//div[@class="text-intro"]/p/a[2]

${shopping_cart_img}  //div[@class="rewards-intro"]//section[@class="right-section"]/ul/li[1]/img
${shopping_cart_description}  //*[@id="nav-main-view-container"]//div[@class="rewards-intro"]//section[@class="right-section"]/ul/li[1]/p

${vip_img}  //div[@class="rewards-intro"]//section[@class="right-section"]/ul/li[2]/img
${vip_description}  //*[@id="nav-main-view-container"]//div[@class="rewards-intro"]//section[@class="right-section"]/ul/li[2]/p

#member tier
${liyaocanattsyed_string}  //div[@class="member-tier ng-scope"]/section/span
${d2d_member_img}  //div[@class="member-tier ng-scope"]/section/img[4]

${user_panel_ele}  //*[@id="navMenu"]/li[2]/div/div/a/strong
${Logout_ele}  //*[@id="navMenu"]/li[2]/div/div/ul/li[2]/a

${vip_tier_ele}  xpath=//section[@class="tier-bar"]//span[@ng-if="current_vip_tier"]
${amout_to_next_tier_ele}  //div[@class="member-tier ng-scope"]//span[@class="level-info font-italic ng-binding ng-scope"]

${tmp}  0

*** Keywords ***
check current membership and amount
    [Arguments]    ${email}    ${pwd}

    log  post request login and get token
    ${login_user_data}=   Create Dictionary   email=${email}  password=${pwd}
#    ${login_headers_tmp}=  Create Dictionary  Content-Type=application/x-www-form-urlencoded  devise=D2D Desktop  fp=MjY5NzE5NjkxMg==  remote-ip=3.255.255.255
    ${login_headers_tmp}=  Create Dictionary  Content-Type=application/x-www-form-urlencoded; charset=UTF-8  fp=OTgxMzk0ODQ5  remote-ip=3.255.255.255


    Create Session  d2d  ${d2d_url}  verify=True
    ${response}=  Post Request  d2d  ${login_uri}   data=${login_user_data}  headers=${login_headers_tmp}
    ${result} =  To Json  ${response.content}
    ${vip_tier}  Set Variable  ${result["account"]["vip_tier"]}
    ${purchase_amount}  Set Variable  ${result["account"]["purchase_amount"]}

    #check current vip tier
    run keyword if  ${vip_tier}==1  element should contain  ${vip_tier_ele}  CURRENT MEMBERSHIP TIER: D2D MEMBER
    ...  ELSE IF  ${vip_tier}==2  element should contain  ${vip_tier_ele}  CURRENT MEMBERSHIP TIER: BRONZE MEMBER
    ...  ELSE IF  ${vip_tier}==3  element should contain  ${vip_tier_ele}  CURRENT MEMBERSHIP TIER: SILVER MEMBER
    ...  ELSE IF  ${vip_tier}==4  element should contain  ${vip_tier_ele}  CURRENT MEMBERSHIP TIER: GOLD MEMBER
    ...  ELSE IF  ${vip_tier}==5  element should contain  ${vip_tier_ele}  CURRENT MEMBERSHIP TIER: PLATINUM MEMBER

    #check amount to next tier
    run keyword if  ${purchase_amount}<9.99  check amout to next tier ele keyword  9.99  ${purchase_amount}
    ...  ELSE IF  ${purchase_amount}>=9.99 and ${purchase_amount}<19.99  check amout to next tier ele keyword  19.99  ${purchase_amount}
    ...  ELSE IF  ${purchase_amount}>=19.99 and ${purchase_amount}<29.99  check amout to next tier ele keyword  29.99  ${purchase_amount}
    ...  ELSE IF  ${purchase_amount}>=29.99 and ${purchase_amount}<59.99  check amout to next tier ele keyword  59.99  ${purchase_amount}
    ...  ELSE IF  ${purchase_amount}>=59.99  page should not contain  ${amout_to_next_tier_ele}

check amout to next tier ele keyword
    [Arguments]  ${next_tier_price}  ${purchase_amount}

    ${tmp}  Evaluate  ${next_tier_price} - ${purchase_amount}
    ${pa_str}  convert to string  ${tmp}
    element should contain  ${amout_to_next_tier_ele}  ${pa_str}

#check new reward offers
#    Create Session  d2d  https://d2d-qa-f2.direct2drive.com  verify=True
#    ${response}=  Get Request  d2d  ${new_reward_offers_uri}
#    ${result} =  To Json  ${response.content}
#
#    : for    ${i}    IN RANGE    0    5
#        \    log  check game title
#        \    ${game_title}=  get element attribute  xpath=//*[@id="d2d-main-view-wrapper"]/div/div[6]/div/div[${i+1}]/div/div[1]/a/img  title
#        \    Set Suite Variable  ${reward_game_title}  ${result["reward_offers"]["products"][${i}]["title"]}
#        \    should be equal  ${game_title}  ${reward_game_title}
#        \    log  check isOnSale boolean value to check was price
#        \    set suite variable  ${s_price}  ${result["reward_offers"]["products"][${i}]["offerActions"][0]["suggestedPrice"]["amount"]}
#        \    set suite variable  ${ios_boolean}  ${result["reward_offers"]["products"][${i}]["offerActions"][0]["isOnSale"]}
#        \    Run Keyword If  ${ios_boolean}==True  element should contain  //div[@class="carousel-inner"]/div[${i+1}]//div[@style="font-size:24px; margin-top:5px; line-height:41px; color:white"]  ${s_price}
#        \    log  check totalPercentOff value to different value layout
#        \    set suite variable  ${pp_amount}  ${result["reward_offers"]["products"][${i}]["offerActions"][0]["purchasePrice"]["amount"]}
#        \    set suite variable  ${tpo}  ${result["reward_offers"]["products"][${i}]["offerActions"][0]["totalPercentOff"]}
#        \    log  get whole number from totalPercentOff
#        \    ${tpo_whole_num}  Fetch From Left  ${tpo}  .
#        \    Run Keyword If  ${tpo}==0  element should contain  xpath=//*[@id="d2d-main-view-wrapper"]/div/div[6]/div/div[${i+1}]/div/div[2]/div/div/div[1]/div/table/tbody/tr/td[2]/div/div  ${pp_amount}
#        \    Run Keyword If  ${tpo}!=0
#        \    ...  run keywords
#        \    ...  element should contain  xpath=//*[@id="d2d-main-view-wrapper"]/div/div[6]/div/div[${i+1}]/div/div[2]/div/div/div[1]/div/table/tbody/tr/td[2]/div/div[2]  ${pp_amount}
#        \    ...  AND  element should contain  //div[@class="carousel-inner"]/div[${i+1}]//div[@ng-show="product.hasDiscount"]/div/strong  ${tpo_whole_num}


d2d check rewards intro
    page should contain element  ${widr_string}
    element should contain  ${widr_string}  WHAT IS D2D REWARDS?
    page should contain element  ${widr_description}
    element should contain  ${widr_description}  membership program designed to give PC gamers the opportunity to earn big discounts on the games they love. The concept is simple: the more you spend on Direct2Drive
    element should contain  ${widr_description}  no cost to sign up so log into your account today and see how big your discounts are. For more information, please visit our
    page should contain element  ${FAQ_link}
    page should contain element  ${terms_link}
    page should contain element  ${shopping_cart_img}
    page should contain element  ${shopping_cart_description}
    page should contain element  ${vip_img}
    page should contain element  ${vip_description}

d2d check tier bar
    page should contain element  ${liyaocanattsyed_string}
    element should contain  ${liyaocanattsyed_string}  LOG INTO YOUR ACCOUNT OR CREATE A NEW ACCOUNT TODAY TO SEE YOUR ELIGIBLE DISCOUNT!
    page should contain element  ${d2d_member_img}

d2d check member tier table
    Table Cell Should Contain  xpath=//div[@class="member-tier-table ng-scope"]/table  2  1  Membership
    : for    ${i}    IN RANGE    2    7
      \    page should contain element  xpath=//div[@class="member-tier-table ng-scope"]/table/thead/tr/th[${i}]/img

    Table Cell Should Contain  xpath=//div[@class="member-tier-table ng-scope"]/table  3  1  Game Purchases
    Table Cell Should Contain  xpath=//div[@class="member-tier-table ng-scope"]/table  3  2  <$9.99
    Table Cell Should Contain  xpath=//div[@class="member-tier-table ng-scope"]/table  3  3  $9.99
    Table Cell Should Contain  xpath=//div[@class="member-tier-table ng-scope"]/table  3  4  $19.99
    Table Cell Should Contain  xpath=//div[@class="member-tier-table ng-scope"]/table  3  5  $29.99
    Table Cell Should Contain  xpath=//div[@class="member-tier-table ng-scope"]/table  3  6  $59.99

    Table Cell Should Contain  xpath=//div[@class="member-tier-table ng-scope"]/table  4  1  Most Titles
    Table Cell Should Contain  xpath=//div[@class="member-tier-table ng-scope"]/table  4  2  5%
    Table Cell Should Contain  xpath=//div[@class="member-tier-table ng-scope"]/table  4  3  8%
    Table Cell Should Contain  xpath=//div[@class="member-tier-table ng-scope"]/table  4  4  12%
    Table Cell Should Contain  xpath=//div[@class="member-tier-table ng-scope"]/table  4  5  15%
    Table Cell Should Contain  xpath=//div[@class="member-tier-table ng-scope"]/table  4  6  20%

    Table Cell Should Contain  xpath=//div[@class="member-tier-table ng-scope"]/table  5  1  All Others
    Table Cell Should Contain  xpath=//div[@class="member-tier-table ng-scope"]/table  5  2  2%
    Table Cell Should Contain  xpath=//div[@class="member-tier-table ng-scope"]/table  5  3  4%
    Table Cell Should Contain  xpath=//div[@class="member-tier-table ng-scope"]/table  5  4  6%
    Table Cell Should Contain  xpath=//div[@class="member-tier-table ng-scope"]/table  5  5  8%
    Table Cell Should Contain  xpath=//div[@class="member-tier-table ng-scope"]/table  5  6  10%