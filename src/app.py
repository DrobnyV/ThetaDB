import mysql
from flask import Flask, render_template, request, redirect, url_for, flash
from src.database import get_db_connection

app = Flask(__name__, template_folder='../templates', static_folder='../static')


from tables import BaseTable, Zeme, Adresa, Zakaznik, Typ_pokoje, Pokoj, Doprava, Rezervace, Pokoj_v_rezervaci, Audit_log


db_connection = get_db_connection()

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/list/<model>')
def list_items(model):
    try:
        model_class = globals()[model]
        model_instance = model_class(db_connection)
        raw_items = model_instance.select_all()
        if raw_items is None:
            raw_items = []
        items = list(raw_items)
        column_names = model_instance.get_column_names()
        return render_template('list.html', items=items, model=model, columns=column_names)
    except KeyError:
        return "Model not found", 404



@app.route('/update/<model>/<id>', methods=['GET', 'POST'])
def update_item(model, id):
    try:
        model_class = globals()[model]
        model_instance = model_class(db_connection)
        if request.method == 'POST':
            try:

                model_instance.load(id)

                for key, value in request.form.items():
                    setattr(model_instance, key, value)
                model_instance.update()

                return redirect(url_for('list_items', model=model))
            except Exception as e:

                return f"Error during update: {str(e)}", 500
        else:
            model_instance.load(id)
            return render_template('update.html', item=model_instance.__dict__, model=model)
    except KeyError:
        return "Model not found", 404


@app.route('/delete/<model>/<id>')
def delete_item(model, id):
    try:
        model_class = globals()[model]
        model_instance = model_class(db_connection)
        model_instance.load(id)
        model_instance.delete()
        return redirect(url_for('list_items', model=model))
    except KeyError:
        return "Model not found", 404

@app.route('/find/<model>/<int:id>')
def find_item(model, id):
    try:
        model_class = globals()[model]
        model_instance = model_class(db_connection)
        model_instance.load(id)
        if model_instance.id:
            return render_template('find.html', item=model_instance.__dict__, model=model)
        else:
            return "Item not found", 404
    except KeyError:
        return "Model not found", 404


@app.route('/find/<model>', methods=['GET', 'POST'])
def find_items(model):
    if request.method == 'POST':
        try:
            model_class = globals()[model]
            instance = model_class(db_connection)
            search_criteria = {k: v for k, v in request.form.items() if v}

            if search_criteria:
                where_clause = " AND ".join([f"{k} LIKE %s" for k in search_criteria.keys()])
                params = tuple(f'%{v}%' for v in search_criteria.values())
                sql = f"SELECT * FROM {model} WHERE {where_clause}"
                cursor = instance.execute(sql, params)
                items = cursor.fetchall() if cursor else []
                cursor.close() if cursor else None
            else:
                items = instance.select_all()

            column_names = instance.get_column_names()
            return render_template('find_results.html', items=items, model=model, columns=column_names)
        except Exception as e:
            print(f"Error during find: {str(e)}")
            return "An error occurred", 500
    else:
        try:
            model_class = globals()[model]
            column_names = model_class(db_connection).get_column_names()
            return render_template('find.html', columns=column_names, model=model)
        except KeyError:
            return "Model not found", 404


@app.route('/add/<model>', methods=['GET', 'POST'])
def add_item(model):
    try:
        columns = []
        if model == 'Pokoj':
            columns = ['cislo', 'pocet_posteli', 'typ_pokoje_nazev', 'velikost_pokoje']
        elif model == 'Zakaznik':
            columns = ['jmeno', 'prijmeni', 'telefon', 'email', 'zeme_nazev', 'vek']
        elif model == 'Rezervace':
            columns = ['cislo_rezervace', 'datum_od', 'datum_do', 'check_in_do', 'check_out_do',
                       'celkova_cena', 'snidane', 'vratna_rezervace', 'pocet_deti', 'pocet_dospelych',
                       'adresa_ID', 'zakaznik_ID', 'doprava_ID', 'stav']


        if request.method == 'POST':
            form_data = request.form.to_dict()


            if 'zeme_nazev' in form_data:
                zeme_nazev = form_data['zeme_nazev']
                zeme_cursor = db_connection.cursor()
                zeme_cursor.execute("SELECT ID FROM Zeme WHERE nazev = %s", (zeme_nazev,))
                zeme_row = zeme_cursor.fetchone()
                if zeme_row:
                    form_data['zeme_id'] = zeme_row[0]
                else:
                    return "Zeme not found", 400

            if 'typ_pokoje_nazev' in form_data:
                typ_pokoje_nazev = form_data['typ_pokoje_nazev']
                typ_pokoje_cursor = db_connection.cursor()
                typ_pokoje_cursor.execute("SELECT ID FROM Typ_pokoje WHERE nazev = %s", (typ_pokoje_nazev,))
                typ_pokoje_row = typ_pokoje_cursor.fetchone()
                if typ_pokoje_row:
                    form_data['typ_pokoje_id'] = typ_pokoje_row[0]
                else:
                    return "Typ pokoje not found", 400


            form_data.pop('zeme_nazev', None)
            form_data.pop('typ_pokoje_nazev', None)


            model_class = globals()[model]
            model_instance = model_class(db_connection, **form_data)
            model_instance.create()

            return redirect(url_for('list_items', model=model))


        return render_template('add_item.html', model=model, columns=columns)

    except Exception as e:
        return str(e), 500



@app.route('/list/adresa')
def list_adresa():
    return list_items('Adresa')

@app.route('/list/zakaznik')
def list_zakaznik():
    return list_items('Zakaznik')

@app.route('/list/doprava')
def list_doprava():
    return list_items('Doprava')

