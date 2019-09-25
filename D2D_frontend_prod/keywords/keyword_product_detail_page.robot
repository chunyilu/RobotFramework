*** Settings ***
Documentation    Suite description
Library  SeleniumLibrary
Library  String
Library  RequestsLibrary

*** Variable ***
${nba_2k19_url}  https://www.direct2drive.com/#!/download-nba-2k19--20th-anniversary-edition/5013463
${first_game_title}  //div[@class="row-fluid browse-results"]/div[1]//div[@class="span3 title"]/div/h4

${title}  //div[@class="span7 product-title margin-right-default margin-top-mini"]/h1

#on sale elements
${was_element}  //div[@class="pull-right"]//table/tbody/tr/td[1]/div[2]/div[1]
${was_price_element}  //div[@class="pull-right"]//table/tbody/tr/td[1]/div[2]/div[2]
${now_element}  //div[@class="pull-right"]//table/tbody/tr/td[2]/div/div[1]
${now_price_element}  //div[@class="pull-right"]//table/tbody/tr/td[2]/div/div[2]

#normal elements
${normal_now_element}  //div[@class="pull-right"]//table/tbody/tr/td[1]/div[2]/div
${normal_now_price_element}  //div[@class="pull-right"]//table/tbody/tr/td[2]/div/div

${buy_btn}  //button[contains(@class, 'btn-primary')]

${boxart}  //div[contains(@class, 'boxart')]/img
${discount_value}  //div[contains(@class, 'boxart')]//div[@class="value"]//strong

${rating}  //*[@id="nav-main-view-container"]/div[contains(@class, 'esrb')]/div[1]/img

${publisher_support_link}  //*[@id="nav-main-view-container"]//a[text() = 'Publisher Support']
${recommended_games_txt}  //*[@id="nav-main-view-container"]//div[@ng-show="recommendedProducts && recommendedProducts.length > 0"]/div/strong

#right panel
${summary}  //div[@class="panel span9 pad-large"]//ul[@class="nav gf-pills"]/li[1]/a
${screenshots}  //div[@class="panel span9 pad-large"]//ul[@class="nav gf-pills"]/li[2]/a
${videos}  //div[@class="panel span9 pad-large"]//ul[@class="nav gf-pills"]/li[3]/a


${product_req}  xpath=//*[@id="nav-main-view-container"]//div[@ng-show="product.requirements"]
${product_description}  xpath=//*[@id="nav-main-view-container"]//div[@ng-bind-html="product.description"]
${country_restriction}  xpath=//*[@id="nav-main-view-container"]//div[@ng-show="product.countryRestrictions.length"]

${sys_req}  xpath=//*[@id="nav-main-view-container"]//div[@ng-show="product.techSpecs.length"]/p

${r_name}  null name

*** Keywords ***
check product detail via first product id in browse result
    ${id}=  get element attribute  //div[@class="row-fluid browse-results"]/div[1]/a  id
    click element  ${first_game_title}
    sleep  3s
    check onsale product detail  ${id}

