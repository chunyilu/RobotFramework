*** Settings ***
Documentation    Suite description
#Library  SeleniumLibrary
Library  AppiumLibrary
Library  RequestsLibrary
Library  String

*** Variable ***
${div_top}  //html/body/d2d-root/mat-sidenav-container/mat-sidenav-content/div/div
${D2D_icon}  ${div_top}/a/img
${side_nav}  //html/body/d2d-root/mat-sidenav-container/mat-sidenav/div/d2d-header/mat-list
${index_page_link}  ${side_nav}/mat-list-item[1]/div/a
${shop_cart_btn}  //d2d-shopping-cart//button
${shopping_cart_h3}  //mat-sidenav-content//d2d-my-shopping-cart//h3
${hamburger_btn}  ${div_top}/button

#search and filter
${search_input}  //d2d-search-box/div/input
${search_icon}  //d2d-search-box/div/div/mat-icon
${search_menu_btn}  //d2d-product-search/mat-sidenav-container/mat-sidenav-content/button
${game_filter_menu}  //d2d-games-menu/div/button/span

#promotion
${promotion_link}  //d2d-home/div/a

#hero rotator
${hero_title}  //d2d-swiper//d2d-product-main/mat-card/mat-card-header/div/mat-card-title
${hero_img}  //d2d-product-main/mat-card/img
${hero_price_now}  //d2d-product-main/mat-card/mat-card-actions/div/d2d-price/div/div[1]/div/div
${hero_price_element}  //d2d-product-main/mat-card/mat-card-actions/div/d2d-price/div/div[2]/div/div
${hero_buy_btn}  //d2d-product-main/mat-card/mat-card-actions/div/d2d-add-shopping-cart/button

${d2d_swiper}  //d2d-home/div/d2d-swiper

${hero_5}  //d2d-swiper/div/div[1]/div[5]/d2d-product-main/mat-card/img
${hero_4}  //d2d-swiper/div/div[1]/div[4]/d2d-product-main/mat-card/img

${swiper_page}  //d2d-home/div/d2d-swiper/div/div[2]

#square banner
${square1}  //d2d-home/div/div[1]/div/a[1]
${square2}  //d2d-home/div/div[1]/div/a[2]

#feature section
${featured_tab}  //d2d-home/div/div[2]/mat-tab-group/mat-tab-header//div[contains(text(),'Featured')]
${feature_r_arrow}  //d2d-swiper/div/mat-icon[contains(text(),'arrow_forward_ios')]
${feature_l_arrow}   //d2d-swiper/div/mat-icon[contains(text(),'arrow_back_ios')]
${new_tab}  //d2d-home/div/div[2]/mat-tab-group/mat-tab-header//div[contains(text(),'New')]

${f_img}  //d2d-product-row/d2d-product-boxart/div/img
${f_text}  //d2d-product-row/d2d-price/div/div[1]/div/div
${f_price}  //d2d-product-row/d2d-price/div/div[2]/div/div
${f_buy_btn}  //d2d-product-row/d2d-add-shopping-cart/button

#filter
${filter_div}  //d2d-product-search/mat-sidenav-container/mat-sidenav-content/div/div/div[1]
${price_filter}  ${filter_div}//span[contains(text(),'All Prices')]
${on_sale_filter}  //*[@id="mat-option-1"]
${release_data_filter}  ${filter_div}//span[contains(text(),'All Release Dates')]
${sort_by_filter}  ${filter_div}//span[contains(text(),'Release Date')]

#footer
${about_us}  //d2d-footer/mat-action-list/a[1]
${support}  //d2d-footer/mat-action-list/a[2]
${sitemap}  //d2d-footer/mat-action-list/a[3]
${privacy_policy}  //d2d-footer/mat-action-list/a[4]
${terms_of_use}  //d2d-footer/mat-action-list/a[5]

*** Test Cases ***
test index page
    [Tags]  index

    Open Application  http://localhost:4723/wd/hub  platformName=Android  platformVersion=7.0  deviceName=HCNPCX0485823BZ  browserName=Chrome  automationName=UiAutomator2
    go to url  https://m.direct2drive.com/#!/pc
    sleep  10s

    log to console  check top div section
    top div section
    sleep  3s

    log to console  check search feature
    ${tmp}  get element attribute  ${search_input}  placeholder
    should be equal as strings  ${tmp}  Search Store

    log to console  check d2d game menu
    click element  ${game_filter_menu}

    check game genre filter options
    sleep  2s

    log to console  click genre all option
    click element  //*[@id="cdk-overlay-0"]/div/div/button[1]
    sleep  2s

    Element Should Be Visible  //d2d-home/div/a

    log to console  check hero rotator
