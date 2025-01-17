create database hotel2;
use hotel2;

-- Vytvoření tabulky Zeme
CREATE TABLE Zeme (
    ID INT NOT NULL AUTO_INCREMENT,
    nazev VARCHAR(30) NOT NULL,
    ISO_kod VARCHAR(10) NOT NULL,
    mena VARCHAR(30) NOT NULL,
    uredni_jazyk VARCHAR(30) NOT NULL,
    region VARCHAR(30) NOT NULL,
    PRIMARY KEY (ID)
);

-- Vytvoření tabulky Adresa
CREATE TABLE Adresa (
    ID INT NOT NULL AUTO_INCREMENT,
    mesto VARCHAR(30) NOT NULL,
    cislo_popisne VARCHAR(30) NOT NULL,
    psc VARCHAR(10) NOT NULL,
    zeme_ID INT NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (zeme_ID) REFERENCES Zeme(ID) ON DELETE NO ACTION
);

-- Vytvoření tabulky Zakaznik
CREATE TABLE Zakaznik (
    ID INT NOT NULL AUTO_INCREMENT,
    jmeno VARCHAR(30) NOT NULL,
    prijmeni VARCHAR(30) NOT NULL,
    telefon VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(30) NOT NULL UNIQUE,
    zeme_ID INT NOT NULL,
    vek FLOAT NOT NULL, -- Přidáno reálné číslo
    PRIMARY KEY (ID),
    FOREIGN KEY (zeme_ID) REFERENCES Zeme(ID) ON DELETE NO ACTION,
    CHECK(email LIKE ('%@%'))
);

-- Vytvoření tabulky Typ_pokoje
CREATE TABLE Typ_pokoje (
    ID INT NOT NULL AUTO_INCREMENT,
    nazev VARCHAR(30) NOT NULL,
    popis VARCHAR(255),
    PRIMARY KEY (ID)
);

-- Vytvoření tabulky Pokoj
CREATE TABLE Pokoj (
    ID INT NOT NULL AUTO_INCREMENT,
    cislo VARCHAR(10) NOT NULL,
    pocet_posteli NUMERIC(3, 0) NOT NULL,
    typ_pokoje_ID INT NOT NULL,
    velikost_pokoje FLOAT NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (typ_pokoje_ID) REFERENCES Typ_pokoje(ID) ON DELETE NO ACTION,
    CHECK (pocet_posteli BETWEEN 1 AND 10)
);

-- Vytvoření tabulky Doprava
CREATE TABLE Doprava (
    ID INT NOT NULL AUTO_INCREMENT,
    nazev VARCHAR(30) NOT NULL,
    cena FLOAT NOT NULL, -- Změněno na FLOAT pro reálné číslo
    popis VARCHAR(200),
    PRIMARY KEY (ID)
);

-- Vytvoření tabulky Rezervace
CREATE TABLE Rezervace (
    cislo_rezervace VARCHAR(20) NOT NULL,
    datum_od DATE NOT NULL,
    datum_do DATE NOT NULL,
    check_in_do TIME NOT NULL,
    check_out_do TIME NOT NULL,
    celkova_cena FLOAT NOT NULL, -- Změněno na FLOAT pro reálné číslo
    snidane BOOLEAN NOT NULL DEFAULT FALSE, -- Změněno na BOOLEAN pro logickou hodnotu
    vratna_rezervace BOOLEAN NOT NULL DEFAULT FALSE, -- Změněno na BOOLEAN pro logickou hodnotu
    pocet_deti NUMERIC(3, 0) NOT NULL,
    pocet_dospelych NUMERIC(3, 0) NOT NULL,
    adresa_ID INT NOT NULL,
    zakaznik_ID INT NOT NULL,
    doprava_ID INT NOT NULL,
    stav ENUM('Probiha', 'Dokoncena') NOT NULL DEFAULT 'Probiha', -- Změněno na ENUM pro výčet
    PRIMARY KEY (cislo_rezervace),
    FOREIGN KEY (adresa_ID) REFERENCES Adresa(ID) ON DELETE NO ACTION,
    FOREIGN KEY (zakaznik_ID) REFERENCES Zakaznik(ID) ON DELETE NO ACTION,
    FOREIGN KEY (doprava_ID) REFERENCES Doprava(ID) ON DELETE NO ACTION,
    CHECK (pocet_deti >= 0 AND pocet_dospelych > 0),
    CHECK (datum_od < datum_do),
    CHECK (celkova_cena > 0)
);

