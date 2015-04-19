/* ----------------------------------------------------------------
 * <doc>
 * @purpose Verifies the existence of a file by fileref. 
 * @param FILE - file ref
 * @return 1 if the file exists, 0 if it doesn't 
 * </doc>
 *
 * Modified FUTS v1.1
 * Copyright (c) 2015 John Jacobs. All rights reserved.
 * ---------------------------------------------------------------- */

%macro fexist(FILEREF);
 %local rc;
 %let rc = %sysfunc(fexist(&FILEREF));
 
 &rc
 
%mend fexist;
