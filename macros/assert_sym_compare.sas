/* ----------------------------------------------------------------
 * <doc>
 * @purpose Generates an event if the arguments do not meet the 
 *  comparison criteria where comparison is of the form
 *  ARG1 OPERATOR ARG2. If comparison is false an error is
 *  generated.
 * @param ARG1 - the value to compare to the second argument
 * @param ARG2 - the value to compare to the first argument
 * @param OPERATOR - the operator you wish to use to make the comparisons 
 *  (e.g., NE, GT, GE, EQ, LT, LE).
 * @param DATATYPE - optional parameter, default is to perform
 *  a character comparison test. If the parameter is set
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
 *  precision. The PRECISION value is as specified in all numeric
 *  comparisons. The comparisons that involve testing if one argument 
 *  is greater or less than the other argument use the PRECISION value
 *  to test if the values are equal within the precision limit. If they
 *  do test equal then they cannot be strictly greater than or less than
 *  one another and the test will generate an error. The PRECISION value
 *  is not used in the actual test if one value is greater or less than
 *  another. The PRECISION parameter documentation has 
 *  additional information related to using the numeric comparison method. 
 * @param PRECISION - optional parameter that defaults to 1E-15. If the 
 *  DATATYPE parameter is set to NUMERIC or HEX the PRECISION parameter is 
 *  used in the following function to test if two values are equal.
 *  if abs((ARG1-ARG2)/DIV) > PRECISION then the values are different.
 *  In this function DIV is the max(abs(ARG1),abs(ARG2)) unless exactly
 *  one of the two values is is zero. If one value is zero, the other value
 *  is set to DIV.
 *  Note that there are cases where this comparison function may perform
 *  poorly. Testing should be performed using a range of expected values
 *  to confirm that both the function and the value specified in the 
 *  PRECISION parameter are appropriate. If you want to perform numeric
 *  testing without a precision set precision to 0 (the numeral zero).
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
 * Copyright (c) 2005 ThotWave Technologies, LLC. All rights reserved.
 * ---------------------------------------------------------------- */


%macro assert_sym_compare( ARG1, ARG2, OPERATOR, DATATYPE=, PRECISION=1e-15, 
        MESSAGE=Symbol comparison failure &ARG1 &OPERATOR &ARG2,
        TYPE=,
        LEVEL=,
        ATTACHDATA=,
        ATTACHFILE=,
        METRIC=,
        PROPERTIES=,
        ON_EVENT=,
        DESCRIPTION=, ABORT= );

%local FIRE_EVENT;
%LET FIRE_EVENT=0;

%if %upcase(&datatype.) = NUMERIC OR %upcase(&datatype.) = HEX %then %do;
  data _null_;

    /* variable used to pass sas boolean value out of link sections */ 
    rc=.; 

    %if %upcase(&DATATYPE.) = HEX %then %do;
      arg1=input("&ARG1.",hex16.);
      arg2=input("&ARG2.",hex16.);
    %end;
    %else %do;
      arg1=&ARG1.;
      arg2=&ARG2.;
    %end;

    operator=upcase("&OPERATOR.");
    precision=&PRECISION.;

    select (operator);
      when ('EQ') do;
        link testEQ;
        if not(rc) then link event;
      end;
      when ('NE') do;
        link testEQ;
        if rc then link event;
      end;
      when ('GE') do;
        link testEQ;
        if rc then stop;
        link testGT;
        if not(rc) then link event;
      end;
      when ('LE') do;
        link testEQ;
        if rc then stop;
        link testGT;
        if rc then link event;
      end;
      when ('GT') do;
        link testEQ;
        if rc then link event;
        link testGT;
        if not(rc) then link event;
      end;
      when ('LT') do;
        link testEQ;
        if rc then link event;
        link testGT;
        if rc then link event;
      end;
      otherwise do;
        /* an invalid operator was specified */
        link event;
      end;
    end;

    stop;

    testEQ:
      rc = (arg1 = arg2);
      if (precision=0) or (rc) then do;
        return;
      end;
      else do;
        if arg1 = 0 then divisor = arg2;
        else if arg2 = 0 then divisor = arg1;
          else divisor=max( abs(arg1), abs(arg2) );
        rc= NOT ( ( abs((ARG1 - ARG2) / divisor) ) > PRECISION );
      end;
    return;

    testGT:
      rc = (arg1 > arg2);
    return;

    event:
      code_str='%let FIRE_EVENT=1;';
      call execute(code_str);
      stop;
    return;
  run;
%end;
%else %do;
  %if not (&ARG1 &OPERATOR &ARG2) %then %do;
    %let FIRE_EVENT=1;
  %end;
%end;

%let futs_tst_cnt = %eval(&futs_tst_cnt.+1);

%if &FIRE_EVENT = 1 %then %do;
      %generate_event(TYPE=&TYPE, LEVEL=&LEVEL, 
           MESSAGE=&MESSAGE,
           ATTACHDATA=&ATTACHDATA, ATTACHFILE=&ATTACHFILE,
           METRIC=&METRIC,
           PROPERTIES=&PROPERTIES,
           ON_EVENT=&ON_EVENT,
           DESCRIPTION=&DESCRIPTION, ABORT=&ABORT);
%end;


%mend assert_sym_compare;
