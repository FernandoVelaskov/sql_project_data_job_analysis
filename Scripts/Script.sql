/* 
* Proceso de Limpieza de datos.
*/ 

-- 1. Convertir textos vacios a Nulos.
UPDATE job_postings_fact
SET job_country = NULL
WHERE job_country = '';

UPDATE job_postings_fact
SET salary_rate = NULL
WHERE salary_rate = '';

UPDATE company_dim
SET name = NULL
WHERE name = '';

UPDATE company_dim
SET link = NULL 
WHERE link = '';

UPDATE company_dim
SET link_google = NULL 
WHERE link_google = '';

UPDATE company_dim 
SET thumbnail = NULL
WHERE thumbnail = '';

-- 2. Cambiar los tipos de datos
UPDATE job_postings_fact
SET job_work_from_home = CASE
	WHEN job_work_from_home = 'True' THEN '1'
	WHEN job_work_from_home = 'False' THEN '0'
	ELSE job_work_from_home
END;

UPDATE job_postings_fact
SET job_no_degree_mention = CASE
	WHEN job_no_degree_mention = 'True' THEN '1'
	WHEN job_no_degree_mention = 'False' THEN '0'
	ELSE job_no_degree_mention
END;

UPDATE job_postings_fact
SET job_health_insurance = CASE
	WHEN job_health_insurance = 'True' THEN '1'
	WHEN job_health_insurance = 'False' THEN '0'
	ELSE job_health_insurance
END;

ALTER TABLE job_postings_fact
MODIFY COLUMN job_work_from_home TINYINT(1);

ALTER TABLE job_postings_fact
MODIFY COLUMN job_posted_date TIMESTAMP;

ALTER TABLE job_postings_fact
MODIFY COLUMN job_no_degree_mention TINYINT(1);

ALTER TABLE job_postings_fact
MODIFY COLUMN job_health_insurance TINYINT(1);

-- 3. Identificar y eliminar los duplicados
SELECT *
FROM skills_dim
WHERE skills IN (
	SELECT skills
	FROM skills_dim
	GROUP BY skills
	HAVING COUNT(*) > 1 AND COUNT(DISTINCT(`type`)) = 1
);

SELECT *
FROM job_postings_fact jpf 
WHERE job_id IN (
	SELECT job_id
	FROM skills_job_dim sjd 
	WHERE sjd.skill_id = 203
)
INTERSECT 
SELECT *
FROM job_postings_fact
WHERE job_id IN (
	SELECT job_id 
	FROM skills_job_dim
	WHERE skill_id = 205
);

SELECT *
FROM job_postings_fact jpf 
WHERE job_id IN (
	SELECT job_id
	FROM skills_job_dim sjd 
	WHERE sjd.skill_id = 164
)
INTERSECT 
SELECT *
FROM job_postings_fact
WHERE job_id IN (
	SELECT job_id 
	FROM skills_job_dim
	WHERE skill_id = 166
);

SELECT *
FROM job_postings_fact jpf 
WHERE job_id IN (
	SELECT job_id
	FROM skills_job_dim sjd 
	WHERE sjd.skill_id = 71
)
INTERSECT 
SELECT *
FROM job_postings_fact
WHERE job_id IN (
	SELECT job_id 
	FROM skills_job_dim
	WHERE skill_id = 72
);

UPDATE skills_job_dim
SET skill_id = 203
WHERE skill_id = 205;

UPDATE skills_job_dim
SET skill_id = 164
WHERE skill_id = 166;

UPDATE skills_job_dim
SET skill_id = 71
WHERE skill_id = 72;

DELETE FROM skills_dim
WHERE skill_id IN (205, 166, 72);

SELECT jpf.job_id 
FROM job_postings_fact jpf 
GROUP BY job_id 
HAVING COUNT(*) > 1;

SELECT name 
FROM company_dim cd 
GROUP BY cd.name  
HAVING COUNT(*) > 1;

-- 4. Descartar datos no relevantes


SELECT *
FROM job_postings_fact jpf 
WHERE jpf.company_id = 0;

SELECT *
FROM skills_job_dim sjd;

SELECT *
FROM job_postings_fact jpf
WHERE jpf.job_country = 'Mexico'

-- 
ALTER TABLE job_postings_fact
ADD PRIMARY KEY (job_id);

ALTER TABLE job_postings_fact
ADD FOREIGN KEY (company_id) REFERENCES data_jobs.company_dim(company_id)