from flask import Flask, render_template, request, redirect, url_for, flash
from con_basedatos import BASEDATOS

app = Flask(__name__)
app.secret_key = 'ET\x1aU\xf5& 4\xdci\xc9\x06G\x1b\xfd-'
server= "DRJAVA"
basedatos= "biblioteca"
usuario= "biblioteca_user"
contra = "password"
conn = BASEDATOS(server, basedatos, usuario, contra)

@app.route("/")
def home():
    datosLibrosAzar = conn.obtenerLibrosAzar()
    return render_template("index.html", librosAzar = datosLibrosAzar)

@app.route("/libros")
def libros():
    datosLibros = conn.obtenerLibros()
    return render_template("libros.html", libros = datosLibros)

@app.route("/miembros")
def miembros():
    datosMiembros = conn.obtenerMiembros()
    return render_template("miembros.html", miembros = datosMiembros)

@app.route("/rentados")
def rentados():
    datosRentados = conn.obtenerRentas()
    return render_template("rentas.html", rentas = datosRentados)

@app.route("/rentas_pasadas")
def rentasPasadas():
    datosRentas = conn.obtenerRentasPasadas()
    return render_template("rentasPasadas.html", rentas = datosRentas)

@app.route("/multas")
def multas():
    datosMultas = conn.obtenerMultas()
    return render_template("multas.html", multas = datosMultas)
    #CREAR PROCEDURE PARA MULTAS, MÉTODO PARA LA CONECCIÓN Y HTML

@app.route("/multas_pasadas")
def multasPasadas():
    datosMultados = conn.obtenerMultasPasadas()
    return render_template("multasPasadas.html", multas = datosMultados)

@app.route("/libro/<int:id>")
def libro(id):
    datosLibro = conn.obtenerLibro(id)
    return render_template("libro.html", libro = datosLibro)


if __name__ == "__main__":
    app.run(debug=True, host="localhost", port="80")


