#wifitestscripts

##Requirements:

* expect
* gnuplot
* pdfunite
* iperf

##For Asus, Asus N66 & Netgear

1. **Telnet Enable for Netgear:**
  * Make sure you can ping 192.168.1.1 then:
  ```bash
  python telnetenable.py 192.168.1.1 C404150C9A83 Gearguy Geardog
```
  * Try telnetting to 192.168.1.1

2. **Prep for Asus & Asus N66 & Netgear:**

  * Copy nc and dut.sh to a USB disk
  * On the DUT copy nc and dut.sh to /tmp
  * Asus: 
  ```bash
  cd /tmp/mnt/sd*1
  ```
  * Netgear: 
  ```bash
  cd /tmp/mnt/usb0/part1
  ```
  * Then: 
  ```bash
  cd /tmp/
  chmod 777 dut.sh nc
  ./dut.sh
  ```

##Init Test

3. **Set these variables:**
  * DUTA
  * SINKIP
  * STA_MAC
  * MYIP (Not needed for asus_ngear, n66)

4. **Set 5G and 2G SSIDs to the same string**

5. **On the sink device, associate to the SSID and set static IP to SINKIP, then:**
  ```bash
  iperf -s -i 1
  ```

6. **On the source device**
  ```bash
  ./test_e.sh [logdir]
  ```
