/* ----------------------------------------------------------------
 * <doc>
 * @purpose Verifies the existence of a file by name. 
 * @param FILE - fully qualified pathname/filename
 * @return 1 if the file exists, 0 if it doesn't 
 * </doc>
 *
 * Modified FUTS v1.1
 * Copyright (c) 2015 John Jacobs. All rights reserved.
 * ---------------------------------------------------------------- */

%macro fileexist(FILE);
 %local rc;
 %let rc = %sysfunc(fileexist(&FILE));
 
 &rc
 
%mend fileexist;
