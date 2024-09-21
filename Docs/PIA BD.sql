USE [biblioteca]
GO

CREATE TABLE dbo.libro (
	iIdLibro INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	vLibro VARCHAR(255) NOT NULL,
	iIdGenero INT NOT NULL,
	iIdSubGenero INT NOT NULL,
	iIdEditorial INT NOT NULL,
	tEdicion TINYINT NOT NULL,
	dAñoEdicion DATE NOT NULL,
	vLugarPublicacion varchar(255) NOT NULL,
	vISBN varchar(13) UNIQUE NOT NULL,
	vFotoPortada varchar(15) NOT NULL,
	tResumen text NOT NULL,
	tDescripcion text NOT NULL,
	iTotal INT NOT NULL,
	iDisponible INT NOT NULL,
	iRentado INT NOT NULL
)


CREATE TABLE dbo.subgenero (
	iIdSubgenero INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	vSubgenero varchar(15) NOT NULL,
	iIdGenero INT NOT NULL
)

CREATE TABLE dbo.autor(
	iIdAutor int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	vAutor VARCHAR(70)
)

CREATE TABLE dbo.autorLibro(
	iIdLibro INT NOT NULL,
	iIdAutor INT NOT NULL
)

CREATE TABLE dbo.genero(
	iIdGenero INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	vGenero VARCHAR(15) NOT NULL
)

CREATE TABLE dbo.factura(
	iIdFactura INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	iIdFolio INT NOT NULL,
	vRFC VARCHAR(13) NOT NULL,
	iNumTimbrado INT
)

CREATE TABLE dbo.recibo(
	iIdFolio INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	iIdMiembro INT NOT NULL,
	iIdLibro INT NOT NULL,
	dFechaRenta DATE NOT NULL,
	dFechaEstimadaDevolucion DATE NOT NULL,
	dFechaDevolucion DATE,
	iTotal INT NOT NULL
)

CREATE TABLE dbo.multa(
	iIdMulta INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	iIdFolio INT NOT NULL,
	iTotalMulta INT NOT NULL,
	bPagado BIT NOT NULL DEFAULT 0
)

CREATE TABLE dbo.miembro(
	iIdMiembro INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	vNombre VARCHAR(35) NOT NULL,
	vApellidoPaterno VARCHAR(35) NOT NULL,
	vApellidoMaterno VARCHAR(35) NOT NULL,
	vCorreo VARCHAR(70) NOT NULL,
	vTelefono1 VARCHAR(15) NOT NULL,
	vTelefono2 VARCHAR(15),
	tDireccion TEXT NOT NULL,
	bActivo BIT DEFAULT 1
)


CREATE PROCEDURE registrar_autor
(@autor varchar(70))
AS 
INSERT INTO dbo.autor (vAutor) VALUES (@autor)


CREATE PROCEDURE select_autores
AS
SELECT * FROM dbo.autor

SELECT * FROM dbo.libro
DROP PROCEDURE registrar_libro
CREATE PROCEDURE registrar_libro
(	@libro VARCHAR(255),
	@autor VARCHAR(100),
	@genero INT,
	@subgenero INT,
	@editorial VARCHAR(20),
	@edicion TINYINT,
	@año DATE,
	@lugarPublicacion VARCHAR(255),
	@ISBN VARCHAR(15),
	@foto VARCHAR(15),
	@resumen TEXT,
	@descripcion TEXT,
	@total INT,
	@disponible INT,
	@rentado INT) 
AS
INSERT INTO dbo.libro (vLibro, vAutor, iIdGenero, iIdSubGenero, vEditorial, tEdicion, dAñoEdicion, vLugarPublicacion, vISBN, vFotoPortada, tResumen, tDescripcion, iTotal, iDisponible, iRentado, bExiste) 
VALUES (@libro, @autor, @genero, @subgenero, @editorial, @edicion, @año, @lugarPublicacion, @ISBN, @foto, @resumen, @descripcion, @total, @disponible, @rentado, 1)


CREATE PROCEDURE actualizar_libro
(	@libro VARCHAR(255),
	@autor VARCHAR(100),
	@genero INT,
	@subgenero INT,
	@editorial VARCHAR(20),
	@edicion TINYINT,
	@año DATE,
	@lugarPublicacion VARCHAR(255),
	@ISBN VARCHAR(15),
	@foto VARCHAR(15),
	@resumen TEXT,
	@descripcion TEXT,
	@total INT,
	@disponible INT,
	@rentado INT,
	@id INT) 
