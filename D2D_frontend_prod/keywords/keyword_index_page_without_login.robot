coding: utf-8

*** Settings ***
Library  SeleniumLibrary
Documentation    Suite description
Variables  ../variables/d2d_uri.py

*** Variable ***
#feature section top
${featured_tab}      //div[contains(@class, "featured-module")]/div/ul/li[1]/a
${popular_tab}       //div[contains(@class, "featured-module")]/div/ul/li[2]/a
${new_tab}           //div[contains(@class, "featured-module")]/div/ul/li[3]/a
${on_sale_tab}       //div[contains(@class, "featured-module")]/div/ul/li[4]/a
${pre_purchase_tab}  //div[contains(@class, "featured-module")]/div/ul/li[5]/a
${under_10_tab}      //div[contains(@class, "featured-module")]/div/ul/li[6]/a
${under_30_tab}      //div[contains(@class, "featured-module")]/div/ul/li[7]/a

*** Keywords ***
convert percent off
    [Arguments]  ${arg}
    
    ${temp}  Convert To Number  ${arg}  0
    ${temp}  Convert To String  ${temp}
    ${ret}  Fetch From Left  ${temp}  .
    
    [Return]  ${ret}

check on sale hero rotator product
    [Arguments]  ${i}  ${s_price}  ${p_price}  ${vip_price_str}

    log  check was price/suggested price
    Element Should Contain  //div[@class='carousel-inner']/div[${i+1}]//table/tbody/tr/td[1]/div[2]/div[1]  ${s_price}
    log  check now price/purchased price
    Element Should Contain  //div[@class='carousel-inner']/div[${i+1}]//table/tbody/tr/td[1]/div[2]/div[2]  ${p_price}
    log  check vip price
    Element Should Contain  //div[@class='carousel-inner']/div[${i+1}]//div[contains(@class, 'vip_color')]  ${vip_price_str}

check hero rotator product
    [Arguments]  ${i}  ${vip_price_str}

    log  check vip price
    Element Should Contain  //div[@class='carousel-inner']/div[${i+1}]//div[contains(@class, 'vip_color')]  ${vip_price_str}

check feature section buttom section without login
    Create Session  d2d  ${d2d_url}  verify=True
    ${mer_response}=  Get Request  d2d  ${merchandising_uri}
    ${mer_result} =  To Json  ${mer_response.content}

    log  check fixed title
    ${headline}=  get variable value  ${mer_result["groups"][2]["headline"]}
    page should contain element  ${feature_product_headline}
    ${headline}  convert to string  ${headline}
    element should contain  ${feature_product_headline}  ${headline}

    FOR    ${i}    IN RANGE    0    5
        log  check id
        ${json_id}=  get variable value  ${mer_result["groups"][2]["items"][${i}]["product"]["productVariantId"]}
        ${json_id_str}=  Convert To String  ${json_id}
        ${href}=  get element attribute  xpath=//*[@id="featured-fix"]/div[1]/div/div[${i+1}]/div/div[1]/a  href
        ${element_id}  Fetch From Right  ${href}  /
        should be equal  ${json_id_str}  ${element_id}
        ${now_amount}=  get variable value  ${mer_result["products"]["${json_id}"]["offerActions"][0]["purchasePrice"]["amount"]}
        ${was_amount}=  get variable value  ${mer_result["products"]["${json_id}"]["offerActions"][0]["suggestedPrice"]["amount"]}
        ${isonsale}=  get variable value  ${mer_result["products"]["${json_id}"]["offerActions"][0]["isOnSale"]}
        Run Keyword If  ${isOnSale}==True  check buttom section products without login  ${i}  ${was_amount}  ${now_amount}
        Run Keyword If  ${isOnSale}==False  check onsale buttom section products without login  ${i}  ${now_amount}
    END

check buttom section products without login
    [Arguments]  ${i}  ${was_amount}  ${now_amount}

    element should contain  xpath=//*[@id="featured-fix"]/div[1]/div[1]/child::div[${i+1}]//table/tbody/tr/td[1]/div[2]/div[2]  ${was_amount}
    element should contain  xpath=//*[@id="featured-fix"]/div[1]/div[1]/child::div[${i+1}]//table/tbody/tr/td[2]/div/div[2]  ${now_amount}

