from types import DynamicClassAttribute
import pyodbc
from werkzeug.utils import redirect
from datetime import datetime

class BASEDATOS:
    #Metodo constructor, conecta a la base de datos
    def __init__(self, server, basedatos, usuario, contra):
        try:
            # server= "DRJAVA"
            # basedatos= "biblioteca"
            # usuario= "biblioteca_user"
            # contra = "password"
            self.cuotaPorDia = 50
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

    def actualizarMiembro(self,miembro):
        sql = f"""EXEC actualizar_Miembro {miembro[0]}, '{miembro[1]}', '{miembro[2]}', '{miembro[3]}',
                '{miembro[4]}', '{miembro[5]}', '{miembro[6]}', '{miembro[7]}' """
        print(sql)
        self.cursor.execute(sql)
        self.cursor.commit()

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

    def registrarMovimiento(self, datos):
        entrega = datetime.strptime(datos[2], "%Y-%m-%d")
        fechaEstimada = datetime.strptime(datos[3], "%Y-%m-%d")
        dias = fechaEstimada - entrega
        total = dias.days * self.cuotaPorDia
        sql = f"EXEC registrar_Movimiento {datos[0]}, {datos[1]}, '{datos[2]}', '{datos[3]}', {total} "
        print(sql)
        self.cursor.execute(sql)
        self.cursor.commit()
            
    def obtenerMultas(self):
        self.cursor.execute("EXEC obtener_Multas")
        multas = self.cursor.fetchall()
        for i in range(0,len(multas)):
            multa = list(multas[i])
            multa[1] = f"{multas[i][1]} {multas[i][2]} {multas[i][3]}"
            
            multa.pop(2)
            multa.pop(2)

            hoy = datetime.now()
            fechaEstimada = datetime.strptime(multa[4], "%Y-%m-%d")
            dias = hoy - fechaEstimada
            multa.append(dias.days)
            multas[i] = multa.copy()

        return multas

    def actualizarMultas(self):
        self.cursor.execute("EXEC obtener_Rentas_Sin_Pagar")
        datosRentas = self.cursor.fetchall()
        self.cursor.execute("EXEC obtener_Folio_Multas")
        idFolios = self.cursor.fetchall()
        ids= list()
        for id in idFolios:
            ids.append(id[0])

        for renta in datosRentas:
            if not renta[0] in ids:
                fechaEstimada = datetime.strptime(renta[1], "%Y-%m-%d")
                fechaActual = datetime.now()
                dias = fechaActual - fechaEstimada
                if dias.days > 0:
                    total = dias.days * self.cuotaPorDia
                    self.cursor.execute(f"EXEC registrar_Multa {renta[0]},  {total}")
                    self.cursor.commit()
    
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

    def buscarLibro(self, nombre):
        self.cursor.execute(f"EXEC buscar_Libros '{nombre}' ")
        libros = self.cursor.fetchall()
        return libros

    def obtenerSubgeneros(self):
        self.cursor.execute("EXEC obtener_subgeneros")
        subgeneros = self.cursor.fetchall()
        return subgeneros

    def registrarLibro(self, libro):
        sql = f"""EXEC registrar_libro '{libro[0]}', '{libro[1]}', {libro[2]}, {libro[3]}, 
                '{libro[4]}', {libro[5]}, '{libro[6]}', '{libro[7]}', '{libro[8]}',
                '{libro[9]}', '{libro[10]}', '{libro[11]}', {libro[12]}, {libro[12]}, 0 """
        print(sql)
        self.cursor.execute(sql)
        self.cursor.commit()


    def registrarMiembro(self, miembro):
        sql = f"""EXEC registrar_Miembro '{miembro[0]}', '{miembro[1]}', '{miembro[2]}', '{miembro[3]}',
                '{miembro[4]}', '{miembro[5]}', '{miembro[6]}' """
        print(sql)
        self.cursor.execute(sql)
        self.cursor.commit()


    def obtenerDatosMovimiento(self):
        self.cursor.execute("EXEC obtencion_Datos_Miembros")
        miembros = self.cursor.fetchall()
        for i in range(0, len(miembros)):
            miembro = list(miembros[i])
            miembro[1] = f"{miembros[i][1]} {miembros[i][2]} {miembros[i][3]}"

            miembro.pop(2)
            miembro.pop(2)
            miembros[i] = miembro.copy()

        self.cursor.execute(f"EXEC obtencion_Datos_Libros")
        libros = self.cursor.fetchall()

        return miembros, libros

    def obtenerRenta(self, id):
        self.cursor.execute(f"EXEC obtener_Renta {id}")
        datos = self.cursor.fetchone()

        miembro = list(datos)
        miembro[2] = f"{datos[2]} {datos[3]} {datos[4]}"

        miembro.pop(3)
        miembro.pop(3)
        datos = miembro.copy()

        return datos
        

    def eliminarLib(self, id):
        self.cursor.execute(f"EXEC eliminar_libro {id}")
        self.cursor.commit()

    def eliminarMiembro(self, id):
        self.cursor.execute(f"EXEC eliminar_Miembro {id}")
        self.cursor.commit()

    def obtenerMiembro(self, id):
        self.cursor.execute(f"EXEC obtener_Miembro {id}")
        datos = self.cursor.fetchone()

        miembro = list(datos)
        miembro[1] = f"{datos[1]} {datos[2]} {datos[3]}"

        miembro.pop(2)
        miembro.pop(2)
        datos = miembro.copy()
        return datos

    def obtenerMiembroDatos(self, id):
        self.cursor.execute(f"EXEC obtener_Miembro {id}")
        datos = self.cursor.fetchone()
        return datos

    def actualizarRenta(self,renta):
        entrega = datetime.strptime(renta[3], "%Y-%m-%d")
        fechaEstimada = datetime.strptime(renta[4], "%Y-%m-%d")
        dias = fechaEstimada - entrega
        total = dias.days * self.cuotaPorDia
        sql = f"""EXEC actualizar_Renta {renta[0]}, {renta[1]}, {renta[2]}, '{renta[3]}',
                '{renta[4]}', {total}"""
        print (sql)
        self.cursor.execute(sql)
        self.cursor.commit()
    
    def eliminarRenta(self, id):
        self.cursor.execute(f"EXEC eliminar_Renta {id}")
        self.cursor.commit()

    def devolverRenta(self, id):
        hoy = datetime.now()
        fecha = hoy.strftime("%Y-%m-%d")
        self.cursor.execute(f"EXEC devolver_Renta {id}, '{fecha}'")
        self.cursor.commit()

    def pagarMulta(self, id):
        self.cursor.execute(f"EXEC obtener_Fecha_Estimada_Multa {id}")
        recibo = self.cursor.fetchone()
        fechaEtimada = datetime.strptime(recibo[1], "%Y-%m-%d")
        fechaHoy = datetime.now()
        dias = fechaHoy - fechaEtimada
        dias = dias.days
        sql = f"EXEC pagar_Multa {id}, {dias}"
        fecha = fechaHoy.strftime("%Y-%m-%d")
        print(sql)
        self.cursor.execute(f"EXEC pagar_Multa {id}, '{fecha}', {dias}")
        self.cursor.commit()

    def eliminarMulta(self, id):
        self.cursor.execute(f"EXEC eliminar_Multa {id}")
        self.cursor.commit()

    def actualizarLibro(self, libro):
        print(libro)
        sql = f"""EXEC actualizar_libro '{libro[0]}', '{libro[1]}', {libro[2]}, {libro[3]}, 
                '{libro[4]}', {libro[5]}, '{libro[6]}', '{libro[7]}', '{libro[8]}',
                '{libro[9]}', '{libro[10]}', '{libro[11]}', {libro[12]}, {libro[12]}, 0, {libro[-1]} """
        print(sql)
        self.cursor.execute(sql)
        self.cursor.commit()
                
    #Cierra conexión de la base de datos
    def close(self):
        self.connection.close()