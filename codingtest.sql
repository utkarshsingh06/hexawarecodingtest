use careerdb


/*1. Provide a SQL script that initializes the database for the Job Board scenario “CareerHub”. */

use careedb
/*2. Create tables for Companies, Jobs, Applicants and Applications. */

create table Companies (
    company_id INT identity primary key,
    company_name varchar(50) NOT NULL,
    Location VARCHAR(100) not null
);


create table Jobs(
 job_id int identity primary key,
 company_id int, foreign key(company_id) references Companies(company_id),
 job_title VARCHAR(30) NOT NULL,
 job_description TEXT,
 job_location varchar(80),
 salary decimal(10, 2),
 job_type VARCHAR(50),
 posted_date DATETIME
	)

create table Applicants (
    applicant_id int identity primary key,
    first_name varchar (20) NOT NULL,
    last_name varchar(100) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    Phone varchar(20),
    Resumes TEXT
);



create table Applications (
    application_id int identity primary key,
    job_id int, foreign key(job_id) references Jobs(job_id),
    applicant_id int, foreign key(applicant_id) references Applicants(applicant_id),
    application_date DATETIME,
    cover_letter TEXT
)

INSERT INTO Companies (company_name,Location)
VALUES ('Tech Innovators', 'Delhi'),
       ('Global Solutions', 'Mumbai'),
       ('Hexaware', 'Gurgaon')
INSERT INTO Jobs (company_id, job_title, job_description, job_location, salary, job_type, posted_date)
VALUES (1, 'Software Engineer', 'Develop and maintain software applications.', 'New delhi', 85000.00, 'Full-time', GETDATE()),
       (2, 'Data Analyst', 'Analyze business data and provide insights.', 'San Francisco', 70000.00, 'Full-time', GETDATE()),
       (3, 'UX Designer', 'Design user interfaces and experiences.', 'Chicago', 65000.00, 'Contract', GETDATE())

INSERT INTO Applicants ( first_name, last_name, email, Phone, Resumes)
VALUES ('Utkarsh', 'Singh', 'ukki.sin@gmail.com', '123-456-7890', 'Resume for Utakrsh'),
       ('Rohan', 'Sinha', 'rohan.smith@gmail.com', '098-765-4321', 'Resume for Rohan'),
       ('Amit', 'Jaiswal', 'amit.johnson@gmail.com', '555-555-5555', 'Resume for Amit')

INSERT INTO Applications (job_id, applicant_id, application_date,cover_letter)
VALUES ( 2, 1, GETDATE(), 'Cover letter for Software Engineer role'),
       (2, 2, GETDATE(), 'Cover letter for Data Analyst role'),
       (1 ,3, GETDATE(), 'Cover letter for UX Designer role')


select * from Applications

select * from Companies
/* 3. Define appropriate primary keys, foreign keys, and constraints. */


ALTER TABLE Jobs
ADD CONSTRAINT FK_Jobs_Companies
FOREIGN KEY (company_id) REFERENCES Companies(company_id) ON DELETE
CASCADE

ALTER TABLE Applications
ADD CONSTRAINT FK_Applications_Applicants
FOREIGN KEY (applicant_id) REFERENCES Applicants(applicant_id) ON DELETE
CASCADE

ALTER TABLE Applications
ADD CONSTRAINT FK_Applications_Jobs
FOREIGN KEY (job_id) REFERENCES Jobs(job_id) ON DELETE
CASCADE

/* 4. . Ensure the script handles potential errors, such as if the database or tables already exist.
*/

/* 5. Write an SQL query to count the number of applications received for each job listing in the
"Jobs" table. Display the job title and the corresponding application count. Ensure that it lists all
jobs, even if they have no applications.*/

SELECT j.job_title, COUNT(a.applicant_id) AS [ApplicationCount]
FROM Jobs j
LEFT JOIN Applications a ON j.job_id= a.job_id
GROUP BY j.job_title
 

/* 6. Develop an SQL query that retrieves job listings from the "Jobs" table within a specified salary
range. Allow parameters for the minimum and maximum salary values. Display the job title,
company name, location, and salary for each matching job.*/declare @minsal decimal(10,2)=68000declare @maxsal decimal(10,2)=90000select j.job_title,c.company_name,j.job_location,j.salary from Jobs as jjoin Companies as c on j.company_id=c.company_idwhere j.salary between @minsal and @maxsal/* 7. Write an SQL query that retrieves the job application history for a specific applicant. Allow a
parameter for the ApplicantID, and return a result set with the job titles, company names, and
application dates for all the jobs the applicant has applied to.*/declare @app_id int= 2select j.job_title, c.company_name, a.application_date
from Applications as a
join Jobs as j on a.job_id= j.job_id
join Companies as c on j.company_id = c.company_id
where a.applicant_id = @app_id/* 8. Create an SQL query that calculates and displays the average salary offered by all companies for
job listings in the "Jobs" table. Ensure that the query filters out jobs with a salary of zero.*/INSERT INTO Companies (company_name,Location)
VALUES ('New Developers', 'Delhi')INSERT INTO Jobs (company_id, job_title, job_description, job_location, salary, job_type, posted_date)
VALUES (4, 'Devops Engineer', 'Develop and maintain software applications.', 'Old delhi', null, 'Full-time', GETDATE())select avg(salary)as [avg_salary] from(select salary from Jobswhere salary is not null and salary>0) as q1/* 9. Write an SQL query to identify the company that has posted the most job listings. Display the
company name along with the count of job listings they have posted. Handle ties if multiple
companies have the same maximum count.*/INSERT INTO Jobs (company_id, job_title, job_description, job_location, salary, job_type, posted_date)
VALUES(2, 'Backend Engineer', 'Develop and maintain software applications.', 'Punjab', null, 'Full-time', GETDATE()),(4, 'Frontend Engineer', 'Develop and maintain software applications.', 'Mumbai', 78000.00, 'Full-time', GETDATE())select c.company_name, count(j.job_id) as[count_of_jobs] from Companies as cjoin Jobs as j on c.company_id=j.company_idgroup by c.company_namehaving count(j.job_id) =(select max(job_count) from(select count(j.job_id) as [job_count] from Jobsgroup by company_id) as q1)/*  10. Find the applicants who have applied for positions in companies located in 'CityX' and have at
least 3 years of experience.*/

