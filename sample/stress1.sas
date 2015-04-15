%macro main;
  %init;
  %import_data;
  %prepare_data;
  %print_data;
%mend;

%macro init;
  libname clinic '/folders/myfolders/functions';
  filename tests '/folders/myfolders/cert1/input/tests2.dat';
%mend;

%macro import_data;
  data clinic.stress;
    infile tests;
    
    input ID 1-4 
          Name $ 6-25 
          RestHR 27-29
          MaxHR 31-33
          RecHR 35-37 
          TimeMin 39-40
          TimeSec 42-43
          Tolerance $ 45;

    if tolerance='D';
  
    TotalTime=(timemin*60)+timesec;
  run;
%mend;

%macro prepare_data;
  proc sort data=clinic.stress out=work.stress;
    by resthr ;
  run;
%mend;

%macro print_data;
  proc print data=work.stress;
  run;
%mend;

