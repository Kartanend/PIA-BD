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
    return render_template("index.html", )

if __name__ == "__main__":
    app.run(debug=True, host="localhost", port="80")