--we have to add a table  named years of experience here
ALTER TABLE Applicants
ADD years_of_experience int default 0;

select * from Companies
select * from Applicants
select * from Applications
select * From Jobs

select a.first_name, a.last_name from Applicants as a
join Applications as a1 on a.applicant_id=a1.applicant_id
join Jobs as j on a1.job_id=j.job_id
join Companies as c on j.company_id=c.company_id

where c.Location='Mumbai' and a.years_of_experience>=3

INSERT INTO Applications (job_id, applicant_id, application_date,cover_letter)
VALUES ( 4, 5, GETDATE(), 'Cover letter for Software Engineer role'),
       (2, 2, GETDATE(), 'Cover letter for Data Analyst role'),
       (6 ,6, GETDATE(), 'Cover letter for UX Designer role')

/* 11. 1. Retrieve a list of distinct job titles with salaries between $60,000 and $80,000*/

SELECT DISTINCT j.job_title
FROM Jobs AS j
WHERE j.salary BETWEEN 60000 AND 80000;

/* 12. Find the jobs that have not received any applications.*/
SELECT j.job_id, j.job_title
FROM Jobs AS j
LEFT JOIN Applications AS a ON j.job_id = a.job_id
where a.applicant_id is null

/* 13. Retrieve a list of job applicants along with the companies they have applied to and the positions
they have applied for*/

SELECT a.applicant_id, a.first_name, a.last_name,c.company_name, j.job_title
FROM Applicants AS a
JOIN Applications AS a1 ON a.applicant_id = a1.applicant_id
JOIN Jobs AS j ON a1.job_id = j.job_id
JOIN Companies AS c ON j.company_id = c.company_id

/* 14. . Retrieve a list of companies along with the count of jobs they have posted, even if they have not
received any applications.*/

select c.company_name , count(j.job_id) as [job_cnt] from Companies as c
left join jobs as J on c.company_id=j.company_id
group by c.company_id,c.company_name

/* 15. List all applicants along with the companies and positions they have applied for, including those
who have not applied.*/

SELECT a.applicant_id, a.first_name, a.last_name, c.company_name, j.job_title
FROM Applicants AS a
LEFT JOIN Applications AS app ON a.applicant_id = app.applicant_id
LEFT JOIN Jobs AS j ON app.job_id = j.job_id
LEFT JOIN Companies AS c ON j.company_id = c.company_id



/* 16. Find companies that have posted jobs with a salary higher than the average salary of all jobs.*/

SELECT DISTINCT c.company_id, c.company_id
FROM Companies AS c
JOIN Jobs AS j ON c.company_id = j.company_id
WHERE j.salary > (
SELECT AVG(salary) FROM Jobs
)

/*  17. Display a list of applicants with their names and a concatenated string of their city and state*/

ALTER TABLE Applicants
ADD city varchar(50)    

ALTER TABLE Applicants
ADD state varchar(50)   

INSERT INTO Applicants ( first_name, last_name, email, Phone, Resumes,city,state)
VALUES ('Raghav', 'Singh', 'raghav.sin@gmail.com', '123-456-7890', 'Resume for Raghav','mumbai','Maharshtra'),
       ('Shivani', 'Sinha', 'shvani.smith@gmail.com', '058-765-4321', 'Resume for Shivani','New York','USA')

select * from Applicants

select applicant_id , concat_ws(' ',first_name,last_name) as [Name] , concat_ws(' ',city,state) as [Address]
from Applicants


/* 18. . Retrieve a list of jobs with titles containing either 'Developer' or 'Engineer'*/
select * from Jobs

INSERT INTO Jobs (company_id, job_title, job_description, job_location, salary, job_type, posted_date)
VALUES (2, 'Java Developer', 'Develop software.', 'New delhi', 65000.00, 'Full-time', GETDATE())

select job_title, job_description, job_location, salary, job_type, posted_date from Jobs
where job_title like  '%Developer%' OR job_title LIKE '%Engineer%';

/* 19. Retrieve a list of applicants and the jobs they have applied for, including those who have not
applied and jobs without applicants.*/

SELECT a.applicant_id, a.first_name, a.last_name, j.job_id, j.job_title
FROM Applicants AS a
full outer join Applications AS a1 ON a.applicant_id= a1.applicant_id
full outer join Jobs AS j ON a1.job_id = j.job_id




/* 20. List all combinations of applicants and companies where the company is in a specific city and the
applicant has more than 2 years of experience. For example: city=Chennai*/


SELECT a.applicant_id, a.first_name, a.last_name, c.company_name
FROM Applicants AS a
JOIN Applications AS a1 ON a.applicant_id = a1.applicant_id
JOIN Jobs AS j ON a1.job_id= j.job_id
JOIN Companies AS c ON j.company_id = c.company_id
WHERE c.Location = 'Hexaware' 
  AND a.years_of_experience > 2;
