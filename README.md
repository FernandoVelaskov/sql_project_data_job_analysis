# Introducci\'on
Proyecto de analisis de datos con SQL. Analizando el mercado laboral de datos, centrandose en los roles de analista de datos, los trabajos mejor pagados, habilidades mas demandadas y cuales son las habilidades mejor pagadas.

# Justificacion
Este proyecto esta basado o inspirado en el proyecto "Optimal Skills Analysis" del [Curso de SQL](https://lukevarousse.com/sql) realizado por Luke Barousse, contando con diferencias para ajustarse mas al contexto propio.

El proyecto busca demostrar las habilidades y conocimientos en SQL necesarios en el analisis de datos.

### Las preguntas que quiero responder a travez de mis consultas en SQL son:
1. Cuales son los trabajos mejor pagados en analisis de datos?
2. Cuales son las habilidades requeridas para esos trabajos?
3. Cuales son las habilidades mas demandadas para analisis de datos?
4. Cuales son las habilidades mas valoradas?
5. Como se compara el analisis de datos frente a otros trabajos relacionados con datos?

# Herramientas usadas
Para el analisis de las ofertas laborales, se hicieron uso de las siguientes herramientas:

- **SQL:** La herramienta principal de mi analisis, lo que permite consultar la base de datos y descubrir informacion critica.
- **MariaDB:** El sistema de gestion de bases de datos elegido, ideal para el manejo de los datos de publicacionde trabajo.
- **DBeaver:** Mi opcion para la gestion de bases de datos y la ejecucion de consultas SQL.
- **Python:** Usando bibliotecas como plotly para la visualizacion de los datos.
- **Git&Github:** Para el control de versiones y compartir mis scripts y analisis, dandole seguimiento al proyecto.

# Analisis
Cada script de este proyecto tiene la finalidad de realizar una tarea especifica siguiendo la metodologia del Analisis de Datos.

### Cleaning
Se procede a realizar una limpieza de los datos y darle un formato para su posterior analisis.

1. Estandarizar los textos.
2. Convertir textos vacios a Nulos.
3. Cambiar los tipos de datos.
4. Identificar y eliminar duplicados.
5. Descartar datos no necesarios.

### Analysis
Se crea un query para cada pregunta a responder.

#### 1. Trabajos de analisis de datos mejor pagados
Para identificar los trabajos mejor pagados, filtramos los trabajos que son de analisis de datos, y los seleccionamos junto con el salario promedio al ano y su localizacion, nos enfocaremos en los trabajos remotos o que se promocionan en Mexico.

```sql
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
```

Aqui esta el desglose de nuestro analisis:
- **Amplio y alto rango salarial:** Los 10 principales trabajos de analista de datos abarcan sueldos desde $184,000 hasta $650,000 dolares al ano.
- **Diversas Empresas:** Las empresas como AT&T, Meta o Pinterest demuestran el interes de las diferentes industrias.
- **Puestos Altos:** Las empresas buscan profesionales con cargo de Directivo o Principal, demostrando la escalabilidad del campo de analisis de datos.

![Top Paying Roles](images/fig1.png)
*La grafica de barras visualiza los salarios de los 10 mejores trabajos para analisis de datos, fue generado usando Plotly.*