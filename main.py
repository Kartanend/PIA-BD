from flask import Flask, render_template, request, redirect, url_for, flash
import requests
# from werkzeug.utils import validate_arguments
from con_basedatos import BASEDATOS
import os

app = Flask(__name__)
app.secret_key = 'ET\x1aU\xf5& 4\xdci\xc9\x06G\x1b\xfd-'
server = "192.168.1.223"
basedatos = "biblioteca"
usuario = "SQLBiblioteca"
contra = "SQLBiblioteca"
conn = BASEDATOS(server, basedatos, usuario, contra)
# os.chdir("C:\\Users\\Diego\\Desktop\\PIA-BD")
os.chdir("C:\\Users\\diego\\OneDrive\\Escritorio\\Sistema biblioteca\\PIA-BD Original")


@app.route("/")
def home():
    datosLibrosAzar = conn.obtenerLibrosAzar()
    return render_template("index.html", librosAzar=datosLibrosAzar, titulo="Inicio")


@app.route("/libros")
def libros():
    datosLibros = conn.obtenerLibros()
    return render_template("libros.html", libros=datosLibros)


@app.route("/miembros")
def miembros():
    datosMiembros = conn.obtenerMiembros()
    return render_template("miembros.html", miembros=datosMiembros)


@app.route("/editarMiembro/<int:id>")
def editarMiembro(id):
    datosMiembros = conn.obtenerMiembroDatos(id)
    return render_template("editarMiembro.html", miembro=datosMiembros)


@app.route("/actualizarMiembro", methods=["POST"])
def actualizarMiembro():
    valores = list()
    valores.append(request.form["id"])
    valores.append(request.form["nombre"])
    valores.append(request.form["apellidoP"])
    valores.append(request.form["apellidoM"])
    valores.append(request.form["correo"])
    valores.append(request.form["tel1"])
    if not request.form["tel2"] == "":
        valores.append(request.form["tel2"])
    else:
        valores.append("000-000-0000")
    valores.append(request.form["direccion"])
    conn.actualizarMiembro(valores)
    return redirect("/miembros")


@app.route("/eliminarMiembro/<int:id>")
def eliminarMiembros(id):
    conn.eliminarMiembro(id)
    return redirect("/miembros")


@app.route("/registro_miembro")
def registroMiembro():
    return render_template("nuevoMiembro.html")


@app.route("/registroM", methods=["POST"])
def registroM():
    valores = list()
    valores.append(request.form["nombre"])
    valores.append(request.form["apellidoP"])
    valores.append(request.form["apellidoM"])
    valores.append(request.form["correo"])
    valores.append(request.form["tel1"])
    if not request.form["tel2"] == "":
        valores.append(request.form["tel2"])
    else:
        valores.append("000-000-0000")
    valores.append(request.form["direccion"])
    conn.registrarMiembro(valores)
    return redirect("/registro_miembro")


@app.route("/rentados")
def rentados():
    datosRentados = conn.obtenerRentas()
    return render_template("rentas.html", rentas=datosRentados)


@app.route("/rentas_pasadas")
def rentasPasadas():
    datosRentas = conn.obtenerRentasPasadas()
    return render_template("rentasPasadas.html", rentas=datosRentas)


@app.route("/multas")
def multas():
    datosMultas = conn.obtenerMultas()
    return render_template("multas.html", multas=datosMultas)


@app.route("/multas_pasadas")
def multasPasadas():
    datosMultados = conn.obtenerMultasPasadas()
    return render_template("multasPasadas.html", multas=datosMultados)


@app.route("/libro/<int:id>")
def libro(id):
    datosLibro = conn.obtenerLibro(id)
    print(datosLibro)
    if datosLibro[10] == "":
        datosLibro[10] = "0.png"
    elif not os.path.exists(os.getcwd() + url_for("static", filename="portadas/"+datosLibro[10])):
        datosLibro[10] = "0.png"

    return render_template("libro.html", libro=datosLibro)


@app.route("/registro_libro")
def registroLibro():
    subGeneros = conn.obtenerSubgeneros()
    return render_template("nuevoLibro.html", subgeneros=subGeneros)


