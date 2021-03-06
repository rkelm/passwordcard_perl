# passwordcard_perl
State: RELEASED DEVELOPMENT_ENDED  
This simple perl script generates a scrambled table of your passwords to be printed/saved as a password card. Input and output are plain text files in 8-bit character encoding. Scrambled passwords may be safer to keep written down or saved on disk, than unscrambled passwords. Somebody knowing any one of your scrambled passwords will be able to read all other passwords! So keep your scrambled password card hidden.
Use only when there is no safer method to store your passwords, like using a password manager or remembering your passwords.

The scrambled passwords can be read with the help of the master password defined at creation time. The master password must not contain any character more than once! One scrambled password card can contain up to 8 passwords. Optionally a short hint can be specified for each password, this could be the username corresponding to the password or the name of the service to login in to. The hints are written unscrambled on the upper, lower, right and left sides of the scrambled table. 

# Reading a scrambled password card
To use the password card you will most likely need to add row and column lines. The first and last column and the first and last row may contain hints describing the passwords. The other rows and columns are grouped in 3x3 squares (3 rows and 3 columns). The middle field of each 3x3 square is the master field, containing a single character of the master password. The master field is surround by 8 password fields, each containg a single character of one password. To which password the character belongs depends on the position of the password field to the master field in the 3x3 square. 

To read a password from the scrambled password table, find the hint describing the password you plan to read. The position of the hint equals the position of the corresponding password field relative to the master field. Find the first character of the master password in all the available master fields. 

Simple example for an output file, unformated and raw:
```
aaaa bbbb cccc
 HgaabcabcHA§ 
d1ArdCedEeYGWe
dF&Qfghfgh1THe
düKiabcabc###e
dgHXdBedDe#F#e
 &B3fghfgh### 
ffff gggg hhhh
```
The same example output file formated with row and column lines: 
```
aaaa bbbb cccc
-------------------
 |Hga|abc|abc|HA§| 
d|1Ar|dCe|dEe|YGW|e
d|F&Q|fgh|fgh|1TH|e
-------------------
d|üKi|abc|abc|###|e
d|gHX|dBe|dDe|#F#|e
 |&B3|fgh|fgh|###| 
-------------------
ffff gggg hhhh
```
The example scrambled table contains 8 squares each with 3x3=9 characters, surrounded by 8 hints "aaaa", "bbbb", "cccc", "dddd", "eeee", "ffff", "gggg" and "hhhh". The example master password is "BCDEF". To read the password for the hint "cccc", find where the hint "cccc" is located. It's located on upper right of the scrambled table. This is the position the password characters will have in each square. Next find the square having the first character of the master password in the center. The first character of the master password is "B", so the first square to read is the second square in the lower row of squares. The middle field shows a "BW. The field in the upper right of the square is a "c". It is the first character of the password belonging to hint "cccc". Repeat for the next character, find the square showing "C" in the middle. It's the second sqare on the uper row of squares. The next password character for hint "cccc" is "c". Keep repeating. You will end up with "cccc#". In this example "#" was defined as the end character. It's not part of the password, so password corresponding to hint "cccc" is "cccc".

# Usage
Usage example: ```./pwcard_create.pl < test_pwcard.def > new_pwcard```

# Input file format
The input file contains your plain text passwords and even the scrambled output table. Save it only on an encrypted volume!

The input file must only contain linux line ending (LF). 
Input file format is:
1. line: master password. The master password must be at least as long as the longest password.

2. line: filler chars. master pw + filler chars valid sums = 1x2=2, 2x4=8, 3x6=18, 4x8=32, 5x10=50, 6x12=72, 7x14=98, 8x16=128, 9x18=162, 10x20=200

3. line password end characters

4. line: hint for first password

5. line: hint for second password

6. line: second password

7. ... Repeat hint and password, each on one line. Up to a total of 8 hints and passwords possible.

Filler chars are characters not contained in any password, master or other, which are used to fill up the scrambled table randomly. The more filler chars, the bigger the scrambled table, the harder it should be to guess the passwords, the more secure the scrambled table.

# Notes on security 
Only use this in situations to protect written or saved passwords. It may be a bit more secure than writing down a password in plain text, but there are safer ways to protect your passwords.
