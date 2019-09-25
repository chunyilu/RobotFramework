coding: utf-8
*** Settings ***
Library  SeleniumLibrary
Library  String
Library  OperatingSystem
Library  RequestsLibrary
Library  Collections
Resource  ../../keywords/smoke_test.robot
Variables  ../../variables/d2d_uri.py
Library  ../../libs/atgames.py

*** Variable ***
${shop_cart_url}  https://www.direct2drive.com/#!/cart

${my_shopping_cart_str}  //div[@class="cart-header"]/h3
${cart_icon}  //div[@class="cart-header"]/h3/i

${your_items}  //div[@class="row-fluid item-bar"]/div[1]
${platform}  //div[@class="row-fluid item-bar"]/div[2]
${genre}  //div[@class="row-fluid item-bar"]/div[3]
${DRM}  //div[@class="row-fluid item-bar"]/div[4]
${price}  //div[@class="row-fluid item-bar"]/div[5]

${please_login_element}  //div[@class="item-list"]//div[@ng-show="!gf.account"]/h4

${coupon_code_input}  xpath=//*[@id="appendedInputButton"]
${apply_btn}  //button[@class="btn btn-default-post"]
${godaddy_icon}  xpath=//*[@id="siteseal"]/img
${con_shop_btn}  //button[@class="btn btn-default ng-scope"]
${pro_checkout_btn}  //div[@id="paypal-button"]

${product_url}  https://www.direct2drive.com/#!/download-lego-the-hobbit/5010717
${injustice2_url}  https://www.direct2drive.com/#!/download-injustice-2/5013156
${Atelier_Lulua_url}  https://www.direct2drive.com/#!/download-atelier-lulua-the-scion-of-arland--standard-edition/5014866
${buy_btn}  xpath=//*[@id="nav-main-view-container"]//div[contains(@class, 'pull-right')]//button[contains(@class, 'btn-primary')]
${cart_btn}  xpath=//*[@id="popover-cart"]/button

#item details
${item_img_element}  //*[@id="cart-view-content"]//img[@class="thumbnail-img"]
${item_title_element}  //*[@id="cart-view-content"]/div[3]/div[1]/div[1]/div[2]
${item_platform_element}  //*[@id="cart-view-content"]/div[3]/div[1]/div[1]/div[3]/i
${item_genre1_element}  //*[@id="cart-view-content"]/div[3]/div[1]/div[1]/div[4]/div[1]
${item_genre2_element}  //*[@id="cart-view-content"]/div[3]/div[1]/div[1]/div[4]/div[2]
${item_DRM_element}  //*[@id="cart-view-content"]/div[3]/div[1]/div[1]/div[5]/div/img
${item_price_del_element}  //*[@id="cart-view-content"]/div[3]/div[1]/div[1]/div[6]/del
${item_price_element}  //*[@id="cart-view-content"]/div[3]/div[1]/div[1]/div[6]
${streaming_hours}  //div[@class="malibu-cloud-play ng-scope"]/strong/span

${only_amount_to_top_tier}  //div[@class="vip-upgrade-info ng-scope"]/div/strong/span[1]
${top_tier_save}  //div[@class="vip-upgrade-info ng-scope"]/div/strong/span[2]

${add_to_cart_fail_close_btn}  //div[@id="message" and @class="modal hide fade in"]//button[@class="btn btn-default"]

${gymal_text_ele}  //*[@id="cart-view-content"]/div[4]/div/div[1]/div

*** Test Cases ***
TS check shopping cart page with no items
    [Tags]  noitem

    Open browser  ${shop_cart_url}  ${browser}
	Maximize Browser Window
	Set Browser Implicit Wait  10 seconds
    
    #check top two rows items
    check common items
    
    page should contain element  ${my_shopping_cart_str}
    element should contain  ${my_shopping_cart_str}  My Shopping Cart 
    page should contain element  ${cart_icon}

    log to console  item bar
    page should contain element  ${your_items}
    element should contain  ${your_items}  Your item(s)
    page should contain element  ${platform}
    element should contain  ${platform}  Platform
    page should contain element  ${genre}
    element should contain  ${genre}  Genre
    page should contain element  ${DRM}
    element should contain  ${DRM}  DRM
    page should contain element  ${price}
    element should contain  ${price}  Price ($)

    log to console  please login string
    page should contain element  ${please_login_element}

    log to console  coupon code
    page should contain element  ${coupon_code_input}
    ${coupon_str}=  get element attribute  ${coupon_code_input}  placeholder
    should be equal  ${coupon_str}  Enter Coupon Code.
    page should contain element  ${apply_btn}
    element should contain  ${apply_btn}  Apply
    
    page should contain element  ${godaddy_icon}

    log to console  continue shopping btn
    page should contain element  ${con_shop_btn}
    ${func}=  get element attribute  ${con_shop_btn}  ng-click
    should be equal  ${func}  goIndex();

    #proceed to checkout button
    page should contain element  ${pro_checkout_btn}

    custom check footer section
    
    [TearDown]  close browser  
    
    #TODO check shopping cart page
    #     check icon changed after add new item
