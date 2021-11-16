USE [biblioteca]
GO

CREATE TABLE dbo.libro (
	iIdLibro INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	vLibro VARCHAR(255) NOT NULL,
	iIdGenero INT NOT NULL,
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

ALTER TABLE dbo.libro DROP COLUMN iIdAutor

CREATE TABLE dbo.subgenero (
	iIdSubgenero INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	vSubgenero varchar(15) NOT NULL,
	iIdGenero INT NOT NULL
)

DROP TABLE dbo.subgenero

CREATE TABLE dbo.subgeneroLibro(
	iIdSubgenero int NOT NULL,
	iIdLibro INT NOT NULL
)

CREATE TABLE dbo.editorial(
	iIdEditorial int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	vEditorial VARCHAR(20) NOT NULL
)

ALTER TABLE dbo.editorial ALTER COLUMN vEditorial VARCHAR(50)

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
	iDiasRetraso INT NOT NULL,
	iTotalMulta INT NOT NULL
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

CREATE TABLE dbo.vetado(
	iIdVeta INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	iIdMiembro INT NOT NULL,
	tRazon TEXT NOT NULL
)

DROP TABLE dbo.libro;

ALTER TABLE dbo.subgenero ALTER COLUMN vSubgenero VARCHAR(20)

INSERT INTO dbo.subgenero (vSubgenero, iIdGenero) VALUES ('Aforismo', 4);
INSERT INTO dbo.genero (vGenero) VALUES ('Didáctico')

SELECT * FROM dbo.libro
SELECT * FROM dbo.autor
SELECT * FROM dbo.genero
SELECT * FROM dbo.subgenero;
SELECT * FROM dbo.subgeneroLibro;
SELECT * FROM dbo.editorial

INSERT INTO dbo.editorial (vEditorial) VALUES ('Edicions Universitat Barcelona')

UPDATE dbo.subgenero SET vSubgenero = 'Épica' WHERE iIdSubgenero=1

CREATE PROCEDURE registrar_autor
(@autor varchar(70))
AS 
INSERT INTO dbo.autor (vAutor) VALUES (@autor)
GO

DROP PROCEDURE registrar_autor
EXEC registrar_autor 'Walter Lambert'

CREATE PROCEDURE select_autores
AS
SELECT * FROM dbo.autor
GO

EXEC select_autores;

DELETE FROM dbo.autor where iIdAutor=2;

EXEC registrar_libro 'Promoting Equity in Maths Achievement. The Current discussion', 1, 4, 1, 4, '2008-01-01', 'México', '9788447532254', '1', 
'Presented in this volume is a kaleidoscopic view of the research done in the PREMA project (Promoting Equity in Maths Achievement. Proceedings of the Projects Workshops), which was a twenty months research study type of project funded under the \"General Activities of Observation, Analysis and Innovation\" of the Socrates Programme (European Commission, DG for Education and Culture). The research is enrooted on the position that the achievement of Europes Lisbon goal set in March 2000 is dependent on the extend to which Europe will utilize all of its human resources and its rich socio-cultural heritage',
'Libro de portada azul', 6, 6, 0

CREATE PROCEDURE registrar_libro
(	@libro VARCHAR(255),
	@genero INT,
	@editorial INT,
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
INSERT INTO dbo.libro (vLibro, iIdGenero, iIdEditorial, tEdicion, dAñoEdicion, vLugarPublicacion, vISBN, vFotoPortada, tResumen, tDescripcion, iTotal, iDisponible, iRentado) 
VALUES (@libro, @genero, @editorial, @edicion, @año, @lugarPublicacion, @ISBN, @foto, @resumen, @descripcion, @total, @disponible, @rentado)
GO

DROP PROCEDURE registrar_libro

SELECT * FROM dbo.libro

EXEC registrar_libro 'Promoting Equity in Maths Achievement. The Current discussion', 4, 11, 12, '2012-08-23', 'Libya', '9788447532254', '144', 
'Presented in this volume is a kaleidoscopic view of the research done in the PREMA project (Promoting Equity in Maths Achievement. Proceedings of the Project's Workshops), which was a twenty months research study type of project funded under the "General Activities of Observation, Analysis and Innovation" of the Socrates Programme (European Commission, DG for Education and Culture). The research is enrooted on the position that the achievement of Europe's Lisbon goal set in March 2000 is dependent on the extend to which Europe will utilize all of its human resources and its rich socio-cultural heritage', 
'Libro color rojo, con bordes verde y con 489 páginas', 3, 3, 0



CREATE PROCEDURE obtener_Libros
AS
SELECT iIdLibro, vLibro, tEdicion, dbo.genero.vGenero, dbo.editorial.vEditorial, vISBN, iDisponible, irentado, iTotal 
FROM (dbo.libro JOIN dbo.genero ON dbo.libro.iIdGenero = dbo.genero.iIdGenero) 
JOIN dbo.editorial ON dbo.libro.iIdEditorial = dbo.editorial.iIdEditorial
GO

DROP PROCEDURE obtener_Libros

EXEC obtener_Libros



SELECT * FROM dbo.miembro

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
GO

DROP PROCEDURE registrar_Miembro

EXEC registrar_Miembro 'Charles', 'Ramirez', 'Ramos', 'lorijohnson@example.org', '784-817-3036', '000-000-0000', '31886 Berg Point\nJamesbury, MN 96497'
EXEC registrar_Miembro 'Brian', 'Shepard', 'Gilbert', 'martindaniel@example.net', '742-183-3961', '667-268-9526', '30297 Dougherty Wall Apt. 541
East Ericastad, SC 57433'


CREATE PROCEDURE obtener_Miembros
AS
SELECT iIdMiembro, vNombre, vApellidoPaterno, vApellidoMaterno, vCorreo, vTelefono1, vTelefono2, tDireccion FROM dbo.miembro WHERE bActivo = 1

EXEC obtener_Miembros

UPDATE dbo.miembro SET bActivo = 1 WHERE iIdMiembro = 1

SELECT COUNT(iIdMiembro) FROM dbo.miembro WHERE bActivo = 1



CREATE PROCEDURE obtener_10_Libros_Random
AS
SELECT iIdLibro, vLibro, tEdicion, dbo.genero.vGenero, dbo.editorial.vEditorial, vISBN, iDisponible, irentado, iTotal 
FROM (dbo.libro JOIN dbo.genero ON dbo.libro.iIdGenero = dbo.genero.iIdGenero) 
JOIN dbo.editorial ON dbo.libro.iIdEditorial = dbo.editorial.iIdEditorial where iIdLibro in 
(select top 10 percent iIdLibro from dbo.libro order by newid())

EXEC obtener_10_Libros_Random



SELECT * FROM dbo.recibo

CREATE PROCEDURE registrar_Movimiento
(
	@miembro INT,
	@libro INT,
	@fechaRenta DATE,
	@fechaEstimada DATE,
	@total INT
)
AS
INSERT INTO dbo.recibo (iIdMiembro, iIdLibro, dFechaRenta, dFechaEstimadaDevolucion, iTotal)
VALUES (@miembro, @libro, @fechaRenta, @fechaEstimada, @total)

EXEC registrar_Movimiento 2, 1, '2021-11-16', '2021-11-20', 200



CREATE PROCEDURE obtener_Rentas
AS
SELECT iIdFolio, dbo.miembro.vNombre, dbo.miembro.vApellidoPaterno, dbo.miembro.vApellidoMaterno, dbo.libro.vLibro, dFechaRenta, dFechaEstimadaDevolucion, dbo.recibo.iTotal FROM (dbo.recibo 
JOIN dbo.miembro ON dbo.recibo.iIdMiembro = dbo.miembro.iIdMiembro)
JOIN dbo.libro ON dbo.recibo.iIdLibro = dbo.libro.iIdLibro WHERE dFechaDevolucion IS NULL 

EXEC obtener_rentas



CREATE PROCEDURE obtener_Rentas_Pasadas
AS
SELECT iIdFolio, dbo.miembro.vNombre, dbo.miembro.vApellidoPaterno, dbo.miembro.vApellidoMaterno, dbo.libro.vLibro, dFechaRenta, dFechaEstimadaDevolucion, dFechaDevolucion, dbo.recibo.iTotal FROM (dbo.recibo 
JOIN dbo.miembro ON dbo.recibo.iIdMiembro = dbo.miembro.iIdMiembro)
JOIN dbo.libro ON dbo.recibo.iIdLibro = dbo.libro.iIdLibro WHERE dFechaDevolucion IS NOT NULL 

EXEC obtener_Rentas_Pasadas



SELECT * FROM dbo.multa

CREATE PROCEDURE obtener_Multas
AS
SELECT *
