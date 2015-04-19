/* ----------------------------------------------------------------
 * <doc>
 * @purpose Registers an expected error type, so that an assertion firing 
 *  will not generate an event notification.  See also %assert_error_occurred.
 * @param TYPE - The expected error (event) type, a string that describes 
 *  a kind of event matching the TYPE= argument to the assertion.
 * @symbol FUTS_EXPECTED_ERROR - global symbol written by this macro
 * </doc>
 *
 * Modified FUTS v1.1
 * Copyright (c) 2015 John Jacobs. All rights reserved.
 * ---------------------------------------------------------------- */
 
%macro expect_error(TYPE=);

%global FUTS_EXPECTED_ERROR;
%let FUTS_EXPECTED_ERROR = &TYPE;

%mend expect_error;

