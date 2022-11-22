CREATE SCHEMA scraping;
USE scraping;

CREATE TABLE vehicle_table(
	id_vehicle_table VARCHAR(12) NOT NULL,
	brand VARCHAR(20),
	model VARCHAR(50),
	model_year VARCHAR(50),
	PRIMARY KEY (id_vehicle_table)
);

CREATE TABLE query_table(
	id_query_table INT NOT NULL AUTO_INCREMENT,
	fipe_code VARCHAR(50),
	reference_month VARCHAR(50),
	authentication TEXT,
	consultation_date VARCHAR(50),
	average_price VARCHAR (20),
	fk_id_vehicle_table VARCHAR(12) NOT NULL,
	PRIMARY KEY (id_query_table),
	FOREIGN KEY (fk_id_vehicle_table) REFERENCES vehicle_table (id_vehicle_table)
);

CREATE TABLE cod_vehicle_table(
	id_cod_vehicle_table INT NOT NULL AUTO_INCREMENT,
	cod_brand VARCHAR(12) NOT NULL,
	cod_model VARCHAR(12) NOT NULL ,
	cod_model_year VARCHAR(12) NOT NULL ,
	cod_reference_month VARCHAR(12) NOT NULL,
    fk_id_vehicle_table VARCHAR(12) NOT NULL,
	PRIMARY KEY (id_cod_vehicle_table),
	FOREIGN KEY (fk_id_vehicle_table) REFERENCES vehicle_table (id_vehicle_table)
);

CREATE TABLE period(
	Codigo VARCHAR(12) NOT NULL,
    Mes VARCHAR(50) NOT NULL,
    seq INT,
	PRIMARY KEY (Codigo)
);

CREATE TABLE brands(
	id_Value INT AUTO_INCREMENT NOT NULL,
	Value VARCHAR(12) NOT NULL,
    Label VARCHAR(50) NOT NULL,
	PRIMARY KEY (id_value),
	fk_id_Value VARCHAR(12) NOT NULL,
	FOREIGN KEY (fk_id_Value) REFERENCES period (Codigo)
);

CREATE TABLE models(
	id_Value INT AUTO_INCREMENT NOT NULL,
	Value VARCHAR(12) NOT NULL,
    Label VARCHAR(50) NOT NULL,
	PRIMARY KEY (id_Value),
	fk_id_Value INT NOT NULL,
	FOREIGN KEY (fk_id_Value) REFERENCES brands (id_Value)
);

CREATE TABLE years(
	id_Value INT AUTO_INCREMENT NOT NULL,
	Value VARCHAR(12) NOT NULL,
    Label VARCHAR(50) NOT NULL,
	PRIMARY KEY (id_Value),
	fk_id_Value INT NOT NULL,
	FOREIGN KEY (fk_id_Value) REFERENCES brands (id_Value)
);

-- Cadastrar anos relacionados a um modelo pelo modelo
CREATE TABLE modelYear(
	id_Value INT AUTO_INCREMENT NOT NULL,
	Value VARCHAR(12) NOT NULL,
    Label VARCHAR(50) NOT NULL,
	PRIMARY KEY (id_Value),
	fk_id_Value INT NOT NULL,
	FOREIGN KEY (fk_id_Value) REFERENCES models (id_Value)
);

-- Cadastrar anos relacionados a um modelo pelo ano
CREATE TABLE yearModel(
	id_Value INT AUTO_INCREMENT NOT NULL,
	Value VARCHAR(12) NOT NULL,
    Label VARCHAR(50) NOT NULL,
	PRIMARY KEY (id_Value),
	fk_id_Value INT NOT NULL,
	FOREIGN KEY (fk_id_Value) REFERENCES years (id_Value)
);

