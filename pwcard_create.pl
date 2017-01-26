#!/bin/perl
use strict;
use warnings;

# ToDo
# 

# Input file must only contain linux line ending (LF).
# Input file format is:
# 1. line: master password.
# 2. line: filler chars. master pw + filler chars valid sums = 1x2=2, 2x4=8, 3x6=18, 4x8=32, 5x10=50, 6x12=72, 7x14=98, 8x16=128, 9x18=162, 10x20=200
# 3. password end characters
# 4. line: hint for password
# 5. password
# Repeat hint and password, each on one line.

# **** subroutines *****
sub colrow2square {
    my $col = $_[0];
    my $row = $_[1];
    my $max_cols = $_[2];
    my $square = int(($col-1)/3)+1+int(($row-1)/3)*$max_cols;
    return $square;
}

# Read PWCard Definition
chomp(my $master = <STDIN>); # Master PW.
chomp(my $valid_chars = <STDIN>); # Valid Characters for master PW.

# Remove duplicate chars.
$valid_chars =~ s/(.)(?=.*?\1)//g;

my $valid_chars_all="$master$valid_chars";
# Remove duplicate chars.
$valid_chars_all =~ s/(.)(?=.*?\1)//g;

my @valid_chars_ar = sort split //, $valid_chars_all;
my $max_pw_length = @valid_chars_ar;

# Table layout is 1 row by 2 columns, valid sizes = length(@valid_chars_all): 1x2=2, 2x4=8, 3x6=18, 4x8=32, 5x10=50, 6x12=72, 7x14=98, 8x16=128, 9x18=162, 10x20=200
my $square_cnt_rows = int(sqrt($max_pw_length/2));
my $square_cnt_cols = int($square_cnt_rows * 2);

if ($square_cnt_rows * $square_cnt_cols != $max_pw_length) {
    die "Total length of master pw and filler chars is $max_pw_length, but must be dividable bei integers to give a 2:3 layout. (For example 1x2=2, 2x4=8, 3x6=18, 4x8=32, 5x10=50, 6x12=72, 7x14=98, 8x16=128, 9x18=162, 10x20=200.)"
}

# Each Square consists of three rows and three columns = 9 fields for a single character. And there is one top and one bottom row, and one left and right column, at the sides of the grid.
my $card_cnt_rows = $square_cnt_rows*3+2;
my $card_cnt_cols = $square_cnt_cols*3+2;

chomp( my $end_chars = <STDIN>); # Characters signaling end of PW.

# Read passwords.
my @hint; # Hints about password usage.
my @pw; # Passwords.
my $i = 0;

while ($hint[$i] = <STDIN>)
{
    chomp($hint[$i]);
#    print $hint[$i]."\n";
    chomp($pw[$i++] = <STDIN>);
};

# Check max. 8 Passwords.
die "Maximum of 8 Passwords possible." 
    if (@pw > 8);

my @rnd_letters = ('a'..'z','A'..'Z','0'..'9');
my @rnd_chars = (@rnd_letters, ('ü','ö','ä','Ü','Ö','Ä','§','$','%','&','/','(',
    ')','=','?','+','*','-','_','#','<','>','ß'));

# Add end character string to passwords und fill to max length.
for my $i (0 .. @pw-1) {
    $pw[$i] .= $end_chars;
    die "A password must not be longer than master password."
      if (length($pw[$i]) > $max_pw_length);
    for (length($pw[$i]) .. $max_pw_length-1) {
        $pw[$i] .= $rnd_chars[int rand @rnd_chars]
    }
}

{
# Fill up master pw with randomized valid chars to max pw length.
# First remove chars contained in master pw.
    my $valid = $valid_chars;
    eval "\$valid =~ tr/$master//d";
    my @rnd_valid_chars = sort split //, $valid;
    while (scalar @rnd_valid_chars > 0) {
        $master .= splice(@rnd_valid_chars, int rand @rnd_valid_chars, 1);
    }
}

# Randomly fake missing passwords.
for my $i (@pw .. 8) {
    for my $j (0 .. 4) { $hint[$i] .= $rnd_letters[int rand @rnd_letters] };
#    print $hint[$i]."\n";
    for my $j (0 .. $max_pw_length-1) { $pw[$i] .= $rnd_chars[int rand @rnd_chars] };
#    print $pw[$i]."\n";
}

# Every output row.
for my $row (0..$card_cnt_rows-1) {
    if ($row == 0) {
        # Top row contains the  first 3 hints.
        print "$hint[0] $hint[1] $hint[2]\n";
        next
    }
    if ($row == $card_cnt_rows-1) {
        # Last row contains the  last 3 hints.
        print "$hint[5] $hint[6] $hint[7]\n";
        next
    }
    
    # Every output column.
    for my $col (0 .. $card_cnt_cols-1) {
        # First column contains one letter of fourth hint.
        if ($col == 0) {
            # One blank field, for easier reading or if hint is empty or shorter.
            if ($row == 1 || length($hint[3]) < $row-1 ) { 
                print " "
            } else {
                print substr($hint[3],$row-2,1)
            }
            next
        }
    
        # Last column contains one letter of the fifth hint.
        if ($col == $card_cnt_cols-1 ) {
            # Blank field, for easier reading or if hint is empty or shorter.
            if ($row == 1 || length($hint[4]) < $row-1) {
                print " \n"
            } else {
                print substr($hint[4],$row-2,1)."\n"
            }
            next
        }
        
        my $square = int(colrow2square($col,$row,$square_cnt_cols));
        
        # Scramble up the squares a bit, to hide the order of valid_chars. This is optional.
        $square =  int(($square-1)/$square_cnt_cols) + 1 + (($square-int(($square-1)/$square_cnt_cols)-1)%$square_cnt_cols)*$square_cnt_rows;
        
        # Is it the middle field of a 3x3 square?
        if ($col % 3 == 2 && $row % 3 == 2) {
            # Then print the corresponding letter
            print $valid_chars_ar[$square-1];
        } else {
            # Find index of password to print.
            my $pw_i = ($col-1) %3 + 1 + (($row-1)%3)*3;
            $pw_i -= 1 if ($pw_i > 4);
            $pw_i -= 1;
            
            # Find pw character to print.
            my $i = 0;
            for my $j (0..length($master)-1) {
                if (substr($master,$j,1) eq $valid_chars_ar[$square-1]) {
                    print substr($pw[$pw_i],$j,1);
                    last
                }
            }
        }
    
    } # for my $col
} # for my $row

