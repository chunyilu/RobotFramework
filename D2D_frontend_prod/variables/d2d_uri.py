

flashback_zone_uri= "/backend/api/productquery/findpage?collection=88&pageindex=1&pagesize=10&sort.direction=desc&sort.field=releasedate"
new_reward_offers_uri= "/backend/api/merchandising/reward_offers?pagenumber=1&pagesize=1000"
genres_uri= "/backend/d2d/genres"
platform_uri= "/backend/d2d/platforms"
instant_play_uri= "/backend/d2d/streaming/active_instant_play_collection?pagenumber=1&pagesize=1000"
ps_game_uri= "/backend/api/productquery/findpage?pageindex=1&pagesize=25&platform[]=1300&platform[]=1310&platform[]=1320&sort.direction=desc&sort.field=releasedate" 
just_search_uri= "/backend/api/productquery/findpage?pageindex=1&pagesize=25&platform[]=1100&sort.direction=desc&sort.field=releasedate"
onsale_page_uri= "/backend/api/productquery/findpage?onsale=true&pageindex=1&pagesize=25&sort.direction=desc&sort.field=releasedate"
getdisplay_uri= "/backend/api/merchandising/getdisplay?genre=1&platform=1100"

#main page
merchandising_uri= "/backend/api/merchandising/getdisplay?genre=1"
All_game_list_uri= "/backend/api/productquery/findpage?category=0&genre=1&newreleases=true&pagesize=25&sort.direction=desc&sort.field=releasedate"
Bestselling_uri="/backend/api/productquery/findpage?category=0&genre=1&pagesize=25&sort.direction=desc&sort.field=bestselling"
Onsale_uri=    "/backend/api/productquery/findpage?category=0&genre=1&onsale=true&pagesize=25&sort.direction=desc&sort.field=mostpopular"
New_uri=       "/backend/api/productquery/findpage?category=0&genre=1&newreleases=true&pagesize=25&sort.direction=desc&sort.field=releasedate"
Pre_purchase_uri="/backend/api/productquery/findpage?category=0&genre=1&pagesize=25&release_date=1&sort.direction=asc&sort.field=releasedate"
Under_10_Uri="/backend/api/productquery/findpage?category=0&genre=1&pagesize=25&price.underprice=10&sort.direction=desc&sort.field=mostpopular"
Under_30_Uri="/backend/api/productquery/findpage?category=0&genre=1&pagesize=25&price.underprice=30&sort.direction=desc&sort.field=mostpopular"
shopping_cart_uri="/backend/api/account/shopping_carts"

shopping_cart_data={"product_id": 5014866}

shelves_payloadData = {"shelves":[{"query":{"sort.field":"bestselling","sort.direction":"desc","pageindex":1,"pagesize":15},"value":"Popular"},
{"query":{"newreleases":"true","sort.field":"releasedate","sort.direction":"desc","pageindex":1,"pagesize":15},"value":"New"},
{"query":{"onsale":"true","sort.field":"mostpopular","sort.direction":"desc","pageindex":1,"pagesize":15},"value":"OnSale"},
{"query":{"release_date":"1","sort.field":"releasedate","sort.direction":"asc","pageindex":1,"pagesize":15},"value":"PreOrders"},
{"query":{"price.underprice":10,"sort.field":"mostpopular","sort.direction":"desc","pageindex":1,"pagesize":15},"value":"Under10"},
{"query":{"price.underprice":30,"sort.field":"mostpopular","sort.direction":"desc","pageindex":1,"pagesize":15},"value":"Under30"}]}

#shelves
shelves_uri="/backend/api/merchandising/shelves"

shelves_popular_data =  {"shelves":[{"query":{"sort.field": "bestselling", "sort.direction": "desc", "pageindex":1, "pagesize":15}, "value": "Popular"}]}
shelves_new_data =      {"shelves":[{"query":{"sort.field": "releasedate", "sort.direction": "desc", "pageindex":1, "pagesize":15}, "value": "New"}]}
shelves_onsale_data =   {"shelves":[{"query":{"sort.field": "mostpopular", "sort.direction": "desc", "pageindex":1, "pagesize":15}, "value": "OnSale"}]}
shelves_preorder_data = {"shelves":[{"query":{"sort.field": "releasedate", "sort.direction": "asc", "pageindex":1, "pagesize":15}, "value": "PreOrders"}]}
shelves_under10_data =  {"shelves":[{"query": {"price.underprice": 10, "sort.field": "mostpopular", "sort.direction": "desc", "pageindex": 1,"pagesize": 15}, "value": "Under10"}]}
shelves_under30_data =  {"shelves":[{"query": {"price.underprice": 30, "sort.field": "mostpopular", "sort.direction": "desc", "pageindex": 1,"pagesize": 15}, "value": "Under30"}]}


# shelves_headers = {"Content-Type": "application/json"}
shelves_headers = {
'Host': 'www.direct2drive.com',
'Content-Type': 'application/json;charset=utf-8'}
#d2d plus
subscription_uri="/backend/d2d/premium/active_games?pagenumber=1&pagesize=1000"
rental_uri="/backend/api/productquery/findpage?d2d_plus=2&drm_types%5B%5D=12&pageIndex=1&pageSize=25&platform%5B%5D=1100&sort.direction=desc&sort.field=releasedate"
trade_in_uri="/backend/api/productquery/findpage?d2d_plus=1&drm_types[]=12&pageIndex=1&pageSize=25&platform[]=1100&sort.direction=desc&sort.field=releasedate"

login_uri=  "/backend/api/account/login"
wallet_uri="/backend/api/account/wallet"

campaign_uri=  "/backend/d2d/streaming/campaign"
darksider_result_uri=  "/backend/api/productquery/findpage?pageindex=1&pagesize=25&search.keywords=darksiders&search.titleonly=false&sort.direction=desc&sort.field=releasedate"
stream_info_uri="/backend/api/account/streaming"

shopping_cart_uri="/backend/api/account/shopping_carts"

#my account
purchaseHistory_uri="backend/api/account/payments?per_page=500"


{"shelves":[{"query":{"sort.field":"bestselling","sort.direction":"desc","pageindex":1,"pagesize":15},"value":"Popular"}]}
