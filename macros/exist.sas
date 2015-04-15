/* ----------------------------------------------------------------
 * <doc>
 * @purpose Verifies the existence of a SAS data set. 
 * @param DS - data set name
 * @return 1 if the data set exists, 0 if it doesn't 
 * </doc>
 *
 * FUTS v1.1
 * Copyright (c) 2002 ThotWave Technologies, LLC. All rights reserved.
 * ---------------------------------------------------------------- */

%macro exist(DS);
 %local rc;
 %let rc = %sysfunc(exist(&DS));
 
 &rc
 
%mend exist;
