/* ----------------------------------------------------------------
 * <doc>
 * @purpose Generates an event if two text files identified by name 
 *  are not equal.
 * @param BASE - Base file name to compare
 * @param COMPARE - Comparison file name to compare
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
 * Copyright (c) 2006 ThotWave Technologies, LLC. All rights reserved.
 * ---------------------------------------------------------------- */

%macro assert_filecompare_equal(BASE=, COMPARE=,
        MESSAGE=,
        TYPE=,
        LEVEL=,
        ATTACHDATA=,
        ATTACHFILE=,
        METRIC=,
        PROPERTIES=,
        ON_EVENT=,
        DESCRIPTION=, ABORT= );

%local
    done
    fid0
    fid1
    filrf0
    filrf1
    rcb
    rcc
    rc
    b
    c
    EVENT_MESSAGE
    ;


%let futs_tst_cnt = %eval(&futs_tst_cnt.+1);

%let rc=%sysfunc(filename(filrf0, "&BASE"));
%let rc=%sysfunc(filename(filrf1, "&COMPARE"));
%let fid0=%sysfunc(fopen(&filrf0));
%let fid1=%sysfunc(fopen(&filrf1));

%let rcb=0;
%let rcc=0;

%let done=0;
%if &fid0 = 0 %then 
%do;
    %if &MESSAGE = %str() %then %let EVENT_MESSAGE=File &BASE cannot be read;
    %else %let EVENT_MESSAGE=&MESSAGE;
    %generate_event(TYPE=&TYPE, LEVEL=&LEVEL, 
         MESSAGE=&EVENT_MESSAGE,
         ATTACHDATA=&ATTACHDATA, ATTACHFILE=&ATTACHFILE,
         METRIC=&METRIC,
         PROPERTIES=&PROPERTIES,
         ON_EVENT=&ON_EVENT,
         DESCRIPTION=&DESCRIPTION, ABORT=&ABORT)
%end;
%else %if &fid1 = 0 %then 
%do;
    %if &MESSAGE = %str() %then %let EVENT_MESSAGE=File &COMPARE cannot be read;
    %else %let EVENT_MESSAGE=&MESSAGE;
    %generate_event(TYPE=&TYPE, LEVEL=&LEVEL, 
         MESSAGE=&EVENT_MESSAGE,
         ATTACHDATA=&ATTACHDATA, ATTACHFILE=&ATTACHFILE,
         METRIC=&METRIC,
         PROPERTIES=&PROPERTIES,
         ON_EVENT=&ON_EVENT,
         DESCRIPTION=&DESCRIPTION, ABORT=&ABORT)
%end;
%else
    %do %while(&rcb > -1 and &rcc > -1 and &done = 0); 
        %let rcb=%sysfunc(fread(&fid0)) ; 
    
        %let rc=%sysfunc(fget(&fid0,b,200));
        %let rcc=%sysfunc(fread(&fid1)) ;
        %let rc=%sysfunc(fget(&fid1,c,200));
        /* for debugging...
        */
        %put DBG: BASE: %superq(b);
        %put DBG: COMP: %superq(c);
        %if %superq(b) ne %superq(c) %then 
        %do;
            %let done=1;
            %if &MESSAGE = %str() %then %let EVENT_MESSAGE=File &COMPARE not equal to &BASE;
            %else %let EVENT_MESSAGE=&MESSAGE;
            %generate_event(TYPE=&TYPE, LEVEL=&LEVEL, 
                 MESSAGE=&EVENT_MESSAGE,
                 ATTACHDATA=&ATTACHDATA, ATTACHFILE=&ATTACHFILE,
                 METRIC=&METRIC,
                 PROPERTIES=&PROPERTIES,
                 ON_EVENT=&ON_EVENT,
                 DESCRIPTION=&DESCRIPTION, ABORT=&ABORT)
        %end;
    
    %end;

%let rc=%sysfunc(fclose(&fid0));
%let rc=%sysfunc(fclose(&fid1));
%let rc=%sysfunc(filename(filrf));
%let rc=%sysfunc(filename(filrf1));

%mend assert_filecompare_equal;
