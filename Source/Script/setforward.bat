
WMIC Path Win32_NetworkAdapterConfiguration WHERE "IPEnabled = 'True' AND ServiceName='usb_rndisx'" call enablestatic ("192.168.137.1"), ("255.255.255.0")


net start remoteaccess
netsh interface portproxy reset
netsh interface portproxy add v4tov4 listenport=7778 connectaddress=192.168.137.111 connectport=7778


