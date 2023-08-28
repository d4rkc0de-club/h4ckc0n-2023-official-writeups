1. First of all we do the `file` command in order to know what type of file it is, and we get to know its a Golang binary
![image](https://github.com/d4rkc0de-club/h4ckc0n-2023-official-writeups/assets/64488123/09f78c8f-0bde-46cb-8ff9-b4cd088c45ea)

2. Now we open it in ghidra and choose the golang plugin and find the main.main function, this is the main functinon of the program
![image](https://github.com/d4rkc0de-club/h4ckc0n-2023-official-writeups/assets/64488123/abb65b59-3bb3-48a2-a3e8-483ab50b9e2b)


In here we see the statement "The Oracle wasn't happy..." statement, which is what being printed when we simply enter some random password in the binary, which means this is the area of intertest.
![image](https://github.com/d4rkc0de-club/h4ckc0n-2023-official-writeups/assets/64488123/4e3c1a59-b365-4124-84f1-b3269dc6870e)

3. In here we see that from line 79 to 85, there are some if statements, which if gets satisfied, the code jumps to main.stuff, so lets inspect that.
![image](https://github.com/d4rkc0de-club/h4ckc0n-2023-official-writeups/assets/64488123/17cc6122-1f61-4d6c-a934-1c1f7c1e625e)

In here we that if the size of password is 0x20, and is equal to this long string then it should go to the main.stuff.
Now, in golang, unlike C/C++, strings are not stored in a null byte terminated fashion, rather, it is stored in a one huge blob of data, and is identified by starting byte and till what offset to compare.
Hence, in our case we see the password gets compared to this huge blob starting at "93a..." upto 32 bytes. We copy and paste this string on to the binary and see that it doesnt print the "oracle wasnt happy" message.
![image](https://github.com/d4rkc0de-club/h4ckc0n-2023-official-writeups/assets/64488123/6e3d00fb-d272-4f8a-8ac3-4829986b8a21)

4. Now let's jump to main.stuff
![image](https://github.com/d4rkc0de-club/h4ckc0n-2023-official-writeups/assets/64488123/a6101af6-44f7-4bd7-a4c9-28b9f5387bee)

We see a net.dial, and get that it's trying to make a TCP connection to 127.0.0.1 and some port.
In line 56, we see a runtime.makeslice, which is calling a syscall.newNetlinkRouteRequest, meaning its trying to send some data.
If, we rename a few variables in ghidra for our understanding, we can get that, it is taking the sha256 sum of the pw we provided and then is sending it to the server.
![image](https://github.com/d4rkc0de-club/h4ckc0n-2023-official-writeups/assets/64488123/8c94d03a-afa6-40b4-9428-4711933609ab)

So let's find out the sha256 sum of the password we found
![image](https://github.com/d4rkc0de-club/h4ckc0n-2023-official-writeups/assets/64488123/10b0e567-b53c-4b8b-82a4-4afd9a0c50a6)

5. Now, since we can't send it to 127.0.0.1, and we have a connection port for this challenge, we can try sending it there
![image](https://github.com/d4rkc0de-club/h4ckc0n-2023-official-writeups/assets/64488123/2002b440-13e9-4c8e-a458-257dc14eae25)

And yep, we get our flag.
