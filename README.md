# passwordcard_perl
Simple perl script to generate a scrambled table of your passwords to be printed/saved as a password card.

The scrambled passwords may be safer to keep written down, than unscrambled passwords. The scrambled passwords can be read with the help of the master password defined at creation time. The master password must not contain any character more than once! One scrambled password card can contain up to 8 passwords. Optionally a short hint can be specified for each password. The hints are written unscrambled on the sides of the scrambled table. 

# Reading a scrambled password card
To use the password card you will most likely need to add row and column lines. The first and last column and the first and last row each contain up to three hints. The other rows and columns are grouped in 3x3 squares (3 rows and 3 columns). The middle field of each 3x3 square is the master field, containing a single character of the master password. The master field is surround by 8 password fields, each containg a single character of one password. To which password the character belongs depends on the position of the password field to the master field in the 3x3 square. 

To read a password off the scrambled password table, find the hint describing the password you plan to read. The position of the hint equals the position of the corresponding password field relative to the master field. Find the first character of the master password in all the available master fields. 

Simple example:

aaaa bbbb cccc
 HgaabcabcHA§ 
d1ArdCedEeYGWe
dF&Qfghfgh1THe
düKiabcabc###e
dgHXdBedDe#F#e
 &B3fghfgh### 
ffff gggg hhhh

Master

# Usage
Usage example: ./pwcard_create.pl < test_pwcard.def > new_pwcard

The Takes defintion file as i

and outputs a password card on standard output.
See first lines of pl file for format of definition file.

# Input file format


# Notes on security 