-- REVISADO
/*
DROP SCHEMA fipe_scraping;
DROP TABLE cod_vehicle_table;
DROP TABLE query_table;
DROP TABLE vehicle_table;
DROP TABLE yearModel;
DROP TABLE modelYear;
DROP TABLE years;
DROP TABLE models;
DROP TABLE brands;
DROP TABLE period;

INSERT INTO vehicle_table(id_vehicle_table, brand, model, model_year) VALUES ("1", 'GM - Chevrolet','ONIX HATCH LT 1.4 8V FlexPower 5p Mec.', '2015 Gasolina');
INSERT INTO query_table (fipe_code, reference_month, authentication, consultation_date, average_price, fk_id_vehicle_table) VALUES ( "0940534" , 'outubro de 2022', 'wtktdjmyqmvt', 'sábado, 29 de outubro de 2022 12:38','R$ 46.247,00', "1");
INSERT INTO cod_vehicle_table (cod_brand, cod_model, cod_model_year, cod_reference_month, fk_id_vehicle_table) VALUES ("23", "7691", "2019-1", "290", "1");
INSERT INTO period (Codigo, Mes, seq) VALUES ('291','novembro/2022', 263);
INSERT INTO brands (Value, Label, fk_id_Value) VALUES ('1', 'Acura', '291');
INSERT INTO models (Value, Label, fk_id_Value) VALUES ('1', 'Integra GS 1.8', 1);
INSERT INTO models (Value, Label, fk_id_Value) VALUES ('2', 'Legend 3.2/3.5', 1);
INSERT INTO years (Value, Label, fk_id_Value) VALUES ('1', '1998 Gasolina', 1);
INSERT INTO modelYear (Value, Label, fk_id_Value) VALUES ('1992-1', '1998 Gasolina', 1);
INSERT INTO modelYear (Value, Label, fk_id_Value) VALUES ('1991-1', '1991 Gasolina', 1);  
INSERT INTO modelYear (Value, Label, fk_id_Value) VALUES ('1998-8', '1991 Gasolina', 1); 

SELECT * FROM vehicle_table;
SELECT * FROM query_table;
SELECT * FROM cod_vehicle_table;
SELECT * FROM period;
SELECT * FROM brands;
SELECT * FROM models;

SELECT id_Value FROM years WHERE Value = '1992-1' AND fk_id_Value = '146';

SELECT * FROM years;
SELECT * FROM modelYear;
SELECT * FROM yearModel;
SELECT Codigo FROM period LIMIT 1;
*/

-- REVISAR
/*SELECT vehicle_table.brand, 
	vehicle_table.model, 
	vehicle_table.model_year, 
	query_table.reference_month FROM vehicle_table 
	INNER JOIN query_table ON query_table.id_vehicle_table = vehicle_table.id_vehicle_table
	WHERE brand = "GM - Chevrolet" 
	AND model = "ONIX HATCH Joy 1.0 8V Flex 5p Mec." 
    AND model_year = "2019 Gasolina" AND query_table.reference_month = "outubro de 2022";

create view join_tables as select id_vehicle_table, brand, model, model_year from vehicle_table;
select * from join_tablessss;

create view join_tables7 
as select brand, model, model_year, reference_month, average_price 
from vehicle_table 
inner join query_table 
on vehicle_table.id_vehicle_table = query_table.id_vehicle_table;
select * from join_tables7;

-- create trigger ----------------------------------------------------------------------------------------------------------------------

DELIMITER //
CREATE TRIGGER nome_da_trigger AFTER/BEFORE INSERT/UPDATE/DELETE ON nome_da_tabela
FOR EACH ROW
BEGIN
-- escrever a query
END //
DELIMITER ;

-- create function ----------------------------------------------------------------------------------------------------------------------


-- TESTANDO A CRIAÇAO DE UM GATILHO QUE ACIONA UMA FUNÇAO (TERMINAR)
DELIMITER $$

CREATE TRIGGER put_id
	AFTER INSERT ON vehicle_table
	FOR EACH ROW
	BEGIN
    
		insert into query_table(fipe_code, reference_month, authentication, consultation_date ,average_price, id_query_table)
		values (OLD.fipe_code, OLD.reference_month, OLD.authentication, OLD.consultation_date, OLD.average_price, OLD.id_query_table);

	END$$
    
DELIMITER ;*/
