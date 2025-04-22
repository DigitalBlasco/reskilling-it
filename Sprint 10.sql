-- Creem una base de dades 

CREATE DATABASE IF NOT EXISTS sprint_10_roser_bbdd_afa;


-- Creem la taula families amb un ID incremental

CREATE TABLE IF NOT EXISTS families_restringit (
    id_familia INT AUTO_INCREMENT PRIMARY KEY,
    id_infant INT,
    nombre VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(100),
    tokapp VARCHAR(50),
    grupo VARCHAR(50),
    representantes VARCHAR(255),
    estatus_socis BOOLEAN
);

-- I afegim les dades de la TokApp

LOAD DATA INFILE 'TokApp_Families_Socies_sense_germans.csv' INTO TABLE families_restringit
	FIELDS TERMINATED BY ';' 
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(id_infant, nombre, telefono, email, tokapp, grupo, representantes, estatus_socis);
	
LOAD DATA INFILE 'TokApp_Families_No_Socies_sense_germans.csv' INTO TABLE families_restringit
	FIELDS TERMINATED BY ';' 
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(id_infant, nombre, telefono, email, tokapp, grupo, representantes, estatus_socis);
	
	
LOAD DATA INFILE 'TokApp_Families_No_volen_ser_socies_sense_germans.csv' INTO TABLE families_restringit
	FIELDS TERMINATED BY ';' 
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(id_infant, nombre, telefono, email, tokapp, grupo, representantes, estatus_socis);
	

CREATE TABLE families_anonimitzat AS SELECT
    id_familia,
    SUBSTRING_INDEX(nombre, ',', 1) AS cognoms,
    id_infant,
    estatus_socis
FROM families_restringit;


ALTER TABLE families_anonimitzat
ADD PRIMARY KEY (id_familia);




CREATE TABLE IF NOT EXISTS tots_els_infants (
    id_infant INT PRIMARY KEY,
    nombre VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(100),
    tokapp VARCHAR(50),
    grupo VARCHAR(50),
    representantes VARCHAR(255)
);


LOAD DATA INFILE 'TokApp_Z.Tots_Infants.csv' INTO TABLE tots_els_infants
	FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(id_infant, nombre, telefono, email, tokapp, grupo, representantes);
	

CREATE TABLE infants_anonimitzat AS SELECT 
    id_infant,
	SUBSTRING_INDEX(nombre, ',', 1) AS cognoms,
    SUBSTRING_INDEX(nombre, ',', -1) AS nom
FROM tots_els_infants;

ALTER TABLE infants_anonimitzat
ADD PRIMARY KEY (id_infant);


ALTER TABLE families_anonimitzat
ADD FOREIGN KEY (id_infant) REFERENCES infants_anonimitzat(id_infant);	

-- Estan tots els nens de les famílies en la taula tots els nens? Si, el resultat és el mateix, 385
SELECT *
FROM infants_anonimitzat
INNER JOIN families_anonimitzat
ON infants_anonimitzat.id_infant = families_anonimitzat.id_infant;


-- Quants nens estan en la taula tots els nens que no estan a la taula famílies? 90, la diferència entre 475 i 385

SELECT *
FROM infants_anonimitzat
LEFT JOIN families_anonimitzat on infants_anonimitzat.id_infant = families_anonimitzat.id_infant
WHERE families_anonimitzat.id_infant is NULL;

-- Els nens que tenen ID de família:



SELECT id_familia
FROM families_anonimitzat
LEFT JOIN infants_anonimitzat on infants_anonimitzat.id_infant = families_anonimitzat.id_infant;


-- Ara copiem el ID de família a la taula de nens

ALTER TABLE infants_anonimitzat 
ADD id_familia INT;

UPDATE infants_anonimitzat
JOIN families_anonimitzat on infants_anonimitzat.id_infant = families_anonimitzat.id_infant
SET infants_anonimitzat.id_familia = families_anonimitzat.id_familia;

SELECT *
FROM infants_anonimitzat;

SELECT *
FROM infants_anonimitzat
LEFT JOIN families_anonimitzat on infants_anonimitzat.id_infant = families_anonimitzat.id_infant
WHERE families_anonimitzat.id_infant is NULL;