check onsale buttom section products without login
    [Arguments]  ${i}  ${now_amount}

    element should contain  xpath=//*[@id="featured-fix"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[1]/div[2]/div  Now
    Log  now price
    element should contain  xpath=//*[@id="featured-fix"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[2]/div/div  ${now_amount}
    Log  buy button
    element should contain  xpath=//*[@id="featured-fix"]/div[1]/div/child::div[${i+1}]//button[contains(@class, 'btn-primary')]  Buy Now

Scroll Page To Location
    [Arguments]    ${x_location}    ${y_location}
    Execute JavaScript    window.scrollTo(${x_location},${y_location})

Check Hero Rotator Info without login
    Create Session  d2d  ${d2d_url}  verify=True
    ${mer_response}=  Get Request  d2d  ${merchandising_uri}
    ${mer_result} =  To Json  ${mer_response.content}

    #group 0 -> hero rotator
    FOR    ${i}    IN RANGE    0    5
        ${pvid}=  set variable  ${mer_result["groups"][0]["items"][${i}]["product"]["productVariantId"]}
        ${pvid_str}  convert to string  ${pvid}
        log  get title
        ${title}=  set variable  ${mer_result["products"]["${pvid_str}"]["title"]}
        log  get isOnSale/purchasePrice
        ${isOnSale}=  set variable  ${mer_result["products"]["${pvid_str}"]["offerActions"][0]["isOnSale"]}
        ${p_price}=  set variable  ${mer_result["products"]["${pvid_str}"]["offerActions"][0]["purchasePrice"]["amount"]}
        ${p_price}  convert to string  ${p_price}
        ${s_price}=  set variable  ${mer_result["products"]["${pvid_str}"]["offerActions"][0]["suggestedPrice"]["amount"]}
        ${s_price}  convert to string  ${s_price}
        Click Element  //ul[@class='carousel-thumbnails inline']/li/a[${i+1}]/div/img
        Sleep  2s
        Run Keyword If  ${isOnSale}==True  check on sale hero product without login  ${i}  ${title}  ${s_price}  ${p_price}
        Run Keyword If  ${isOnSale}==False  check hero product without login  ${i}  ${title}  ${p_price}
    END

check on sale hero product without login
    [Arguments]  ${i}  ${title}  ${s_price}  ${p_price}

    Element Should Contain  //div[@class="carousel-inner"]/div[${i+1}]//div[contains(@class, 'product-title')]  ${title}
    log  check was price/suggested price
    Element Should Contain  //div[@class="carousel-inner"]/div[${i+1}]//table/tbody/tr/td[1]/div[2]/div[2]  ${s_price}
    log  check now price/purchased price
    Element Should Contain  //div[@class="carousel-inner"]/div[${i+1}]//table/tbody/tr/td[2]/div/div[2]  ${p_price}

check hero product without login
    [Arguments]  ${i}  ${title}  ${p_price}

    Element Should Contain  //div[@class="carousel-inner"]/div[${i+1}]//div[contains(@class, 'product-title')]  ${title}
    Element Should Contain  //div[@class="carousel-inner"]/div[${i+1}]//table/tbody/tr/td[2]/div/div  ${p_price}

check square banner
    [Arguments]    ${login_or_not}

    Create Session  d2d  ${d2d_url}  verify=True
    ${mer_response}=  Get Request  d2d  ${merchandising_uri}
    ${mer_result} =  To Json  ${mer_response.content}

    ${len}  get length  ${mer_result["groups"][4]["items"]}    

    : FOR    ${i}    IN RANGE    0    ${len}
    \  run keyword if  ${login_or_not}==True  check square banner vip price  ${i}  ${mer_result}

