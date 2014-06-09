#!/usr/bin/expect
set timeout 200
set hostname [lindex $argv 0]
spawn telnet $hostname
expect "login:"
send "root\r"
expect "Password:"
send "admin\r"
expect "# "
send "cd /tmp/\r"
expect "#"
send "nc [lindex $argv 1] 1234 > dut.sh\r"
expect "#"
send "chmod 777 dut.sh\r"
expect "#"
send "killall dut.sh\r"
expect "#"
send "killall nc\r"
expect "#"
send "(./dut.sh [lindex $argv 2] > /dev/null &) &\r"
expect "#"
