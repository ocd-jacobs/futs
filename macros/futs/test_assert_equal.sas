/* ----------------------------------------------------------------
 * <doc>
 * @purpose Tests %assert_equal, %assert_not_equal
 * </doc>
 *
 * FUTS v1.1
 * Copyright 2002 ThotWave Technologies, LLC. All rights reserved.
 * ---------------------------------------------------------------- */

/* character value tests */
%let VAL1=foo;
%let VAL2=bar;
%let VAL3=foo;

%assert_equal( &VAL1, &VAL3 )
%assert_not_equal( &VAL1, &VAL2 )

%expect_error( TYPE=test )
%assert_equal( &VAL1, &VAL2, TYPE=test );
%assert_error_occurred
    
%expect_error( TYPE=test )
%assert_not_equal( &VAL1, &VAL3, TYPE=test );
%assert_error_occurred
   
/* numeric value tests */

data _null_;
  /* create numbers that are only different in the least signigicant bit */
  a=10;

  /* create number that differs from A in the last bit */
  char_A_bin64=left(reverse(put(a,binary64.)));
  if substr(char_A_bin64,1,1)='0' then new_bit='1';
  else new_bit='0';
  b=input(reverse(new_bit||substr(char_A_bin64,2)),binary64.);

  /* create base ten macro variables with values that lose precision when stored */
  call symput('NUM1_1',compress(put(a,32.31)));
  call symput('NUM1_2',compress(put(b,32.31)));

  /* create a base ten number that will retain more of its original precision */
  c=a+1.234e-8;
  call symput('NUM1_3',compress(put(c,32.31)));

  /* create hex macro varaibles that will keep their precision information */
  call symput('NUM2_1',put(a,hex16.));
  call symput('NUM2_2',put(b,hex16.));

run;

/* some code to verify/illustrate that precision was lost in the base ten test data */
/*

%put NUM1_1=&NUM1_1.;
%put NUM1_2=&NUM1_2.;
%put NUM1_3=&NUM1_3.;
%put NUM2_1=&NUM2_1.;
%put NUM2_2=&NUM2_2.;

data _null_;
a=&num1_1.;
b=&num1_2.;
c=&num1_3.;
put 'A - ' a hex16.;
put 'B - ' b hex16.;
put 'C - ' c hex16.;
put 'C - ' c best.;
run;
*/


%assert_equal(&NUM1_1., &NUM1_1., DATATYPE=NUMERIC)

%assert_equal(&NUM2_1.,&NUM2_1.,DATATYPE=HEX)

/* this test only passes because we lost numeric precision when storing the decimal value to a macro variable */
%assert_equal(&NUM1_1., &NUM1_2., DATATYPE=NUMERIC)


%expect_error( TYPE=test )
%assert_equal(&NUM1_1., &NUM1_3., DATATYPE=NUMERIC, TYPE=test)
%assert_error_occurred

/* this test passes because the difference is within the default precision limit */
%assert_equal(&NUM2_1.,&NUM2_2.,DATATYPE=HEX)

/* this test only passes because we lost numeric precision when storing the decimal value to a macro variable */
%expect_error( TYPE=test )
%assert_not_equal(&NUM1_1., &NUM1_2., DATATYPE=NUMERIC, TYPE=test);
%assert_error_occurred

%expect_error( TYPE=test )
%assert_not_equal(&NUM2_1.,&NUM2_1.,DATATYPE=HEX, TYPE=test);
%assert_error_occurred

%assert_not_equal(&NUM1_1., &NUM1_3., DATATYPE=NUMERIC)

/* this test fails because the difference is within the default precision limit */
%expect_error( TYPE=test )
%assert_not_equal(&NUM2_1.,&NUM2_2.,DATATYPE=HEX, TYPE=test);
%assert_error_occurred

/* now tests with specific precision */

%expect_error( TYPE=test )
%assert_equal(&NUM2_1.,&NUM2_2.,DATATYPE=HEX, PRECISION=1E-16, TYPE=test)
%assert_error_occurred

%assert_not_equal(&NUM2_1.,&NUM2_2.,DATATYPE=HEX, PRECISION=1E-16)

%assert_equal(&NUM1_1., &NUM1_1., DATATYPE=NUMERIC, PRECISION=0.1);

%assert_equal(&NUM2_1.,&NUM2_1.,DATATYPE=HEX, PRECISION=0.1);

%assert_equal(&NUM2_1.,&NUM2_1.,DATATYPE=HEX, PRECISION=1E-20);




