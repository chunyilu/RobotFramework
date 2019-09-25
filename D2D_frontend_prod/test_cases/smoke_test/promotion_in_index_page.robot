coding: utf-8

*** Settings ***
Library  SeleniumLibrary
Library  String
Library  RequestsLibrary
Variables  ../../variables/smoke_test_prod.py
Variables  ../../variables/login_d2d_user.py
Variables  ../../variables/d2d_uri.py
Resource  ../../keywords/smoke_test.robot
#Resource  ../../keywords/keyword_index_page.robot
Resource  ../../keywords/keyword_product_detail_page.robot

*** Variable ***
${skin}  xpath=//a[@class='skin']
${default_get_promo_api}  /backend/api/merchandising/getpromotion/

*** Test Cases ***
TS check page in skin class
    [Tags]  prod  logout  skin

    log to console  launch browser
    Open browser  ${d2d_url}  ${browser}
	Maximize Browser Window
	Set Browser Implicit Wait  10 seconds

    log to console  check skin exist and check skin element
    #check skin
    ${status}  check skin exist
    run keyword if  ${status}==False  log  no skin element now
    run keyword if  ${status}==True  continue to check skin element

    [TearDown]  close browser

*** Keywords ***
check skin exist
    Create Session  d2d  ${d2d_url}  verify=True
    ${mer_response}=  Get Request  d2d  ${merchandising_uri}
    ${mer_result} =  To Json  ${mer_response.content}

    ${status}  run keyword and return status  log  ${mer_result["groups"][5]["marketingUrl"]}

    [Return]  ${status}

continue to check skin element
    page should contain element  ${skin}
    click element  ${skin}
    sleep  1s
    #check the link is product page or promotion page
    ${ret}  run keyword and return status  page should contain element  ${boxart}
    run keyword if  ${ret}==True  go to check product detail
    run keyword if  ${ret}==False  go to check promotion page

go to check promotion page
    log  "this is a promotion page"

    #get URL and get promotion id to real get promotion api
    ${url} =  Execute Javascript  return window.location.href;
    ${promotion_id}  Fetch From Right  ${url}  /
    ${get_promo_api}=  Catenate  SEPARATOR=  ${default_get_promo_api}  ${promotion_id}

    #send GET request
    Create Session  d2d  ${d2d_url}  verify=True
    ${response}=  Get Request  d2d  ${get_promo_api}
    ${result} =  To Json  ${response.content}

    #get promotion product number
    ${product_num}  get length  ${result["promotion"]["products"]}

    run keyword if  ${product_num}<6  check product elements less than six  ${product_num}  ${result}
    ...  ELSE  check product elements more than five  ${product_num}  ${result}


check product elements less than six
    [Arguments]  ${items}  ${result}

    FOR  ${i}  IN RANGE  0  ${items}
        log  ${result["promotion"]["products"][${i}]["title"]}
        log to console  ${result["promotion"]["products"][${i}]["title"]}
        ${discount}  get text  //div[contains(@class, 'promotion')]/div/div[1]/ul/li[${i+1}]//div[@class="value"]/strong
        ${json_discount}  frontend percent off value  ${result["promotion"]["products"][${i}]["offerActions"][0]["totalPercentOff"]}
        element should contain  //div[contains(@class, 'promotion')]/div/div[1]/ul/li[${i+1}]//div[@class="value"]/strong  ${json_discount}
        ${href}=  get element attribute  //div[contains(@class, 'promotion')]/div/div[1]/ul/li[${i+1}]/div/div[1]/a  href
        ${element_id}  Fetch From Right  ${href}  /
        log  check was text and price
        element should contain  //div[contains(@class, 'promotion')]/div/div[1]/ul/li[${i+1}]//table/tbody/tr/td[1]/div[2]/div[1]  Was
        ${was_price}  set variable  ${result["promotion"]["products"][${i}]["offerActions"][0]["suggestedPrice"]["amount"]}
        element should contain  //div[contains(@class, 'promotion')]/div/div[1]/ul/li[${i+1}]//table/tbody/tr/td[1]/div[2]/div[2]  ${was_price}
        log  check now text and price
        element should contain  //div[contains(@class, 'promotion')]/div/div[1]/ul/li[${i+1}]//table/tbody/tr/td[2]/div/div[1]  Now
        ${now_price}  set variable  ${result["promotion"]["products"][${i}]["offerActions"][0]["purchasePrice"]["amount"]}
        element should contain  //div[contains(@class, 'promotion')]/div/div[1]/ul/li[${i+1}]//table/tbody/tr/td[2]/div/div[2]  ${now_price}
    END

