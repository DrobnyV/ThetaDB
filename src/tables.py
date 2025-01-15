import mysql.connector

class BaseTable:
    def __init__(self, db_connection):
        self.db = db_connection
        self.id = None

    def execute(self, sql, params=None):
        cursor = self.db.cursor()
        try:
            if params:
                cursor.execute(sql, params)
            else:
                cursor.execute(sql)
            self.db.commit()
            return cursor
        except mysql.connector.Error as err:
            print(f"Chyba při provádění SQL: {err}")
            self.db.rollback()
            return None
        finally:
            cursor.close()

    def save(self):
        if self.id is None:
            self.create()
        else:
            self.update()

    def select_all(self):
        sql = f"SELECT * FROM {self.__class__.__name__}"
        cursor = self.db.cursor()
        try:
            cursor.execute(sql)
            results = cursor.fetchall()
            return results
        finally:
            cursor.close()

    def create(self):
        pass

    def update(self):
        pass

    def delete(self):
        pass

    def load(self, id):
        pass

class Zeme(BaseTable):
    def __init__(self, db_connection, nazev=None, iso_kod=None, mena=None, uredni_jazyk=None, region=None):
        super().__init__(db_connection)
        self.nazev = nazev
        self.iso_kod = iso_kod
        self.mena = mena
        self.uredni_jazyk = uredni_jazyk
        self.region = region

    def create(self):
        sql = "INSERT INTO Zeme (nazev, ISO_kod, mena, uredni_jazyk, region) VALUES (%s, %s, %s, %s, %s)"
        cursor = self.execute(sql, (self.nazev, self.iso_kod, self.mena, self.uredni_jazyk, self.region))
        if cursor:
            self.id = cursor.lastrowid

    def update(self):
        sql = "UPDATE Zeme SET nazev=%s, ISO_kod=%s, mena=%s, uredni_jazyk=%s, region=%s WHERE ID=%s"
        self.execute(sql, (self.nazev, self.iso_kod, self.mena, self.uredni_jazyk, self.region, self.id))

    def delete(self):
        sql = "DELETE FROM Zeme WHERE ID=%s"
        self.execute(sql, (self.id,))
        self.id = None  # Reset id po smazání

    def load(self, id):
        sql = "SELECT * FROM Zeme WHERE ID=%s"
        cursor = self.execute(sql, (id,))
        if cursor:
            row = cursor.fetchone()
            if row:
                self.id, self.nazev, self.iso_kod, self.mena, self.uredni_jazyk, self.region = row

class Adresa(BaseTable):
    def __init__(self, db_connection, mesto=None, cislo_popisne=None, psc=None, zeme_id=None):
        super().__init__(db_connection)
        self.mesto = mesto
        self.cislo_popisne = cislo_popisne
        self.psc = psc
        self.zeme_id = zeme_id

    def create(self):
        sql = "INSERT INTO Adresa (mesto, cislo_popisne, psc, zeme_ID) VALUES (%s, %s, %s, %s)"
        cursor = self.execute(sql, (self.mesto, self.cislo_popisne, self.psc, self.zeme_id))
        if cursor:
            self.id = cursor.lastrowid

    def update(self):
        sql = "UPDATE Adresa SET mesto=%s, cislo_popisne=%s, psc=%s, zeme_ID=%s WHERE ID=%s"
        self.execute(sql, (self.mesto, self.cislo_popisne, self.psc, self.zeme_id, self.id))

    def delete(self):
        sql = "DELETE FROM Adresa WHERE ID=%s"
        self.execute(sql, (self.id,))
        self.id = None

    def load(self, id):
        sql = "SELECT * FROM Adresa WHERE ID=%s"
        cursor = self.execute(sql, (id,))
        if cursor:
            row = cursor.fetchone()
            if row:
                self.id, self.mesto, self.cislo_popisne, self.psc, self.zeme_id = row

class Zakaznik(BaseTable):
    def __init__(self, db_connection, jmeno=None, prijmeni=None, telefon=None, email=None, zeme_id=None, vek=None):
        super().__init__(db_connection)
        self.jmeno = jmeno
        self.prijmeni = prijmeni
        self.telefon = telefon
        self.email = email
        self.zeme_id = zeme_id
        self.vek = vek

    def create(self):
        sql = "INSERT INTO Zakaznik (jmeno, prijmeni, telefon, email, zeme_ID, vek) VALUES (%s, %s, %s, %s, %s, %s)"
        cursor = self.execute(sql, (self.jmeno, self.prijmeni, self.telefon, self.email, self.zeme_id, self.vek))
        if cursor:
            self.id = cursor.lastrowid

    def update(self):
        sql = "UPDATE Zakaznik SET jmeno=%s, prijmeni=%s, telefon=%s, email=%s, zeme_ID=%s, vek=%s WHERE ID=%s"
        self.execute(sql, (self.jmeno, self.prijmeni, self.telefon, self.email, self.zeme_id, self.vek, self.id))

    def delete(self):
        sql = "DELETE FROM Zakaznik WHERE ID=%s"
        self.execute(sql, (self.id,))
        self.id = None

    def load(self, id):
        sql = "SELECT * FROM Zakaznik WHERE ID=%s"
        cursor = self.execute(sql, (id,))
        if cursor:
            row = cursor.fetchone()
            if row:
                self.id, self.jmeno, self.prijmeni, self.telefon, self.email, self.zeme_id, self.vek = row

