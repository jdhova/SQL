



-- QUESTION 1 WHERE CLAUSE
-- SELECT EMPLOYEES ,GENDER, MARITAL STATUS WITH JOB TITLE 'Marketing Assistant' AND 'Tool Designer' 

SELECT JobTitle  as 'Employees' 
       ,cast(left(HireDate, 4)as int) as 'newyear'
	   ,Gender
	   , MaritalStatus
FROM [HumanResources].[Employee]
where JobTitle =  'Marketing Assistant'
or JobTitle= 'Tool Designer' 


-- RETURN THE JOB TITLE AND ORGANIZATIONAL LEVELS GROUP BY JOB TITLE AND LEVEL
-- AND RETURN THE ORG LEVELS GREATED THAN 3 AND ORDER IN DECENDING
-- GROUP BY ORDER BY AND HAVING CLAUSE

SELECT JobTitle as 'Title'
		, OrganizationLevel as 'Level'
		
FROM [HumanResources].[Employee]
group by JobTitle
		,OrganizationLevel
HAVING OrganizationLevel > 3
order by OrganizationLevel desc


-- JOIN TWO TABLES WITN INNER JOIN

SELECT *		
FROM [HumanResources].[Employee] emp
inner JOIN [HumanResources].[EmployeePayHistory] pay
on emp.BusinessEntityID = pay.BusinessEntityID


--- WHERE CLAUSE-------------------------------------------------


SELECT VacationHours, SickLeaveHours, JobTitle	
FROM [HumanResources].[Employee] emp
inner JOIN [HumanResources].[EmployeePayHistory] pay
on emp.BusinessEntityID = pay.BusinessEntityID
WHERE VacationHours >= 70 and VacationHours <= 80

-- between clause 

SELECT VacationHours, SickLeaveHours, JobTitle	
FROM [HumanResources].[Employee] emp
inner JOIN [HumanResources].[EmployeePayHistory] pay
on emp.BusinessEntityID = pay.BusinessEntityID
WHERE VacationHours between 70 and 80 
and SickLeaveHours between 60 and 80

--LIKE CLAUSE 

SELECT VacationHours, SickLeaveHours, JobTitle	
FROM [HumanResources].[Employee] emp
inner JOIN [HumanResources].[EmployeePayHistory] pay
on emp.BusinessEntityID = pay.BusinessEntityID
where emp.JobTitle LIKE 'Seni%' or  emp.JobTitle LIKE 'De%'

--IN CLAUSE 
SELECT VacationHours, SickLeaveHours, JobTitle	
FROM [HumanResources].[Employee] emp
inner JOIN [HumanResources].[EmployeePayHistory] pay
on emp.BusinessEntityID = pay.BusinessEntityID
where emp.JobTitle IN ('Senior Tool Designer', 
						'Senior Design Engineer', 
							'Tool Designer',
							'Data Analyst')



--------------------------------------

--SUBQUERIES

--FIND EMPLYEES WHO ARE MALE AND MARRIED FROM THE RESULT FROM A QUERY  IN OP IS POPULALALLY USED IN SUB QUERIES


SELECT  VacationHours, SickLeaveHours, JobTitle	
FROM [HumanResources].[Employee] emp
inner JOIN [HumanResources].[EmployeePayHistory] pay
on emp.BusinessEntityID = pay.BusinessEntityID

WHERE emp.VacationHours  > any  (select VacationHours   
							FROM [HumanResources].[Employee] 
							where VacationHours < 30)



SELECT  VacationHours, SickLeaveHours, JobTitle	
FROM [HumanResources].[Employee] emp
inner JOIN [HumanResources].[EmployeePayHistory] pay
on emp.BusinessEntityID = pay.BusinessEntityID
--WHERE emp.VacationHours < 30 and emp.SickLeaveHours  < 40
WHERE emp.VacationHours  in  (select VacationHours  
							FROM [HumanResources].[Employee] 
							where VacationHours < 30)
							and 
		emp.SickLeaveHours in (select SickLeaveHours  
							FROM [HumanResources].[Employee] 
							where SickLeaveHours < 40)

							




--CTE---------------------------------------------------------------------
-- FROM THE  [HumanResources].[Employee]
--SELECT ALL EMOLOYEES WITH JOB TITLE MARKETING AND 'Tool Designer' AND HIRE DATE AFTER 2009


