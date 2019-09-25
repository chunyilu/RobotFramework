coding: utf-8
*** Settings ***
Library  SeleniumLibrary
Resource  ../../keywords/smoke_test.robot

*** Variable ***
${invalid_email}  enter_your_invalid_email
${invalid_pwd}  enter_your_invalid_password
${email}  enter_your_email
${pwd}  enter_your_password
${subscribeDesc}  //form[@id='registerForm']/div[3]/div[2]/div/div/span
${forget_pwd}  //a[contains(text(),'Forgot your password?')]

#error msg
${login_fail_msg}  //*[@id="login"]//ul[@class="login-error"]/li
${password_empty_msg}  //div[@id='login']//label[@for="loginPassword"]
${email_empty_msg}  //div[@id='login']//label[@for="loginEmail"]

*** Test Cases ***
Invalid Email
    [Tags]  ngmail

    Open browser  ${d2d_url}  ${browser}
	Maximize Browser Window
	Set Selenium Speed  0.3 seconds
	Set Browser Implicit Wait  5 seconds
    Sleep  3s
    Click Element  ${login_signup}
    Sleep  3s
    Wait Until Element Contains  ${subscribeDesc}   Yes! Add me to Direct2Drive's mailling list to get the latest offers and sweet gaming deals!
    Wait Until Element Contains  ${forget_pwd}    Forgot your password?
    Input Text  ${email_input}    ${invalid_email}
    Input Text  ${pwd_input}    ${pwd}
    Click Element  ${login_btn}
    sleep  3s
    element should contain  ${login_fail_msg}  (Login failed. Please try again.)

    [Teardown]  Close Browser

Invalid Password
    [Tags]  ngpwd

    Open browser  ${d2d_url}  ${browser}
	Maximize Browser Window
	Set Selenium Speed  0.3 seconds
	Set Browser Implicit Wait  5 seconds
    Sleep  3s
    Click Element  ${login_signup}
    Sleep  3s
    Wait Until Element Contains  ${subscribeDesc}   Yes! Add me to Direct2Drive's mailling list to get the latest offers and sweet gaming deals!
    Wait Until Element Contains  ${forget_pwd}    Forgot your password?
    Input Text  ${email_input}    ${email}
    Input Text  ${pwd_input}    ${invalid_pwd}
    Click Element  ${login_btn}
    sleep  3s
    element should contain  ${login_fail_msg}  (Login failed. Please try again.)

    [Teardown]  Close Browser

Invalid password and email
    [Tags]  ng

    Open browser  ${d2d_url}  ${browser}
	Maximize Browser Window
	Set Selenium Speed  0.3 seconds
	Set Browser Implicit Wait  5 seconds
    Sleep  3s
    Click Element  ${login_signup}
    Sleep  3s
    Wait Until Element Contains  ${subscribeDesc}   Yes! Add me to Direct2Drive's mailling list to get the latest offers and sweet gaming deals!
    Wait Until Element Contains  ${forget_pwd}    Forgot your password?
    Input Text  ${email_input}    ${invalid_email}
    Input Text  ${pwd_input}    ${invalid_pwd}
    Click Element  ${login_btn}
    sleep  3s
    element should contain  ${login_fail_msg}  (Login failed. Please try again.)

    [Teardown]  Close Browser

Empty password
    [Tags]  emptypwd

    Open browser  ${d2d_url}  ${browser}
	Maximize Browser Window
	Set Selenium Speed  0.3 seconds
	Set Browser Implicit Wait  5 seconds
    Sleep  3s

    #click login/sing up button
    Click Element  ${login_signup}
    Sleep  3s

    #check login window
    Wait Until Element Contains  ${subscribeDesc}   Yes! Add me to Direct2Drive's mailling list to get the latest offers and sweet gaming deals!
    Wait Until Element Contains  ${forget_pwd}    Forgot your password?

    #only input email
    Input Text  ${email_input}    ${email}
    Click Element  ${login_btn}
    sleep  3s

    element should contain  ${password_empty_msg}  This field is required.

    [Teardown]  Close Browser

Empty email
    [Tags]  emptymail

    Open browser  ${d2d_url}  ${browser}
	Maximize Browser Window
	Set Selenium Speed  0.3 seconds
	Set Browser Implicit Wait  5 seconds
    Sleep  3s
    Click Element  ${login_signup}
    Sleep  3s
    Wait Until Element Contains  ${subscribeDesc}   Yes! Add me to Direct2Drive's mailling list to get the latest offers and sweet gaming deals!
    Wait Until Element Contains  ${forget_pwd}    Forgot your password?
    Input Text  ${pwd_input}    ${pwd}
    Click Element  ${login_btn}
    sleep  3s
    element should contain  ${email_empty_msg}  This field is required.

    [Teardown]  Close Browser

Empty email and password
    [Tags]  emptymailpwd

    Open browser  ${d2d_url}  ${browser}
	Maximize Browser Window
	Set Selenium Speed  0.3 seconds
	Set Browser Implicit Wait  5 seconds
    Sleep  3s
    Click Element  ${login_signup}
    Sleep  3s
    Wait Until Element Contains  ${subscribeDesc}   Yes! Add me to Direct2Drive's mailling list to get the latest offers and sweet gaming deals!
    Wait Until Element Contains  ${forget_pwd}    Forgot your password?

    Click Element  ${login_btn}
    sleep  3s
    element should contain  ${password_empty_msg}  This field is required.
    element should contain  ${email_empty_msg}  This field is required.

    [Teardown]  Close Browser