-- Vytvoření tabulky Pokoj_v_rezervaci
CREATE TABLE Pokoj_v_rezervaci (
    ID INT NOT NULL AUTO_INCREMENT, -- Změněno na AUTO_INCREMENT
    pokoj_ID INT NOT NULL,
    cislo_rezervace VARCHAR(20) NOT NULL,
    pocet_lidi NUMERIC(3, 0) NOT NULL,
    datum_rezervace DATETIME NOT NULL, -- Přidáno DATETIME pro datum a čas
    PRIMARY KEY (ID),
    FOREIGN KEY (pokoj_ID) REFERENCES Pokoj(ID) ON DELETE NO ACTION,
    FOREIGN KEY (cislo_rezervace) REFERENCES Rezervace(cislo_rezervace) ON DELETE NO ACTION,
    CHECK(pocet_lidi > 0)
);

CREATE TABLE Audit_log (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    akce VARCHAR(50) NOT NULL,
    detail TEXT,
    datum_cas DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    uzivatel_id INT,
    FOREIGN KEY (uzivatel_id) REFERENCES Zakaznik(ID) ON DELETE SET NULL
);


-- Testovací data pro tabulku Zeme
INSERT INTO Zeme (nazev, ISO_kod, mena, uredni_jazyk, region) VALUES
('Česká republika', 'CZ', 'Kč', 'Čeština', 'Evropa'),
('Slovensko', 'SK', '€', 'Slovenčina', 'Evropa'),
('Spojené království', 'GB', '£', 'Angličtina', 'Evropa');

-- Testovací data pro tabulku Adresa
INSERT INTO Adresa (mesto, cislo_popisne, psc, zeme_ID) VALUES
('Praha', '1234', '12000', 1),
('Bratislava', '5678', '81101', 2),
('Londýn', '9012', 'WC2N', 3);

-- Testovací data pro tabulku Zakaznik
INSERT INTO Zakaznik (jmeno, prijmeni, telefon, email, zeme_ID, vek) VALUES
('Jan', 'Novák', '123456789', 'jan.novak@example.com', 1, 30.5),
('Mária', 'Kováčová', '987654321', 'maria.kovacova@example.com', 2, 25.0),
('John', 'Smith', '555123456', 'john.smith@example.com', 3, 45.75);

-- Testovací data pro tabulku Typ_pokoje
INSERT INTO Typ_pokoje (nazev, popis) VALUES
('Jednolůžkový', 'Pokoj pro jednu osobu'),
('Dvoulůžkový', 'Pokoj pro dvě osoby'),
('Apartmán', 'Luxusní apartmán s kuchyňkou');

-- Testovací data pro tabulku Pokoj
INSERT INTO Pokoj (cislo, pocet_posteli, typ_pokoje_ID, velikost_pokoje) VALUES
('101', 1, 1, 15.5),
('102', 2, 2, 20.0),
('201', 4, 3, 40.25);

-- Testovací data pro tabulku Doprava
INSERT INTO Doprava (nazev, cena, popis) VALUES
('Letadlo', 1500.00, 'Přeprava letadlem'),
('Vlak', 500.50, 'Pohodlná cesta vlakem'),
('Auto', 250.75, 'Půjčovna aut');

