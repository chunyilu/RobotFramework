coding: utf-8
*** Settings ***
Library  SeleniumLibrary
Resource  ../../keywords/smoke_test.robot

*** Variable ***
${email}  enter_your_email
${pwd}  enter_your_password
${free_hours}  4
${my_shopping_cart_h3}  //div[@class="cart-header"]/h3
${cart_icon}  //div[@class="cart-header"]/h3/i
${checkout_btn}  //div[@id="paypal-button"]

*** Test Cases ***
Check PayPal UI
    [Tags]  paypal
    
    log to console  open browser
    Open browser  ${d2d_url}  ${browser}
	Maximize Browser Window
	Set Browser Implicit Wait  5 seconds
    Sleep  3s
    
    log to console  put the product to shopping cart
    click button  //div[@class="row-fluid browse-results"]/div[1]//button

    log to console  check shopping cart elements
    Go To  https://www.direct2drive.com/#!/cart
    sleep  3s
    element should contain  ${my_shopping_cart_h3}  My Shopping Cart 
    page should contain element  ${cart_icon}

    log to console  click checkout button
    click element  ${checkout_btn} 
    Sleep  6s
    
    log to console  enter login credential
    Input Text  ${email_input}  ${email}
    Input Text  ${pwd_input}  ${pwd}
    Click Element  ${login_btn}
    sleep  3s
    
    log to console  click checkout button
    click element  ${checkout_btn} 
    Sleep  6s

    #switch to paypal window
    Select Window  NEW

    #check paypal checkout page type
    ${status1}  run keyword and return status  page should contain element  //*[@id="paypalLogo"]
    ${status2}  run keyword and return status  page should contain element  //html/body/div[1]/section[1]/div/div/header/p
    Run Keyword If  ${status1} or ${status2}  success message
    ...  ELSE  fail message

    [TearDown]  close browser  

*** Keywords ***
success message
    log to console  PayPal checkout page show up

fail message
    log to console  PayPal checkout page NOT show up