#    Element Should Be Visible  ${hero_title}
    Element Should Be Visible  ${hero_img}
    Element Should Be Visible  ${hero_price_now}
    Element Should Be Visible  ${hero_price_element}
    Element Should Be Visible  ${hero_buy_btn}

    log to console  check square banners
    Element Should Be Visible  ${square1}
    Element Should Be Visible  ${square2}

    log to console  check featured section
    check featured section

    execute script  window.scrollBy(0,700);
    sleep  1s

    ${text}  get text  ${price_filter}
    ${text}  get text  ${release_data_filter}
    ${text}  get text  ${sort_by_filter}

    execute script  window.scrollBy(0,1200);
    sleep  1s

    check browse section

#    check onsale browse section

    check footer section

#test hero rotator
#    [Tags]    hero
#
##    Open Application  http://localhost:4723/wd/hub  platformName=Android  platformVersion=7.0  deviceName=HCNPCX0485823BZ  browserName=Chrome  automationName=UiAutomator2
#    Open Application  http://localhost:4723/wd/hub  platformName=Android  platformVersion=7.0  deviceName=HCNPCX0485823BZ  browserName=Chrome
#    go to url  https://m.direct2drive.com/#!/pc
#    sleep  10s
#
#    Get Element Location  ${d2d_swiper}
#
##    swipe by direction  left
#    Swipe  500  100  100  0  1000
##    log to console  java script
##    execute script    window.scrollBy(100,0);
##    sleep  1s
#
#    scroll  ${hero_5}  ${hero_4}
#

test onsale section
    [Tags]  onsale

    Open Application  http://localhost:4723/wd/hub  platformName=Android  platformVersion=7.0  deviceName=HCNPCX0485823BZ  browserName=Chrome  automationName=UiAutomator2
    go to url  https://m.direct2drive.com/#!/pc
    sleep  10s

    check onsale browse section

*** Keywords ***
check footer section
    element text should be  //d2d-footer/mat-action-list/h3[1]  About Direct2Drive

    element attribute should match  ${about_us}  href  https://m.direct2drive.com/about/us
    element attribute should match  ${support}  href  https://support.direct2drive.com/
    element attribute should match  ${sitemap}  href  https://m.direct2drive.com/sitemap
    element attribute should match  ${privacy_policy}  href  https://m.direct2drive.com/about/privacy-policy
    element attribute should match  ${terms_of_use}  href  https://m.direct2drive.com/about/terms-of-use

check onsale browse section
    Create Session  d2d  https://m.direct2drive.com/  verify=True
    ${response}=  Get Request  d2d  /backend/api/productquery/findpage?pageindex=1&pagesize=5&platform%5B%5D=1100&genre%5B%5D=1&sort.direction=desc&sort.field=releasedate&onsale=true
    ${result} =  To Json  ${response.content}

    execute script  window.scrollBy(0,1400);
    sleep  1s

    click element  ${price_filter}
    sleep  1s

    click element  ${on_sale_filter}
    sleep  10s

    : FOR  ${i}  IN RANGE  1  6
    \  page should contain element  //d2d-product-search/mat-sidenav-container/mat-sidenav-content/div/div/div[2]/div[${i}]//img
    \  ${title_api}  set variable  ${result["products"]["items"][${i}-1]["title"]}
    \  ${title_fr}  get text  //d2d-product-search/mat-sidenav-container/mat-sidenav-content/div/div/div[2]/div[${i}]/d2d-product-column/div/div/h4
    \  should be equal as strings  ${title_api}  ${title_fr}
    \  ${is_sale}  set variable  ${result["products"]["items"][${i}-1]["offerActions"][0]["isOnSale"]}
    \  run keyword if  ${is_sale}==False  check product price  ${i}  ${result}
    \  run keyword if  ${is_sale}==True  check on sale product price  ${i}  ${result}

check browse section
    Create Session  d2d  https://m.direct2drive.com/  verify=True
    ${response}=  Get Request  d2d  /backend/api/productquery/findpage?pageindex=1&pagesize=5&platform%5B%5D=1100&genre%5B%5D=1&sort.direction=desc&sort.field=releasedate
    ${result} =  To Json  ${response.content}

    execute script  window.scrollBy(0,1400);
    sleep  1s

    : FOR  ${i}  IN RANGE  1  6
    \  page should contain element  //d2d-product-search/mat-sidenav-container/mat-sidenav-content/div/div/div[2]/div[${i}]//img
    \  ${title_api}  set variable  ${result["products"]["items"][${i}-1]["title"]}
    \  ${title_fr}  get text  //d2d-product-search/mat-sidenav-container/mat-sidenav-content/div/div/div[2]/div[${i}]/d2d-product-column/div/div/h4
    \  should be equal as strings  ${title_api}  ${title_fr}
    \  ${is_sale}  set variable  ${result["products"]["items"][${i}-1]["offerActions"][0]["isOnSale"]}
    \  run keyword if  ${is_sale}==False  check product price  ${i}  ${result}
    \  run keyword if  ${is_sale}==True  check on sale product price  ${i}  ${result}