-- Testovací data pro tabulku Rezervace (pokračování)
INSERT INTO Rezervace (cislo_rezervace, datum_od, datum_do, check_in_do, check_out_do, celkova_cena, snidane, vratna_rezervace, pocet_deti, pocet_dospelych, adresa_ID, zakaznik_ID, doprava_ID, stav) VALUES
('R001', '2025-01-20', '2025-01-25', '14:00:00', '11:00:00', 5000.00, TRUE, FALSE, 0, 1, 1, 1, 1, 'Probiha'),
('R002', '2025-02-01', '2025-02-05', '15:00:00', '10:00:00', 3000.50, FALSE, TRUE, 2, 2, 2, 2, 2, 'Dokoncena'),
('R003', '2025-03-10', '2025-03-15', '13:00:00', '12:00:00', 7500.75, TRUE, TRUE, 1, 3, 3, 3, 3, 'Probiha');

-- Testovací data pro tabulku Pokoj_v_rezervaci
INSERT INTO Pokoj_v_rezervaci (pokoj_ID, cislo_rezervace, pocet_lidi, datum_rezervace) VALUES
(1, 'R001', 1, NOW()),
(2, 'R002', 4, NOW()),
(3, 'R003', 4, NOW());

-- Testovací data pro tabulku Audit_log
INSERT INTO Audit_log (akce, detail, uzivatel_id) VALUES
('Vytvoření rezervace', 'Vytvořena rezervace R001 pro Jana Nováka', 1),
('Aktualizace rezervace', 'Změna stavu rezervace R002 na Dokoncena', 2),
('Vytvoření pokoje', 'Vytvořen pokoj č. 201 typu Apartmán', NULL);

use hotel2;
DELIMITER //
-- Trigger pro kontrolu počtu lidí v pokoji při INSERT
CREATE TRIGGER check_pocet_lidi_v_pokoji_insert
BEFORE INSERT ON Pokoj_v_rezervaci
FOR EACH ROW
BEGIN
    DECLARE pocet_posteli INT;
    
    SELECT pocet_posteli INTO pocet_posteli
    FROM Pokoj
    WHERE ID = NEW.pokoj_ID;
    
    IF NEW.pocet_lidi > pocet_posteli THEN
        SET NEW.pocet_lidi = pocet_posteli;  -- Nastavíme na maximální možný počet lidí místo na 0
    END IF;
END//

-- Trigger pro kontrolu počtu lidí v pokoji při UPDATE
CREATE TRIGGER check_pocet_lidi_v_pokoji_update
BEFORE UPDATE ON Pokoj_v_rezervaci
FOR EACH ROW
BEGIN
    DECLARE pocet_posteli INT;
    
    SELECT pocet_posteli INTO pocet_posteli
    FROM Pokoj
    WHERE ID = NEW.pokoj_ID;
    
    IF NEW.pocet_lidi > pocet_posteli THEN
        SET NEW.pocet_lidi = pocet_posteli;  -- Nastavíme na maximální možný počet lidí místo na 0
    END IF;
END//


-- Procedura pro kontrolu celkového počtu lidí v rezervaci
CREATE PROCEDURE check_celkovy_pocet_lidi(IN rezervace_cislo VARCHAR(20))
BEGIN
    DECLARE total_pocet_lidi INT;
    DECLARE pocet_deti_dospelych INT;
    
    -- Spočítáme celkový počet lidí v pokojích pro tuto rezervaci
    SELECT SUM(pocet_lidi) INTO total_pocet_lidi
    FROM Pokoj_v_rezervaci
    WHERE cislo_rezervace = rezervace_cislo;
    
    SELECT (pocet_deti + pocet_dospelych) INTO pocet_deti_dospelych
    FROM Rezervace
    WHERE cislo_rezervace = rezervace_cislo;
    
    IF total_pocet_lidi != pocet_deti_dospelych THEN
		UPDATE Rezervace SET stav = 'Probiha' WHERE cislo_rezervace = rezervace_cislo;
    ELSE
		UPDATE Rezervace SET stav = 'Dokoncena' WHERE cislo_rezervace = rezervace_cislo;
    END IF;