@app.route('/view/obsazenost')
def view_obsazenost():
    conn = get_db_connection()
    if not conn:
        return "Database connection failed", 500

    cursor = conn.cursor(dictionary=True)
    query = "SELECT * FROM view_ObsazenostPokojuvRealnemCase"
    cursor.execute(query)
    results = cursor.fetchall()
    cursor.close()
    conn.close()

    columns = results[0].keys() if results else []
    return render_template('view_results.html', model="Obsazenost Pokoju", columns=columns, items=results)

@app.route('/view/financni_prehled')
def view_financni_prehled():
    conn = get_db_connection()
    if not conn:
        return "Database connection failed", 500

    cursor = conn.cursor(dictionary=True)
    query = "SELECT * FROM view_FinancniPrehledRezervaci"
    cursor.execute(query)
    results = cursor.fetchall()
    cursor.close()
    conn.close()

    columns = results[0].keys() if results else []
    return render_template('view_results.html', model="Finanční Přehled", columns=columns, items=results)


@app.route('/zrus_rezervaci', methods=['POST'])
def zrus_rezervaci():
    rezervace_cislo = request.form.get('rezervace_cislo')

    conn = get_db_connection()
    if not conn:
        return "Database connection failed", 500

    try:
        cursor = conn.cursor()

        cursor.callproc('zrus_rezervaci', [rezervace_cislo])
        conn.commit()
        cursor.close()
        conn.close()

    except mysql.connector.Error as err:
        print(f"Error: {err}")
        conn.rollback()
        cursor.close()
        conn.close()

    return redirect(url_for('list_items', model='Rezervace'))

@app.route('/summary_report')
def summary_report():
    conn = get_db_connection()
    if not conn:
        return "Database connection failed", 500

    try:
        cursor = conn.cursor(dictionary=True)


        cursor.execute("""
            SELECT 
                (SELECT COUNT(*) FROM Zakaznik) AS pocet_zakazniku,
                (SELECT COUNT(*) FROM Pokoj WHERE pocet_posteli >= 2) AS pokoje_s_vice_postelemi,
                (SELECT MIN(celkova_cena) FROM Rezervace) AS nejlevnejsi_rezervace,
                (SELECT MAX(celkova_cena) FROM Rezervace) AS nejdrazsi_rezervace,
                (SELECT COUNT(*) FROM Rezervace WHERE datum_od >= CURDATE()) AS aktivni_rezervace
        """)
        report_data = cursor.fetchone()

        cursor.close()
        conn.close()
        return render_template('summary_report.html', report_data=report_data)
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        conn.close()
        return "Error fetching summary report", 500

def refresh_db_connection():
    global db_connection
    if db_connection is not None:
        db_connection.close()
    db_connection = get_db_connection()


@app.route('/import/<model>', methods=['GET', 'POST'])
def import_data(model):
    if request.method == 'POST':
        if 'file' not in request.files:
            return "No file part", 400

        file = request.files['file']
        if file.filename == '':
            return "No selected file", 400

        if file:
            file_extension = file.filename.split('.')[-1].lower()
            data = None

            if file_extension == 'csv':
                import csv
                data = csv.reader(file.stream.read().decode('utf-8').splitlines())
                process_csv_data_with_classes(model, data)
            elif file_extension == 'json':
                import json
                data = json.load(file)
                process_json_data_with_classes(model, data)
            elif file_extension == 'xml':
                import xml.etree.ElementTree as ET
                tree = ET.parse(file.stream)
                root = tree.getroot()
                process_xml_data_with_classes(model, root)
            else:
                return "Unsupported file format", 400
            refresh_db_connection()
            return f"Data imported into {model} successfully!", 200

    return render_template('import_data.html', model=model)


def process_csv_data_with_classes(model, data):
    db_connection = get_db_connection()

    if model == 'Zeme':
        for row in data:
            zeme = Zeme(
                db_connection,
                nazev=row[0],
                iso_kod=row[1],
                mena=row[2],
                uredni_jazyk=row[3],
                region=row[4]
            )
            zeme.create()

    elif model == 'Typ_pokoje':
        for row in data:
            typ_pokoje = Typ_pokoje(
                db_connection,
                nazev=row[0],
                popis=row[1] if len(row) > 1 else None
            )
            typ_pokoje.create()


def process_json_data_with_classes(model, data):
    db_connection = get_db_connection()

    if model == 'Zeme':
        for record in data:
            zeme = Zeme(
                db_connection,
                nazev=record['nazev'],
                iso_kod=record['ISO_kod'],
                mena=record['mena'],
                uredni_jazyk=record['uredni_jazyk'],
                region=record['region']
            )
            zeme.create()

    elif model == 'Typ_pokoje':
        for record in data:
            typ_pokoje = Typ_pokoje(
                db_connection,
                nazev=record['nazev'],
                popis=record.get('popis')
            )
            typ_pokoje.create()


def process_xml_data_with_classes(model, root):
    db_connection = get_db_connection()

    if model == 'Zeme':
        for item in root.findall('Item'):
            zeme = Zeme(
                db_connection,
                nazev=item.find('nazev').text,
                iso_kod=item.find('ISO_kod').text,
                mena=item.find('mena').text,
                uredni_jazyk=item.find('uredni_jazyk').text,
                region=item.find('region').text
            )
            zeme.create()

    elif model == 'Typ_pokoje':
        for item in root.findall('Item'):
            typ_pokoje = Typ_pokoje(
                db_connection,
                nazev=item.find('nazev').text,
                popis=item.find('popis').text if item.find('popis') is not None else None
            )
            typ_pokoje.create()




if __name__ == '__main__':
    app.run(debug=True)