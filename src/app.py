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
                # Update the instance with form data
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
            model_instance = model_class(db_connection)
            # Get form data
            search_criteria = {k: v for k, v in request.form.items() if v}

            # Construct SQL query (Be cautious with SQL injection here, consider using parameterized queries)
            where_clause = " AND ".join(f"{k} LIKE %s" for k in search_criteria.keys())
            params = tuple(f"%{v}%" for v in search_criteria.values())

            sql = f"SELECT * FROM {model} WHERE {where_clause}"
            items = model_instance.execute(sql, params)
            column_names = model_instance.get_column_names()

            return render_template('find_results.html', items=items, model=model, columns=column_names)
        except KeyError:
            return "Model not found", 404
    else:  # GET request
        try:
            model_class = globals()[model]
            model_instance = model_class(db_connection)
            column_names = model_instance.get_column_names()
            return render_template('find.html', columns=column_names, model=model)
        except KeyError:
            return "Model not found", 404


@app.route('/add/<model>', methods=['GET', 'POST'])
def add_item(model):
    try:
        model_class = globals()[model]
        if request.method == 'POST':
            try:

                new_item = model_class(db_connection)

                for key, value in request.form.items():
                    if hasattr(new_item, key):
                        setattr(new_item, key, value)

                new_item.create()

                return redirect(url_for('list_items', model=model))
            except Exception as e:

                return f"Error during addition: {str(e)}", 500

        column_names = model_class(db_connection).get_column_names()
        return render_template('add_item.html', model=model, columns=column_names)
    except KeyError:
        return "Model not found", 404

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
        # Call the stored procedure
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

        # Aggregated data query
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


if __name__ == '__main__':
    app.run(debug=True)