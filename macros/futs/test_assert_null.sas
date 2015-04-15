/* ----------------------------------------------------------------
 * <doc>
 * @purpose Tests %assert_null, %assert_not_null.
 * </doc>
 *
 * FUTS v1.1
 * Copyright 2002 ThotWave Technologies, LLC. All rights reserved.
 * ---------------------------------------------------------------- */

%let VAL1=;
%let VAL2=%str();
%let VAL3=foo;

%expect_error( TYPE=test )
%assert_null( &VAL3, TYPE=test )
%assert_error_occurred

%assert_null( &VAL1 )

%assert_null( &VAL2 )
    
%assert_not_null( &VAL3 )

%expect_error( TYPE=test )
%assert_not_null( &VAL1, TYPE=test )
%assert_error_occurred
    
