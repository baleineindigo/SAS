DATA WORK.CLASS;
	SET SASHELP.CLASS;
	temp=Weight;
	Weight=Height;
	Height=temp;
	Healthy=Height-Weight;
	DROP temp;
RUN;


/* SQL로 쿼리 만들기 */
PROC SQL;
	CREATE TABLE sql_avg_tbl AS
	SELECT 	AGE, 
			round(avg(Height),2) as Height, 
			round(avg(Weight),2) as Weight, 
			round(avg(Healthy),2) as Healthy
	FROM WORK.CLASS
	GROUP BY AGE
	ORDER BY AGE ASC
;
QUIT;

/* 서브 쿼리 */
PROC SQL;
	CREATE TABLE sub_tbl AS
	SELECT 	class.Name,
			class.Sex, 
			class.Age, 
			class.Height,
			class.Weight,
			new_class.Healthy
	FROM WORK.CLASS as aclass,
	(
	SELECT *
	FROM WORK.CLASS 
	WHERE Sex="F"
	) as new_class
	WHERE class.Name=new_class.Name
	ORDER BY class.AGE ASC
;
QUIT;

