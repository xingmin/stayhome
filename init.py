import os,sys
import time

#切换工作目录
oldpath = os.getcwd();
newpath = sys.path[0];
if oldpath != newpath:
    os.chdir(newpath);
#更新程序
os.system("sh --login -c 'git pull origin master'")

#切换回工作目录
if oldpath != newpath:
    os.chdir(oldpath);