#check on sale product
check onsale product detail
    [Arguments]  ${id}

    ${id}  convert to string  ${id}

    ${uri}=  Catenate  SEPARATOR=  /backend/api/product/get/${id}
    Create Session  d2d  ${d2d_url}  verify=True
    ${response}=  Get Request  d2d  ${uri}
    ${result} =  To Json  ${response.content}

    #check top three rows items
    check common items
    Navigation Section Test In Prod env

    #check pricing panel
    page should contain element  ${title}
    page should contain element  ${was_element}
    page should contain element  ${was_price_element}
    page should contain element  ${now_element}
    page should contain element  ${now_price_element}
    page should contain element  ${buy_btn}

    element should contain  ${title}  ${result["product"]["title"]}
    #now
    element should contain  ${now_element}  Now:
    ${now_price}  custom get rounded number  ${result["product"]["offerActions"][0]["purchasePrice"]["amount"]}
    element should contain  ${now_price_element}  ${now_price}
    #was
    element should contain  ${was_element}  Was:
    ${was_price}  custom get rounded number  ${result["product"]["offerActions"][0]["suggestedPrice"]["amount"]}
    element should contain  ${was_price_element}  ${was_price}
    #buy button
    element should contain  ${buy_btn}  Buy

    #check countdown element
    ${is_onsale}  set variable  ${result["product"]["offerActions"][0]["isOnSale"]}
    run keyword if  ${is_onsale}==True   page should contain element  //*[@id="nav-main-view-container"]//b[@class="on-sale-countdown pull-right"]

    #check left panel
    page should contain element  ${boxart}

    #check rating icon description exists
    ${status}  run keyword and return status  ${r_name}  set variable  ${result["product"]["contentRating"]["rating"]["name"]}
    run keyword if  ${status}==True  page should contain element  ${rating}
    ...  ELSE  log  no rating icon

    ${len}  get length  ${result["product"]["contentRating"]["descriptors"]}
    run keyword if  ${len}>0  check rating descriptor  ${len}
    ...  ELSE  log  no rating descriptor

    #genres
    ${len}  get length  ${result["product"]["genres"]}
    run keyword if  ${len}>0  check genres  ${len}
    ...  ELSE  log  no genres

    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  1  1  Genre
    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  1  2  ${result["product"]["genres"][0]["name"]}
    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  2  1  Developer
    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  2  2  ${result["product"]["developer"]}
    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  3  1  Publisher
    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  3  2  ${result["product"]["publisher"]}
    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  4  1  Release Date
    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  4  2  ${result["product"]["releaseDate"]["text"]}
    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  5  1  Platform
    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  6  1  DRM

    log to console  check total percent off value on boxart
    ${percent_off}  convert to number  ${result["product"]["offerActions"][0]["totalPercentOff"]}  0
    ${percent_off}  convert to string  ${percent_off}
    ${percent_off}  Fetch From Left  ${percent_off}  .
    element should contain  ${discount_value}  ${percent_off}

    log to console  check publisher link
    page should contain element  ${publisher_support_link}
    element should contain  ${publisher_support_link}  Publisher Support

    #check recommended games section
    ${len}  get length  ${result["recommendedProducts"]}
    run keyword if  ${len}>0  check recommended games section  ${len}
    ...  ELSE  log  no recommended Products

    #check right panel
    page should contain element  ${summary}
    page should contain element  ${screenshots}
    page should contain element  ${videos}

    ${len}  get length  ${result["topMedia"]}

    log  top media number
    : for  ${i}  IN RANGE  1  ${len}
        \  page should contain element  //div[@class="row-fluid margin-bottom-large top-media ng-scope"]/ul/li[${i}]//img

    page should contain element  ${product_req}
    page should contain element  ${product_description}
    page should contain element  ${country_restriction}

    #system requirement
    page should contain element  ${sys_req}
    element should contain  ${sys_req}  SYSTEM REQUIREMENTS

    ${len}  get length  ${result["product"]["techSpecs"]}
    : for    ${i}    IN RANGE    0    ${len}
      \  Table Cell Should Contain  xpath=//table[@class="system-requirements"]  ${i+1}  1  ${result["product"]["techSpecs"][${i}]["name"]}
      \  Table Cell Should Contain  xpath=//table[@class="system-requirements"]  ${i+1}  2  ${result["product"]["techSpecs"][${i}]["value"]}

check rating descriptor
    [Arguments]  ${len}
    : for  ${i}  IN RANGE  0  ${len}
    \  page should contain element  //div[@class="span8 text-light text-small"]/ul/li[${i+1}]

check genres
    [Arguments]  ${len}
    : for  ${i}  IN RANGE  0  ${len}
    \  page should contain element  //table[@class="product-meta-data"]/tbody/tr[1]/td[2]/div[${i+1}]

