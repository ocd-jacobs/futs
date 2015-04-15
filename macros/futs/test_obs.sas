/* ----------------------------------------------------------------
 * <doc>
 * @purpose Tests %obs.
 * </doc>
 *
 * FUTS v1.1
 * Copyright 2002 ThotWave Technologies, LLC. All rights reserved.
 * ---------------------------------------------------------------- */

/* Test on data set with 2 rows
 */
data obstest;
    x=1; output;
    x=2; output;
run;
%let NOBS = %obs(obstest);
%assert_equal(2, &NOBS)

/* Test on data set with 2 rows
 */
proc sql;
    delete from obstest;
quit;
%let NOBS = %obs(obstest);
%assert_equal(0, &NOBS)

/* Test on missing data set
 */
%let NOBS = %obs(not_exist);
%assert_equal(., &NOBS)
%put nobs is &NOBS;
