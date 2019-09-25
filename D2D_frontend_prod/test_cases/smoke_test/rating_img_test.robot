coding: utf-8
*** Settings ***
Library  SeleniumLibrary
Library  SikuliLibrary  mode=NEW
Suite Setup  Start Sikuli Process
Suite Teardown  Stop Remote Server
Test Teardown  Close All Browsers
Resource  ../../keywords/keyword_index_page.robot
Variables  ../../variables/smoke_test_prod.py

*** Variable ***
# ${IMAGE_DIR}  ${EXECDIR}\\..\\..\\images
${IMAGE_DIR}  ${CURDIR}\\img

*** Test Cases ***
TS check rating img in product detail page
    log to console  not ready
#    Add Image Path    ${IMAGE_DIR}
#
#    log to console  open browser
#    Open browser  ${d2d_url}  ${browser}
#    Maximize Browser Window
#	Set Browser Implicit Wait  10 seconds
#	sleep  6s
#
#    #group 0 -> hero rotator
#    : FOR    ${i}    IN RANGE    0    5
#    \  Click Element  //ul[@class='carousel-thumbnails inline']/li/a[${i+1}]/div/img
#    \  Sleep  1s
#    \  Click Element  //*[@id="hero"]/div/div[${i+1}]/div/a/img
#    \  sleep  3s
#    \  Wait Until Screen Contain  esrb-m.png  3
    
#TS sikuli
#    [Tags]  sik
#
#    log to console  sikuli test
#    Add Image Path    ${IMAGE_DIR}
#    SikuliLibrary.click  Chrome.PNG  0  0