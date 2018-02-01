# Codes hand-written in pure assembly (ARM + x86)
### Can be tested using [ARMSIM](http://armsim.cs.uvic.ca/)

Index and description of Codes:

A.s :  This is a program that takes input in form of number of integers, followed by the integers, and outputs their sum.

B.s : This program takes input n, and prints the n'th Fibonacci number in reverse.

C.s : This program takes and input string of length n, and prints out the CRC32 checksum of the string as a signed integer. This version uses brute-force method of bit by bit calculation.

D.s : This is optimised CRC32 checksum calculation using pre-computed tables. 

Note: You need to enable the SWI package in ARMSIM and set up an input file with appropriate input for the codes to work.

(The above are ARM Assembly codes)


add.asm : This is a simple program defining two functions add and add2, add takes two integers and returns the sum, while add2 takes address of two integers and returns the sum.

(The above is x86 Assembly code)