check recommended games section
    [Arguments]  ${len}

    page should contain element  ${recommended_games_txt}
    : for    ${i}    IN RANGE    0    ${len}
    \  log  rg_image
    \  page should contain element  //*[@id="nav-main-view-container"]/div[2]/div[1]/div[2]/div/div[1]/div[4]/a[${i+1}]/img
    \  log  rg_title
    \  page should contain element  //*[@id="nav-main-view-container"]/div[2]/div[1]/div[2]/div/div[1]/div[4]/a[${i+1}]/div/div[1]/strong
    \  log  rg_publisher
    \  page should contain element  //*[@id="nav-main-view-container"]/div[2]/div[1]/div[2]/div/div[1]/div[4]/a[${i+1}]/div/div[3]
    \  log  rg_release_date
    \  page should contain element  //*[@id="nav-main-view-container"]/div[2]/div[1]/div[2]/div/div[1]/div[4]/a[${i+1}]/div/div[4]
    \  log  rg_platform
    \  page should contain element  //*[@id="nav-main-view-container"]/div[2]/div[1]/div[2]/div/div[1]/div[4]/a[${i+1}]/div/div[5]/i
    \  log  rg_drm
    \  page should contain element  //*[@id="nav-main-view-container"]/div[2]/div[1]/div[2]/div/div[1]/div[4]/a[${i+1}]/div/div[6]/img

#check normal product, without onsale
check product detail
    [Arguments]  ${id}

    ${id}  convert to string  ${id}

    ${uri}=  Catenate  SEPARATOR=  /backend/api/product/get/${id}
    Create Session  d2d  ${d2d_url}  verify=True
    ${response}=  Get Request  d2d  ${uri}
    ${result} =  To Json  ${response.content}

    log to console  check top three rows items
    check common items
    Navigation Section Test In Prod env

    log to console  check pricing panel
    page should contain element  ${title}
    page should contain element  ${normal_now_element}
    page should contain element  ${normal_now_price_element}
    page should contain element  ${buy_btn}

    element should contain  ${title}  ${result["product"]["title"]}

    log to console  now text and price
    element should contain  ${normal_now_element}  Now
    element should contain  ${normal_now_price_element}  ${result["product"]["offerActions"][0]["purchasePrice"]["amount"]}

    log to console  buy button
    element should contain  ${buy_btn}  Buy

    log to console  check left panel
    page should contain element  ${boxart}

    log to console  check rating icon description exists
    ${status}  run keyword and return status  ${r_name}  set variable  ${result["product"]["contentRating"]["rating"]["name"]}
    run keyword if  ${status}==True  page should contain element  ${rating}
    ...  ELSE  log  no rating icon

    ${len}  get length  ${result["product"]["contentRating"]["descriptors"]}
    run keyword if  ${len}>0  check rating descriptor  ${len}
    ...  ELSE  log  no rating descriptor

    #genres
    ${len}  get length  ${result["product"]["genres"]}
    run keyword if  ${len}>0  check genres  ${len}
    ...  ELSE  log  no genres

    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  1  1  Genre
    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  1  2  ${result["product"]["genres"][0]["name"]}
    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  2  1  Developer
    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  2  2  ${result["product"]["developer"]}
    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  3  1  Publisher
    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  3  2  ${result["product"]["publisher"]}
    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  4  1  Release Date
    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  4  2  ${result["product"]["releaseDate"]["text"]}
    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  5  1  Platform
    Table Cell Should Contain  xpath=//table[@class="product-meta-data"]  6  1  DRM

    page should contain element  ${publisher_support_link}
    element should contain  ${publisher_support_link}  Publisher Support

    log to console  check recommended games section
    ${len}  get length  ${result["recommendedProducts"]}
    run keyword if  ${len}>0  check recommended games section  ${len}
    ...  ELSE  log  no recommended Products

    #check right panel
    page should contain element  ${summary}
    page should contain element  ${screenshots}
    page should contain element  ${videos}

    ${len}  get length  ${result["topMedia"]}

    log  top media number
    : for  ${i}  IN RANGE  1  ${len}
        \  page should contain element  //div[@class="row-fluid margin-bottom-large top-media ng-scope"]/ul/li[${i}]//img

    page should contain element  ${product_req}
    page should contain element  ${product_description}
    page should contain element  ${country_restriction}

    #system requirement
    page should contain element  ${sys_req}
    element should contain  ${sys_req}  SYSTEM REQUIREMENTS

    ${len}  get length  ${result["product"]["techSpecs"]}
    : for    ${i}    IN RANGE    0    ${len}
      \  Table Cell Should Contain  xpath=//table[@class="system-requirements"]  ${i+1}  1  ${result["product"]["techSpecs"][${i}]["name"]}
      \  Table Cell Should Contain  xpath=//table[@class="system-requirements"]  ${i+1}  2  ${result["product"]["techSpecs"][${i}]["value"]}