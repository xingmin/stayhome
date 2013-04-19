import os,sys
import time
import config

#切换工作目录
oldpath = os.getcwd();
newpath = sys.path[0];
if oldpath != newpath:
    os.chdir(newpath);

#更新程序的数据,从repo中clone/pull
if not os.path.isdir(config.DB_PATH):
    os.makedirs (config.DB_PATH);
data_repo_dir=config.DB_PATH+"/machines";
data_repo_git_dir = data_repo_dir+"/.git";
if not os.path.isdir(data_repo_git_dir):
    cmd = "sh --login -c 'git clone {0} {1}/machines'".format(config.DB_REPO, config.DB_PATH);
else:
    cmd = "sh --login -c 'git --git-dir={0} pull origin master'".format(data_repo_git_dir);
os.system(cmd);


#切换回工作目录
if oldpath != newpath:
    os.chdir(oldpath);
