# coding: utf-8

# 说明：该脚本用于iPhoneX的王者刷金币，使用FaceBook的WDA自动化工具执行。
# 主要工具记录：WDA、iproxy(安装方法brew install libimobiledevice --HEAD)。
# 使用方法：开启WDA，打开王者“冒险模式->魔女回忆”，调用该脚本即可模拟循环点击屏幕，据计算赚钱速度大概为：0.5金币/秒，19金币，39秒左右一盘。

import wda
import time

def tap():
    s.tap(600, 330)

def wait(atime):
    time.sleep(atime)

def hold(atime):
    s.tap_hold(200, 200, atime)

def loop():
	tap()
	wait(0.5)
	loop()

c = wda.Client()
s = c.session()

#开始刷钱
loop()


