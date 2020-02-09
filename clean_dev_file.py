#-*- coding:utf-8 -*-

import os, re

keep_ext = set(('', '.a', '.h', '.inc'))
del_ext = {'.a'}
def file_extension(path): 
    return os.path.splitext(path)[1] 

def findAllFile(base):
    for root, ds, fs in os.walk(base):
        for f in fs:
            fullname = os.path.join(root, f)
            yield fullname
            
def main():
    base = './tensorflow_libs/'
    coo = 0
    for i in findAllFile(base):
        ext = file_extension(i)
        if ext  in del_ext and os.path.isfile(i):
            coo = coo + 1
            #os.remove(i)
            print(i)
    print(coo)

if __name__ == '__main__':
    main()