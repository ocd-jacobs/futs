/*  Source: setup.sas
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
 *  Purpose: To be included in programs that use modified futs unit testing.
 *  
 *  Method: This file needs to be included in the unittest file to setup the environment for
 *          modified futs unit testing. It performs three standard functions:
 *          - set the directory where the modified futs macros can be found;
 *          - includes the futs_macros.sas file;
 *          - prepares the test report file.
 *          
 *          The user can modify this file to execute application specific setup code.
 *
 *  Modified FUTS v1.1
 *  Copyright (c) 2015 John Jacobs. All rights reserved.
 */
 

/* Modified futs specific setup code.
 */
  %let futs_directory = /folders/myfolders/futs/macros;
  %include "&futs_directory./futs_macros.sas";
  %futs_prep_report;
  
/* ******************************************************************************************** */

/* <application specific code goes here> */

/* ******************************************************************************************** */