check square banner vip price
    [Arguments]    ${index}  ${mer_result}

    #group 4 -> square banner
    ${url_id}=  set variable  ${mer_result["groups"][4]["items"][${index}]["square"]["url_or_id"]}
    #status == True, it is just link
    #status == False, it is a product, should check price
    ${status}  Run Keyword And Return Status  Should Start With  ${url_id}  http
    Run Keyword If  ${status}==True  Return From Keyword  ${-1}
    #is_product == False, it is just link
    #is_product == True, it is a product, should check price
    ${is_product}=  set variable if  ${status}==False  True
    ${p_price}=  set variable if  ${is_product}==True  ${mer_result["products"]["${url_id}"]["offerActions"][0]["purchasePrice"]["amount"]}
    ${isOnSale}=  set variable if  ${is_product}==True  ${mer_result["products"]["${url_id}"]["offerActions"][0]["isOnSale"]}
    ${vip_price}=  set variable  ${mer_result["products"]["${url_id}"]["offerActions"][0]["vipPrice"]["amount"]}
    ${vip_price}=  Convert To Number  ${vip_price}  2
    ${vip_price}=  Convert To String  ${vip_price}
    ${square_pos}=  Evaluate  ${index}+1
    Run Keyword If  ${isOnSale}==True
    ...  run keywords
    ...  log to console  is on sale True
    ...  AND  Element Should Contain  //div[@class='promotion ng-scope']//div[${square_pos}][@class='square ng-scope']//div[starts-with(@class, 'vip_color')]  ${vip_price}
    Run Keyword If  ${isOnSale}==False
    ...  run keywords
    ...  log to console  is on sale False
    ...  AND  Element Should Contain  //div[@class='promotion ng-scope']//div[${square_pos}][@class='square ng-scope']//div[@class="ng-binding"]  ${p_price}
    ...  AND  Element Should Contain  //div[@class='promotion ng-scope']//div[${square_pos}][@class='square ng-scope']//div[starts-with(@class, 'vip_color')]  ${vip_price}

#                   year day month
#json date format = 2018-08-10T00:00:00.000Z
Reassemble Release Date String
    [Arguments]    ${date}
    ${year}=  Get Substring  ${date}  0  4
    ${day}=  Get Substring  ${date}  5  7
    ${month}=  Get Substring  ${date}  8  10
    #day/month/year....frontend release date
    ${ret}=  Catenate  SEPARATOR=  ${day}  /
    ${ret}=  Catenate  SEPARATOR=  ${ret}  ${month}
    ${ret}=  Catenate  SEPARATOR=  ${ret}  /
    ${ret}=  Catenate  SEPARATOR=  ${ret}  ${year}
    # [Return]  ${ret}
    Set Suite Variable  ${custom_date}  ${ret}

Check Feature Section Top Row
    element should contain  ${featured_tab}  Featured
    element should contain  ${popular_tab}  Popular
    element should contain  ${new_tab}  New
    element should contain  ${on_sale_tab}  On Sale
    element should contain  ${pre_purchase_tab}  Pre-Purchase
    element should contain  ${under_10_tab}  Under $10
    element should contain  ${under_30_tab}  Under $30

    Create Session  d2d  ${d2d_url}  verify=True
    ${response}=  Get Request  d2d  ${merchandising_uri}
    ${result} =  To Json  ${response.content}

    FOR    ${i}    IN RANGE    0    5
        log  check img element
        page should contain element  xpath=//div[@class="carousel-inner"]/div/div[${i+1}]//div[@class="boxart text-center"]/a/img
        log  check id
        ${json_id}=  get variable value  ${result["groups"][1]["items"][${i}]["product"]["productVariantId"]}
        ${json_id_str}=  Convert To String  ${json_id}
        ${href}=  get element attribute  xpath=//*[@id="featured"]/div[1]/div/div[${i+1}]/div/div[1]/a  href
        ${element_id}  Fetch From Right  ${href}  /
        should be equal  ${json_id_str}  ${element_id}
        log  check preorder or on-sale product
        ${isOnSale}=  get variable value  ${result["products"]["${json_id_str}"]["offerActions"][0]["isOnSale"]}
        ${isPreorderOffer}=  get variable value  ${result["products"]["${json_id_str}"]["offerActions"][0]["isPreorderOffer"]}
        ${percent_off}=  get variable value  ${result["products"]["${json_id_str}"]["offerActions"][0]["totalPercentOff"]}

        Log  scenario1
        Run Keyword If  ${isOnSale}==False and ${isPreorderOffer}==False  check top row feature products  ${i}  ${result}  ${json_id_str}
        Log  scenario2, check on-sale items
        Run Keyword If  ${isOnSale}==True  check onsale top row feature products  ${i}  ${result}  ${percent_off}  ${json_id_str}
        Log  scenario3, check pre-purchase items
        Run Keyword If  ${isPreorderOffer}==True  check preorder top row feature products  ${i}  ${result}  ${json_id_str}
    END