-- Observem quin seria el canvi

SELECT s1.id_infant, s1.cognoms, s1.id_familia AS before_familia,
       s2.id_familia AS from_sibling
FROM infants_anonimitzat s1
JOIN infants_anonimitzat s2 
  ON s1.cognoms = s2.cognoms
WHERE s1.id_familia IS NULL
  AND s2.id_familia IS NOT NULL;


-- fem el canvi pegant el id_familia dels germans

UPDATE infants_anonimitzat s1
JOIN infants_anonimitzat s2 
  ON s1.cognoms = s2.cognoms
SET s1.id_familia = s2.id_familia
WHERE s1.id_familia IS NULL
  AND s2.id_familia IS NOT NULL;
  
  
SELECT *
FROM infants_anonimitzat
WHERE id_familia is NULL;

-- Arreglem una entrada on un dels germans sabem que no té els mateixos cognoms i la borrem de la llista de famílies.

UPDATE infants_anonimitzat
SET id_familia = (
    SELECT id_familia
    FROM (
        SELECT id_familia
        FROM infants_anonimitzat
        WHERE id_infant = 75
    ) AS subquery
)
WHERE id_infant = 379;

SELECT * 
FROM infants_anonimitzat
WHERE id_infant = 379;


SELECT *
FROM families_anonimitzat
WHERE id_infant = 379;

DELETE from families_anonimitzat
WHERE id_infant = 379;


-- Ara afegim una relació via el id de família


ALTER TABLE infants_anonimitzat
ADD FOREIGN KEY (id_familia) REFERENCES families_anonimitzat(id_familia);

-- Treiem la relació via id d'infant 
-- SHOW CREATE TABLE families_anonimitzat;
ALTER TABLE families_anonimitzat
DROP FOREIGN KEY families_anonimitzat_ibfk_1;



-- Treiem de la taula famílies les columnes que no ens calen: els cognoms i id infant


ALTER TABLE families_anonimitzat
DROP COLUMN cognoms;


ALTER TABLE families_anonimitzat
DROP COLUMN id_infant;

SELECT *
FROM families_anonimitzat;


-- I de la taula d'infants anonimitzats, treiem els noms i cognoms 
ALTER TABLE infants_anonimitzat
DROP COLUMN cognoms; 

ALTER TABLE infants_anonimitzat
DROP COLUMN nom; 


SELECT * 
FROM infants_anonimitzat;

-- Cuántes famílies hi ha al TokApp? 384
SELECT COUNT(*)
FROM families_anonimitzat;

-- Cuántes famílies socies hi ha? 242
SELECT COUNT(*)
FROM families_anonimitzat
WHERE estatus_socis = 1;

-- Cuántes famílies no socies hi ha? 142
SELECT COUNT(*)
FROM families_anonimitzat
WHERE estatus_socis = 0;

-- Cuants nens hi ha al TokApp? 475
SELECT COUNT(*)
FROM infants_anonimitzat;


-- Cuants nens socis hi ha? 308
SELECT COUNT(infants_anonimitzat.id_infant)
FROM infants_anonimitzat
JOIN families_anonimitzat ON families_anonimitzat.id_familia = infants_anonimitzat.id_familia
WHERE families_anonimitzat.estatus_socis = 1 
;

-- Cuants nens no socis hi ha? 167
SELECT COUNT(infants_anonimitzat.id_infant)
FROM infants_anonimitzat
JOIN families_anonimitzat ON families_anonimitzat.id_familia = infants_anonimitzat.id_familia
WHERE families_anonimitzat.estatus_socis = 0 
;



-- Hem graficat en Python la distribució de famílies segons el número de fills

