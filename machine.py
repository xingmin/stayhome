import os,sys
import re,urllib2
import socket
import configparser

class machineip:  
    def get_ip(self):  
        try:  
            myip = self.visit("http://www.ip138.com/ip2city.asp")  
        except:  
            try:  
                myip = self.visit("http://www.bliao.com/ip.phtml")  
            except:  
                try:  
                    myip = self.visit("http://www.whereismyip.com/")  
                except:  
                    myip = "So sorry!!!"  
        return myip  
    def visit(self,url):  
        opener = urllib2.urlopen(url)  
        if url == opener.geturl():  
            str = opener.read()  
        return re.search('\d+\.\d+\.\d+\.\d+',str).group(0)
    def get_local_ip(self):
        return socket.gethostbyname(socket.gethostname())

class machine:
    def __init__(self, data_repo_dir, machine_name):
        self.data_repo = data_repo_dir;
        self.uuid = "";
        self.name = machine_name;
        
    #根据name来找UUID
    def get_uuid_by_name(self, name):
        for uuid_dir in os.listdir(self.data_repo):
            uuid_dir_full = self.data_repo +"/"+uuid_dir;            
            if os.path.isdir(uuid_dir_full):
                uuid_dir_full_config = uuid_dir_full +"/config"
                parser = configparser.ConfigParser();
                parser.read(uuid_dir_full_config);
                if parser['base']['name'] == name:
                    return parser['base']['uuid'];
        return "";
    def create_machine(self):
        self.uuid_dir = self.data_repo+"/"+self.uuid;
        self.config_file = self.uuid_dir + "/config"
        self.report_file = self.uuid_dir + "/report.log"
        os.mkdir(self.uuid_dir);
        parser = configparser.ConfigParser();
        parser['base']={'uuid':self.uuid,
                        'name':self.name}
        with open(self.config_file, 'w') as configfile:
            parser.write(configfile);
        reportfile = open(self.report_file, 'w');
        reportfile.close();
    def report_status(self):
        with open(        
        
