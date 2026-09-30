import mysql.connector


class ClienteModel:

    def __init__(self):
        # conexion a la base de datos
        self.conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database="hotelpro"
        )
        self.cursor = self.conn.cursor()

    def obtener_clientes(self):
        # retorna todos los clientes
        self.cursor.callproc("sp_obtener_clientes")
        for result in self.cursor.stored_results():
            return result.fetchall()

    def crear_cliente(self, nombre, apellido, documento, telefono, correo):
        # inserta un nuevo cliente
        self.cursor.callproc("sp_crear_cliente", (nombre, apellido, documento, telefono, correo))
        self.conn.commit()

    def actualizar_cliente(self, id, nombre, apellido, documento, telefono, correo):
        # actualiza los datos de un cliente
        self.cursor.callproc("sp_actualizar_cliente", (id, nombre, apellido, documento, telefono, correo))
        self.conn.commit()

    def eliminar_cliente(self, id):
        # elimina un cliente por id
        self.cursor.callproc("sp_eliminar_cliente", (id,))
        self.conn.commit()