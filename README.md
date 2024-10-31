When PVE marks a network interface as isolated this is setting the isoalted flag. There is very few ways to see this setting and it is not displayed in standard linux command output. 
The quickest way to see if an interface is isolated is to use the following example command 

**cat /sys/devices/virtual/net/veth139i0/brport/isolated**

This will return 0 for not isoalted and 1 for isolated. 

The attached script is simply looking for tap interfaces (VM) and veth interfaces (LXC Containers) and producing a table. 

![image](https://github.com/user-attachments/assets/ea0715e1-26d0-4068-92fd-337df1419847)