check top row feature products
    [Arguments]  ${i}  ${result}  ${json_id_str}

    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//button[contains(@class, 'btn-primary')]  Buy Now
    log  check now text
    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[1]/div[2]/div  Now
    log  check now price
    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[2]/div/div  ${result["products"]["${json_id_str}"]["offerActions"][0]["purchasePrice"]["amount"]}

check onsale top row feature products
    [Arguments]  ${i}  ${result}  ${percent_off}  ${json_id_str}

    log  convert to frontend total percent off value
    ${percent_off}=  get variable value  ${result["products"]["${json_id_str}"]["offerActions"][0]["totalPercentOff"]}
    ${percent_off}  Convert To Number  ${percent_off}  0
    ${percent_off}  Convert To String  ${percent_off}
    ${percent_off}  Fetch From Left  ${percent_off}  .

    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//button[contains(@class, 'btn-primary')]  Buy
    log  check was text, price
    element should contain  xpath=//div[@id="featured"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[1]/div[2]/div[1]  Was
    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[1]/div[2]/div[2]  ${result["products"]["${json_id_str}"]["offerActions"][0]["suggestedPrice"]["amount"]}
    log  check now text, price
    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[2]/div/div[1]  Now
    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[2]/div/div[2]  ${result["products"]["${json_id_str}"]["offerActions"][0]["purchasePrice"]["amount"]}
    log  check total percent off element
    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//div[@class="value"]/strong  ${percent_off}

check preorder top row feature products
    [Arguments]  ${i}  ${result}  ${json_id_str}

    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//button[contains(@class, 'btn-primary')]   Pre-Purchase
    log  check now text, price
    Run Keyword And Ignore Error  element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[2]/div/div[1]  Now
    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[2]/div/div  ${result["products"]["${json_id_str}"]["offerActions"][0]["purchasePrice"]["amount"]}


#shelves  0
Check Feature Section Popular Tab Items
    [Arguments]    ${result}
    
    log  ${result["shelf"]}
    Click Element  ${popular_tab}
    Sleep  3s

    #check login or logout, status = True: logout, status = False: login
    ${status}  run keyword and return status  Element Should Contain  ${login_element}  Login/Sign Up
    run keyword if  ${status}==True  Feature Section Top Elements Via API  ${result}
    ...  ELSE  Check Feature Section Top Elements Via API after login  ${result}

Check Feature Section New Tab Items
    [Arguments]    ${result}
    
    log  ${result["shelf"]}    
    Click Element  ${new_tab}
    Sleep  3s

    #check login or logout, status = True: logout, status = False: login
    ${status}  run keyword and return status  Element Should Contain  ${login_element}  Login/Sign Up
    run keyword if  ${status}==True  Feature Section Top Elements Via API  ${result}
    ...  ELSE  Check Feature Section Top Elements Via API after login  ${result}

Check Feature Section OnSale Tab Items
    [Arguments]    ${result}
    
    log  ${result["shelf"]}    
    Click Element  ${on_sale_tab}
    Sleep  3s

    #if no onsale items, return
    ${status}  run keyword and return status  Element Should Contain  ${no_result_element}  No results to display
    Run Keyword If  ${status}==True  Return From Keyword  ${-1}

    #check login or logout, status = True: logout, status = False: login
    ${status}  run keyword and return status  Element Should Contain  ${login_element}  Login/Sign Up
    run keyword if  ${status}==True  Feature Section Top Elements Via API  ${result}
    ...  ELSE  Check Feature Section Top Elements Via API after login  ${result}

Check Feature Section PrePurchase Tab Items
    [Arguments]    ${result}
    
    log  ${result["shelf"]}      
    Click Element  ${pre_purchase_tab}
    Sleep  3s

    #if no onsale items, return
    ${status}  run keyword and return status  Element Should Contain  ${no_result_element}  No results to display
    Run Keyword If  ${status}==True  Return From Keyword  ${-1}

    #check login or logout, status = True: logout, status = False: login
    ${status}  run keyword and return status  Element Should Contain  ${login_element}  Login/Sign Up
    run keyword if  ${status}==True  Feature Section Top Elements Via API  ${result}
    ...  ELSE  Check Feature Section Top Elements Via API after login  ${result}

