import time
import os
import re
import shutil
import math
from decimal import Decimal
import decimal
import logging
import string


class atgames:
    
    def __init__(self):
        print('init')

    def hello(self):
        print('Login successfully!')

    def round_up(self, n, decimals=0):
        multiplier = 10 ** decimals
        return math.ceil(n * multiplier + 0.5) / multiplier

    #check original d2d rewards
    #isgenba=1, check genba products
    #isgenba=0, check normal products
    def check_d2d_reward_discount_py(self, nowprice, vipprice, isgenba=0):
        if isgenba==0:
            member_discount=0.95
            bronze_discount=0.92
            silver_discount=0.88
            gold_discount=0.85
            platinum_discount=0.8
        else:
            member_discount=0.98
            bronze_discount=0.96
            silver_discount=0.94
            gold_discount=0.92
            platinum_discount=0.9

        print("now price " + nowprice)
        nprice = re.sub('[!@#$]', '', nowprice)
        print("vip price " + vipprice)
        vprice = re.sub('[!@#$]', '', vipprice)

        #convert to float type
        f_nprice = float(nprice)
        f_vprice = float(vprice)

        decimal.getcontext().rounding = decimal.ROUND_UP
        # decimal.getcontext().prec = 3
        # print decimal.getcontext()

        if f_nprice < 9.99:
            # print "member_discount"
            f_nprice = f_nprice * member_discount
            f_nprice = decimal.Decimal(f_nprice).quantize(Decimal("1.0"))
            f_vprice = decimal.Decimal(f_vprice).quantize(Decimal("1.0"))
            if float(f_nprice) == float(f_vprice):
                # print "pass"
                status = 1
            else:
                # print "fail"
                # print f_nprice
                # print f_vprice
                status = 0
        elif 9.99 <= f_nprice < 19.99:
            # print "bronze_discount"
            f_nprice = f_nprice * bronze_discount
            f_nprice_2 = decimal.Decimal(f_nprice).quantize(Decimal("1.0"))
            f_vprice = decimal.Decimal(f_vprice).quantize(Decimal("1.0"))
            if float(f_nprice_2) == float(f_vprice):
                # print "pass"
                status = 1
            else:
                # print "fail"
                # print f_nprice_2
                # print f_vprice
                status = 0
        elif 19.99 <= f_nprice < 29.99:
            # print "silver_discount"
            f_nprice = f_nprice * silver_discount
            f_nprice_2 = decimal.Decimal(f_nprice).quantize(Decimal("1.0"))
            f_vprice = decimal.Decimal(f_vprice).quantize(Decimal("1.0"))
            if float(f_nprice_2) == float(f_vprice):
                # print "pass"
                status = 1
            else:
                # print "fail"
                # print f_nprice_2
                # print f_vprice
                status = 0
        elif 29.99 <= f_nprice < 59.99:
            # print "gold_discount"
            f_nprice = f_nprice * gold_discount
            f_nprice_2 = decimal.Decimal(f_nprice).quantize(Decimal("1.0"))
            f_vprice = decimal.Decimal(f_vprice).quantize(Decimal("1.0"))
            if float(f_nprice_2) == float(f_vprice):
                # print "pass"
                status = 1
            else:
                # print "fail"
                # print f_nprice_2
                # print f_vprice
                status = 0
        elif f_nprice >= 59.99:
            # print "platinum_discount"
            f_nprice = f_nprice * platinum_discount
            f_nprice_2 = decimal.Decimal(f_nprice).quantize(Decimal("1.0"))
            f_vprice = decimal.Decimal(f_vprice).quantize(Decimal("1.0"))
            if float(f_nprice_2) == float(f_vprice):
                # print "pass"
                status = 1
            else:
                # print "fail"
                # print f_nprice_2
                # print f_vprice
                status = 0
        else:
            print("exception happen")

        return status

    def dir_list_folder(self, head_dir, dir_name):
        # print head_dir
        # print dir_name
        outputList = []
        for root, dirs, files in os.walk(head_dir):
            # print dirs
            # print files
            # print "test"
            for d in dirs:
                # print d
                if d.upper() == dir_name.upper():
                    outputList.append(os.path.join(root, d))
        return outputList


    #account: your PC account, ex: steve
    #folder_name: the carbon client log folder name(ex: log-20190318)
    #target_str: the string you want to search(ex: [StreamService::HandleStreamStarted] Streaming started)
    #wait_time: the processing time, current default time 30 sec
    def check_target_str_in_log(self, account, folder_name, target_str, wait_time=30):

        #connect path string
        path = 'C:\\Users\\' + account + '\\AppData\\Local\\Mas'
        # print path

        names = os.listdir(path)
        # print names

        #find target folder
        for name in names:
            if name.startswith(folder_name):
                log_folder = name
                # print name

        wtime = int(wait_time)
        for x in range(wtime):
            # print 'x'
            # print x
            # copy file
            log_path = path + '\\' + log_folder + '\\carbon_client.0.log'
            copy_path = path + '\\' + log_folder + '\\robot_tmp.log'
            shutil.copy(log_path, copy_path)

            with open(copy_path, 'r+') as f:
                str = f.read();
                # print ("Read String is : ", str)
                result = str.find(target_str)
                # print result

                if wtime == 0:
                    return result
                elif result == -1:
                    wtime = wtime - 1
                    time.sleep(1)
                else:
                    return result

    #send one hour for $10 price
    def check_streamig_hour(self, price):
        f_price = float(price)
        hour = f_price/10.0
        # print(hour)
        i_hour = int(hour)
        # print(i_hour)
        return i_hour