/*
 * 1. Cuales son los trabajos de analisis de datos mejor pagados?
 * - Identificamos los 10 trabajos mejor pagados en analisis de datos ya sean remotos o en Mexico.
 * - Nos enfocamos en los trabajos que especifican sus salarios(Valores no Nulos).
 */

SELECT
	job_id,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg,
	job_posted_date,
	name AS company_name
FROM 
	job_postings_fact jpf 
LEFT JOIN company_dim cd ON jpf.company_id = cd.company_id 
WHERE
	job_title_short = 'Data Analyst' AND
	salary_year_avg IS NOT NULL AND
	(job_country  = 'Mexico' OR job_work_from_home = TRUE)
ORDER BY 
	salary_year_avg DESC
LIMIT 10;

/*
 * 2. Cuales son las habilidades requeridas para estos trabajos?
 * - Usamos los datos obtenidos del query anterior.
 * - Agregamos las habilidades requeridas para esos trabajos.
 */

WITH top_paying_jobs AS (
	SELECT
		job_id,
		job_title,
		salary_year_avg,
		name AS company_name
	FROM 
		job_postings_fact jpf 
	LEFT JOIN company_dim cd ON jpf.company_id = cd.company_id 
	WHERE
		job_title_short = 'Data Analyst' AND
		salary_year_avg IS NOT NULL AND
		(job_country  = 'Mexico' OR job_work_from_home = TRUE)
	ORDER BY 
		salary_year_avg DESC
	LIMIT 10
)
SELECT 
	tpj.*, 
	sd.skills
FROM 
	top_paying_jobs tpj
INNER JOIN skills_job_dim sjd ON tpj.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
ORDER BY
	tpj.salary_year_avg DESC;

/*
 * 3. Cuales son las habilidades mas demandas en analisis de datos.
 */

WITH skills_ids AS (
SELECT skill_id
FROM skills_job_dim sjd
WHERE job_id IN (
	SELECT jpf.job_id 
	FROM job_postings_fact jpf 
	WHERE jpf.job_title_short = 'Data Analyst'
)
)
SELECT 
	sd.skills, 
	COUNT(sd.skill_id) AS demand_count
FROM 
	skills_ids si
INNER JOIN skills_dim sd ON si.skill_id = sd.skill_id
GROUP BY 
	sd.skills
ORDER BY 
	demand_count DESC
LIMIT 5;

/*
 * 4. Como se compara el analisis de datos frente a otros trabajos relacionados con datos?
 * - Filtramos los trabajos que tienen que ver con datos
 * - Contamos la cantidad de trabajos que ofrece cada rol
 */
SELECT 
	job_title_short,
	COUNT(job_title) AS job_count,
	ROUND(AVG(salary_year_avg)) AS salary_avg
FROM 
	job_postings_fact jpf
WHERE 
	salary_year_avg IS NOT NULL AND 
	job_title_short LIKE '%Data%'
GROUP BY
	job_title_short;