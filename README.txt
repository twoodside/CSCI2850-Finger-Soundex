DESCRIPTION:
This program searches for a given name in the output of the "finger" command on UNO's student linux terminal. the finger command itself returns information about the last few users who logged in. 

The names are searched for using the soundex algorithm, so that near spellings correctly match to a user. For instance, "Tyler" and "Tiler" would both return the same value in the soundex algorithm, because they sound very similar.

This program, along with everything else I did for this class, will only work on UNO's system without modification. That was just the nature of the assignments. 

HOW TO RUN:
./twoodside_9Fingered.pl <First or Last Name>