@app.route("/registroL", methods=["POST"])
def registroBasedatosLibro():
    valores = list()
    valores.append(request.form["libro"])
    valores.append(request.form["autor"])
    valores.append(request.form["genero"])
    valores.append(request.form["subgenero"])
    valores.append(request.form["editorial"])
    valores.append(request.form["edicion"])
    valores.append(request.form["fechaPublicacion"])
    valores.append(request.form["lugarPublicacion"])
    valores.append(request.form["isbn"])
    if request.form["fotoPortada"] == "":
        valores.append("0.png")
    else:
        valores.append(request.form["fotoPortada"])
    valores.append(request.form["resumen"])
    valores.append(request.form["descripcion"])
    valores.append(request.form["disponibles"])
    valores.append(request.form["lugarPublicacion"])
    valores.append(request.form["disponibles"])
    conn.registrarLibro(valores)
    return render_template("nuevoLibro.html")


@app.route("/actualizarLibro", methods=["POST"])
def actualizarLibro():
    valores = list()
    valores.append(request.form["libro"])
    valores.append(request.form["autor"])
    valores.append(request.form["genero"])
    valores.append(request.form["subgenero"])
    valores.append(request.form["editorial"])
    valores.append(request.form["edicion"])
    valores.append(request.form["fechaPublicacion"])
    valores.append(request.form["lugarPublicacion"])
    valores.append(request.form["isbn"])
    valores.append(request.form["fotoPortada"])
    valores.append(request.form["resumen"])
    valores.append(request.form["descripcion"])
    valores.append(request.form["disponibles"])
    valores.append(request.form["id"])
    conn.actualizarLibro(valores)
    return redirect("/libros")


@app.route("/buscarLibro", methods=["POST"])
def buscarLibro():
    libros = conn.buscarLibro(request.form["libro"])
    return render_template("libros.html", libros=libros)


@app.route("/nuevo_movimiento")
def nuevoMovimiento():
    miembros, libros = conn.obtenerDatosMovimiento()
    return render_template("nuevoMovimiento.html", miembros=miembros, libros=libros)


@app.route("/nuevoMov", methods=["POST"])
def RegistrarMovimiento():
    valores = list()
    valores.append(request.form["miembro"])
    valores.append(request.form["libro"])
    valores.append(request.form["fechaRenta"])
    valores.append(request.form["fechaEntrega"])
    conn.registrarMovimiento(valores)

    return redirect("/nuevo_movimiento")


@app.route("/editarRenta/<int:id>")
def editarRenta(id):
    datosRenta = conn.obtenerRenta(id)
    miembros, libros = conn.obtenerDatosMovimiento()
    return render_template("editarRenta.html", rentas=datosRenta, miembros=miembros, libros=libros)


@app.route("/eliminarRenta/<int:id>")
def eliminarRenta(id):
    conn.eliminarRenta(id)
    return redirect("/rentados")


@app.route("/actualizarRentas", methods=["POST"])
def ActualizarRenta():
    valores = list()
    valores.append(request.form["id"])
    valores.append(request.form["miembro"])
    valores.append(request.form["libro"])
    valores.append(request.form["fechaRenta"])
    valores.append(request.form["fechaEntrega"])
    conn.actualizarRenta(valores)

    return redirect("/rentados")


@app.route("/devolverRenta/<int:id>")
def devolverRenta(id):
    conn.actualizarMultas()
    conn.devolverRenta(id)
    return redirect("/rentados")


@app.route("/checar_multas")
def checarMultas():
    conn.actualizarMultas()
    return redirect("/multas")


@app.route("/pagarMulta/<int:id>")
def pagarMulta(id):
    conn.pagarMulta(id)
    return redirect("/multas")


@app.route("/eliminarMulta/<int:id>")
def eliminarMulta(id):
    conn.eliminarMulta(id)
    return redirect("/multas")


@app.route("/editarLibro/<int:id>")
def editarLibro(id):
    datosLibro = conn.obtenerLibro(id)
    subGeneros = conn.obtenerSubgeneros()
    return render_template("editarLibro.html", libro=datosLibro, subgeneros=subGeneros)


@app.route("/eliminarLibro/<int:id>")
def eliminarLibro(id):
    conn.eliminarLib(id)
    return redirect("/libros")


if __name__ == "__main__":
    app.run(debug=True, host="localhost", port="80")
