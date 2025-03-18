CREATE DATABASE telecomunicaciones;
USE telecomunicaciones;
SELECT tel_movil_unid, departamento, anio FROM telecomunicaciones_stg 
WHERE anio = 2011
ORDER BY tel_movil_unid;
SELECT SUM(tel_pub_unid), anio, COUNT(*) FROM telecomunicaciones_stg GROUP BY anio;
SELECT SUM(tel_fija_unid), anio, COUNT(*) FROM telecomunicaciones_stg GROUP BY anio;
CREATE TABLE telecomunicaciones_stg(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    departamento VARCHAR(20), --
    anio INT, -- Este se queda
    uso_cabina_porc FLOAT, --
    tel_fija_unid INT, --
    tel_movil_unid INT, --
    tel_pub_unid INT, --
    uso_inter_porc FLOAT, --
    sub_inter_fijo_unid INT, --
    vab_tel_miles_2007 INT, --
    pbi_regional_miles INT, --
    hogar_1_radio_porc FLOAT, -- 
    hogar_1_tv_porc FLOAT, --
    hogar_con_cable_porc FLOAT, --
    hogar_1_compu_porc FLOAT, --
    compus INT, --
    id_logit INT -- 
);


-- Tablas de dimensiones

CREATE TABLE dim_departamento (
    id_departamento INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    departamento VARCHAR(50) UNIQUE NOT NULL
);


CREATE TABLE dim_telefono(
	id_telefono INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	tel_fija_unid INT,
    tel_movil_unid INT,
    tel_pub_unid INT
);


CREATE TABLE dim_hogar(
	id_hogar INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    hogar_1_radio_porc FLOAT,
    hogar_1_tv_porc FLOAT,
    hogar_con_cable_porc FLOAT,
    hogar_1_compu_porc FLOAT
);


CREATE TABLE dim_pbi(
	id_pbi INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    pbi_regional_miles INT,
    id_logit INT
);


CREATE TABLE dim_internet(
	id_internet INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    uso_inter_porc FLOAT,
    sub_inter_fijo_unid INT
);


CREATE TABLE dim_computadora(
	id_computadora INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    vab_tel_miles_2007 INT,
    compus INT, 
    uso_cabina_porc FLOAT
);


-- Tabla de Hechos
CREATE TABLE fac_telecomunicaciones(
	id_telecomunicaciones INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	id_departamento INT, 
	id_telefono INT, 
	id_hogar  INT, 
	id_pbi INT, 
	id_internet INT, 
	id_computadora INT,
    anio INT -- Este no se relaciona a alguna tabla
);

-- Referenciando
ALTER TABLE fac_telecomunicaciones ADD CONSTRAINT fk_dim_departamento 
FOREIGN KEY fac_telecomunicaciones(id_departamento) REFERENCES dim_departamento(id_departamento);

ALTER TABLE fac_telecomunicaciones ADD CONSTRAINT fk_dim_telefono
FOREIGN KEY fac_telecomunicaciones(id_telefono) REFERENCES dim_telefono(id_telefono);

ALTER TABLE fac_telecomunicaciones ADD CONSTRAINT fk_dim_hogar 
FOREIGN KEY fac_telecomunicaciones(id_hogar) REFERENCES dim_hogar(id_hogar);

ALTER TABLE fac_telecomunicaciones ADD CONSTRAINT fk_dim_pbi
FOREIGN KEY fac_telecomunicaciones(id_pbi) REFERENCES dim_pbi(id_pbi);

ALTER TABLE fac_telecomunicaciones ADD CONSTRAINT fk_dim_internet
FOREIGN KEY fac_telecomunicaciones(id_internet) REFERENCES dim_internet(id_internet);

ALTER TABLE fac_telecomunicaciones ADD CONSTRAINT fk_dim_computadora
FOREIGN KEY fac_telecomunicaciones(id_computadora) REFERENCES dim_computadora(id_computadora);

-- Modificando tipos
ALTER TABLE telecomunicaciones_stg CHANGE id_logit id_logit ENUM("Alto","Bajo");
ALTER TABLE dim_pbi CHANGE id_logit id_logit ENUM("Alto","Bajo");

