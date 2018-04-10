#coding=utf-8
''' this product from mr wang'''
import os,shutil,commands

# he realserver  zai tong yi ce set to True, else set to False
HE_REAL_SERVER_TONG_YI_CE = True

# clientproxy and serverproxy is on one machine
BOTH_ON = False

clientwritepath = '/root/wxh/clientwrite'
clientreadpath = '/root/wxh/clientread'
serverwritepath = '/root/wxh/serverwrite'
serverreadpath = '/root/wxh/serverread'
tempfilepath = '/root/wxh/tempfile'

# 'tcp 172.16.193.179 9900 9900 /root/wxh/bin_tcp9900'
# tcp or udp to be proxyed, realserverip  realserverport proxyport  exeinstalledpath
configdict = ['tcp 172.16.193.179 9900 9900 /root/wxh/bin_tcp9900',
              'tcp 172.16.193.179 9907 9907 /root/wxh/bin_tcp9907',
              'udp 172.16.193.179 9908 9908 /root/wxh/bin_udp9908']

def copyclientexe():
    ''' x '''
    return BOTH_ON or HE_REAL_SERVER_TONG_YI_CE
def copyserverexe():
    ''' f '''
    return BOTH_ON or (not HE_REAL_SERVER_TONG_YI_CE)

def copyfilelist(filelist, destpath):
    ''' copy '''
    for item in filelist:
        with open(item[0], 'r') as fileread:
            strinfo = fileread.read()
            print item[1]
            strdstinfo = strinfo % item[1]

            with open(os.path.join(destpath, os.path.basename(item[0])), 'w') as filewrite:
                filewrite.write(strdstinfo)
def main():
    '''main'''
    for subitem in [clientreadpath, clientwritepath, serverreadpath, serverwritepath, tempfilepath]:
        if os.path.exists(subitem) is False:
            os.makedirs(subitem)

    for configitem in configdict:
        item = configitem.split()

        tcporudp, realserverip, realserverport, proxyport, destpath = item

        if os.path.exists(destpath) is True:
            shutil.rmtree(destpath)
        os.makedirs(destpath)

        if tcporudp == 'tcp' or tcporudp == 'udp':
            exe1 = './tcp/clientproxy'
            exe2 = './tcp/serverproxy'
            if tcporudp == 'udp':
                exe1 = './udp/udpclientproxy'
                exe2 = './udp/udpserverproxy'

            filelist = list()
            if copyclientexe() is True:
                shutil.copy(exe1, destpath)
                filelist.append(['./%s/startclient.sh' % tcporudp, (realserverip, realserverport, proxyport, clientwritepath, clientreadpath, tempfilepath)])
                filelist.append(['./%s/killclient.sh' % tcporudp, (realserverip, realserverport, proxyport)])
            if copyserverexe() is True:
                shutil.copy(exe2, destpath)
                filelist.append(['./%s/startserver.sh' % tcporudp, (realserverip, realserverport, proxyport, serverwritepath, serverreadpath, tempfilepath)])
                filelist.append(['./%s/killserver.sh' % tcporudp, (realserverip, realserverport, proxyport)])
            copyfilelist(filelist, destpath)
        else:
            print 'bad protocol will not work', item
        print commands.getstatusoutput('chmod -R 777   %s' % destpath)
    print 'operate ok'
    createshellfiles()
    copyusbkeyso()

def createshellfiles():
    ''' c'''
    if BOTH_ON:
        copyfilelist([['./tcp/wangzhacopy.sh', (clientwritepath, serverreadpath, serverwritepath, clientreadpath)]], './')
    strstartlist, strstoplist = list(), list()
    for startitem in configdict:
        pathdir = startitem.split()[4]
        if copyclientexe() is True:
            strstartlist.append(os.path.join(pathdir, 'startclient.sh'))
            strstoplist.append(os.path.join(pathdir, 'killclient.sh'))
        if copyserverexe() is True:
            strstartlist.append(os.path.join(pathdir, 'startserver.sh'))
            strstoplist.append(os.path.join(pathdir, 'killserver.sh'))

    for shfile, infolist in [('./startall.sh', strstartlist), ('./stopall.sh', strstoplist)]:
        with open(shfile, 'w') as filewrite:
            strdstinfo = '''#!/bin/sh\nDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"  \ncd $DIR  \necho $DIR \n%s''' % '\n'.join(infolist)
            filewrite.write(strdstinfo)

def copyusbkeyso():
    '''copy usbkey so'''
    print 'copy so to /usr/lib'
    print commands.getstatusoutput('sh ./copyusbkeyso.sh')

if __name__ == '__main__':
    main()
    print 'Moriturus te saluto!!!'
