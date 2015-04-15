/* ----------------------------------------------------------------
 * <doc>
 * @purpose Tests %assert_filecompare_equal.
 * </doc>
 *
 * FUTS v1.1
 * Copyright 2006 ThotWave Technologies, LLC. All rights reserved.
 * ---------------------------------------------------------------- */

%assert_filecompare_equal(BASE=testdata/filecompare1.txt, COMPARE=testdata/filecompare2.txt)

%expect_error( TYPE=test )
%assert_filecompare_equal(BASE=testdata/filecompare1.txt, 
    COMPARE=testdata/filecompare3.txt, TYPE=test )
%assert_error_occurred

%expect_error( TYPE=test )
%assert_filecompare_equal(BASE=testdata/filecompare1.txt, 
    COMPARE=testdata/filecompare4.txt, TYPE=test )
%assert_error_occurred

%expect_error( TYPE=test )
%assert_filecompare_equal(BASE=testdata/notexist1.txt, 
    COMPARE=testdata/filecompare4.txt, TYPE=test )
%assert_error_occurred