AS
UPDATE dbo.libro SET vLibro = @libro, vAutor=@autor, iIdGenero=@genero, iIdSubGenero=@subgenero, vEditorial=@editorial, 
tEdicion=@edicion, dAñoEdicion=@año, vLugarPublicacion=@lugarPublicacion, vISBN=@ISBN, vFotoPortada=@foto,
tResumen=@resumen, tDescripcion=@descripcion, iTotal=@total, iDisponible=@disponible, iRentado=@rentado WHERE iIdLibro =@id

SELECT * FROM dbo.libro

EXEC actualizar_libro 'Everyday Maths', 'Melissa Haney Jones', 1, 1, 
                'Routledge', 10, '1975-08-26', 'Turkey', '1741250439',
                '', 'This book gives you a range of basic everyday maths tips, including: the maths of buying, selling and investing in property what your renovation will cost calculating the return from shares and short-term investments decoding your pay slip 
and s uper contributions calculating GST costs smart shoppin g calculating percentages and discounts', 'Libro color verde, con bordes amarillo y con 197 páginas', 50, 50, 0, Turkey

ALTER TABLE dbo.libro DROP CONSTRAINT

CREATE PROCEDURE obtener_Libros
AS
SELECT iIdLibro, vLibro, vAutor, tEdicion, dbo.genero.vGenero, vEditorial, vISBN, iDisponible, irentado, iTotal 
FROM (dbo.libro JOIN dbo.genero ON dbo.libro.iIdGenero = dbo.genero.iIdGenero) WHERE bExiste = 1


CREATE PROCEDURE buscar_Libros
(@nombre VARCHAR(255))
AS
SELECT iIdLibro, vLibro, tEdicion, dbo.genero.vGenero, vEditorial, vISBN, iDisponible, irentado, iTotal 
FROM (dbo.libro JOIN dbo.genero ON dbo.libro.iIdGenero = dbo.genero.iIdGenero) WHERE bExiste = 1 AND (vLibro LIKE '%'+@nombre+'%')


CREATE PROCEDURE registrar_Miembro
(
	@nombre VARCHAR(35),
	@apellidoP VARCHAR(35),
	@apellidoM VARCHAR(35),
	@correo VARCHAR(70),
	@tel1 VARCHAR(15),
	@tel2 VARCHAR(15),
	@direccion TEXT
)
AS
INSERT INTO dbo.miembro (vNombre, vApellidoPaterno, vApellidoMaterno, vCorreo, vTelefono1, vTelefono2, tDireccion)
VALUES (@nombre, @apellidoP, @apellidoM, @correo, @tel1, @tel2, @direccion)


CREATE PROCEDURE actualizar_Miembro
(
	@id INT,
	@nombre VARCHAR(35),
	@apellidoP VARCHAR(35),
	@apellidoM VARCHAR(35),
	@correo VARCHAR(70),
	@tel1 VARCHAR(15),
	@tel2 VARCHAR(15),
	@direccion TEXT
)
AS
UPDATE dbo.miembro SET vNombre=@nombre, vApellidoPaterno=@apellidoP, vApellidoMaterno=@apellidoM, 
vCorreo=@correo, vTelefono1=@tel1, vTelefono2=@tel2, tDireccion=@direccion WHERE iIdMiembro = @id


CREATE PROCEDURE obtener_Miembros
AS
SELECT iIdMiembro, vNombre, vApellidoPaterno, vApellidoMaterno, vCorreo, vTelefono1, vTelefono2, tDireccion FROM dbo.miembro WHERE bActivo = 1


CREATE PROCEDURE obtener_10_Libros_Random
AS
SELECT iIdLibro, vLibro, tEdicion, dbo.genero.vGenero, vEditorial, vISBN, iDisponible, irentado, iTotal 
FROM (dbo.libro JOIN dbo.genero ON dbo.libro.iIdGenero = dbo.genero.iIdGenero) 
WHERE iIdLibro in (select top 10 percent iIdLibro from dbo.libro order by newid())

CREATE PROCEDURE obtener_Rentas_Sin_Pagar
AS
SELECT iIdFolio, dFechaEstimadaDevolucion FROM dbo.recibo WHERE dFechaDevolucion IS NULL AND bDisponible = 1


