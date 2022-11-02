CREATE SCHEMA scraping;
USE scraping;

CREATE TABLE vehicle_table(
id_vehicle_table VARCHAR(12) NOT NULL,
brand VARCHAR(20),
model VARCHAR(50),
model_year VARCHAR(50),
PRIMARY KEY (id_vehicle_table)
);

create table query_table(
id_query_table INT NOT NULL AUTO_INCREMENT,
fipe_code VARCHAR(50),
reference_month VARCHAR(50),
authentication TEXT,
consultation_date VARCHAR(50),
average_price VARCHAR (20),
id_vehicle_table VARCHAR(12) NOT NULL,
PRIMARY KEY (id_query_table),
FOREIGN KEY (id_vehicle_table) REFERENCES vehicle_table (id_vehicle_table)
);

-- adriano 

/*DROP SCHEMA fipe_scraping;
DROP TABLE vehicle_table;
DROP TABLE query_table;*/

/*INSERT INTO vehicle_table(id_vehicle_table, brand, model, model_year) VALUES ("1", 'GM - Chevrolet','ONIX HATCH LT 1.4 8V FlexPower 5p Mec.', '2015 Gasolina');
INSERT INTO query_table (fipe_code, reference_month, authentication, consultation_date, average_price,id_vehicle_table) VALUES ( "0940534" , 'outubro de 2022', 'wtktdjmyqmvt', 'sábado, 29 de outubro de 2022 12:38','R$ 46.247,00', "1");

select * from vehicle_table;
select * from query_table;

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