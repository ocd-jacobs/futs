/*  Source: futs_macros.sas

    Author: John Jacobs
    Date  : 15-04-2015
    
    SAS version: 9.3
    
    Purpose: To be included in programs that use modified futs unit testing.
    
    Notes: This system of unit testing is based on FUTS (Framework for Unit 
           Testing SAS programs) by ThotWave(www.thotwave.com).
           The supplied macros where modified to perform automatic counting
           of tests and errors.
           
           The method of testing is also altered. The original program used
           one SAS file per test. Running the tests and reporting was done 
           via a Perl script.
           
           This modified version uses one SAS file which contains macros as
           the individual tests. Reporting is done completely in SAS.
 */

/* Set maximun number of tests per test case. */
  %let FUTS_MAX_TESTS = 100;

/* Include the modified futs macros needed for unit testing
 */
  %include "&futs_directory./assert_compare_equal.sas";
  %include "&futs_directory./assert_empty.sas";
  %include "&futs_directory./assert_equal.sas";
  %include "&futs_directory./assert_error_occurred.sas";
  %include "&futs_directory./assert_exist.sas";
  %include "&futs_directory./assert_fexist.sas";
  %include "&futs_directory./assert_filecompare_equal.sas";
  %include "&futs_directory./assert_fileexist.sas";
  %include "&futs_directory./assert_not_compare_equal.sas";
  %include "&futs_directory./assert_not_empty.sas";
  %include "&futs_directory./assert_not_equal.sas";
  %include "&futs_directory./assert_not_exist.sas";
  %include "&futs_directory./assert_not_fileexist.sas";
  %include "&futs_directory./assert_not_null.sas";
  %include "&futs_directory./assert_not_zero.sas";
  %include "&futs_directory./assert_null.sas";
  %include "&futs_directory./assert_sym_compare.sas";
  %include "&futs_directory./assert_zero.sas";
  %include "&futs_directory./exist.sas";
  %include "&futs_directory./expect_error.sas";
  %include "&futs_directory./fexist.sas";
  %include "&futs_directory./fileexist.sas";
  %include "&futs_directory./generate_event.sas";
  %include "&futs_directory./obs.sas";

/* %macro futs_prep_report;
     Prepares the test report by erasing all previous content.
     Prints the source file name as header.
 */
  %macro futs_prep_report;
    data _null_;
      file futs_rpt;
      put "** &futs_src.";
      put;
    run;
  %mend;

/* %macro futs_tst_finish(test_name);
     Prints the total number of tests performed and the number of failed tests
     for testcase &test_name. to the test report futs_rpt.
 */
  %macro futs_case_finish;
      %let futs_tot_err = %eval(&futs_tot_err.+&futs_tst_err.);
      %let futs_tot_cnt = %eval(&futs_tot_cnt.+&futs_tst_cnt.);
      
      data _null_;
        file futs_rpt mod;        
        length l $ 120;

        l = lowcase("&futs_macro_name.");
        l = strip(l) || ": &futs_case_description.";
        l = strip(l) || " (&futs_tst_cnt. tests / &futs_tst_err. errors)";
        
        l = strip(l) ||
            repeat(' ', 70 - length(l)) ||
            ifc(&futs_tst_err. = 0, '** passed **', '** FAILED **');

        put @4 l;  
        
        do i = 1 to &futs_test_descr_n.;
           l = symget('futs_test_descr' || strip(put(i,3.)));
           put @8 '>> ' l;
        end;
      run;
      
      %let futs_tst_cnt=0;   
      %let futs_tst_err=0;   
  %mend;
  
/* %macro futs_tot_finish;
     Prints the total number of tests performed and the number of failed tests
     for source file &futs_src. to the test report futs_rpt. 
 */
  %macro futs_tot_finish;
    data _null_;
      file futs_rpt mod;
      length l $ 120;
       
      put;
      
      l = "** &futs_src.: " ||
           ifc(&futs_tot_err. = 0, "&futs_tot_cnt.", "&futs_tot_err.") ||
           " out of &futs_tot_cnt. tests " ||
           ifc(&futs_tot_err. = 0, 'tests passed => GREEN', 'tests failed => RED');
       
      put l;    
    run;
  %mend;

/* Create macro array &futs_test_descr.
   This array will contain the descriptions of failed tests. 
 */
  %macro futs_init_array;
    %do i = 1 %to &FUTS_MAX_TESTS.;
      %global futs_test_descr&i;
      %let futs_test_descr&i = -;
    %end;
    
    %global futs_test_descr_n;
    %let futs_test_descr_n = 0;
  %mend;
  %futs_init_array;
  
/* Initialize a new test case by resetting the array counter of &futs_text_descr.
   to zero.
 */
  %let futs_case_description = -;
 
  %macro futs_case_init(case_description);
    data _null_;
      call symputx('futs_case_description', &case_description.);
      call symputx('futs_test_descr_n', 0);
    run;
  %mend;
  
/* Check if the counting variables are already defined indicating either an interupted
   unittest execution or the variable name being used somewhere in user defined code.
   If variables are found to be defined write an error message to the log file and
   abort the test.
 */
  data _null_;
    if %symexist(futs_tst_err) then put 'ERROR: macro variable FUTS_TST_ERR already defined.';
    if %symexist(futs_tot_err) then put 'ERROR: macro variable FUTS_TOT_ERR already defined.';
    if %symexist(futs_tst_cnt) then put 'ERROR: macro variable FUTS_TST_CNT already defined.';
    if %symexist(futs_tot_cnt) then put 'ERROR: macro variable FUTS_TOT_CNT already defined.';
  run;
  
  data _null;   
    if  %symexist(futs_tst_err) or
        %symexist(futs_tot_err) or 
        %symexist(futs_tst_cnt) or 
        %symexist(futs_tot_cnt) then 
    do;
      abort cancel;
    end;
  run;

/* Initialize the counting variables.
 */
  %let futs_tst_err = 0;
  %let futs_tot_err = 0;
  
  %let futs_tst_cnt = 0;
  %let futs_tot_cnt = 0;

/* Initialize the macro variable that will contain the name of the running test case
 */
  %let futs_macro_name = -;
    