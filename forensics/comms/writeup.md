1. We know its a keyboard pcap as its written in the challenge description.
2. So now we need to parse this pcap as keyboard. For this lets open it in wireshark, and in wireshark we can see that for HID Data, it parses it for us. So with the help of this, we need to make a python script which can parse the HID Data for us and then give us the strings.
![image](https://github.com/d4rkc0de-club/h4ckc0n-2023-official-writeups/assets/64488123/8ea80989-28e3-4934-ab82-9856f3a3fa6b)
3. So for that lets first export all the HID Data to a txt file using this
![image](https://github.com/d4rkc0de-club/h4ckc0n-2023-official-writeups/assets/64488123/db431cc7-6995-4630-b41a-c6b9544009e0)

4. Now lets make a python script which parses this txt file.
5. We can use this https://github.com/TeamRocketIst/ctf-usb-keyboard-parser/blob/master/usbkeyboard.py as an inspiration, but we will have to make our own script.
