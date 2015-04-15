/* ----------------------------------------------------------------
 * <doc>
 * @purpose Generates a notification that an assertion has failed.
 * @param TYPE - The event type, a string that describes a kind of event
 * @param LEVEL - The severity level of the event (ERROR|WARNING|INFO|DEBUG)
 * @param MESSAGE - A text message explaining the event details.
 * @param ATTACHDATA - A space-delimited list of data sets to attach to the
 *  event.
 * @param ATTACHFILE - A fully-qualified delimited list of files to attach
 *  to the event.  
 * @param METRIC - Optional numeric metric associated with event
 * @param PROPERTIES - Optional event custom properties.  Format is 
 *  /prop1=val1/prop2=val2/.  The first character defines the separator,
 *  and can be a character other than '/'.  An arbitrary number of 
 *  properties may be passed in this format.
 * @param ON_EVENT - Optional block of SAS code to execute 
 *  if the event is fired.
 * @param ABORT - Flag instructing the event system if it should end
 *  the SAS session and stop the batch run.  Valid values are
 *  (YES|TRUE|NO|FALSE)
 * </doc>
 *
 * FUTS v1.1
 * Copyright (c) 2006 ThotWave Technologies, LLC. All rights reserved.
 * ---------------------------------------------------------------- */
 
%macro generate_event( TYPE=,
               LEVEL=,
               MESSAGE=,
               ATTACHDATA=,
               ATTACHFILE=,
               METRIC=,
               PROPERTIES=,
               ON_EVENT=,
               ABORT= );
               
%local 
    ABORT_STATUS
    OPT_LINESIZE
    ;

%global
	FUTS_EXPECTED_ERROR
	;

/* inspect current system options and modify
 */
%let OPT_LINESIZE = %sysfunc( getoption(LINESIZE) );
options linesize=max;

/* check for expected error event
 */
%if &LEVEL eq %str() %then %let LEVEL=ERROR;
%if (&FUTS_EXPECTED_ERROR ne %str()) and (&TYPE eq &FUTS_EXPECTED_ERROR) %then
%do;
	/* clear expected error */
	%expect_error(TYPE=)
%end;
%else
%do;
	/* write event
	 */
	%put &LEVEL.: &MESSAGE.;
%end;
  
/* restore system options 
 */
options linesize=&OPT_LINESIZE;

/* process &ON_EVENT logic 
 */
%if %length(&ON_EVENT) > 0 %then
%do;
    *%unquote(&ON_EVENT)
%end;

/* check for abort
 */
%let ABORT = %upcase(&ABORT);

%if "&ABORT" eq "YES" or "&ABORT" eq "TRUE" %then %do;
    %let ABORT_STATUS = 99;
    data _null_;
        abort return &ABORT_STATUS;
    run;
%end;

%let futs_tst_err = %eval(&futs_tst_err. + 1);

%mend generate_event;
