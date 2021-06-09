#!/usr/bin/env python
# -*- coding: UTF-8 -*-
'''
@Project ：tools_script 
@File ：Decorator.py
@comments: 掌握装饰器的使用，统计质数的个数
@Author ：ying.zhou
@Date ：2021/6/9 下午4:47
'''

import time

#装饰器，统计时间
def display_time(func):
    def wrapper(*args):
        t1 = time.time()
        result = func(*args)
        t2 = time.time()
        print("Total Time:{:.4} s".format(t2-t1))
        return result
    return wrapper

#判断是否为质数
def is_prime(num):
    if num < 2:
        return False
    elif num == 2:
        return True
    else:
        for i in range(2,num):
            if num % i == 0:
                return False
            else:
                return True


#统计质数的个数，及花费的时间

@display_time
def count_prime_nums(maxnum):
    count = 0
    for i in range(2,maxnum):
        if is_prime(i):
            count = count + 1
    return count

count = count_prime_nums(10000)
print(count)




