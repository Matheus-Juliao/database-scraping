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
	fk_vehicle_table VARCHAR(12) NOT NULL,
	PRIMARY KEY (id_query_table),
	FOREIGN KEY (fk_vehicle_table) REFERENCES vehicle_table (id_vehicle_table)
);

CREATE TABLE cod_vehicle_table(
	id_cod_vehicle_table INT NOT NULL AUTO_INCREMENT,
	cod_brand VARCHAR(12) NOT NULL,
	cod_model VARCHAR(12) NOT NULL ,
	cod_model_year VARCHAR(12) NOT NULL ,
	cod_reference_month VARCHAR(12) NOT NULL,
    fk_cod_vehicle_table VARCHAR(12) NOT NULL,
	PRIMARY KEY (id_cod_vehicle_table),
	FOREIGN KEY (fk_cod_vehicle_table) REFERENCES vehicle_table (id_vehicle_table)
);

/*DROP SCHEMA fipe_scraping;
DROP TABLE cod_vehicle_table;
DROP TABLE query_table;
DROP TABLE vehicle_table;*/

INSERT INTO vehicle_table(id_vehicle_table, brand, model, model_year) VALUES ("1", 'GM - Chevrolet','ONIX HATCH LT 1.4 8V FlexPower 5p Mec.', '2015 Gasolina');
INSERT INTO query_table (fipe_code, reference_month, authentication, consultation_date, average_price, fk_vehicle_table) VALUES ( "0940534" , 'outubro de 2022', 'wtktdjmyqmvt', 'sábado, 29 de outubro de 2022 12:38','R$ 46.247,00', "1");
INSERT INTO cod_vehicle_table (cod_brand, cod_model, cod_model_year, cod_reference_month, fk_cod_vehicle_table) VALUES ("23", "7691", "2019-1", "290", "1");

SELECT * FROM vehicle_table;
SELECT * FROM query_table;
SELECT * FROM cod_vehicle_table;
	
SELECT reference_month, 
	fipe_code, brand, model, 
    model_year, authentication, 
    consultation_date  FROM vehicle_table 
    INNER JOIN query_table ON query_table.fk_vehicle_table = "1";

/*
SELECT vehicle_table.brand, 
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