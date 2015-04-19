/* ----------------------------------------------------------------
 * <doc>
 * @purpose Generates an event if two arguments are equal.
 * @param ARG1 - one of the values to check for equality
 * @param ARG2 - one of the values to check for equality
 * @param DATATYPE - optional parameter, default is to perform
 *  an exact character comparison test. If the parameter is set
 *  to NUMERIC or HEX a numeric test will be performed that uses 
 *  the value in the PRECISION parameter to test if two numbers 
 *  are close enough to be considered equal. If any other value 
 *  or no value is specified an exact character test for equality 
 *  is performed. If DATATYPE is specified as NUMERIC, the values
 *  passed to ARG1 and ARG2 are expected to be normal base ten
 *  numeric values. If DATATYPE is specified as HEX, the values
 *  passed to ARG1 and ARG2 are expected to be the hex code values
 *  that correspond to the values to be tested. The hex format
 *  should conform to SAS format hex16.. An example from a data step 
 *  for this conversion which includes storing the value into 
 *  a macro variable would be the following line of code. 
 *  call symput('arg1_value',put(my_number,hex16.));
 *  The HEX option was added because many common methods used 
 *  to store numeric values into macro variables can lead to 
 *  a loss of precision. The HEX method will prevent this loss of 
 *  precision. The PRECISION parameter documentation has 
 *  additional information related to using the numeric comparison method. 
 * @param PRECISION - optional parameter that defaults to 1E-15. If the 
 *  DATATYPE parameter is set to NUMERIC the PRECISION parameter is used
 *  in the following function. 
 *  if abs((ARG1-ARG2)/DIV) > PRECISION then the values are different.
 *  In this function DIV is the max(abs(ARG1),abs(ARG2)) unless exactly
 *  one of the two values is is zero. If one value is zero, the other value
 *  is set to DIV.
 *  Note that there are cases where this comparison function may perform
 *  poorly. Testing should be performed using a range of expected values
 *  to confirm that both the function and the value specified in the 
 *  PRECISION parameter are appropriate.
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
 * Modified FUTS v1.1
 * Copyright (c) 2015 John Jacobs. All rights reserved.
 * ---------------------------------------------------------------- */

%macro assert_not_equal( ARG1, ARG2, DATATYPE=, PRECISION=1e-15,
        MESSAGE=Equal values <&ARG1> and <&ARG2>,
        TYPE=,
        LEVEL=,
        ATTACHDATA=,
        ATTACHFILE=,
        METRIC=,
        PROPERTIES=,
        ON_EVENT=,
        DESCRIPTION=, ABORT= );

%let futs_tst_cnt = %eval(&futs_tst_cnt.+1);

%assert_sym_compare( &ARG1, &ARG2, ne, DATATYPE=&DATATYPE, PRECISION=&PRECISION, 
        MESSAGE=&MESSAGE,
        TYPE=&TYPE,
        LEVEL=&LEVEL,
        ATTACHDATA=&ATTACHDATA,
        ATTACHFILE=&ATTACHFILE,
        METRIC=&METRIC,
        PROPERTIES=&PROPERTIES,
        ON_EVENT=&ON_EVENT,
        DESCRIPTION=&DESCRIPTION, ABORT=&ABORT );

%mend assert_not_equal;
