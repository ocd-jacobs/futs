/* ----------------------------------------------------------------
 * <doc>
 * @purpose Tests %assert_zero, %assert_not_zero.
 * </doc>
 *
 * FUTS v1.1
 * Copyright 2002 ThotWave Technologies, LLC. All rights reserved.
 * ---------------------------------------------------------------- */

%let VAL1=0;
%let VAL2=123456;

%expect_error( TYPE=test )
%assert_zero( &VAL2, TYPE=test )
%assert_error_occurred
               
%assert_zero( &VAL1 )
    
%assert_not_zero( &VAL2 )
               
%expect_error( TYPE=test )
%assert_not_zero( &VAL1, TYPE=test )
    
