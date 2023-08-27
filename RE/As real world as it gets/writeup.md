1. First we will find the main by first going to the entry function and looking at the first parameter of libc_start_main
![first](https://i.imgur.com/WroqebX_d.png?maxwidth=760)

2. Going there we see it checks for a string at the 2nd cmdline arg which translates to root in little endian
![second](https://i.imgur.com/bUCTlPw.png)  ![third](https://i.imgur.com/n9kQEIX_d.png?maxwidth=760)

We also see there is a fork call, meaning it creates a child process and in the parent it waits till child exits and the child does the rest execution
![fourth](https://i.imgur.com/jaXCUKZ_d.png?maxwidth=760&fidelity=grand)

3. We see that the program asks for a password, just like a normal su program in here, and stores its input in the local_828 variable of size 2048 bytes, hence we make some changes in the psuedo code of ghidra and change the variable type to get better psuedo code and after doing that our reversing gets a bit easier as seen
![image](https://user-images.githubusercontent.com/64488123/175617992-e531b10b-f261-45da-b464-59cdd7223fd2.png)

4. Now for our first check we see if the 16th element is a "\n" and our 0th element is a "$" then it moves forward
And for the 1st Check it simply compares the 1st element with "U"
5. For the 2nd check we see it multiplies the character(single byte) with -51 and adds it to 25. Then type casting it to byte, meaning only the LSB of the negative number(massive unsigned number) will be taken for comparison, with 51, and it has to be less than that. And also if the character divided by 27 gives a remainder of 26, then it proceeds further. Doing these checks on a few ASCII bytes gave us the letter "P".
6. For the 3rd, 4th and 5th check, the 4th and 5th check can easily be seen that it is being compared to with an "R" and "\_" respectively. For the 3rd character we see that there is a strtol being called, meaning most likely its a number, but it could be a signed number(both negative and positive). Above that line there is a if statement which checks that if the ascii character of the number -51 should be < 3. The important point here is that it compares 1 ascii character, but to represent negative numbers we need 2  ascii characters, 1 for -, 1 for number, this means that it is a positive number. So it can be anything from 0 to 53. Now lopking at this big if statement the 1st condition will be a 0 due to that many right shifts. The 2nd case after the OR is the number itself AND'ed with -1 divided by 3 should give 0 as a remainder. And this cvondition is AND'ed with the condition that the AND of the ascii byte of the character with 1 will not give 0. With all these conditions doing hit and trial from 0 to 53 we get 51 as our byte, which is "3" in ascii.

So for now the string becomes "$UP3R_"

7. Now comes the next function, renaming and retyping all the variables and adding appropriate comments we get something as follows
![image](https://user-images.githubusercontent.com/64488123/175648853-549c852e-cff0-40f2-8044-ca9e6af2e344.png)


8. Here we see that the first character is "$". And for the rest there is a do while loop and the do while loop terminates when the ptr_param != string[sum].
9. Starting everything from 0, i goes to 0 and ptr_param also goes to 1, now since i != 6 it wont go to the if statement, and the sum will become sum+i. From this do while loop we can infer that string[sum] should be == the password, hence we loop through the string with offsets of sum and get "3CR3T" as the string.

So hence the whole string is "$3CR3T"

10. After that when i == 6, we enter the if statement and see 6th character is "\_". For the 7th character we see we AND it with 0x1fffffff and get 107, so ANDing 0x1fffffff with 107, we get 107 as a result which is "k" in ascii.
11. For the 8th char we right shift 12, 2 times and get the ascii "3". And the last character is Y

Hence our password becomes "$UP3R_$3CR3T_k3Y"