TS check shopping cart page with one item
    [Tags]  oneitem

    Open browser  ${Atelier_Lulua_url}  ${browser}
	Maximize Browser Window
	Set Browser Implicit Wait  10 seconds

    #get price from product detail page
    ${element_price}  get text  //div[@btn-class="btn-large"]//table/tbody/tr/td[2]/div/div
    ${product_price_num}  Fetch From Right  ${element_price}  $
    ${product_title}  get text  //div[contains(@class, 'product-title')]/h1

    #click buy button
    click element  ${buy_btn}
    sleep  6s

    #click cart icon to shopping cart page
    click element  ${cart_btn}
    sleep  6s

    ${headers}=  Create Dictionary  Content-Type=application/json;charset=UTF-8  fp=NWI5YWU2YTBjNjc2Yzk4Y2E5YjhkZGVlN2RhNjg2ZTg  Host=www.direct2drive.com

    Create Session  d2d  ${d2d_url}  verify=True
    ${response}=  Post Request  d2d  ${shopping_cart_uri}  data=${shopping_cart_data}  headers=${headers}
    ${result} =  To Json  ${response.content}

    log to console  ${result["cart"]["id"]}
    log to console  ${result["cart"]["cart_details"][0]["id"]}

    element should contain  ${item_title_element}  ${result["cart"]["cart_details"][0]["product"]["title"]}

    ${calculated_hours}  check_streamig_hour  ${result["cart"]["net_price"]}

    Log  streaming section
    ${calculated_hours}  convert to string  ${calculated_hours}
    element should contain  ${streaming_hours}  ${calculated_hours}

    #membership saving
#    element should contain  ${only_amount_to_top_tier}  ${result["cart"]["vip"]["only_amount_to_top_tier"]}
#    element should contain  ${top_tier_save}  ${result["cart"]["vip"]["top_tier_save"]}

    page should contain element  ${godaddy_icon}

    #continue shopping btn
    page should contain element  ${con_shop_btn}
    ${func}=  get element attribute  ${con_shop_btn}  ng-click
    should be equal  ${func}  goIndex();

    #proceed to checkout btn
    page should contain element  ${pro_checkout_btn}

    #skip these since backend engineer remove games you may also like
#    Wait Until Element Is Visible  ${gymal_text_ele}  10s
#    check games you may also like  ${result}

    custom check footer section
    
    [TearDown]  close browser      

TS add product to shopping cart fail
    [Tags]  fail

    Open browser  ${injustice2_url}  ${browser}
	Maximize Browser Window
	Set Browser Implicit Wait  10 seconds

    #get price from product detail page
    ${element_price}  get text  //div[@btn-class="btn-large"]//table/tbody/tr/td[2]/div/div
    ${product_price_num}  Fetch From Right  ${element_price}  $
    ${product_title}  get text  //div[contains(@class, 'product-title')]/h1

    #click buy button
    click element  ${buy_btn}
    sleep  6s

    #click buy button again
    click element  ${buy_btn}

    Wait Until Element Is Visible  xpath=//*[@id="message"]/div[1]/h3  10s

#    element should contain  xpath=//*[@id="message"]/div[1]/h3  Notice
    element should contain  xpath=//*[@id="message"]/div[2]/h5  The product is already in the shopping cart

    #close add to cart fail window
    click element  ${add_to_cart_fail_close_btn}
    sleep  1s

    [TearDown]  close browser


TS check shoppig cart mouse hover behavior
    [Tags]  hover

    Open browser  ${injustice2_url}  ${browser}
	Maximize Browser Window
	Set Browser Implicit Wait  10 seconds

    #click buy button
    click element  ${buy_btn}
    sleep  6s

    #mouse over shopping cart to check detail
    Mouse Over  //*[@id="popover-cart"]/button/i
    sleep  1s

    #check popover
    #img
    page should contain element  //*[@id="popoverCart"]/div[2]/div/div[2]/div[1]/a/img
    element should contain  //div[@id="popover-cart"]/button/span  1
    #title
    element should contain  //*[@id="popoverCart"]/div[2]/div/div[2]/div[2]/a/div[1]  Injustice 2
    #price
    element should contain  //*[@id="popoverCart"]/div[2]/div/div[2]/div[2]/a/div[2]  Price:
    #view cart button
    element should contain  //*[@id="popoverCart"]/div[2]/div/div[4]/a/strong  View Cart ( 1 items)

    [TearDown]  close browser


*** Keywords ***
check games you may also like
    [Arguments]  ${result}

    element should contain  ${gymal_text_ele}  GAMES YOU MAY ALSO LIKE:

    ${len}  get length  ${result["cart"]["recommendation"]}

    : FOR  ${i}  IN RANGE  0  ${len}
    \  ${title}=  get element attribute  //*[@id="cart-view-content"]/div[4]/div/div[1]/div/div/div[${i+1}]/a  title
    \  should be equal  ${title}  ${result["cart"]["recommendation"][${i}]["title"]}
    \  element should contain  //*[@id="cart-view-content"]/div[4]/div/div[1]/div/div/div[${i+1}]/div/span[2]  ${result["cart"]["recommendation"][${i}]["price"]["amount"]}
