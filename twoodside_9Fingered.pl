#!/usr/bin/perl

# Name          : Tyler Woodside
# Class         : 2850-001
# Program #     : 9
# Due Date      : November 1
#
# Honor Pledge  : On my honor as a student of the University of Nebraska at Omaha,
#                 I have neither given nor received unauthorized help on this
#                 homework assignment.
# NAME:         Tyler Woodside
# EMAIL:        twoodside@unomaha.edu
# NUID:         615
# Colleagues:   NONE
#
# Implement the soundex algorithm into the functionality of the finger program

use strict;
use warnings;
use v5.14; #There's a switch statement down there somewhere.

if ($#ARGV!=0 || ($ARGV[0]!~/[a-z]{2,8}[a-z]*/i) ){ #If no commandline argument.
    print("Usage: $0 <name>\n");
    exit(0);
}

#Get the name and associated soundex code
my $userName=$ARGV[0]; 
my $soundCode=soundex($userName);

#Get all users matching that soundex code
my @command=getUsers();
my @sameSoundUsers=getSounds($soundCode,\@command);

#Print the code and all users matching
print("The name you were looking for, $userName, converted to $soundCode.\n\n");
printUsers(@sameSoundUsers);

#getUsers();
#Returns an array of all users of the system.
sub getUsers{
    my @r;
    
    open(IN,"/home/rfulkerson/passwd");
    @r = <IN>;
    close IN;

    return @r;
}

#getSounds($soundexCode,\@toSearch);
#Returns all users in the search that match $soundexCode.
sub getSounds{
    my @r;
    my ($sound,$search)=@_;

    foreach my $line (@$search){
        #(\w+) - login name: twoodside
        #.*? - Find all the stuff up to the first and last name.
        #: - delimits the name field.
        #The next parts are optional. This is for cases like "test" which don't have a name field, but are still supported by finger.
        #([a-z'-]+) - First name: Tyler
        #\s+(?:\S*\s*)*?\b - as many spaces and middle names as can possibly be found before the last name.
        #([a-z'-]+) - Last name: Woodside
        #,.*,.*,.* - User information. Literally only used by rfulkerson. 0 other users have any information in this field. He must be a p cool guy, rfulkerson.
        #: - End of the name field.
        #.* - To the end of the line, not that it matters.
        if ($line =~ /^(\w+).*?:(?:([a-z'-]+)\s+(?:\S*\s*)*?\b([a-z'-]+),.*,.*,.*)?:.*/i){
            # if the username matches, or if there's a first name and last name and either of them match.
            if ( $sound ~~ soundex($1) || ( defined($2) && ($sound ~~ soundex($2) || $sound ~~ soundex($3) ) ) ){
                push(@r,$1); #Remember the username to print out later.
            }
        }
    }

    return @r;

}

#printUsers(@usernamesToPrint);
#Prints out the finger info for all usernames in the passed array.
#Returns 1 for success, of which it always has.
sub printUsers{
    my @users=@_;
    foreach (@users){
        my @t=("finger",$_);
        system(@t);
        print("\n");
    }
    return 1;
}

#soundex($word);
#Returns a 5 long soundex code for the passed word.
sub soundex{
    my $word=shift();
    my $sdxValue="";

    $sdxValue.=uc substr($word,0,1);#Add an uppercase version of the first letter of the word
    my $i=1;
    my $prevValue=soundexCode($sdxValue);
    while (length($sdxValue)<5 && $i<length($word)){ #Go until the soundex value is 5 long or the end of the word.
        #Add the soundex number corresponding to each letter, as long as its supported.
        my $currentValue=soundexCode( substr($word,$i,1) );
        if ($currentValue!=$prevValue && $currentValue!=0){ #Make sure two of the same letter aren't being added next to eachother.
            $sdxValue.=$currentValue;
        }
        $prevValue=$currentValue;
        $i++;

    }
    while (length($sdxValue)<5){ #Fill the value in with zeros if it's too short.
        $sdxValue.="0";
    }

    return $sdxValue;
}

#soundexCode($letter)
#returns the soundex code which corresponds to the passed letter.
sub soundexCode{
    my $letter=shift();
    my $r=0;
    given ($letter){
        when (/[bfpv]/i)    {$r=1;}
        when (/[cgjkqsxz]/i){$r=2;}
        when (/[dt]/i)      {$r=3;}
        when (/[l]/i)       {$r=4;}
        when (/[mn]/i)      {$r=5;}
        when (/[r]/i)       {$r=6;}
    }
    return $r;
}
