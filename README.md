# futs
Unit testing for SAS programs

This system of unit testing is based on FUTS (Framework for Unit 
Testing SAS programs) by ThotWave(www.thotwave.com).
The supplied macros where modified to perform automatic counting
of tests and errors.

The method of testing is also altered. The original program used
one SAS file per test. Running the tests and reporting was done 
via a Perl script.

This modified version uses one SAS file which contains macros as
the individual tests. Reporting is done completely in SAS. 