-- Ara importem la taula d'acollida
CREATE TABLE IF NOT EXISTS acollida_restringit (
    marca_temps VARCHAR(50),
    email VARCHAR(50),
    cognom1 VARCHAR(50),
    cognom2 VARCHAR(50),
    nom VARCHAR(50),
    curs VARCHAR(50),
    data_neixement VARCHAR(50),
    adressa VARCHAR(50),
    codi_postal VARCHAR(50),
    poblacio VARCHAR(50),
    nom_tutor VARCHAR(50),
    cognoms_tutor VARCHAR(50),
    dni VARCHAR(50),
    telefon VARCHAR(100),
    mensual_mati VARCHAR(50),
    dies_mati VARCHAR(50),
    mensual_tarda VARCHAR(50),
    dies_tarda VARCHAR(50),
    IBAN VARCHAR(50),
    estatus_declarat VARCHAR(50),
    conforme VARCHAR(50),
    id_infant VARCHAR(50),
    estatus VARCHAR(50)
);



LOAD DATA INFILE 'FORMULARI INSCRIPCIO ACOLLIDA 24-25 (Responses) - Form Responses 1.csv' INTO TABLE acollida_restringit
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(marca_temps, email, cognom1, cognom2, nom, curs, data_neixement, adressa, codi_postal,poblacio, nom_tutor, cognoms_tutor, dni, telefon, mensual_mati, dies_mati, mensual_tarda, dies_tarda, IBAN, estatus_declarat, conforme, id_infant, estatus);


SELECT *
FROM  acollida_restringit;


-- Creem una nova taula anonimitzada

CREATE TABLE acollida_anonimitzat AS SELECT
    marca_temps,
    id_infant,
    curs,
    mensual_mati, 
    dies_mati, 
    mensual_tarda, 
    dies_tarda,
    estatus_declarat
FROM acollida_restringit;


-- Cuants infants tenen domiciliada acollida? 69

SELECT *
FROM acollida_anonimitzat
WHERE id_infant = 'duplicat';


DELETE FROM acollida_anonimitzat
WHERE id_infant = 'duplicat';

SELECT *
FROM acollida_anonimitzat
WHERE id_infant = 'duplicat';

SELECT COUNT(*)
FROM acollida_anonimitzat;

-- Ara importem les taules d'extraescolars


CREATE TABLE IF NOT EXISTS extraescolar_angles_2425 (
	cognoms VARCHAR(50),
	nom VARCHAR(50),
	curs VARCHAR(50),
	id_infant INT NULL,
	estatus_socis VARCHAR(50)
);


LOAD DATA INFILE 'ANGLES.csv' INTO TABLE extraescolar_angles_2425
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(cognoms, nom, curs, @id_infant, estatus_socis)
	SET id_infant = NULLIF(@id_infant, '');


CREATE TABLE IF NOT EXISTS extraescolar_basquet_2425 (
	nom_complet VARCHAR(50),
	curs VARCHAR(50),
	any_neixement VARCHAR(50),
	dies VARCHAR(50),
	id_infant INT NULL,
	estatus_socis VARCHAR(50)
);

LOAD DATA INFILE 'BASQUET.csv' INTO TABLE extraescolar_basquet_2425
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(nom_complet, curs, any_neixement, dies, @id_infant, estatus_socis)
	SET id_infant = NULLIF(@id_infant, '');
	


CREATE TABLE IF NOT EXISTS extraescolar_taekwondo_2425 (
	nom VARCHAR(50),
	cognoms VARCHAR(50),
	grup_clase VARCHAR(50),
	curs VARCHAR(50),
	data_baixa VARCHAR(50),
	activitat VARCHAR(50),
	dies VARCHAR(50),
	id_infant INT NULL,
	estatus_socis VARCHAR(50)
);

LOAD DATA INFILE 'TAEKWONDO.csv' INTO TABLE extraescolar_taekwondo_2425
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(nom, cognoms, grup_clase, curs, data_baixa, activitat, dies, @id_infant, estatus_socis)
	SET id_infant = NULLIF(@id_infant, '');

CREATE TABLE IF NOT EXISTS extraescolar_patinatge_2425 (
	nom VARCHAR(50),
	cognoms VARCHAR(50),
	grup_clase VARCHAR(50),
	curs VARCHAR(50),
	data_baixa VARCHAR(50),
	activitat VARCHAR(50),
	dies VARCHAR(50),
	id_infant INT NULL,
	estatus_socis VARCHAR(50)
);

LOAD DATA INFILE 'PATINATGE.csv' INTO TABLE extraescolar_patinatge_2425
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(nom, cognoms, grup_clase, curs, data_baixa, activitat, dies, @id_infant, estatus_socis)
	SET id_infant = NULLIF(@id_infant, '');
	
	