ALTER TABLE telecomunicaciones_stg CHANGE departamento departamento ENUM('Amazonas', 'Áncash', 'Apurímac', 'Arequipa', 'Ayacucho', 'Cajamarca', 'Callao', 'Cusco', 
'Huancavelica', 'Huánuco', 'Ica', 'Junín', 'La Libertad', 'Lambayeque', 'Lima Metropolitana', 'Lima provincias', 'Loreto', 'Madre de Dios', 'Moquegua', 
'Pasco', 'Piura', 'Puno', 'San Martín', 'Tacna', 'Tumbes', 'Ucayali');
ALTER TABLE dim_departamento CHANGE departamento departamento ENUM('Amazonas', 'Áncash', 'Apurímac', 'Arequipa', 'Ayacucho', 'Cajamarca', 'Callao', 'Cusco', 
'Huancavelica', 'Huánuco', 'Ica', 'Junín', 'La Libertad', 'Lambayeque', 'Lima Metropolitana', 'Lima provincias', 'Loreto', 'Madre de Dios', 'Moquegua', 
'Pasco', 'Piura', 'Puno', 'San Martín', 'Tacna', 'Tumbes', 'Ucayali');

-- Verificando la insercción que se hizo en python
SELECT DISTINCT(anio) FROM telecomunicaciones_stg;
SELECT DISTINCT(departamento) FROM telecomunicaciones_stg;
SELECT DISTINCT(id_logit) FROM telecomunicaciones_stg;
SELECT * FROM telecomunicaciones_stg WHERE tel_fija_unid = NULL;

-- Verificando el llenado de las tablas de dimensión
SELECT COUNT(*) FROM dim_computadora;
SELECT COUNT(*) FROM dim_internet;
SELECT COUNT(*) FROM dim_pbi;
SELECT COUNT(*) FROM dim_hogar;
SELECT COUNT(*) FROM dim_telefono;
SELECT COUNT(*) FROM dim_departamento;
SELECT COUNT(*) FROM telecomunicaciones_stg;
SELECT * FROM dim_computadora;
SELECT * FROM dim_internet;
SELECT * FROM dim_pbi;
SELECT * FROM dim_hogar;
SELECT * FROM dim_telefono;
SELECT * FROM dim_departamento;
SELECT * FROM telecomunicaciones_stg;

-- Para reiniciar el incremento de sus llaves primarias
DELETE FROM dim_computadora;
DELETE FROM dim_internet;
DELETE FROM dim_pbi;
DELETE FROM dim_hogar;
DELETE FROM dim_telefono;
DELETE FROM dim_departamento;
DELETE FROM telecomunicaciones_stg;
ALTER TABLE dim_computadora AUTO_INCREMENT = 1;
ALTER TABLE dim_internet AUTO_INCREMENT = 1;
ALTER TABLE dim_pbi AUTO_INCREMENT = 1;
ALTER TABLE dim_hogar AUTO_INCREMENT = 1;
ALTER TABLE dim_telefono AUTO_INCREMENT = 1;
ALTER TABLE dim_departamento AUTO_INCREMENT = 1;
ALTER TABLE telecomunicaciones_stg AUTO_INCREMENT = 1;

-- Sentencia para llenar tabla de hechos
SELECT * FROM fac_telecomunicaciones;
SELECT id_departamento, id_telefono, id_hogar, id_pbi, id_internet, id_computadora, anio FROM telecomunicaciones_stg
JOIN dim_computadora ON dim_computadora.id_computadora = telecomunicaciones_stg.id
JOIN dim_internet ON dim_internet.id_internet = telecomunicaciones_stg.id
JOIN dim_pbi ON dim_pbi.id_pbi = telecomunicaciones_stg.id
JOIN dim_hogar ON dim_hogar.id_hogar = telecomunicaciones_stg.id
JOIN dim_telefono ON dim_telefono.id_telefono = telecomunicaciones_stg.id
JOIN dim_departamento ON dim_departamento.departamento = telecomunicaciones_stg.departamento;






