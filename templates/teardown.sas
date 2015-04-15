/*  Source: teardown.sas

    Author : John Jacobs
    Date   : 15-04-2015
    
    version: 1.0
    as of  : 15-04-2015
    
    SAS version: 9.3
    
    Purpose: To be included in programs that use modified futs unit testing.
    
    Method: This file needs to be included in the unittest file to tear down the
            environment after modified futs unit testing. It performs two standard functions:
            - releases the file reference futs_rpt;
            - Deletes all macro variables created for the execution of the unittest.
            
            The user can modify this file to execute application specific teardown code.
 */


/* ******************************************************************************************** */

/* <application specific code goes here> */

/* ******************************************************************************************** */


/* Modified futs specific teardown code.
 */
  filename futs_rpt;
  
  %symdel futs_tst_err 
          futs_tot_err 
          futs_tst_cnt
          futs_tot_cnt
          futs_program_directory
          futs_src
          futs_directory;