END//

-- Trigger pro kontrolu celkového počtu lidí v rezervaci při INSERT
CREATE TRIGGER check_celkovy_pocet_lidi_v_rezervaci_insert
AFTER INSERT ON Pokoj_v_rezervaci
FOR EACH ROW
BEGIN
    DECLARE v_stav VARCHAR(20);
    
    SELECT stav INTO v_stav FROM Rezervace WHERE cislo_rezervace = NEW.cislo_rezervace;
    IF v_stav = 'Dokoncena' THEN
        CALL check_celkovy_pocet_lidi(NEW.cislo_rezervace);
    END IF;
END//

-- Trigger pro kontrolu celkového počtu lidí v rezervaci při UPDATE
CREATE TRIGGER check_celkovy_pocet_lidi_v_rezervaci_update
AFTER UPDATE ON Pokoj_v_rezervaci
FOR EACH ROW
BEGIN
    DECLARE v_stav VARCHAR(20);
    
    SELECT stav INTO v_stav FROM Rezervace WHERE cislo_rezervace = NEW.cislo_rezervace;

    IF v_stav = 'Dokoncena' THEN
        CALL check_celkovy_pocet_lidi(NEW.cislo_rezervace);
    END IF;
END//

-- Trigger pro kontrolu celkového počtu lidí v rezervaci při DELETE
CREATE TRIGGER check_celkovy_pocet_lidi_v_rezervaci_delete
AFTER DELETE ON Pokoj_v_rezervaci
FOR EACH ROW
BEGIN
    DECLARE v_stav VARCHAR(20);

    SELECT stav INTO v_stav FROM Rezervace WHERE cislo_rezervace = OLD.cislo_rezervace;

    IF v_stav = 'Dokoncena' THEN
        CALL check_celkovy_pocet_lidi(OLD.cislo_rezervace);
    END IF;
END//

-- Procedura pro zrušení rezervace
CREATE PROCEDURE zrus_rezervaci(
    IN rezervace_cislo VARCHAR(20)
)
BEGIN
    START TRANSACTION;
    DELETE FROM Pokoj_v_rezervaci WHERE cislo_rezervace = rezervace_cislo;
    DELETE FROM Rezervace WHERE cislo_rezervace = rezervace_cislo;
    
    INSERT INTO Audit_log (akce, detail, datum_cas) 
    VALUES ('Zrušení rezervace', CONCAT('Zrušena rezervace č. ', rezervace_cislo), NOW());
    COMMIT;
END//

-- Procedura pro získání volných pokojů v daném období
CREATE PROCEDURE ziskej_volne_pokoje(
    IN datum_od DATE,
    IN datum_do DATE
)
BEGIN
    SELECT p.ID AS pokoj_ID, p.cislo, p.pocet_posteli, tp.nazev AS typ_pokoje
    FROM Pokoj p
    JOIN Typ_pokoje tp ON p.typ_pokoje_ID = tp.ID
    WHERE NOT EXISTS (
    SELECT *
    FROM Rezervace r
    JOIN Pokoj_v_rezervaci pvr ON r.cislo_rezervace = pvr.cislo_rezervace
    WHERE pvr.pokoj_ID = p.ID
    AND (datum_od BETWEEN r.datum_od AND r.datum_do 
      OR datum_do BETWEEN r.datum_od AND r.datum_do 
      OR r.datum_od BETWEEN datum_od AND datum_do 
      OR r.datum_do BETWEEN datum_od AND datum_do)
);
END//
-- Procedura pro aktualizaci rezervace
CREATE PROCEDURE aktualizuj_rezervaci(
    IN rezervace_cislo VARCHAR(20),
    IN novy_datum_od DATE,
    IN novy_datum_do DATE,
    IN novy_pocet_deti INT,
    IN novy_pocet_dospelych INT,
    IN nova_doprava_id INT,
    IN nova_adresa_id INT
)
BEGIN
    START TRANSACTION;
    
    
    UPDATE Rezervace 
    SET 
        datum_od = novy_datum_od,
        datum_do = novy_datum_do,
        pocet_deti = novy_pocet_deti,
        pocet_dospelych = novy_pocet_dospelych,
        doprava_ID = nova_doprava_id,
        adresa_ID = nova_adresa_id,
        stav = 'Probiha'
    WHERE 
        cislo_rezervace = rezervace_cislo;
    
    
    UPDATE Pokoj_v_rezervaci 
    SET 
        pocet_lidi = novy_pocet_deti + novy_pocet_dospelych
    WHERE 
        cislo_rezervace = rezervace_cislo;
    
   
    CALL check_celkovy_pocet_lidi(rezervace_cislo);
    
   
    INSERT INTO Audit_log (akce, detail, datum_cas) 
    VALUES ('Aktualizace rezervace', CONCAT('Aktualizována rezervace č. ', rezervace_cislo), NOW());
    
    COMMIT;
