import pyodbc

class BASEDATOS:
    #Metodo constructor, conecta a la base de datos
    def __init__(self, server, basedatos, usuario, contra):
        try:
            # server= "DRJAVA"
            # basedatos= "biblioteca"
            # usuario= "biblioteca_user"
            # contra = "password"
            self.connection = pyodbc.connect(f"""DRIVER={{SQL Server}};
                                            SERVER={server};
                                            DATABASE={basedatos};
                                            Trusted_Connection=yes;
                                            UID={usuario};
                                            PWD={contra};""")
            # connection = pyodbc.connect('DRIVER={SQL Server};SERVER=nombredetuServer;DATABASE=nombreDeLaBS;Trusted_Connection=yes;') en caso de que te quieras conectar con la sesión de windows,
            print("__________Conexión exitosa__________")


            self.cursor = self.connection.cursor()
            # self.cursor.execute("SELECT @@version;")
            # row = self.cursor.fetchone()
            # print(f"Versión del servidor de SQL Server: {row[0]}")


            # cursor.execute("SELECT * FROM Alumnos")
            # rows = cursor.fetchall()
            # for row in rows:
            #     print(row)

            #return self.cursor()

        except Exception as ex:
            print(f"Error durante la conexión: {ex}")
        finally:
            pass
            #self.connection.close()  # Se cerró la conexión a la BD.
            #print("La conexión ha finalizado.")

    def registrar_autor(self, autor):
        try:
            self.cursor.execute(f"EXEC registrar_autor '{autor}'")
            self.cursor.commit()
        except:
            pass

    #Cierra conexión de la base de datos
    def close(self):
        self.connection.close()