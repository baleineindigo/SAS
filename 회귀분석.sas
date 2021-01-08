/* 데이터 불러오기 및 요약 */
data score;
	infile "/folders/myshortcuts/myfolder/data/score.txt";
	input score kor eng math science;
	label score="성적" kor="국어" eng="영어" math="수학" science="과학";
run;

proc print data=work.score;run;

proc univariate data=score plot;run;

/* 합계 열 추가 */
data work.score_sum;
	set work.score;
	sum_score=kor+eng+math+science;
run;

/* ==================================================================================== */

/* 단순회귀함수 
영어와 국어보다 수학, 과학 성적이 전체 score에 미치는 영향이 더 크다.
*/
proc reg data=score;
	model score = eng;
	model score = kor;
	model score = math;
	model score = science;	
run;

/* plot 그리기 */
proc reg data=work.score;
	model score = math/ P R;
/* 	output out=score_math_result predicted=pred residual=residual lclm=lclm rstudent=rstudent student=student; */
/* 	plot STUDENT.*math; */
	plot score*math P.*math/overlay;
run;

proc print data=score_math_result;run;

/* 
1) beta0 검정 : 단순 선형 회귀 모형에서 절편을 나타내는 모집단 회귀계수 b0의 검정 문제
H0 : b0=0 검정을 위해 검정 통계량 T value 사용.
만약 b0가 유의하지 않으면 절편을 포함하지 않는 회귀모형을 다시 적합시켜야 한다.(NOINT옵션 사용)
위 예시에서는 절편이 유의하므로 포함시켜 적합.

2) beta1 검정 : 기울기를 나타내는 회귀계수의 유의미성
b1도 마찬가지로 T분포를 따르는 통계량으로 검정

3) 설명력 : 회귀직선이 전체 자료를 얼마나 잘 설명하고 있는지
R^2 = sum((X-X_bar)^2)/sum((Y-Y_bar)^2)

4) 잔차 분석 : 잔차는 독립변수와 독립이다.

5) 회귀모형의 선형성
독립변수와 종속 변수의 관계는 선형이다.

6) 오차항의 등분산성 : 오차항의 분산이 모든 독립변수에 대하여 동일하다

*/

/* 용어 설명
- residual : 잔차는 모형에 의한 추정치와 관측치의 편차를 의미 
- rstandard(내면 스튜던트 잔차) : 잔차를 표준오차로 나눈 값(표준화된 잔차). rstudent와 달리 i번째 값을 포함.
- rstudent(외면 스튜던트 잔차) : i번째 값 제거 한 rstandard 값
- cook's distance : 각각의 값이 얼마나 많이 회귀 모델을 변화시키는지 영향치 진단에 가장 많이 쓰이는 값이다.
 */


/* 4) 잔차 분석 */
proc reg data=work.score;
	model score=math / P R CLM;
	output out=work.score_result PREDICTED=pred residual=resid STUDENT=student;
run;

Proc sgplot data=work.score_result;
	scatter X=math Y=score;
	scatter  X=math Y=pred;
run;

/* 5) 선형성 검토 */
Proc sgplot data=work.score_result;
	scatter X=math Y=resid;
	reg X=math Y=resid;
run;


/* 6) 오차항의 등분산성 */
Proc sgplot data=work.score_result;
	scatter X=pred Y=student;
	reg X=pred Y=student;
run;

/* 7) 오차항의 정규성 */
PROC UNIVARIATE DATA=work.score_result NORMAL PLOT;
	var student;
RUN;
/* Shapiro-Wilk : W	0.950069	, Pr < W	0.2516
>> 유의확률 0.2516으로 귀무가설(정규분포를 따른다) 기각할 수 없음.
=오차항은 정규분포
 */



/* ==================================================================================== */

/* 다중회귀함수 
[모형 선택 기준]
1) 결정계수(수정된)
2) 오차평균제곱
3) Cp통계량 : 구한 통계량 값이 독립변수의 수 p와 가장 가까운 값을 가지는 모형을 최적 모형으로 판단하는 기준
*/

proc reg data=score;
	model score = eng kor math science /
							 SLENTRY=0.15 SLS=0.15 pc ADJRSQ MSE;
run;
/* 영어점수는 계수가 유의미하지 않음 >> 제외. 
절편은 유의미하므로 포함*/

proc reg data=score;
	model score = kor math science /P R CLM
							 SLENTRY=0.15 SLS=0.15 pc ADJRSQ MSE;
run;

/* ==================================================================================== */

/* 로지스틱 */
proc logistic data=work.admit;
	var gpa ;
run;

proc logistic data=work.admit descending;
  model admit = gre gpa rank race;
  plot admit*race;
run;

proc logistic data=work.admit descending;
  class race / param=ref ;
  model admit = gre gpa rank;
  contrast 'rank 2 vs 3' rank -1 0 1 / estimate=parm;
run;