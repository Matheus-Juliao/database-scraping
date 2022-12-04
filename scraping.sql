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
	average_price DECIMAL(15, 2),
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

CREATE TABLE period_aux(
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

-- Cadastrar anos relacionados a um modelo
CREATE TABLE modelYear(
	id_Value INT AUTO_INCREMENT NOT NULL,
	Value VARCHAR(12) NOT NULL,
    Label VARCHAR(50) NOT NULL,
	PRIMARY KEY (id_Value),
	fk_id_Value INT NOT NULL,
	FOREIGN KEY (fk_id_Value) REFERENCES models (id_Value)
);

-- Cadastrar modelos relacionados a um ano
CREATE TABLE yearModel(
	id_Value INT AUTO_INCREMENT NOT NULL,
	Value VARCHAR(12) NOT NULL,
    Label VARCHAR(50) NOT NULL,
	PRIMARY KEY (id_Value),
	fk_id_Value INT NOT NULL,
	FOREIGN KEY (fk_id_Value) REFERENCES years (id_Value)
);

CREATE TABLE insertPeriod(
	id_insertPeriod INT AUTO_INCREMENT NOT NULL,
    PRIMARY KEY (id_insertPeriod),
    note VARCHAR(255),
    date_creation DATETIME NOT NULL
);

CREATE TABLE insertBrand(
	id_insertPeriod INT AUTO_INCREMENT NOT NULL,
    PRIMARY KEY (id_insertPeriod),
    note VARCHAR(255),
    date_creation DATETIME NOT NULL
);

CREATE TABLE insertQuery(
	id_insertPeriod INT AUTO_INCREMENT NOT NULL,
    PRIMARY KEY (id_insertPeriod),
    note VARCHAR(255),
    date_creation DATETIME NOT NULL
);

DELIMITER $$
	CREATE PROCEDURE brand(
		IN Value VARCHAR(50),
        IN period VARCHAR(50)
	)
    BEGIN
		SELECT brands.id_Value FROM brands WHERE brands.Value = Value AND fk_id_Value = period;
    END $$
DELIMITER ;

DELIMITER $$
	CREATE PROCEDURE model(
		IN Value VARCHAR(50),
        IN period VARCHAR(50)
	)
    BEGIN
		SELECT models.id_Value FROM models WHERE models.Value = Value AND models.fk_id_Value = period;
    END $$
DELIMITER ;

DELIMITER $$
	CREATE PROCEDURE year(
		IN Value VARCHAR(50),
        IN period VARCHAR(50)
	)
    BEGIN
		SELECT years.id_Value FROM years WHERE years.Value = Value AND years.fk_id_Value = period;
    END $$
DELIMITER ;

DELIMITER $$
	CREATE FUNCTION selectPeriodLimit()
	RETURNS INT
    DETERMINISTIC
    BEGIN
		DECLARE 
        lim INT;
		SELECT Codigo INTO lim FROM period LIMIT 1;
		RETURN lim;
    END $$
DELIMITER ;

DELIMITER $$
	CREATE FUNCTION verification()
	RETURNS INT
    DETERMINISTIC
    BEGIN
		DECLARE contP INT;
        DECLARE contL INT;
        DECLARE cont INT;
        DECLARE newMes VARCHAR(50);
        DECLARE newCodigo VARCHAR(12);
        SELECT COUNT(*) INTO contP FROM period;
        SELECT COUNT(*) INTO contL FROM period_aux;

        IF(contL > contP) THEN 
			SELECT Mes INTO newMes FROM period_aux WHERE seq = ContL;
            SELECT Codigo INTO newCodigo FROM period_aux WHERE seq = ContL;
            INSERT INTO period (Codigo, Mes, seq) VALUES (newCodigo, newMes, contP+1);
			RETURN 1;
        ELSE 
			RETURN 0;
        END IF;
    END $$
DELIMITER ;

DELIMITER $$
	CREATE FUNCTION insertPeriodWithEvent()
	RETURNS INT
    DETERMINISTIC
    BEGIN
		INSERT INTO insertPeriod (note, date_creation) VALUES ("Add period", NOW());
        RETURN 0;
    END $$
DELIMITER ;
    
DELIMITER $$
	CREATE TRIGGER afterInsertPeriod
    AFTER INSERT ON period
    FOR EACH ROW
	BEGIN
		DECLARE ret INT;
		SET ret = (SELECT insertPeriodWithEvent());
    END $$
DELIMITER ;

DELIMITER $$
	CREATE TRIGGER afterInsertBrand
    AFTER INSERT ON brands
    FOR EACH ROW
	BEGIN
		INSERT INTO insertBrand (note, date_creation) VALUES ("Add new brand", NOW());
    END $$
DELIMITER ;

DELIMITER $$
	CREATE TRIGGER afterInsertQuery
    AFTER INSERT ON vehicle_table
    FOR EACH ROW
	BEGIN
		INSERT INTO insertQuery (note, date_creation) VALUES ("Add new query", NOW());
    END $$
DELIMITER ;

CREATE EVENT verificationPeriod
	ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 12 HOUR -- 1 MINUTE 
	ON COMPLETION PRESERVE
	DO SELECT verification();

-- Mais caro no nosso banco
CREATE VIEW mostExpensiveCarInDatabase AS
	SELECT reference_month, fipe_code, brand, model, model_year, authentication, MAX(average_price) AS average_price
	FROM vehicle_table 
    INNER JOIN cod_vehicle_table ON cod_vehicle_table.fk_id_vehicle_table = vehicle_table.id_vehicle_table 
    INNER JOIN query_table ON query_table.fk_id_vehicle_table = vehicle_table.id_vehicle_table 
    GROUP BY reference_month, fipe_code, brand, model, model_year, authentication
    ORDER BY 7 DESC LIMIT 1;

-- Mais barato no nosso banco    
CREATE VIEW cheapestCarInDatabase AS
	SELECT reference_month, fipe_code, brand, model, model_year, authentication, MIN(average_price) AS average_price
	FROM vehicle_table 
    INNER JOIN cod_vehicle_table ON cod_vehicle_table.fk_id_vehicle_table = vehicle_table.id_vehicle_table 
    INNER JOIN query_table ON query_table.fk_id_vehicle_table = vehicle_table.id_vehicle_table 
    GROUP BY reference_month, fipe_code, brand, model, model_year, authentication
    ORDER BY 7 ASC LIMIT 1;

-- Menos potente   
CREATE VIEW lessPowerfulCar AS
	SELECT reference_month, fipe_code, brand, model, model_year, authentication, average_price 
	FROM vehicle_table 
    INNER JOIN cod_vehicle_table ON cod_vehicle_table.fk_id_vehicle_table = vehicle_table.id_vehicle_table 
    INNER JOIN query_table ON query_table.fk_id_vehicle_table = vehicle_table.id_vehicle_table 
    WHERE cod_vehicle_table.cod_brand = "24" 
    AND cod_vehicle_table.cod_model = "1238" 
    AND cod_vehicle_table.cod_model_year = "1989-1" 
    AND cod_vehicle_table.cod_reference_month = "291";

-- Mais econômico
CREATE VIEW moreEconomical AS
	SELECT reference_month, fipe_code, brand, model, model_year, authentication, average_price 
	FROM vehicle_table 
    INNER JOIN cod_vehicle_table ON cod_vehicle_table.fk_id_vehicle_table = vehicle_table.id_vehicle_table 
    INNER JOIN query_table ON query_table.fk_id_vehicle_table = vehicle_table.id_vehicle_table 
    WHERE cod_vehicle_table.cod_brand = "7" 
    AND cod_vehicle_table.cod_model = "7024" 
    AND cod_vehicle_table.cod_model_year = "2021-1" 
    AND cod_vehicle_table.cod_reference_month = "291";
    
-- Menos econômico
CREATE VIEW lessEconomical AS
	SELECT reference_month, fipe_code, brand, model, model_year, authentication, average_price 
	FROM vehicle_table 
    INNER JOIN cod_vehicle_table ON cod_vehicle_table.fk_id_vehicle_table = vehicle_table.id_vehicle_table 
    INNER JOIN query_table ON query_table.fk_id_vehicle_table = vehicle_table.id_vehicle_table 
    WHERE cod_vehicle_table.cod_brand = "39" 
    AND cod_vehicle_table.cod_model = "7770" 
    AND cod_vehicle_table.cod_model_year = "2016-1" 
    AND cod_vehicle_table.cod_reference_month = "291";
    
-- Insert less powerful car - Menos potente - https://www.carrosnaweb.com.br/fichadetalhe.asp?codigo=14639
INSERT INTO vehicle_table (id_vehicle_table, brand, model, model_year) 
	VALUES ("jsykouidr7", "Gurgel", "BR-800 (todos)/Supermini", "1989 Gasolina");
    
INSERT INTO query_table (fipe_code, reference_month, authentication, average_price, fk_id_vehicle_table) 
	VALUES ("045003-0", "novembro de 2022", "19dwzmcmcxp", 6073.00, "jsykouidr7");     
    
INSERT INTO cod_vehicle_table (cod_brand, cod_model, cod_model_year, cod_reference_month, fk_id_vehicle_table)
	VALUES ("24", "1238", "1989-1", "291", "jsykouidr7");
    
-- Insert more economical car - Mais econômico - https://www.carrosnaweb.com.br/fichadetalhe.asp?codigo=16395
INSERT INTO vehicle_table (id_vehicle_table, brand, model, model_year) 
	VALUES ("7ptvkglc75", "BMW", "i3 Rex E Drive Full 170cv Aut.(Elétrico)", "2021 Gasolina");
    
INSERT INTO query_table (fipe_code, reference_month, authentication, average_price, fk_id_vehicle_table) 
	VALUES ("009195-2", "novembro de 2022", "njp7ljs1kldjf", 269841.00, "7ptvkglc75");     
    
INSERT INTO cod_vehicle_table (cod_brand, cod_model, cod_model_year, cod_reference_month, fk_id_vehicle_table)
	VALUES ("7", "7024", "2021-1", "291", "7ptvkglc75");
    
-- Insert less economical car - Menos econômico - https://www.carrosnaweb.com.br/fichadetalhe.asp?codigo=6829
INSERT INTO vehicle_table (id_vehicle_table, brand, model, model_year) 
	VALUES ("2ptvkglc75", "Mercedes-Benz", "S-65 L AMG 6.0 V12 630cv Aut.", "2016 Gasolina");
    
INSERT INTO query_table (fipe_code, reference_month, authentication, average_price, fk_id_vehicle_table) 
	VALUES ("021359-4", "novembro de 2022", "7dm5r92pmmcz9", 742286.00, "2ptvkglc75");     
    
INSERT INTO cod_vehicle_table (cod_brand, cod_model, cod_model_year, cod_reference_month, fk_id_vehicle_table)
	VALUES ("39", "7770", "2016-1", "291", "2ptvkglc75");

-- REVISADO
/*
DROP SCHEMA scraping;
DROP PROCEDURE brand;
DROP PROCEDURE model;
DROP PROCEDURE year;
DROP FUNCTION selectPeriodLimit;
DROP TABLE cod_vehicle_table;
DROP TABLE query_table;
DROP TABLE vehicle_table;
DROP TABLE yearModel;
DROP TABLE modelYear;
DROP TABLE years;
DROP TABLE models;
DROP TABLE brands;
DROP TABLE period;
DROP TABLE period_aux;
DROP TABLE insertPeriod;
DROP TABLE insertBrand;
DROP TABLE insertQuery;
DROP EVENT verificationPeriod;

DELETE FROM period_aux;

-- Insert para testes
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
SELECT * FROM years;
SELECT * FROM modelYear;
SELECT * FROM yearModel;
SELECT * FROM insertPeriod;
SELECT * FROM insertBrand;
SELECT * FROM insertQuery;
SELECT Codigo FROM period LIMIT 1;
SELECT id_vehicle_table, reference_month, fipe_code, brand, model, model_year, authentication, average_price FROM vehicle_table 
    INNER JOIN query_table ON fk_id_vehicle_table = id_vehicle_table
    WHERE id_vehicle_table = fk_id_vehicle_table;
    
-- Comando para liberar o event_scheduler
SET GLOBAL event_scheduler = ON;

--Comando para ver eventos no database
SHOW EVENTS FROM scraping;
SHOW TRIGGERS;
*/