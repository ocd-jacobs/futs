/* ----------------------------------------------------------------
 * <doc>
 * @purpose Generates an event if a data set has no observations,
 *  or if the data set does not exist.
 * @param DS - Name of data set to check
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

%macro assert_not_empty( DS,
        MESSAGE=,
        TYPE=,
        LEVEL=,
        ATTACHDATA=,
        ATTACHFILE=,
        METRIC=,
        PROPERTIES=,
        ON_EVENT=,
        DESCRIPTION=, ABORT= );

%local EVENT_COUNT DS_EXIST;
%let EVENT_COUNT = 0;
%let DS_EXIST = %exist(&DS);
%*put LOG: ds_exist = <&DS_EXIST.>;

%if &DS_EXIST eq 0 %then %do;
    %let EVENT_COUNT = 1;
    %if &MESSAGE = %str() %then %let MESSAGE = Data set &DS does not exist;
%end;
%else %do;
    %if %obs(&DS) eq 0 %then %do;
        %let EVENT_COUNT = 1;
        %if &MESSAGE = %str() %then 
            %let MESSAGE = Data set &DS is empty;
    %end;
%end;

%let futs_tst_cnt = %eval(&futs_tst_cnt.+1);

%if &EVENT_COUNT gt 0 %then 
    %generate_event(TYPE=&TYPE, LEVEL=&LEVEL, 
         MESSAGE=&MESSAGE,
         ATTACHDATA=&ATTACHDATA, ATTACHFILE=&ATTACHFILE,
         METRIC=&METRIC,
         PROPERTIES=&PROPERTIES,
         ON_EVENT=&ON_EVENT,
         DESCRIPTION=&DESCRIPTION, ABORT=&ABORT);

%mend assert_not_empty;
