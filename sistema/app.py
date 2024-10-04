from flask import Flask, render_template, request, url_for, flash, redirect, session
from flask_mysqldb import MySQL

app = Flask(__name__)
app.secret_key = "many random bytes"

app.config["MYSQL_HOST"] = "localhost"
app.config["MYSQL_USER"] = "root"
app.config["MYSQL_PASSWORD"] = "usbw"
app.config["MYSQL_DB"] = "teachers_database"

mysql = MySQL(app)

# Rota para a tela de login
@app.route("/", methods=['GET', 'POST'])
def login():
    if request.method == "POST":
        email = request.form.get('email')
        password = request.form.get("password")
        if email and password:
            cursor = mysql.connection.cursor()
            cursor.execute(
                "SELECT * FROM Usuario WHERE email=%s AND senha=%s", (email, password))
            user = cursor.fetchone()
            cursor.close()
            if user:
                session['user_id'] = user[0]
                return redirect(url_for('dashboard'))
            else:
                flash('Login inválido. Tente novamente.')
                return redirect(url_for('login'))
    return render_template('login.html')

# Rota para logout
@app.route("/logout")
def logout():
    session.pop('user_id', None)
    flash('Você saiu com sucesso.')
    return redirect(url_for('login'))

# Rota para a tela principal do professor
@app.route("/dashboard")
def dashboard():
    if 'user_id' not in session:
        flash('Por favor, faça login para acessar esta página.')
        return redirect(url_for('login'))

    cursor = mysql.connection.cursor()
    cursor.execute(
        "SELECT nome FROM Professor WHERE id_usuario = %s", (session['user_id'],))
    user_name = cursor.fetchone()

    cursor.execute("SELECT * FROM Turma WHERE id_professor = %s", (session['user_id'],))
    name_class = cursor.fetchall()
    cursor.close()

    return render_template("dashboard.html", Turma=name_class, user_name=user_name[0])

# Rota para a tela de cadastro de Turma
@app.route("/cadastro", methods=["GET", "POST"])
def add_class():
    if 'user_id' not in session:
        flash('Por favor, faça login para acessar esta página.')
        return redirect(url_for('login'))

    cursor = mysql.connection.cursor()
    cursor.execute(
        "SELECT nome FROM Professor WHERE id_usuario = %s", (session['user_id'],))
    user_name = cursor.fetchone()
    cursor.close()

    if request.method == "POST":
        name_class = request.form['name_class']
        cursor = mysql.connection.cursor()
        cursor.execute("INSERT INTO Turma (nome, id_professor) VALUES (%s, %s)", (name_class, session['user_id']))
        mysql.connection.commit()
        cursor.close()
        flash("Turma cadastrada com sucesso!")
        return redirect(url_for('dashboard'))
    return render_template("add_class.html", user_name=user_name[0])

# Rota para excluir a turma
@app.route("/excluir/<string:id_data>", methods=['GET'])
def delete_class(id_data):
    cursor = mysql.connection.cursor()
    # Verificar se há atividades associadas à turma
    cursor.execute(
        "SELECT COUNT(*) FROM Atividade WHERE id_turma = %s", (id_data,))
    activity_count = cursor.fetchone()[0]
    if activity_count > 0:
        flash("Não é possível excluir a turma com atividades cadastradas.")
        return redirect(url_for("dashboard"))

    # Deletar a turma se não houver atividades associadas
    cursor.execute("DELETE FROM Turma WHERE id=%s", (id_data,))
    mysql.connection.commit()
    cursor.close()
    flash("Turma deletada com sucesso!")
    return redirect(url_for("dashboard"))

# Rota para listar atividades da turma
@app.route("/atividades/<int:id_turma>")
def activities(id_turma):
    if 'user_id' not in session:
        flash('Por favor, faça login para acessar esta página.')
        return redirect(url_for('login'))

    cursor = mysql.connection.cursor()
    cursor.execute("""
        SELECT a.id, a.nome, a.descricao, t.nome AS turma_nome
        FROM Atividade a
        JOIN Turma t ON a.id_turma = t.id
        WHERE t.id = %s AND t.id_professor = (SELECT id_professor FROM Turma WHERE id = %s)
    """, (id_turma, id_turma))
    activities = cursor.fetchall()
    cursor.close()

    cursor = mysql.connection.cursor()
    cursor.execute(
        "SELECT nome FROM Professor WHERE id_usuario = %s", (session['user_id'],))
    user_name = cursor.fetchone()

    if not activities:
        flash("Não há atividades registradas para esta turma. Por favor, registre uma nova atividade.")
        return redirect(url_for('add_activity', id_turma=id_turma, user_name=user_name))

    return render_template("activities.html", activities=activities, id_turma=id_turma, user_name=user_name[0])

# Rota para cadastrar nova atividade para a turma
@app.route("/cadastro_atividade", methods=["GET", "POST"])
def add_activity():
    if 'user_id' not in session:
        flash('Por favor, faça login para acessar esta página.')
        return redirect(url_for('login'))

    id_turma = request.args.get('id_turma')
    if request.method == "POST":
        name = request.form['name']
        descricao = request.form['descricao']
        id_turma = request.form['id_turma']

        cursor = mysql.connection.cursor()

        try:
            cursor.execute("SELECT id_professor FROM Turma WHERE id = %s", (id_turma,))
            result = cursor.fetchone()

            if result is None:
                flash('Turma não encontrada ou não associada a um professor.')
                return redirect(url_for('add_activity', id_turma=id_turma))

            professor_id = result[0]
            cursor.execute("INSERT INTO Atividade (nome, descricao, id_turma, id_professor) VALUES (%s, %s, %s, %s)", (name, descricao, id_turma, professor_id))
            mysql.connection.commit()
            flash('Atividade cadastrada com sucesso!')
            return redirect(url_for('activities', id_turma=id_turma))

        except MySQL.OperationalError as e:
            flash(f'Erro no banco de dados: {e}')
            return redirect(url_for('add_activity', id_turma=id_turma,))

        finally:
            cursor.close()

    return render_template('add_activities.html', id_turma=id_turma)

# TODO Rota para editar a atividade
# TODO Rota para excluir a atividade

# Executa a aplicação
if __name__ == "__main__":
    app.run(debug=True)
