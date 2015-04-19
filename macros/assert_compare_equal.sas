/* ----------------------------------------------------------------
 * <doc>
 * @purpose Generates an event if two data sets are not the same,
 *  as compared by PROC COMPARE.
 * @param BASE - Base data set to compare
 * @param COMPARE - Comparison data set to compare
 * @param CRITERION - (optional) value used to specify the precision of
 *  of numeric comparisons. See SAS PROC COMPARE documentation for
 *  a complete description of the CRITERION option.
 * @param METHOD - (optional) specifies the type of test that will be 
 *  used to compare numeric values. See the SAS PROC COMPARE documentation
 *  for a complete description of the METHOD option.
 * @param VAR - (optional) variable list to explicitly compare a subset
 *  of all variables
 * @param TYPE - The event type, a string that describes a kind of event
 * @param LEVEL - The severity level of the event (ERROR|WARNING|INFO|DEBUG)
 * @param MESSAGE - A text message explaining the event details.
 * @param ATTACHDATA - A space-delimited list of data sets to attach to the
 *  event.
 * @param ATTACHFILE - A fully-qualified delimited list of files to attach
 *  to the event.  Use &PATHSEP as a delimiter.
 * @param METRIC - Optional numeric metric associated with event
 * @param PROPERTIES - Optional event custom properties.  Format is 
 *  /prop1=val1/prop2=val2/.  The first character defines the separator,
 *  and can be a character other than '/'.  An arbitrary number of 
 *  properties may be passed in this format.
 * @param ON_EVENT - Optional block of SAS code to execute 
 *  if the event is fired.
 * @param DESCRIPTION - Optional quoted string describing the event that
 *  is to be generated. 
 * @param ABORT - Flag instructing the event system if it should end
 *  the SAS session and stop the batch run.  Valid values are
 *  (YES|TRUE|NO|FALSE)
 * @macro %generate_event
 * </doc>
 *
 * FUTS v1.1
 * Copyright (c) 2002 ThotWave Technologies, LLC. All rights reserved.
 * ---------------------------------------------------------------- */

%macro assert_compare_equal( BASE=, COMPARE=, VAR=, CRITERION=, METHOD=,
        MESSAGE=Data set &COMPARE not equal to &BASE,
        TYPE=,
        LEVEL=,
        ATTACHDATA=,
        ATTACHFILE=,
        METRIC=,
        PROPERTIES=,
        ON_EVENT=,
        DESCRIPTION=, ABORT= );

%let futs_tst_cnt = %eval(&futs_tst_cnt.+1);

proc compare base=&BASE compare=&COMPARE
  %if &CRITERION ^= %then criterion = &CRITERION. 
  %if &METHOD ^= %then method=&method.;
  %if &VAR ^= %then var &VAR.;;
  run;

%*put LOG: after proc compare, sysinfo is &SYSINFO;

%if &SYSINFO ne 0 %then 
    %generate_event(TYPE=&TYPE, LEVEL=&LEVEL, 
         MESSAGE=&MESSAGE,
         ATTACHDATA=&ATTACHDATA, ATTACHFILE=&ATTACHFILE,
         METRIC=&METRIC,
         PROPERTIES=&PROPERTIES,
         ON_EVENT=&ON_EVENT,
         DESCRIPTION=&DESCRIPTION, ABORT=&ABORT);

%mend assert_compare_equal;