class Typ_pokoje(BaseTable):
    def __init__(self, db_connection, nazev=None, popis=None):
        super().__init__(db_connection)
        self.nazev = nazev
        self.popis = popis

    def create(self):
        sql = "INSERT INTO Typ_pokoje (nazev, popis) VALUES (%s, %s)"
        cursor = self.execute(sql, (self.nazev, self.popis))
        if cursor:
            self.id = cursor.lastrowid

    def update(self):
        sql = "UPDATE Typ_pokoje SET nazev=%s, popis=%s WHERE ID=%s"
        self.execute(sql, (self.nazev, self.popis, self.id))

    def delete(self):
        sql = "DELETE FROM Typ_pokoje WHERE ID=%s"
        self.execute(sql, (self.id,))
        self.id = None

    def load(self, id):
        sql = "SELECT * FROM Typ_pokoje WHERE ID=%s"
        cursor = self.execute(sql, (id,))
        if cursor:
            row = cursor.fetchone()
            if row:
                self.id, self.nazev, self.popis = row

class Pokoj(BaseTable):
    def __init__(self, db_connection, cislo=None, pocet_posteli=None, typ_pokoje_id=None, velikost_pokoje=None):
        super().__init__(db_connection)
        self.cislo = cislo
        self.pocet_posteli = pocet_posteli
        self.typ_pokoje_id = typ_pokoje_id
        self.velikost_pokoje = velikost_pokoje

    def create(self):
        sql = "INSERT INTO Pokoj (cislo, pocet_posteli, typ_pokoje_ID, velikost_pokoje) VALUES (%s, %s, %s, %s)"
        cursor = self.execute(sql, (self.cislo, self.pocet_posteli, self.typ_pokoje_id, self.velikost_pokoje))
        if cursor:
            self.id = cursor.lastrowid

    def update(self):
        sql = "UPDATE Pokoj SET cislo=%s, pocet_posteli=%s, typ_pokoje_ID=%s, velikost_pokoje=%s WHERE ID=%s"
        self.execute(sql, (self.cislo, self.pocet_posteli, self.typ_pokoje_id, self.velikost_pokoje, self.id))

    def delete(self):
        sql = "DELETE FROM Pokoj WHERE ID=%s"
        self.execute(sql, (self.id,))
        self.id = None

    def load(self, id):
        sql = "SELECT * FROM Pokoj WHERE ID=%s"
        cursor = self.execute(sql, (id,))
        if cursor:
            row = cursor.fetchone()
            if row:
                self.id, self.cislo, self.pocet_posteli, self.typ_pokoje_id, self.velikost_pokoje = row

class Doprava(BaseTable):
    def __init__(self, db_connection, nazev=None, cena=None, popis=None):
        super().__init__(db_connection)
        self.nazev = nazev
        self.cena = cena
        self.popis = popis

    def create(self):
        sql = "INSERT INTO Doprava (nazev, cena, popis) VALUES (%s, %s, %s)"
        cursor = self.execute(sql, (self.nazev, self.cena, self.popis))
        if cursor:
            self.id = cursor.lastrowid

    def update(self):
        sql = "UPDATE Doprava SET nazev=%s, cena=%s, popis=%s WHERE ID=%s"
        self.execute(sql, (self.nazev, self.cena, self.popis, self.id))

    def delete(self):
        sql = "DELETE FROM Doprava WHERE ID=%s"
        self.execute(sql, (self.id,))
        self.id = None

    def load(self, id):
        sql = "SELECT * FROM Doprava WHERE ID=%s"
        cursor = self.execute(sql, (id,))
        if cursor:
            row = cursor.fetchone()
            if row:
                self.id, self.nazev, self.cena, self.popis = row

