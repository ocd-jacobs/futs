/* ----------------------------------------------------------------
 * <doc>
 * @purpose Returns the observation count for a data set. 
 * @param DS - data set name
 * @return observation count, or . if data set doesn't exist
 * </doc>
 *
 * FUTS v1.1
 * Copyright (c) 2002 ThotWave Technologies, LLC. All rights reserved.
 * ---------------------------------------------------------------- */

%macro obs( DS );

%local DSID NUM_OBS RC;

%let DSID =-1;
 
%if %exist(&DS) ne 0 %then %let DSID = %sysfunc(open(&DS, I));

%if &DSID <= 0 %then %do;
    %let NUM_OBS = .;
    %put WARNING: Data set &DS could not be opened.  Unable to determine number of observations.;
%end;
%else %do;
    %let NUM_OBS = %sysfunc(attrn(&DSID, NLOBS));
    %let RC = %sysfunc(close(&DSID));
%end;

&NUM_OBS
  
%mend obs;