check product price
    [Arguments]  ${i}  ${result}
    ${price_api}  set variable  ${result["products"]["items"][${i}-1]["offerActions"][0]["suggestedPrice"]["amount"]}
    ${price_fr}  get text  //d2d-product-search/mat-sidenav-container/mat-sidenav-content/div/div/div[2]/div[${i}]//d2d-price/div/div[2]/div/div
    ${price_fr}  Fetch From Right  ${price_fr}  $
    should be equal as strings  ${price_api}  ${price_fr}

check on sale product price
    [Arguments]  ${i}  ${result}
    ${price_api}  set variable  ${result["products"]["items"][${i}-1]["offerActions"][0]["suggestedPrice"]["amount"]}
    ${price_fr}  get text  //d2d-product-search/mat-sidenav-container/mat-sidenav-content/div/div/div[2]/div[${i}]//d2d-price/div/div[1]/div/div[2]
    ${price_fr}  Fetch From Right  ${price_fr}  $
    should be equal as strings  ${price_api}  ${price_fr}

check featured section
    execute script  window.scrollBy(0,500);
    sleep  1s

    click element  ${new_tab}
    sleep  1s
    click element  ${featured_tab}
    sleep  1s

    : FOR    ${i}    IN RANGE    0    3
    \  click element  ${feature_r_arrow}
    \  sleep  1s

    : FOR    ${i}    IN RANGE    0    3
    \  click element  ${feature_l_arrow}
    \  sleep  1s

    Element Should Be Visible  ${new_tab}
    Element Should Be Visible  ${f_img}
    Get Element Location  ${f_img}
    Element Should Be Visible  ${f_text}
    Get Element Location  ${f_text}
    Element Should Be Visible  ${f_price}
    Get Element Location  ${f_price}
    Element Should Be Visible  ${f_buy_btn}
    Get Element Location  ${f_buy_btn}

check game genre filter options
    ${text}  get text  //*[@id="cdk-overlay-0"]/div/div/button[1]
    should be equal as strings  ${text}  All

    ${text}  get text  //*[@id="cdk-overlay-0"]/div/div/button[2]
    should be equal as strings  ${text}  Action Adventure

    ${text}  get text  //*[@id="cdk-overlay-0"]/div/div/button[3]
    should be equal as strings  ${text}  Arcade/Puzzle

    ${text}  get text  //*[@id="cdk-overlay-0"]/div/div/button[4]
    should be equal as strings  ${text}  Family/Party

    ${text}  get text  //*[@id="cdk-overlay-0"]/div/div/button[5]
    should be equal as strings  ${text}  Fighting

    ${text}  get text  //*[@id="cdk-overlay-0"]/div/div/button[6]
    should be equal as strings  ${text}  Racing

    ${text}  get text  //*[@id="cdk-overlay-0"]/div/div/button[7]
    should be equal as strings  ${text}  RPG

    ${text}  get text  //*[@id="cdk-overlay-0"]/div/div/button[8]
    should be equal as strings  ${text}  Shooter

    ${text}  get text  //*[@id="cdk-overlay-0"]/div/div/button[9]
    should be equal as strings  ${text}  Sports

    ${text}  get text  //*[@id="cdk-overlay-0"]/div/div/button[10]
    should be equal as strings  ${text}  Strategy/Sim

    ${text}  get text  //*[@id="cdk-overlay-0"]/div/div/button[11]
    should be equal as strings  ${text}  Multiplayer

    ${text}  get text  //*[@id="cdk-overlay-0"]/div/div/button[12]
    should be equal as strings  ${text}  Indie

    ${text}  get text  //*[@id="cdk-overlay-0"]/div/div/button[13]
    should be equal as strings  ${text}  Casual

    ${text}  get text  //*[@id="cdk-overlay-0"]/div/div/button[14]
    should be equal as strings  ${text}  Other

top div section
    Get Element Location  ${D2D_icon}
    sleep  3s

    log to console  hamburger button
    click element  ${hamburger_btn}
    sleep  3s
    click element  ${index_page_link}
    sleep  3s

    log to console  shopping cart button
    click element  ${shop_cart_btn}
    sleep  3s
    element should contain text  ${shopping_cart_h3}  My Shopping Cart
    sleep  3s
    click element  ${D2D_icon}
