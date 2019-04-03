global abc
abc = 10

class abcc():
    def gollog():
        global abc
        print("全局",abc)

    def nglog():
        abc = 5
        print("非全局",abc)

if __name__ == "__main__":
    abcc.gollog()
    abcc.nglog()
    abcc.gollog()