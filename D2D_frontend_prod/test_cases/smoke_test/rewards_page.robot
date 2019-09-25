coding: utf-8

*** Variable ***
${email}  enter_your_email
${pwd}  enter_your_password

*** Settings ***
Library  SeleniumLibrary
Library  String
Library  OperatingSystem
Library  RequestsLibrary
Library  Collections
Variables  ../../variables/d2d_uri.py
Variables  ../../variables/login_d2d_user.py
Resource  ../../keywords/smoke_test.robot
Resource  ../../keywords/keyword_rewards_page.robot

*** Test Cases ***
TS check reward page
    [Tags]  reward  prod

    Open browser  ${reward_page_url}  ${browser}
	Maximize Browser Window
	Set Browser Implicit Wait  10 seconds

    #check top three rows items
    check common items

    #check dwd rewards img
    page should contain element  ${d2d_rewards_img}
    #check rewards intro
    d2d check rewards intro
    #check tier bar
    d2d check tier bar
    #check member tier table
    d2d check member tier table

    custom check footer section

    [TearDown]  close browser

TS check reward page after login
    [Tags]  login

    log to console  launch firefox
    Open browser  ${reward_page_url}  ${browser}
	Maximize Browser Window
	Set Browser Implicit Wait  10 seconds

    log to console  login
	Login User on frontend  ${email}  ${pwd}

    check current membership and amount  ${email}  ${pwd}

    [TearDown]  close browser






