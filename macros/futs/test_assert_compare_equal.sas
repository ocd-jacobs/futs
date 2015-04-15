/* ----------------------------------------------------------------
 * <doc>
 * @purpose Tests %assert_compare_equal, %assert_not_compare_equal
 * </doc>
 *
 * FUTS v1.1
 * Copyright 2002 ThotWave Technologies, LLC. All rights reserved.
 * ---------------------------------------------------------------- */

/* create test data */
data ds1;
    input a b c;
    datalines;
1 2 3
4 5 6
7 8 9
    ;
run;

data different_precision;
/* flip the last bit in each value to create different values */
  set ds1;
  keep a b c;  
  char_A_bin64=left(reverse(put(a,binary64.)));
  if substr(char_A_bin64,1,1)='0' then new_bit='1';
  else new_bit='0';
  a=input(reverse(new_bit||substr(char_A_bin64,2)),binary64.);

  char_B_bin64=left(reverse(put(b,binary64.)));
  if substr(char_B_bin64,1,1)='0' then new_bit='1';
  else new_bit='0';
  b=input(reverse(new_bit||substr(char_B_bin64,2)),binary64.);

  char_C_bin64=left(reverse(put(c,binary64.)));
  if substr(char_C_bin64,1,1)='0' then new_bit='1';
  else new_bit='0';
  c=input(reverse(new_bit||substr(char_C_bin64,2)),binary64.);

run;

proc sql noprint;
    create table same as
    select * from ds1
    ;
quit;

proc sql noprint;
    create table different as
    select * from ds1
    ;
    update different
    set b = b+1
    where a = 4
    ;
quit;

proc sql noprint;
    create table empty1
    (
        a int,
        b int,
        c int
    )
    ;
    create table empty_same
    like empty1
    ;
    create table empty_different
    (
        a int,
        b int,
        d int
    )
    ;
quit;

/* tests */

%assert_compare_equal( BASE=ds1, COMPARE=same )

%expect_error( TYPE=test )
%assert_compare_equal( BASE=ds1, COMPARE=different, TYPE=test )
%assert_error_occurred

%assert_compare_equal( BASE=empty1, COMPARE=empty_same, TYPE=test )

%expect_error( TYPE=test )
%assert_compare_equal( BASE=empty1, COMPARE=empty_different, TYPE=test )
%assert_error_occurred
               
%expect_error( TYPE=test )
%assert_not_compare_equal( BASE=ds1, COMPARE=same, TYPE=test )
%assert_error_occurred

%assert_not_compare_equal( BASE=ds1, COMPARE=different )

%expect_error( TYPE=test )
%assert_not_compare_equal( BASE=empty1, COMPARE=empty_same, TYPE=test );
%assert_error_occurred

%assert_not_compare_equal( BASE=empty1, COMPARE=empty_different );

/* tests involving the criterion and method parameters */
%expect_error( TYPE=test )
%assert_compare_equal( BASE=ds1, COMPARE=different_precision, TYPE=test )
%assert_error_occurred

%expect_error( TYPE=test )
%assert_compare_equal( BASE=ds1, COMPARE=different_precision, CRITERION=1e-20, TYPE=test )
%assert_error_occurred

%assert_compare_equal( BASE=ds1, COMPARE=different_precision, CRITERION=1e-10)

%expect_error( TYPE=test )
%assert_compare_equal( BASE=ds1, COMPARE=different_precision, CRITERION=1e-20, METHOD=absolute, TYPE=test )
%assert_error_occurred

%assert_compare_equal( BASE=ds1, COMPARE=different_precision, CRITERION=1e-10, METHOD=absolute )

%assert_not_compare_equal( BASE=ds1, COMPARE=different_precision )

%assert_not_compare_equal( BASE=ds1, COMPARE=different_precision, CRITERION=1e-20 )

%expect_error( TYPE=test )
%assert_not_compare_equal( BASE=ds1, COMPARE=different_precision, CRITERION=1e-10, TYPE=test )
%assert_error_occurred

%assert_not_compare_equal( BASE=ds1, COMPARE=different_precision, CRITERION=1e-20, METHOD=absolute)

%expect_error( TYPE=test )
%assert_not_compare_equal( BASE=ds1, COMPARE=different_precision, CRITERION=1e-10, METHOD=absolute, TYPE=test )
%assert_error_occurred    
