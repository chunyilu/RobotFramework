*** Settings ***
Documentation    Suite description

*** Variable ***
${login_signup}  //html/body/d2d-root/mat-sidenav-container/mat-sidenav/div/d2d-header/mat-list/mat-list-item[4]/div/d2d-login-sign-up/button/span
${login}  //html/body/div[3]/div[2]/div/mat-dialog-container/d2d-login-sign-up-dialog/div/mat-tab-group/mat-tab-header/div[2]/div/div/div[1]
${signup}  //html/body/div[3]/div[2]/div/mat-dialog-container/d2d-login-sign-up-dialog/div/mat-tab-group/mat-tab-header/div[2]/div/div/div[2]/div

*** Test Cases ***
test appium login signup
    [Tags]    zenpad    signup

    log to console  not ready

#    click element  ${login_signup}
#    sleep  3s
#
#    element should contain text  ${login}  Login
#    click element  ${login}
#    sleep  3s
#
#    click element  ${signup}
#    sleep  3s