Check Feature Section Under10 Tab Items
    [Arguments]    ${result}
    
    log  ${result["shelf"]}       
    Click Element  ${under_10_tab}
    Sleep  3s

    #check login or logout, status = True: logout, status = False: login
    ${status}  run keyword and return status  Element Should Contain  ${login_element}  Login/Sign Up
    run keyword if  ${status}==True  Feature Section Top Elements Via API  ${result}
    ...  ELSE  Check Feature Section Top Elements Via API after login  ${result}

Check Feature Section Under30 Tab Items
    [Arguments]    ${result}
    
    log  ${result["shelf"]}       
    Click Element  ${under_30_tab}
    Sleep  3s

    #check login or logout, status = True: logout, status = False: login
    ${status}  run keyword and return status  Element Should Contain  ${login_element}  Login/Sign Up
    run keyword if  ${status}==True  Feature Section Top Elements Via API  ${result}
    ...  ELSE  Check Feature Section Top Elements Via API after login  ${result}

Check browse module section without login
    Log  check browse module
    element should contain  //div[contains(@class, 'ng-scope') and @filter="price"]/div/button/span[1]  All Prices
    element should contain  //div[contains(@class, 'ng-scope') and @filter="releaseDate"]/div/button/span[1]  All Release Dates
    element should contain  //div[contains(@class, 'ng-scope') and @filter="esrb"]/div/button/span[1]  All ESRB

    page should contain element  ${match_games_num_txt}
    element should contain  ${match_games_num_txt}  matching games
    page should contain element  ${sort_by_txt}
    element should contain  ${sort_by_txt}  Sort by
    page should contain element  ${sort_by_filter}

    page should contain element  //div[@class='gf-repeat-animation ng-scope']  limit=25
    page should contain element  //div[@ng-repeat='product in products']  limit=25

    log  check element info via uri
    Create Session  d2d  ${d2d_url}  verify=True
    ${All_game_list_response}=  Get Request  d2d  ${All_game_list_uri}
    ${All_game_list_result} =  To Json  ${All_game_list_response.content}

    #check 25 games
    FOR    ${i}    IN RANGE    0    25
        log  title
        element should contain  //div[contains(@class, 'browse-results')]/child::div[${i+1}]//div[contains(@class, 'title')]//h4  ${All_game_list_result["products"]["items"][${i}]["title"]}
        log  genre 0
        element should contain  //div[contains(@class, 'browse-results')]/child::div[${i+1}]//div[contains(@class, 'genre')]/div[1]  ${All_game_list_result["products"]["items"][${i}]["genres"][0]["name"]}
        log  check release date type [date] or [text]
        ${stauts}  Run keyword And Return Status  Set Suite Variable  ${rd_date}  ${All_game_list_result["products"]["items"][${i}]["releaseDate"]["date"]}
        run keyword if  ${stauts}==True  check browse results game date  ${i}  ${rd_date}
        run keyword if  ${stauts}==False  element should contain  //div[contains(@class, 'browse-results')]/child::div[${i+1}]//div[contains(@class, 'release-date')]/strong  ${All_game_list_result["products"]["items"][${i}]["releaseDate"]["text"]}
        log  purchase price
        ${is_onsale}=  set variable  ${All_game_list_result["products"]["items"][${i}]["offerActions"][0]["isOnSale"]}
        ${was_price}=  Set Variable  ${All_game_list_result["products"]["items"][${i}]["offerActions"][0]["suggestedPrice"]["amount"]}
        ${now_price}=  Set Variable  ${All_game_list_result["products"]["items"][${i}]["offerActions"][0]["purchasePrice"]["amount"]}
        log  ${is_onsale}
        Run Keyword If  ${is_onsale}==True  check browse results game price  ${i}  ${was_price}  ${now_price}
        Run Keyword If  ${is_onsale}==False  element should contain  //div[contains(@class, 'browse-results')]/child::div[${i+1}]//div[contains(@class, 'action')]//table/tbody/tr/td[2]/div/div  ${now_price}
    END

    page should contain element  ${page_info_element}
    element should contain  ${page_info_element}  1 - 25 of