check product elements more than five
    [Arguments]  ${product_num}  ${result}

    #get quotient
    ${num}  Evaluate  ${product_num}/6
    ${num}  convert to integer  ${num}

    #check elements text in frontend
    : FOR    ${i}    IN RANGE    1    ${num}+1
    \  check products in a row  6  ${i}  ${result}

    #get remainder
    ${remainder}  Evaluate  ${product_num}%6

    #check elements text in frontend
    check product elements less than six  ${remainder}  ${result}

go to check product detail
    log  "this is a product page"
    ${url} =  Execute Javascript  return window.location.href;
    ${product_id}  Fetch From Right  ${url}  /
    check product detail  ${product_id}

frontend percent off value
    [Arguments]  ${param}

    ${percent_off}=  get variable value  ${param}
    ${percent_off}  Convert To Number  ${percent_off}  0
    ${percent_off}  Convert To String  ${percent_off}
    ${percent_off}  Fetch From Left  ${percent_off}  .

    [Return]  ${percent_off}

#items: how many items in row
#row: row number
#result: JSON data from GET request response
check products in a row
    [Arguments]  ${items}  ${row}  ${result}

    FOR  ${i}  IN RANGE  0  ${items}
        ${index}  Evaluate  (${row}-1)*6+${i}
        ${index}  convert to integer  ${index}
        log  ${result["promotion"]["products"][${index}]["title"]}
        log to console  ${result["promotion"]["products"][${index}]["title"]}
        ${discount}  get text  //div[contains(@class, 'promotion')]/div/div[${row}]/ul/li[${i+1}]//div[@class="value"]/strong
        ${json_discount}  frontend percent off value  ${result["promotion"]["products"][${index}]["offerActions"][0]["totalPercentOff"]}
        element should contain  //div[contains(@class, 'promotion')]/div/div[${row}]/ul/li[${i+1}]//div[@class="value"]/strong  ${json_discount}
        ${href}=  get element attribute  //div[contains(@class, 'promotion')]/div/div[${row}]/ul/li[${i+1}]/div/div[1]/a  href
        ${element_id}  Fetch From Right  ${href}  /
        log  check was text and price
        element should contain  //div[contains(@class, 'promotion')]/div/div[${row}]/ul/li[${i+1}]//table/tbody/tr/td[1]/div[2]/div[1]  Was
        ${was_price}  set variable  ${result["promotion"]["products"][${index}]["offerActions"][0]["suggestedPrice"]["amount"]}
        element should contain  //div[contains(@class, 'promotion')]/div/div[${row}]/ul/li[${i+1}]//table/tbody/tr/td[1]/div[2]/div[2]  ${was_price}
        log  check now text and price
        element should contain  //div[contains(@class, 'promotion')]/div/div[${row}]/ul/li[${i+1}]//table/tbody/tr/td[2]/div/div[1]  Now
        ${now_price}  set variable  ${result["promotion"]["products"][${index}]["offerActions"][0]["purchasePrice"]["amount"]}
        element should contain  //div[contains(@class, 'promotion')]/div/div[${row}]/ul/li[${i+1}]//table/tbody/tr/td[2]/div/div[2]  ${now_price}
    END