from flask import Flask, render_template, request
from src.database import get_db_connection

app = Flask(__name__, template_folder='../templates')


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
        items = [{'id': item[0], 'jmeno': item[1], 'prijmeni': item[2]} for item in raw_items] if model == 'Zakaznik' else list(raw_items)
        column_names = model_instance.get_column_names()
        return render_template('list.html', items=items, model=model, columns=column_names)
    except KeyError:
        return "Model not found", 404

@app.route('/create/<model>', methods=['GET', 'POST'])
def create_item(model):
    try:
        model_class = globals()[model]
        if request.method == 'POST':
            item = model_class(db_connection, **request.form.to_dict())
            item.save()
            return render_template('success.html', message=f"{model} created successfully")
        else:
            model_fields = [field for field in model_class.__init__.__code__.co_varnames if field != 'self' and field != 'db_connection']
            return render_template('create.html', model=model, model_fields=model_fields)
    except KeyError:
        return "Model not found", 404

if __name__ == '__main__':
    app.run(debug=True)