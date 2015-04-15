/* ----------------------------------------------------------------
 *
 * <doc>
 * @purpose Tests %assert_exist, %assert_not_exist;
 *  requires manual inspection of log
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

/* tests */

%expect_error( TYPE=test )
%assert_exist( not_a_data_set, TYPE=test )
%assert_error_occurred

%assert_exist( some_data,
               TYPE=test,
               LEVEL=ERROR,
               MESSAGE=not expected event some_data does not exist )
        
%assert_not_exist( not_a_data_set )

%expect_error( TYPE=test )
%assert_not_exist( some_data, TYPE=test )
%assert_error_occurred
    