CREATE TABLE IF NOT EXISTS extraescolar_cuinafreda_2425 (
	nom VARCHAR(50),
	cognoms VARCHAR(50),
	grup_clase VARCHAR(50),
	curs VARCHAR(50),
	data_baixa VARCHAR(50),
	activitat VARCHAR(50),
	dies VARCHAR(50),
	id_infant INT NULL,
	estatus_socis VARCHAR(50)
);

LOAD DATA INFILE 'CUINA FREDA.csv' INTO TABLE extraescolar_cuinafreda_2425
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(nom, cognoms, grup_clase, curs, data_baixa, activitat, dies, @id_infant, estatus_socis)
	SET id_infant = NULLIF(@id_infant, '');
	
	

CREATE TABLE IF NOT EXISTS extraescolar_manualitats_2425 (
	nom VARCHAR(50),
	cognoms VARCHAR(50),
	grup_clase VARCHAR(50),
	curs VARCHAR(50),
	data_baixa VARCHAR(50),
	activitat VARCHAR(50),
	dies VARCHAR(50),
	id_infant INT NULL,
	estatus_socis VARCHAR(50)
);

LOAD DATA INFILE 'MANUALITATS.csv' INTO TABLE extraescolar_manualitats_2425
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(nom, cognoms, grup_clase, curs, data_baixa, activitat, dies, @id_infant, estatus_socis)
	SET id_infant = NULLIF(@id_infant, '');
	


CREATE TABLE IF NOT EXISTS extraescolar_robotica_2425 (
	nom VARCHAR(50),
	cognoms VARCHAR(50),
	grup_clase VARCHAR(50),
	curs VARCHAR(50),
	data_baixa VARCHAR(50),
	activitat VARCHAR(50),
	dies VARCHAR(50),
	id_infant INT NULL,
	estatus_socis VARCHAR(50)
);

LOAD DATA INFILE 'ROBOTICA PRIMARIA.csv' INTO TABLE extraescolar_robotica_2425
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(nom, cognoms, grup_clase, curs, data_baixa, activitat, dies, @id_infant, estatus_socis)
	SET id_infant = NULLIF(@id_infant, '');
	
CREATE TABLE IF NOT EXISTS extraescolar_multiesport_2425 (
	nom VARCHAR(50),
	cognoms VARCHAR(50),
	grup_clase VARCHAR(50),
	curs VARCHAR(50),
	data_baixa VARCHAR(50),
	activitat VARCHAR(50),
	dies VARCHAR(50),
	id_infant INT NULL,
	estatus_socis VARCHAR(50)
);

LOAD DATA INFILE 'MULTIESPORT.csv' INTO TABLE extraescolar_multiesport_2425
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(nom, cognoms, grup_clase, curs, data_baixa, activitat, dies, @id_infant, estatus_socis)
	SET id_infant = NULLIF(@id_infant, '');

CREATE TABLE IF NOT EXISTS extraescolar_voleiprimaria_2425 (
	nom VARCHAR(50),
	cognoms VARCHAR(50),
	grup_clase VARCHAR(50),
	curs VARCHAR(50),
	data_baixa VARCHAR(50),
	activitat VARCHAR(50),
	dies VARCHAR(50),
	id_infant INT NULL,
	estatus_socis VARCHAR(50)
);

LOAD DATA INFILE 'VOLEIBOL PRIMARIA.csv' INTO TABLE extraescolar_voleiprimaria_2425
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(nom, cognoms, grup_clase, curs, data_baixa, activitat, dies, @id_infant, estatus_socis)
	SET id_infant = NULLIF(@id_infant, '');
	
CREATE TABLE IF NOT EXISTS extraescolar_gim_i52_2425 (
	nom VARCHAR(50),
	cognoms VARCHAR(50),
	grup_clase VARCHAR(50),
	curs VARCHAR(50),
	data_baixa VARCHAR(50),
	activitat VARCHAR(50),
	dies VARCHAR(50),
	id_infant INT NULL,
	estatus_socis VARCHAR(50)
);

