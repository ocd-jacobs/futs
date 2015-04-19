/*  Source: testunit.sas
 *
 *  Author : John Jacobs
 *  Date   : 15-04-2015
 *  Licence: Eclipse Public License
 *  
 *  version: 1.1
 *  as of  : 19-04-2015
 *  
 *  SAS version: 9.3
 *  
 *  Purpose: Perform a unittest on a user defined source file.
 *  
 *  Method: The user needs to modify the program to;
 *          - set &futs_program_directory. to the directory where the source file that
 *            is to be tested resides.
 *          - set &futs_src. to the name of the source file to be tested.
 *          
 *          The user must then modify this file to include the tests that are to be run
 *          against the source file.
 *          
 *          When the program is run it will:
 *          1) create a file reference for the test report;
 *          2) include and execute the setup file;
 *          3) include the file that is to be tested;
 *          4) perform the unit tests and create a test report;
 *          5) include and execute the teardown file.
 *              
 *  Modified FUTS v1.1
 *  Copyright (c) 2015 John Jacobs. All rights reserved.
 */


/* Modified futs specific code.
 */
  %let futs_program_directory = /* <directory of the file to be tested> */;
  %let futs_src = /* <filename of the file to be tested> */ ;
  
  filename futs_rpt "&futs_program_directory./futs/test_report.txt"; 
  
  %include "&futs_program_directory./futs/setup.sas";
  %include "&futs_program_directory./&futs_src.";
  
/* ******************************************************************************************** */

/* 
  your tests go here using the following code template:
  
  %macro <testcase name>
    %let futs_macro_name = &sysmacroname.;
    %futs_case_init('<testcase description>');

    <your test code using %assert macros>;
  
    %futs_case_finish;
  %mend;

  %<macro name>;
*/

/* ******************************************************************************************** */

/* Modified futs specific code.
 */
  %futs_tot_finish;
  %include "&futs_program_directory./futs/teardown.sas";
  
