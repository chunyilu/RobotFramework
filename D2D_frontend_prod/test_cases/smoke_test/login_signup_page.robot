coding: utf-8
*** Settings ***
Library  SeleniumLibrary
Resource  ../../keywords/smoke_test.robot

*** Variable ***
${subscribeDesc}  //form[@id='registerForm']/div[3]/div[2]/div/div/span
${forget_pwd}  //a[contains(text(),'Forgot your password?')]

#error msg
${login_fail_msg}  //*[@id="login"]//ul[@class="login-error"]/li
${password_empty_msg}  //div[@id='login']//label[@for="loginPassword"]
${email_empty_msg}  //div[@id='login']//label[@for="loginEmail"]

${login_btn}  //div[@id="login"]/div[2]/form[1]//button
${signup_btn}  //div[@id="login"]/div[2]/form[2]//button

${signup_username}  //input[@id="signupUserName"]
${signup_email}  //input[@id="signupEmail"]
${signup_pwd}  //input[@id="signupPassword"]
${pwd_rule}  //div[@class="password-rule"]/p
${signup_confirm_pwd}  //input[@id="signupConfirmPassword"]

${iframe}  //div[@id="captcha"]/div/div/iframe
# /html/body/div[2]/div[3]/div[1]/div/div/span/div[1]
${recaptcha_text}  //*[@id="recaptcha-anchor-label"]

*** Test Cases ***
check login page elements
    [Tags]  login  signup

    log to console  open browser
    Open browser  ${d2d_url}  ${browser}
	Maximize Browser Window
	Set Selenium Speed  0.3 seconds
	Set Browser Implicit Wait  5 seconds
    Sleep  3s
    
    Click Element  ${login_signup}
    Sleep  3s
    
    log to console  login    
    element should contain  //div[@class="control-group"]/div[1]/div/button  Link Facebook
    element should contain  //div[@class="control-group"]/div[2]/div/button  Link Google

    element should contain  //div[@id="login"]/div[2]/form[1]//h3  Login
    Element Attribute Value Should Be  ${email_input}  placeholder  Email
    Element Attribute Value Should Be  ${pwd_input}  placeholder  Password
    element should contain  ${login_btn}/strong  Login  
    Wait Until Element Contains  ${forget_pwd}  Forgot your password?
    
    log to console  sign up        
    element should contain  //div[@id="login"]/div[2]/form[2]//h3  Sign Up
    
    Element Attribute Value Should Be  ${signup_username}  placeholder  Username
    Element Attribute Value Should Be  ${signup_email}  placeholder  Email
    Element Attribute Value Should Be  ${signup_pwd}  placeholder  Password
    element should contain  ${pwd_rule}  Must be between 8
    element should contain  ${pwd_rule}  16 characters and have at least 1 number
    Element Attribute Value Should Be  ${signup_confirm_pwd}  placeholder  Confirm Password    
    Wait Until Element Contains  ${subscribeDesc}   Yes! Add me to Direct2Drive's mailling list to get the latest offers and sweet gaming deals!
        
    select frame  ${iframe}
    ${text}  get text  ${recaptcha_text}
    should be equal  ${text}  I'm not a robot
    unselect frame    
        
    element should contain  ${signup_btn}/strong  Sign Up  

    [Teardown]  Close Browser

invalid username
    log to console  not implement yet
