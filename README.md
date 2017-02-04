# passwordcard_perl
This simple perl script generates a scrambled table of your passwords to be printed/saved as a password card. Input and output are plain text files in 8-bit character encoding. Scrambled passwords may be safer to keep written down or saved on disk, than unscrambled passwords. Somebody knowing any one of your scrambled passwords will be able to read all other passwords! So keep your scrambled password card hidden.
Use only when there is no safer method to store your passwords, like using a password manager or remembering your passwords.

The scrambled passwords can be read with the help of the master password defined at creation time. The master password must not contain any character more than once! One scrambled password card can contain up to 8 passwords. Optionally a short hint can be specified for each password, this could be the username corresponding to the password or the name of the service to login in to. The hints are written unscrambled on the upper, lower, right and left sides of the scrambled table. 

# Reading a scrambled password card
To use the password card you will most likely need to add row and column lines. The first and last column and the first and last row each contain up to three hints. The other rows and columns are grouped in 3x3 squares (3 rows and 3 columns). The middle field of each 3x3 square is the master field, containing a single character of the master password. The master field is surround by 8 password fields, each containg a single character of one password. To which password the character belongs depends on the position of the password field to the master field in the 3x3 square. 

To read a password off the scrambled password table, find the hint describing the password you plan to read. The position of the hint equals the position of the corresponding password field relative to the master field. Find the first character of the master password in all the available master fields. 

Simple example for a output file, unformated and raw:
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
The example scrambled table contains 8 squares each with 3x3=9 characters, surrounded by 8 hints "aaaa", "bbbb", "cccc", "dddd", "eeee", "ffff", "gggg" and "hhhh". The example master password is "BCDEF". To read the password for the hint "cccc", find where the hint "cccc" is located. It's located on upper right of the scrambled table. This is the position the password characters will have in each square. Next find the square having the first character of the master password in the center. The first character of the master password is "B", so the first square to read is the second square in the lower row of squares. The middle field shows a "BW. The field in the upper right of the square is a "c". It is the first character of the password belonging to hint "cccc". Repeat for the next character, find the square showing "C" in the middle. It's the second sqare on the uper row of squares. The next password character for hint "cccc" is "c". Keep repeating. You will end up with "cccc#". In this example "#" was defined as the end character. It's not part of the password. So the password for hint "cccc" is "cccc".

# Usage
Usage example: ```./pwcard_create.pl < test_pwcard.def > new_pwcard```


# Input file format
The input file contains your plain text passwords and even the scrambled output table

# Notes on security 

