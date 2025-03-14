CREATE DATABASE telecomunicaciones;
USE telecomunicaciones;

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
SELECT * FROM telecomunicaciones_stg;

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



