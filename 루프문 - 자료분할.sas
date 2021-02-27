/* 날짜 최소최대값 확인 */

/* 1. 데이터 일괄 처리 */
data work.init;set mylib.init;run;

proc freq data=init noprint;
	tables stday /nopercent nocol norow nocum nofreq out = _n_;
run;


/* 2. 데이터 분할 & sql */
data work.init;set init(firstobs=1 obs=10000000);run;
data work.init2;set init(firstobs=10000000 obs=20000000);run;
data work.init3;set init(firstobs=20000000 obs=30000000);run;
data work.init4;set init(firstobs=30000000 obs=40000000);run;


proc sql;
	create table temp as
	select max(stday),min(stday)
	from init1	
	;	
quit;

proc sql;
	create table temp as
	select max(stday),min(stday)
	from init2
	;	
quit;

proc sql;
	create table temp as
	select max(stday),min(stday)
	from init3
	;	
quit;

proc sql;
	create table temp as
	select max(stday),min(stday)
	from init4
	;	
quit;

/* 3. 매크로 */
%macro split_data (filename,varname,len,loop_n);

  /*테이블을 조각의 시작&종료 변수 설정*/
  %local firstobs;
  %local obs;

  /* 반복문 시작 */
  %do i=1 %to &loop_n.;     

    %let firstobs=%eval(&len.*(&i.-1)+1);
    %let obs=%eval(&len.*&i.);   /* 매크로 변수는 문자형이므로 EVAL함수를 사용해야 연산이 가능 */
	
	/*로그 창에 반복문이 몇 행째 돌고 있는지 출력함. 삭제해도 무방*/
    %put &firstobs.;   
    %put &obs.;
	  
	  %if i=1 %then %do;
		  proc sql;
			create table temp_base as
			select min(&varname.) as min, max(&varname.)as max
			from &filename.(keep=&varname. firstobs=&start. obs=&end.)
			;
		  quit;
	  %end;
	  
	  %else;
		  proc sql;
			create table temp_1 as
			select min(&varname.) as min, max(&varname.)as max
			from &filename.(keep=&varname. firstobs=&start. obs=&end.)
			;
		  quit;
	  %end;	 
	  
  	proc append base=temp_base data=temp_1; run;
  	
  %end;

  /* 저장 공간 효율을 위해 TEMP1 테이블은 삭제 */
  proc delete data=temp_1;run;
	
  proc sql;
	create table result as
	select min(min), max(max)
	from temp_base
	;
  quit;


%mend split_data ;

%split_data(init, stday, 10000000,5);
