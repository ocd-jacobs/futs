/* ----------------------------------------------------------------
 * <doc>
 * @purpose Tests %assert_fileexist, %assert_not_fileexist.
 * </doc>
 *
 * FUTS v1.1
 * Copyright 2002 ThotWave Technologies, LLC. All rights reserved.
 * ---------------------------------------------------------------- */

%let THIS_FILE = test_assert_file_exist.sas;
%let NOT_A_FILE = /tmp/does_not_exist;
    
%expect_error( TYPE=test )
%assert_fileexist( &NOT_A_FILE, TYPE=test  );
%assert_error_occurred

%assert_fileexist( &THIS_FILE );
        
%assert_not_fileexist( &NOT_A_FILE );

%expect_error( TYPE=test )
%assert_not_fileexist( &THIS_FILE, TYPE=test );
%assert_error_occurred
    
