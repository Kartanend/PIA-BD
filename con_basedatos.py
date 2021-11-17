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

    def obtenerLibros(self):
        self.cursor.execute(f"EXEC obtener_Libros")
        libros = self.cursor.fetchall()
        return libros

    def obtenerMiembros(self):
        self.cursor.execute("EXEC obtener_Miembros")
        miembros = self.cursor.fetchall()
        for i in range(0, len(miembros)):
            miembro = list(miembros[i])
            miembro[1] = f"{miembros[i][1]} {miembros[i][2]} {miembros[i][3]}"

            miembro.pop(2)
            miembro.pop(2)
            miembros[i] = miembro.copy()

        return miembros

    def obtenerLibrosAzar(self):
        self.cursor.execute("EXEC obtener_10_Libros_Random")
        libros = self.cursor.fetchall()
        return libros

    def obtenerRentas(self):
        self.cursor.execute("EXEC obtener_Rentas")
        rentas = self.cursor.fetchall()
        for i in range(0, len(rentas)):
            renta = list(rentas[i])
            renta[1] = f"{rentas[i][1]} {rentas[i][2]} {rentas[i][3]}"

            renta.pop(2)
            renta.pop(2)
            rentas[i] = renta.copy()

        return rentas

    def obtenerRentasPasadas(self):
        self.cursor.execute("EXEC obtener_Rentas_Pasadas")
        rentas = self.cursor.fetchall()
        for i in range(0, len(rentas)):
            renta = list(rentas[i])
            renta[1] = f"{rentas[i][1]} {rentas[i][2]} {rentas[i][3]}"

            renta.pop(2)
            renta.pop(2)
            rentas[i] = renta.copy()

        return rentas
            
    def obtenerMultas(self):
        self.cursor.execute("EXEC obtener_Multas")
        multas = self.cursor.fetchall()
        for i in range(0,len(multas)):
            multa = list(multas[i])
            multa[1] = f"{multas[i][1]} {multas[i][2]} {multas[i][3]}"
            
            multa.pop(2)
            multa.pop(2)
            multas[i] = multa.copy()

        return multas
    
    def obtenerMultasPasadas(self):
        self.cursor.execute("EXEC obtener_Multas_Pasadas")
        multas = self.cursor.fetchall()
        for i in range(0, len(multas)):
            multa = list(multas[i])
            multa[1] = f"{multas[i][1]} {multas[i][2]} {multas[i][3]}"

            multa.pop(2)
            multa.pop(2)
            multas[i] = multa.copy()

        return multas

    def obtenerLibro(self, id):
        self.cursor.execute(f"EXEC obtener_libro {id}")
        libro = self.cursor.fetchone()
        return libro


    #Cierra conexión de la base de datos
    def close(self):
        self.connection.close()