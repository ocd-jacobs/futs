/* ----------------------------------------------------------------
 * <doc>
 * @purpose Tests %assert_empty, %assert_not_empty
 * </doc>
 *
 * FUTS v1.1
 * Copyright 2002 ThotWave Technologies, LLC. All rights reserved.
 * ---------------------------------------------------------------- */

/* create test data */

data some_data;
    input a b c;
    datalines;
1 2 3
4 5 6
7 8 9
    ;
run;

proc sql noprint;
    create table no_data
    (
        a int,
        b int,
        c int
    )
    ;
quit;

/* tests */

%expect_error( TYPE=test )
%assert_empty( some_data, TYPE=test )
%assert_error_occurred

%assert_empty( no_data )

%assert_empty( not_a_data_set )
        
%assert_not_empty( some_data )

%expect_error( TYPE=test )
%assert_not_empty( no_data, TYPE=test  )
%assert_error_occurred

%expect_error( TYPE=test )
%assert_not_empty( not_a_data_set, TYPE=test )
%assert_error_occurred
    
