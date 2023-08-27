1. First we will start with the entry function since the binary is stripped. and identify the main function.
![image](https://github.com/d4rkc0de-club/h4ckc0n-2023-official-writeups/assets/64488123/ca3f5849-951d-4876-a42c-dbeab08acff4)

The main function is the first argument to __libc_start_main, so lets rename it for our reference and jump there.

2. Now we are presented with this decompilation from ghidra
![image](https://github.com/d4rkc0de-club/h4ckc0n-2023-official-writeups/assets/64488123/d9b8a67b-f50f-487c-b6f0-c20a4ec40860)

We can read the code, get an essence of it and rename and retype the variables for our ease. We also need to remeber that in C++ new and delete are used to dyanamic arrays or objects of classes, and in our case we see the pointer is passed to a function which looks like a constructor hence we assume it to be an object.
![image](https://github.com/d4rkc0de-club/h4ckc0n-2023-official-writeups/assets/64488123/d7639395-9ab7-40f0-9c5c-457263f8ddba)

3. Using these we identify our target function
![image](https://github.com/d4rkc0de-club/h4ckc0n-2023-official-writeups/assets/64488123/289fae83-5e26-43dd-8525-da6156b753fb)

4. In line 21 we see some part of the flag which is "d4rk" and in line 23 we see that the '}' has the highest offset 0x23, hence we know the flag format is `d4rkc0de{}`, hence we know characters 0-8 and 35th character (0 based indexing).
5. In line 24, we see that the characters in offset 0xc == 0x10 == 0x13 == 0x18 == '_'.
6. Hence for now we know the flag as `d4krc0de{XXX_XXX_XX_XXXX_XXXXXXXXXX}`, where all the X's are unknown.
7. Now in line 25, from the if statement we make the flag `d4krc0de{X++_XXX_XX_XXXX_XXXXXXXXXX}`
8. Now from lines 27-29 we make the 13th char which is `r`, hence `d4krc0de{X++_rXX_XX_XXXX_XXXXXXXXXX}`.
9. From line 34 we make `d4krc0de{X++_r3X_1X_XXXX_XXXXXXX675}`
10. After that, ine line 38 we make `d4krc0de{X++_r3v_1s_XXXX_XXXXXXX675}`
11. From line 39 to 46, after reversing we make, `d4krc0de{X++_r3v_1s_ezpz_XXXXXXX675}`
12. After that from 47 to 49 `d4krc0de{X++_r3v_1s_ezpz_XdghbXd675}`.
13. Now, since we knew it was a C++ challenge, hence we could guess the first X to be C, hence `d4krc0de{C++_r3v_1s_ezpz_XdghbXd675}`
14. Now due to compiler optimization the rest chars are not clear, we could guess these chars but it would be considered guessy, so to tackle this we did some regex matching by to match the rest of the flag and simply put a wildcard at the places of X's.
15. So, that whatever flag user's submit (whatever chars they have in the place of X, it gets submitted)