END//
-- Procedura pro zmenu pokoje
CREATE PROCEDURE zmen_pokoj_v_rezervaci(
    IN rezervace_cislo VARCHAR(20),
    IN novy_pokoj_id INT
)
BEGIN
    DECLARE stary_pokoj_id INT;
    START TRANSACTION;
    SELECT pokoj_ID INTO stary_pokoj_id
    FROM Pokoj_v_rezervaci WHERE cislo_rezervace = rezervace_cislo;
    
    UPDATE Pokoj_v_rezervaci 
    SET 
        pokoj_ID = novy_pokoj_id
    WHERE 
        cislo_rezervace = rezervace_cislo;
    
    UPDATE Rezervace 
    SET 
        stav = 'Probiha'
    WHERE 
        cislo_rezervace = rezervace_cislo;
    
    INSERT INTO Audit_log (akce, detail, datum_cas) 
    VALUES ('Změna pokoje v rezervaci', CONCAT('Rezervace č. ', rezervace_cislo, ' změněna z pokoje ', stary_pokoj_id, ' na pokoj ', novy_pokoj_id), NOW());
    
    COMMIT;
END//


DELIMITER ;
-- View pro financni prehled
CREATE VIEW view_FinancniPrehledRezervaci AS
SELECT 
    r.cislo_rezervace,
    z.jmeno,
    z.prijmeni,
    r.datum_od,
    r.datum_do,
    r.celkova_cena,
    DATEDIFF(r.datum_do, r.datum_od) AS pocet_dni,
    ROUND(r.celkova_cena / DATEDIFF(r.datum_do, r.datum_od), 2) AS prumerna_denni_cena,
    CASE 
        WHEN r.snidane = 'Y' THEN 'Ano'
        ELSE 'Ne'
    END AS snizena_cena,
    d.nazev AS doprava
FROM 
    Rezervace r
JOIN 
    Zakaznik z ON r.zakaznik_ID = z.ID
LEFT JOIN 
    Doprava d ON r.doprava_ID = d.ID
WHERE 
    r.datum_od >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
    
-- View pro statistiku hostu podel země
CREATE VIEW view_StatistikyHostuPodleZemi AS
SELECT 
    ze.Nazev AS zeme,
    COUNT(DISTINCT r.cislo_rezervace) AS pocet_rezervaci,
    ROUND(AVG(r.pocet_deti + r.pocet_dospelych), 2) AS prumerny_pocet_hostu_na_rezervaci,
    SUM(r.pocet_deti + r.pocet_dospelych) AS celkovy_pocet_hostu
FROM 
    Rezervace r
JOIN 
    Zakaznik z ON r.zakaznik_ID = z.ID
JOIN 
    Zeme ze ON z.zeme_ID = ze.ID
GROUP BY 
    ze.ID, ze.Nazev
HAVING 
    pocet_rezervaci > 0
ORDER BY 
    celkovy_pocet_hostu DESC;