LOAD DATA INFILE 'GIMNASTICA I52.csv' INTO TABLE extraescolar_gim_i52_2425
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(nom, cognoms, grup_clase, curs, data_baixa, activitat, dies, @id_infant, estatus_socis)
	SET id_infant = NULLIF(@id_infant, '');



CREATE TABLE IF NOT EXISTS extraescolar_prefutbol_2425 (
	nom VARCHAR(50),
	cognoms VARCHAR(50),
	grup_clase VARCHAR(50),
	curs VARCHAR(50),
	data_baixa VARCHAR(50),
	activitat VARCHAR(50),
	dies VARCHAR(50),
	id_infant INT NULL,
	estatus_socis VARCHAR(50)
);

LOAD DATA INFILE 'PRE FUTBOL.csv' INTO TABLE extraescolar_prefutbol_2425
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(nom, cognoms, grup_clase, curs, data_baixa, activitat, dies, @id_infant, estatus_socis)
	SET id_infant = NULLIF(@id_infant, '');
	
	


CREATE TABLE IF NOT EXISTS extraescolar_iesportiva_2425 (
	nom VARCHAR(50),
	cognoms VARCHAR(50),
	grup_clase VARCHAR(50),
	curs VARCHAR(50),
	data_baixa VARCHAR(50),
	activitat VARCHAR(50),
	dies VARCHAR(50),
	id_infant INT NULL,
	estatus_socis VARCHAR(50)
);

LOAD DATA INFILE 'INICIACIO ESPORTIVA.csv' INTO TABLE extraescolar_iesportiva_2425
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(nom, cognoms, grup_clase, curs, data_baixa, activitat, dies, @id_infant, estatus_socis)
	SET id_infant = NULLIF(@id_infant, '');

CREATE TABLE IF NOT EXISTS extraescolar_gim_36_2425 (
	nom VARCHAR(50),
	cognoms VARCHAR(50),
	grup_clase VARCHAR(50),
	curs VARCHAR(50),
	data_baixa VARCHAR(50),
	activitat VARCHAR(50),
	dies VARCHAR(50),
	id_infant INT NULL,
	estatus_socis VARCHAR(50)
);

LOAD DATA INFILE 'GIMNASTICA 36.csv' INTO TABLE extraescolar_gim_36_2425
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(nom, cognoms, grup_clase, curs, data_baixa, activitat, dies, @id_infant, estatus_socis)
	SET id_infant = NULLIF(@id_infant, '');

CREATE TABLE IF NOT EXISTS extraescolar_zumba_2425 (
	nom VARCHAR(50),
	cognoms VARCHAR(50),
	grup_clase VARCHAR(50),
	curs VARCHAR(50),
	data_baixa VARCHAR(50),
	activitat VARCHAR(50),
	dies VARCHAR(50),
	id_infant INT NULL,
	estatus_socis VARCHAR(50)
);

LOAD DATA INFILE 'ZUMDANCE.csv' INTO TABLE extraescolar_zumba_2425
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(nom, cognoms, grup_clase, curs, data_baixa, activitat, dies, @id_infant, estatus_socis)
	SET id_infant = NULLIF(@id_infant, '');-- Intentem afegir relaions, però abans em de netejar algunes dades
/*ALTER TABLE extraescolar_angles_2425
ADD FOREIGN KEY (id_infant) REFERENCES infants_anonimitzat(id_infant);

SELECT DISTINCT id_infant
FROM extraescolar_angles_2425
WHERE id_infant IS NOT NULL
AND id_infant NOT IN (
SELECT id_infant FROM infants_anonimitzat
);

SELECT *
FROM extraescolar_angles_2425
WHERE id_infant = 353;



SELECT *
FROM families_restringit
WHERE nombre LIKE '%Jurado%'; */
-- Caniem el ID de 353 a 719 en extraescolar_angles_2425

UPDATE extraescolar_angles_2425
SET
  id_infant = 719
WHERE
  id_infant = 353;


ALTER TABLE extraescolar_angles_2425
ADD FOREIGN KEY (id_infant) REFERENCES infants_anonimitzat(id_infant);

SELECT *
FROM extraescolar_angles_2425;

