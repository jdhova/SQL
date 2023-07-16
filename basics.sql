



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

-- to be fixed
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