-- View pro prehled o obsazenosti pokoju
CREATE VIEW view_ObsazenostPokojuvRealnemCase AS
SELECT 
    p.ID AS pokoj_id,
    p.cislo AS pokoj_cislo,
    p.pocet_posteli,
    CASE 
        WHEN r.cislo_rezervace IS NOT NULL THEN 'Obsazeno'
        ELSE 'Volno'
    END AS stav,
    r.cislo_rezervace,
    r.datum_od,
    r.datum_do
FROM 
    Pokoj p
LEFT JOIN 
    Pokoj_v_rezervaci pvr ON p.ID = pvr.Pokoj_ID
LEFT JOIN 
    Rezervace r ON pvr.cislo_rezervace = r.cislo_rezervace
WHERE 
    (r.datum_od <= CURDATE() AND r.datum_do >= CURDATE()) OR r.cislo_rezervace IS NULL;

-- View pro přehled průměrné delky pobytu hostů
CREATE VIEW view_PrumernaDelkaPobytuHostu AS
SELECT 
    z.jmeno, 
    z.prijmeni, 
    ROUND(AVG(DATEDIFF(r.datum_do, r.datum_od)), 2) AS prumerna_delka_pobytu
FROM 
    Zakaznik z
JOIN 
    Rezervace r ON z.ID = r.zakaznik_ID
GROUP BY 
    z.ID, z.jmeno, z.prijmeni
HAVING 
    prumerna_delka_pobytu > 0;
    
DELIMITER //


DELIMITER //

-- Procedura pro vytvoření nové rezervace a přiřazení pokoje v rámci transakce
CREATE PROCEDURE vytvor_rezervaci_transakce(
    IN zakaznik_id INT,
    IN datum_od DATE,
    IN datum_do DATE,
    IN pocet_deti INT,
    IN pocet_dospelych INT,
    IN doprava_id INT,
    IN adresa_id INT,
    IN pokoj_id INT,
    IN rezervace_cislo VARCHAR(20)
)
BEGIN
    START TRANSACTION;

    INSERT INTO Rezervace (cislo_rezervace, datum_od, datum_do, pocet_deti, pocet_dospelych, doprava_ID, adresa_ID, zakaznik_ID, stav)
    VALUES (rezervace_cislo, datum_od, datum_do, pocet_deti, pocet_dospelych, doprava_id, adresa_id, zakaznik_id, 'Probiha');

    INSERT INTO Pokoj_v_rezervaci (pokoj_ID, cislo_rezervace, pocet_lidi)
    VALUES (pokoj_id, rezervace_cislo, pocet_deti + pocet_dospelych);

    COMMIT;
END//

DELIMITER ;

-- Index na sloupec 'cislo_rezervace' v tabulce Rezervace, protože je často používán k vyhledávání
CREATE INDEX idx_rezervace_cislo ON Rezervace(cislo_rezervace);
-- Index na sloupece 'jmeno' a 'prijmeni' v tabulce Zakaznik, protože je často používán k vyhledávání
CREATE INDEX idx_zakaznik_jmeno_prijmeni ON Zakaznik(jmeno, prijmeni);
-- Index na sloupece 'datum_od' a 'datom_do' v tabulce Rezervace, protože je často používán k vyhledávání
CREATE INDEX idx_rezervace_datum ON Rezervace(datum_od, datum_do);

-- Vytvoření uživatelských účtů a jejich práv
CREATE USER 'admin'@'%' IDENTIFIED BY 'AdminHeslo1';
CREATE USER 'recepce'@'%' IDENTIFIED BY 'RecepceHeslo1';
CREATE USER 'udrzba'@'%' IDENTIFIED BY 'UdrzbaHeslo1';

GRANT ALL PRIVILEGES ON hotel.* TO 'admin';
GRANT SELECT, INSERT, UPDATE, DELETE ON hotel.* TO 'recepce';
GRANT SELECT ON hotel.* TO 'udrzba';