WITH CTE AS (
SELECT JobTitle  as 'Employees' 
       ,cast(left(HireDate, 4)as int) as 'newyear'
FROM [HumanResources].[Employee]
where JobTitle =  'Marketing Assistant'
or JobTitle= 'Tool Designer' 

)
SELECT * FROM CTE
WHERE newyear > 2009



-- SELECT ALL EMPLOYES WITH VACATION HRS OF BETWEEN 20 AND 80 
-- AND SICK LEAVE HOURS OF 40 AND 50

-- GROUP THEM BY THEIR JOB TITTLES and gender
-- RETURN THEIR INDIVIAL AVERAGE SICK LEAVE AND VAC HRS FOR EACH JOB TITTLES
-- EMPLOYEES SHOULD HAVE WORKED BETWEEN 2009 AND 2011


WITH NEWCTE AS 
(
	SELECT JobTitle	
		 ,Gender
			,avg(VacationHours) avgVac
			,avg(SickLeaveHours) avgSick
			 ,cast(left(HireDate, 4)as int) as 'newyear'
	FROM [HumanResources].[Employee]
	where (VacationHours > 20 and VacationHours < 80) and 
	(SickLeaveHours >40 and SickLeaveHours < 50)
	group by JobTitle
		,Gender
		 ,cast(left(HireDate, 4)as int) 
	--	order by Gender 
	)

	SELECT * FROM NEWCTE
	WHERE newyear > 2008 AND newyear < 2011
		order by newyear, Gender DESC

----------------------------------------------------------------------
--WINDOW FUNCTION-- THIS HELPS IN PERFOMING FUNCTIONS AND MANIPULATING ROWS

---PARTITION BY
SELECT JobTitle
       ,SUM(SickLeaveHours) as 'sickleavesum'
      ,SUM(SickLeaveHours)
         OVER(PARTITION BY JobTitle ORDER BY JobTitle ) as 'newval'
FROM [HumanResources].[Employee] emp
inner JOIN [HumanResources].[EmployeePayHistory] pay
on emp.BusinessEntityID = pay.BusinessEntityID
GROUP BY VacationHours, SickLeaveHours, JobTitle
ORDER BY 1


---ROW NUMBER
SELECT ROW_NUMBER()OVER (PARTITION BY JobTitle order by JobTitle) +100 as 'rowNum'
         ,JobTitle
       ,SUM(SickLeaveHours) as 'sickleavesum'
      ,SUM(SickLeaveHours)
         OVER(PARTITION BY JobTitle ) as 'newval'
FROM [HumanResources].[Employee] emp
inner JOIN [HumanResources].[EmployeePayHistory] pay
on emp.BusinessEntityID = pay.BusinessEntityID
GROUP BY VacationHours, SickLeaveHours, JobTitle

--- SUM OF ROW NUMBERS WITH OVER CLAUSE 

WITH CTE AS (
SELECT ROW_NUMBER()OVER (PARTITION BY JobTitle order by JobTitle)  as 'rowNum'
         ,JobTitle
       ,SUM(SickLeaveHours) as 'sickleavesum'
      ,SUM(SickLeaveHours)
         OVER(PARTITION BY JobTitle ) as 'newval'
FROM [HumanResources].[Employee] emp
inner JOIN [HumanResources].[EmployeePayHistory] pay
on emp.BusinessEntityID = pay.BusinessEntityID
GROUP BY VacationHours, SickLeaveHours, JobTitle
)
SELECT *
,max(rowNum) OVER(PARTITION BY JobTitle) AS 'TotalSum'
FROM CTE
order by TotalSum desc


----RANKS()

SELECT ROW_NUMBER()OVER (PARTITION BY JobTitle order by JobTitle)  as 'rowNum'
         ,JobTitle
       ,SUM(SickLeaveHours) as 'sickleavesum'
      ,SUM(SickLeaveHours)
         OVER(PARTITION BY JobTitle ) as 'newval'
		,RANK() OVER(PARTITION BY JobTitle ORDER BY SickLeaveHours desc) AS 'sickLeavRank'
FROM [HumanResources].[Employee] emp
inner JOIN [HumanResources].[EmployeePayHistory] pay
on emp.BusinessEntityID = pay.BusinessEntityID
GROUP BY VacationHours, SickLeaveHours, JobTitle

---CTE plus RANK and FILTER with WHERE CLAUSE 