CREATE PROCEDURE registrar_Movimiento
(
	@miembro INT,
	@libro INT,
	@fechaRenta DATE,
	@fechaEstimada DATE,
	@total INT
)
AS
INSERT INTO dbo.recibo (iIdMiembro, iIdLibro, dFechaRenta, dFechaEstimadaDevolucion, iTotal, bDisponible)
VALUES (@miembro, @libro, @fechaRenta, @fechaEstimada, @total, 1)


#Recolecta los datos para el formulario para registrar un nuevo movimiento
CREATE PROCEDURE obtencion_Datos_Miembros
AS
SELECT iIdMiembro, vNombre, vApellidoPaterno, vApellidoMaterno FROM dbo.miembro


CREATE PROCEDURE obtencion_Datos_Libros
AS
SELECT iIdLibro, vLibro FROM dbo.libro


CREATE PROCEDURE obtener_Rentas
AS
SELECT iIdFolio, dbo.miembro.vNombre, dbo.miembro.vApellidoPaterno, dbo.miembro.vApellidoMaterno, dbo.libro.vLibro, dFechaRenta, dFechaEstimadaDevolucion, dbo.recibo.iTotal FROM (dbo.recibo 
JOIN dbo.miembro ON dbo.recibo.iIdMiembro = dbo.miembro.iIdMiembro)
JOIN dbo.libro ON dbo.recibo.iIdLibro = dbo.libro.iIdLibro WHERE dFechaDevolucion IS NULL AND bDisponible = 1


CREATE PROCEDURE obtener_Rentas_Pasadas
AS
SELECT iIdFolio, dbo.miembro.vNombre, dbo.miembro.vApellidoPaterno, dbo.miembro.vApellidoMaterno, dbo.libro.vLibro, dFechaRenta, dFechaEstimadaDevolucion, dFechaDevolucion, dbo.recibo.iTotal FROM (dbo.recibo 
JOIN dbo.miembro ON dbo.recibo.iIdMiembro = dbo.miembro.iIdMiembro)
JOIN dbo.libro ON dbo.recibo.iIdLibro = dbo.libro.iIdLibro WHERE dFechaDevolucion IS NOT NULL AND bDisponible = 1



CREATE PROCEDURE obtener_Multas
AS
SELECT dbo.recibo.iIdFolio, dbo.miembro.vNombre, dbo.miembro.vApellidoPaterno, dbo.miembro.vApellidoMaterno, dbo.libro.vLibro , dbo.recibo.dFechaRenta, 
dbo.recibo.dFechaEstimadaDevolucion, dbo.recibo.iTotal
FROM ((dbo.multa JOIN dbo.recibo 
ON dbo.multa.iIdFolio = dbo.recibo.iIdFolio) JOIN dbo.miembro ON dbo.miembro.iIdMiembro = dbo.recibo.iIdMiembro)
JOIN dbo.libro ON dbo.libro.iIdLibro = dbo.recibo.iIdLibro WHERE dbo.multa.sDiasRetraso IS NULL AND dbo.multa.bExiste=1


CREATE PROCEDURE obtener_Multas_Pasadas
AS
SELECT dbo.recibo.iIdFolio, dbo.miembro.vNombre, dbo.miembro.vApellidoPaterno, dbo.miembro.vApellidoMaterno, dbo.libro.vLibro , dbo.recibo.dFechaRenta, 
dbo.recibo.dFechaEstimadaDevolucion, dbo.recibo.dFechaDevolucion, sDiasRetraso, dbo.recibo.iTotal
FROM ((dbo.multa JOIN dbo.recibo 
ON dbo.multa.iIdFolio = dbo.recibo.iIdFolio) JOIN dbo.miembro ON dbo.miembro.iIdMiembro = dbo.recibo.iIdMiembro)
JOIN dbo.libro ON dbo.libro.iIdLibro = dbo.recibo.iIdLibro WHERE dbo.multa.sDiasRetraso IS NOT NULL AND dbo.multa.bExiste = 1


CREATE PROCEDURE registrar_Multa
(
	@folio INT,
	@total INT
)
AS
INSERT INTO dbo.multa (iIdFolio, iTotalMulta)
VALUES (@folio, @total)


DROP PROCEDURE obtener_Folio_Multas;
CREATE PROCEDURE obtener_Folio_Multas
AS
SELECT iIdFolio FROM dbo.multa WHERE bExiste = 1