check browse results game date
    [Arguments]  ${i}  ${rd_date}

    Reassemble Release Date String  ${rd_date}
    log  ${custom_date}
    run keyword and ignore error  element should contain  //div[contains(@class, 'browse-results')]/child::div[${i+1}]//div[contains(@class, 'release-date')]/strong  ${custom_date}

check browse results game price
    [Arguments]  ${i}  ${was_price}  ${now_price}

    element should contain  //div[contains(@class, 'browse-results')]/child::div[${i+1}]//div[contains(@class, 'action')]//table/tbody/tr/td[1]/div[2]/div[2]  ${was_price}
    element should contain  //div[contains(@class, 'browse-results')]/child::div[${i+1}]//div[contains(@class, 'action')]//table/tbody/tr/td[2]/div/div[2]  ${now_price}

Feature Section Top Elements Via API
    [Arguments]    ${result}
    
    log  ${result["shelf"]}
    ${items_num}  get length  ${result["items"]}
    ${cnt}  set variable if  ${items_num}>5  5  ${items_num}

    FOR    ${i}    IN RANGE    0    ${cnt}
        ${frontend_title}  get element attribute  //div[@id="featured"]/div[1]/div[1]/div[${i+1}]/div/div[1]/a/img  title
        ${title}=  get variable value  ${result["items"][${i}]["title"]}
        log  check img element
        page should contain element  xpath=//div[@class="carousel-inner"]/div/div[${i+1}]//div[@class="boxart text-center"]/a/img
        log  check preorder or on-sale product
        ${isOnSale}=  get variable value  ${result["items"][${i}]["offerActions"][0]["isOnSale"]}
        ${isPreorderOffer}=  get variable value  ${result["items"][${i}]["offerActions"][0]["isPreorderOffer"]}
        log  convert to frontend total percent off value
         ${percent_off}  convert percent off  ${result["items"][${i}]["offerActions"][0]["totalPercentOff"]}
        ${purchasePrice}=  get variable value  ${result["items"][${i}]["offerActions"][0]["purchasePrice"]["amount"]}
        ${suggestedPrice}=  get variable value  ${result["items"][${i}]["offerActions"][0]["suggestedPrice"]["amount"]}
        check element in feature section top  ${i}  ${isOnSale}  ${isPreorderOffer}  ${purchasePrice}  ${suggestedPrice}  ${percent_off}
    END

scenario1
    [Arguments]  ${i}  ${purchasePrice}
    
    Log  scenario1, check normal items              
    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//button[contains(@class, 'btn-primary')]  Buy Now
    log  check now text
    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[1]/div[2]/div  Now
    log  check now price
    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[2]/div/div  ${purchasePrice}

scenario2
    [Arguments]  ${i}  ${purchasePrice}  ${suggestedPrice}  ${percent_off}
    
    Log  scenario2, check on-sale items        
    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//button[contains(@class, 'btn-primary')]  Buy
    log  check was text, price
    element should contain  xpath=//div[@id="featured"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[1]/div[2]/div[1]  Was
    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[1]/div[2]/div[2]  ${suggestedPrice}
    log  check now text, price
    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[2]/div/div[1]  Now
    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[2]/div/div[2]  ${purchasePrice}
    log  check total percent off element
    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//div[@class="value"]/strong  ${percent_off}

scenario3
    [Arguments]  ${i}  ${purchasePrice}
    
    Log  scenario3, check pre-purchase items        
    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//button[contains(@class, 'btn-primary')]   Pre-Purchase
    log  check now text, price
    Run Keyword And Ignore Error  element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[2]/div/div[1]  Now
    element should contain  xpath=//*[@id="featured"]/div[1]/div/child::div[${i+1}]//table/tbody/tr/td[2]/div/div  ${purchasePrice}

check element in feature section top
    [Arguments]  ${i}  ${isOnSale}  ${isPreorderOffer}  ${purchasePrice}  ${suggestedPrice}  ${percent_off}

    Run Keyword If  ${isOnSale}==False and ${isPreorderOffer}==False  scenario1  ${i}  ${purchasePrice}

    Run Keyword If  ${isOnSale}==True  scenario2  ${i}  ${purchasePrice}  ${suggestedPrice}  ${percent_off}

    Run Keyword If  ${isPreorderOffer}==True  scenario3  ${i}  ${purchasePrice}

