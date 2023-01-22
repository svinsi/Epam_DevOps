web 01 - 2 interfaces int1 enp0s3 -> server 10.88.24.20/24
           interfaces int2 enp0s8 -> web02  172.16.24.1/24
	 3 loopback interface 172.17.34.1/24 from web02 via server 
	   	    interface 172.17.44.1/24 from web02 via net4

web02 -  2 interfaces int1 enp0s3 -> server 10.5.88.30/24
           interfaces int2 enp0s8 -> web001 172.16.24.2/24

server   3 interfaces int1 enp0s8 -> web01  10.88.24.10/24 DHCP
           interfaces int2 enp0s9 -> web02  10.5.88.20/24 DHCP
	   interfaces int2 enp0s17 -> host (outside) 192.168.0.150/24 Static 