WITH CTE AS (
SELECT ROW_NUMBER()OVER (PARTITION BY JobTitle order by JobTitle)  as 'rowNum'
         ,JobTitle
       ,SUM(SickLeaveHours) as 'sickleavesum'
      ,SUM(SickLeaveHours)
         OVER(PARTITION BY JobTitle ) as 'newval'
		,RANK() OVER(PARTITION BY JobTitle ORDER BY SickLeaveHours desc) AS 'sickLeavRank'
FROM [HumanResources].[Employee] emp
inner JOIN [HumanResources].[EmployeePayHistory] pay
on emp.BusinessEntityID = pay.BusinessEntityID
GROUP BY VacationHours, SickLeaveHours, JobTitle
)
SELECT *
,max(rowNum) OVER(PARTITION BY JobTitle) AS 'TotalSum'
FROM CTE
WHERE rowNum < 4
order by TotalSum desc

----- CTE and SUBQUERIES  for RANK AND DENSE_RANK

--- CTE
WITH CTE2 AS (
SELECT ROW_NUMBER()OVER (PARTITION BY JobTitle order by JobTitle)  as 'rowNum'
         ,JobTitle
       ,SUM(SickLeaveHours) as 'sickleavesum'
      ,SUM(SickLeaveHours)
         OVER(PARTITION BY JobTitle ) as 'newval'
		,RANK() OVER(PARTITION BY JobTitle ORDER BY SickLeaveHours desc) AS 'sickLeavRank'
		--	,DENSE_RANK() OVER(PARTITION BY JobTitle ORDER BY SickLeaveHours desc) AS 'DENSE_RANK_SickLeave'
FROM [HumanResources].[Employee] emp
inner JOIN [HumanResources].[EmployeePayHistory] pay
on emp.BusinessEntityID = pay.BusinessEntityID
GROUP BY VacationHours, SickLeaveHours, JobTitle
) 

SELECT * FROM CTE2
WHERE sickLeavRank < 4


---SUBQUERY
SELECT * FROM (
SELECT ROW_NUMBER()OVER (PARTITION BY JobTitle order by JobTitle)  as 'rowNum'
         ,JobTitle
       ,SUM(SickLeaveHours) as 'sickleavesum'
      ,SUM(SickLeaveHours)
         OVER(PARTITION BY JobTitle ) as 'newval'
		,RANK() OVER(PARTITION BY JobTitle ORDER BY SickLeaveHours desc) AS 'sickLeavRank'
	--	,DENSE_RANK() OVER(PARTITION BY JobTitle ORDER BY SickLeaveHours desc) AS 'DENSE_RANK_SickLeave'
FROM [HumanResources].[Employee] emp
inner JOIN [HumanResources].[EmployeePayHistory] pay
on emp.BusinessEntityID = pay.BusinessEntityID
GROUP BY VacationHours, SickLeaveHours, JobTitle
) x
WHERE x.sickLeavRank < 4


--- LEAD AND LAG

 
WITH CTE3 AS 

(
SELECT ROW_NUMBER()OVER (PARTITION BY JobTitle order by JobTitle)  as 'rowNum'
         ,JobTitle
       ,SUM(SickLeaveHours) as 'sickleavesum'
      ,SUM(SickLeaveHours)
         OVER(PARTITION BY JobTitle ) as 'newval'
		--,RANK() OVER(PARTITION BY JobTitle ORDER BY SickLeaveHours desc) AS 'sickLeavRank'
		--,DENSE_RANK() OVER(PARTITION BY JobTitle ORDER BY SickLeaveHours desc) AS 'DENSE_RANK_SickLeave'
		
FROM [HumanResources].[Employee] emp
inner JOIN [HumanResources].[EmployeePayHistory] pay
on emp.BusinessEntityID = pay.BusinessEntityID
GROUP BY VacationHours, SickLeaveHours, JobTitle 
)

SELECT *
	, LEAD(sickleavesum) OVER (partition by JobTitle order by rowNum) as'diff-LEAD'
	, LAG(sickleavesum) OVER (partition by JobTitle order by rowNum) as'diff-LAG'
	FROM CTE3 



	---- TOPICS PENDING  RECUSSION IN SQL, ADVANCED WINDOW_FUCTION NTILE ETC, STORED PROCEDURES, SELF JOIN , FUNCTIONS AND REGEX
	--QUESTION SELECT THE EMPLOYEES WITH SICK LEAVE HIGHER THAN AV SICK LEAVE AND VAN LEAVE 
	-- CHECK THE DIFFERENCE IN HOURS FROM THE AVERAGE SICK LEAVE AND VAC LEAVE 