CREATE PROCEDURE obtener_libro
(@id INT)
AS
SELECT iIdLibro, vLibro, vAutor, dbo.genero.vGenero, dbo.subgenero.vSubgenero, vEditorial, tEdicion, dAñoEdicion, vLugarPublicacion, vISBN, vFotoPortada, tResumen, tDescripcion, iDisponible, iRentado, iTotal 
FROM ((dbo.libro JOIN dbo.genero ON dbo.libro.iIdGenero = dbo.genero.iIdGenero) 
JOIN dbo.subgenero ON dbo.libro.iIdSubGenero = dbo.subgenero.iIdSubgenero)
WHERE iIdLibro = @id AND bExiste = 1
DROP PROCEDURE obtener_libro
EXEC obtener_Libro 93

CREATE PROCEDURE eliminar_libro
(@id INT)
AS
UPDATE dbo.libro SET bExiste = 0 WHERE iIdLibro = @id


CREATE PROCEDURE obtener_subgeneros
AS
SELECT * FROM dbo.subgenero


CREATE PROCEDURE eliminar_Miembro
(@id INT)
AS
UPDATE dbo.miembro SET bActivo = 0 WHERE iIdMiembro = @id
EXEC eliminar_Miembro 1
SELECT * FROM dbo.miembro

CREATE PROCEDURE obtener_miembro
(@id INT)
AS
SELECT * FROM dbo.miembro WHERE iIdMiembro = @id

DROP PROCEDURE obtener_miembro

EXEC obtencion_Datos_Miembros
EXEC obtencion_Datos_Libros

CREATE PROCEDURE obtener_Renta
(@id INT)
AS
SELECT iIdFolio, dbo.miembro.iIdMiembro, dbo.miembro.vNombre, dbo.miembro.vApellidoPaterno, dbo.miembro.vApellidoMaterno, dbo.libro.iIdLibro, dbo.libro.vLibro, dFechaRenta, dFechaEstimadaDevolucion, dbo.recibo.iTotal FROM (dbo.recibo 
JOIN dbo.miembro ON dbo.recibo.iIdMiembro = dbo.miembro.iIdMiembro)
JOIN dbo.libro ON dbo.recibo.iIdLibro = dbo.libro.iIdLibro WHERE dFechaDevolucion IS NULL AND iIdFolio = @id AND bDisponible = 1

ALTER TABLE dbo.libro DROP CONSTRAINT UC_vISBN

CREATE PROCEDURE actualizar_Renta
(
	@id INT,
	@miembro INT,
	@libro INT,
	@fechaRenta DATE,
	@fechaEstimada DATE,
	@total INT
)
AS
UPDATE dbo.recibo SET iIdMiembro =@miembro, iIdLibro=@libro, dFechaRenta=@fechaRenta,
dFechaEstimadaDevolucion=@fechaEstimada, iTotal=@total WHERE iIdFolio = @id

SELECT * FROM dbo.recibo

CREATE PROCEDURE eliminar_Renta
(@id INT)
AS 
UPDATE dbo.recibo SET bDisponible = 0 WHERE iIdFolio = @id


CREATE PROCEDURE devolver_Renta
(
	@id INT,
	@fecha DATE
)
AS
UPDATE dbo.recibo SET dFechaDevolucion = @fecha WHERE iIdFolio = @id

CREATE PROCEDURE pagar_Multa
(
	@id INT,
	@fechaDevolucion DATE,
	@dias SMALLINT
)
AS
UPDATE dbo.recibo SET dFechaDevolucion= @fechaDevolucion WHERE iIdFolio = @id
UPDATE dbo.multa SET sDiasRetraso = @dias WHERE iIdFolio = @id


CREATE PROCEDURE obtener_Fecha_Estimada_Multa
(@id INT)
AS
SELECT iIdFolio, dFechaEstimadaDevolucion FROM dbo.recibo WHERE dbo.recibo.iIdFolio = @id 

CREATE PROCEDURE eliminar_Multa
(@id INT)
AS
UPDATE dbo.multa SET bExiste = 0 WHERE iIdFolio = @id

DROP PROCEDURE eliminar_Multa
SELECT * FROM multa

EXEC obtener_Rentas_Sin_Pagar
EXEC obtener_Folio_Multas