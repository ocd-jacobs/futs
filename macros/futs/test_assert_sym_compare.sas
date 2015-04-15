/* ----------------------------------------------------------------
 * <doc>
 * @purpose Tests %assert_sym_compare.
 * </doc>
 *
 * FUTS v1.1
 * Copyright 2006 ThotWave Technologies, LLC. All rights reserved.
 * ---------------------------------------------------------------- */

%let VAL1=foo;
%let VAL2=bar;
%let VAL3=foo;
%let VAL4=foox;

%assert_sym_compare( &VAL1, &VAL3, operator=eq )
%assert_sym_compare( &VAL1, &VAL3, operator=ge )
%assert_sym_compare( &VAL1, &VAL3, operator=le )

%expect_error( TYPE=test )
%assert_sym_compare( &VAL1, &VAL3, operator=gt, TYPE=test )
%assert_error_occurred

%expect_error( TYPE=test )
%assert_sym_compare( &VAL1, &VAL3, operator=lt, TYPE=test )
%assert_error_occurred

%assert_sym_compare( &VAL1, &VAL2, operator=ne )

%expect_error( TYPE=test )
%assert_sym_compare( &VAL1, &VAL2, operator=eq, TYPE=test )
%assert_error_occurred
    
%expect_error( TYPE=test )
%assert_sym_compare( &VAL1, &VAL3, operator=ne, TYPE=test )
%assert_error_occurred

%expect_error( TYPE=test )
%assert_sym_compare( &VAL1, &VAL4, operator=eq, TYPE=test )
%assert_error_occurred

%expect_error( TYPE=test )
%assert_sym_compare( &VAL1, &VAL4, operator=gt, TYPE=test )
%assert_error_occurred

%assert_sym_compare( &VAL4, &VAL1, operator=gt)

%expect_error( TYPE=test )
%assert_sym_compare( &VAL1, &VAL4, operator=ge, TYPE=test )
%assert_error_occurred

%assert_sym_compare( &VAL1, &VAL4, operator=le)
%assert_sym_compare( &VAL1, &VAL4, operator=lt)

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


%assert_sym_compare(&NUM1_1., &NUM1_1., OPERATOR=eq, DATATYPE=NUMERIC)
%assert_sym_compare(&NUM1_1., &NUM1_1., OPERATOR=EQ, DATATYPE=NUMERIC)
%assert_sym_compare(&NUM1_1., &NUM1_1., OPERATOR=LE, DATATYPE=NUMERIC)
%assert_sym_compare(&NUM1_1., &NUM1_1., OPERATOR=GE, DATATYPE=NUMERIC)

%assert_sym_compare(&NUM2_1.,&NUM2_1., OPERATOR=EQ, DATATYPE=HEX)
%assert_sym_compare(&NUM2_1.,&NUM2_1., OPERATOR=GE, DATATYPE=HEX)
%assert_sym_compare(&NUM2_1.,&NUM2_1., OPERATOR=LE, DATATYPE=HEX)

/* this test only passes because we lost numeric precision when storing the decimal value to a macro variable */
%assert_sym_compare(&NUM1_1., &NUM1_2., OPERATOR=EQ, DATATYPE=NUMERIC)
%assert_sym_compare(&NUM1_1., &NUM1_2., OPERATOR=gE, DATATYPE=NUMERIC)
%assert_sym_compare(&NUM1_1., &NUM1_2., OPERATOR=Le, DATATYPE=NUMERIC)

%expect_error( TYPE=test )
%assert_sym_compare(&NUM1_1., &NUM1_3., OPERATOR=EQ, DATATYPE=NUMERIC, TYPE=test)
%assert_error_occurred

%expect_error( TYPE=test )
%assert_sym_compare(&NUM1_1., &NUM1_3., OPERATOR=GT, DATATYPE=NUMERIC, TYPE=test)
%assert_error_occurred

%expect_error( TYPE=test )
%assert_sym_compare(&NUM1_1., &NUM1_3., OPERATOR=GE, DATATYPE=NUMERIC, TYPE=test)
%assert_error_occurred

%assert_sym_compare(&NUM1_1., &NUM1_3., OPERATOR=NE, DATATYPE=NUMERIC)
%assert_sym_compare(&NUM1_1., &NUM1_3., OPERATOR=LT, DATATYPE=NUMERIC)
%assert_sym_compare(&NUM1_1., &NUM1_3., OPERATOR=LE, DATATYPE=NUMERIC)




/* this test passes because the difference is within the default precision limit */
%assert_sym_compare(&NUM2_1.,&NUM2_2., OPERATOR=EQ, DATATYPE=HEX)

/* this test only passes because we lost numeric precision when storing the decimal value to a macro variable */
%expect_error( TYPE=test )
%assert_sym_compare(&NUM1_1., &NUM1_2., OPERATOR=NE, DATATYPE=NUMERIC, TYPE=test)
%assert_error_occurred

%expect_error( TYPE=test )
%assert_sym_compare(&NUM2_1.,&NUM2_1., OPERATOR=NE, DATATYPE=HEX, TYPE=test)
%assert_error_occurred

%assert_sym_compare(&NUM1_1., &NUM1_3., OPERATOR=NE, DATATYPE=NUMERIC)

/* this test fails because the difference is within the default precision limit */
%expect_error( TYPE=test )
%assert_sym_compare(&NUM2_1.,&NUM2_2., OPERATOR=NE, DATATYPE=HEX, TYPE=test);
%assert_error_occurred

/* now tests with specific precision */

%expect_error( TYPE=test )
%assert_sym_compare(&NUM2_1.,&NUM2_2., OPERATOR=EQ, DATATYPE=HEX, PRECISION=1E-16, TYPE=test)
%assert_error_occurred

%assert_sym_compare(&NUM2_1.,&NUM2_2., OPERATOR=EQ, DATATYPE=HEX, PRECISION=1E-12, TYPE=test)

%expect_error( TYPE=test )
%assert_sym_compare(&NUM2_1.,&NUM2_2., OPERATOR=EQ, DATATYPE=HEX, PRECISION=0, TYPE=test)
%assert_error_occurred

%assert_sym_compare(&NUM2_1.,&NUM2_2., OPERATOR=LE, DATATYPE=HEX, PRECISION=0, TYPE=test)
%assert_sym_compare(&NUM2_1.,&NUM2_2., OPERATOR=LT, DATATYPE=HEX, PRECISION=0, TYPE=test)

%expect_error( TYPE=test )
%assert_sym_compare(&NUM2_1.,&NUM2_2., OPERATOR=gT, DATATYPE=HEX, PRECISION=0, TYPE=test)
%assert_error_occurred

%expect_error( TYPE=test )
%assert_sym_compare(&NUM2_1.,&NUM2_2., OPERATOR=Ge, DATATYPE=HEX, PRECISION=0, TYPE=test)
%assert_error_occurred

%assert_sym_compare(&NUM2_1.,&NUM2_2., OPERATOR=NE, DATATYPE=HEX, PRECISION=1E-16)

%assert_sym_compare(&NUM1_1., &NUM1_1., OPERATOR=EQ, DATATYPE=NUMERIC, PRECISION=0.1)

%assert_sym_compare(&NUM2_1.,&NUM2_1., OPERATOR=EQ, DATATYPE=HEX, PRECISION=0.1)

%assert_sym_compare(&NUM2_1.,&NUM2_1., OPERATOR=EQ, DATATYPE=HEX, PRECISION=1E-20)