class Rezervace(BaseTable):
    def __init__(self, db_connection, cislo_rezervace=None, datum_od=None, datum_do=None, check_in_do=None, check_out_do=None, celkova_cena=None, snidane=None, vratna_rezervace=None, pocet_deti=None, pocet_dospelych=None, adresa_id=None, zakaznik_id=None, doprava_id=None, stav='Probiha'):
        super().__init__(db_connection)
        self.cislo_rezervace = cislo_rezervace
        self.datum_od = datum_od
        self.datum_do = datum_do
        self.check_in_do = check_in_do
        self.check_out_do = check_out_do
        self.celkova_cena = celkova_cena
        self.snidane = snidane
        self.vratna_rezervace = vratna_rezervace
        self.pocet_deti = pocet_deti
        self.pocet_dospelych = pocet_dospelych
        self.adresa_id = adresa_id
        self.zakaznik_id = zakaznik_id
        self.doprava_id = doprava_id
        self.stav = stav

    def create(self):
        sql = "INSERT INTO Rezervace (cislo_rezervace, datum_od, datum_do, check_in_do, check_out_do, celkova_cena, snidane, vratna_rezervace, pocet_deti, pocet_dospelych, adresa_ID, zakaznik_ID, doprava_ID, stav) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        cursor = self.execute(sql, (self.cislo_rezervace, self.datum_od, self.datum_do, self.check_in_do, self.check_out_do, self.celkova_cena, self.snidane, self.vratna_rezervace, self.pocet_deti, self.pocet_dospelych, self.adresa_id, self.zakaznik_id, self.doprava_id, self.stav))
        if cursor:
            self.id = cursor.lastrowid  # V Rezervace je primární klíč cislo_rezervace, takže toto nemusí být nutné

    def update(self):
        sql = "UPDATE Rezervace SET datum_od=%s, datum_do=%s, check_in_do=%s, check_out_do=%s, celkova_cena=%s, snidane=%s, vratna_rezervace=%s, pocet_deti=%s, pocet_dospelych=%s, adresa_ID=%s, zakaznik_ID=%s, doprava_ID=%s, stav=%s WHERE cislo_rezervace=%s"
        self.execute(sql, (self.datum_od, self.datum_do, self.check_in_do, self.check_out_do, self.celkova_cena, self.snidane, self.vratna_rezervace, self.pocet_deti, self.pocet_dospelych, self.adresa_id, self.zakaznik_id, self.doprava_id, self.stav, self.cislo_rezervace))

    def delete(self):
        sql = "DELETE FROM Rezervace WHERE cislo_rezervace=%s"
        self.execute(sql, (self.cislo_rezervace,))
        self.cislo_rezervace = None  # Reset cislo_rezervace po smazání

    def load(self, cislo_rezervace):
        sql = "SELECT * FROM Rezervace WHERE cislo_rezervace=%s"
        try:
            cursor = self.execute(sql, (cislo_rezervace,))
            if cursor:
                row = cursor.fetchone()
                if row:
                    print("Získaná data:", row)
                else:
                    print("Rezervace nenalezena.")
        except mysql.connector.Error as err:
            print(f"Chyba při načítání rezervace: {err}")


class Pokoj_v_rezervaci(BaseTable):
    def __init__(self, db_connection, pokoj_id=None, cislo_rezervace=None, pocet_lidi=None, datum_rezervace=None):
        super().__init__(db_connection)
        self.pokoj_id = pokoj_id
        self.cislo_rezervace = cislo_rezervace
        self.pocet_lidi = pocet_lidi
        self.datum_rezervace = datum_rezervace

    def create(self):
        sql = "INSERT INTO Pokoj_v_rezervaci (pokoj_ID, cislo_rezervace, pocet_lidi, datum_rezervace) VALUES (%s, %s, %s, %s)"
        cursor = self.execute(sql, (self.pokoj_id, self.cislo_rezervace, self.pocet_lidi, self.datum_rezervace))
        if cursor:
            self.id = cursor.lastrowid

    def update(self):
        sql = "UPDATE Pokoj_v_rezervaci SET pokoj_ID=%s, pocet_lidi=%s, datum_rezervace=%s WHERE ID=%s"
        self.execute(sql, (self.pokoj_id, self.pocet_lidi, self.datum_rezervace, self.id))

    def delete(self):
        sql = "DELETE FROM Pokoj_v_rezervaci WHERE ID=%s"
        self.execute(sql, (self.id,))
        self.id = None

    def load(self, id):
        sql = "SELECT * FROM Pokoj_v_rezervaci WHERE ID=%s"
        cursor = self.execute(sql, (id,))
        if cursor:
            row = cursor.fetchone()
            if row:
                self.id, self.pokoj_id, self.cislo_rezervace, self.pocet_lidi, self.datum_rezervace = row

class Audit_log(BaseTable):
    def __init__(self, db_connection, akce=None, detail=None, datum_cas=None, uzivatel_id=None):
        super().__init__(db_connection)
        self.akce = akce
        self.detail = detail
        self.datum_cas = datum_cas
        self.uzivatel_id = uzivatel_id

    def create(self):
        sql = "INSERT INTO Audit_log (akce, detail, datum_cas, uzivatel_id) VALUES (%s, %s, %s, %s)"
        cursor = self.execute(sql, (self.akce, self.detail, self.datum_cas, self.uzivatel_id))
        if cursor:
            self.id = cursor.lastrowid

    def update(self):
        sql = "UPDATE Audit_log SET akce=%s, detail=%s, datum_cas=%s, uzivatel_id=%s WHERE ID=%s"
        self.execute(sql, (self.akce, self.detail, self.datum_cas, self.uzivatel_id, self.id))

    def delete(self):
        sql = "DELETE FROM Audit_log WHERE ID=%s"
        self.execute(sql, (self.id,))
        self.id = None

    def load(self, id):
        sql = "SELECT * FROM Audit_log WHERE ID=%s"
        cursor = self.execute(sql, (id,))
        if cursor:
            row = cursor.fetchone()
            if row:
                self.id, self.akce, self.detail, self.datum_cas, self.uzivatel_id = row