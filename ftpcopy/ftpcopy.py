#coding=utf-8
''' this product from mr wang'''

from ftplib import FTP
import time
import os

def main():
    '''main'''
    ftppathget, ipftpget = 'serverwrite', '172.16.118.206'
    ftppathput, ipftpput = 'clientread', '172.16.251.98'
    temppath = './temppath1'
    if os.path.exists(temppath) is False:
        os.mkdir(temppath)

    ftpget, ftpput = FTP(), FTP()
    timeout, port = 30, 21
    print ftpget.connect(ipftpget, port, timeout)
    print ftpput.connect(ipftpput, port, timeout)

    print ftpget.login('zjq', 'kedacom123')
    print ftpput.login('ftptest', 'kedacom123')

    print ftpget.getwelcome()
    print ftpput.getwelcome()

    print ftpget.cwd(ftppathget)
    print ftpput.cwd(ftppathput)

    while True:
        time.sleep(0.005)
        try:
            for name in ftpget.nlst():
                print '\tftp get:', name
                start = time.time()
                localtemppath = os.path.join(temppath, name)
                with open(localtemppath, 'wb') as filewrite:
                    ftpget.retrbinary('RETR ' + name, filewrite.write)
                with open(localtemppath, 'rb') as fileread:
                    ftpput.storbinary('STOR '+ name, fileread)
                os.remove(localtemppath)
                ftpget.delete(name)
                end = time.time()
                print '\t spend time ', end - start
        except Exception, e:
            print 'exception', e
    ftpget.quit()
    ftpput.quit()
if __name__ == '__main__':
    main()
    print 'Moriturus te saluto!!!'
