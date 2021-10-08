CREATE DATABASE PROYECTO1_BDTD

CREATE TABLE PROYECTO1_BDTD.DBO.DimSubFactura
(
	Id_Factura int primary key,
	Folio varchar(10),
	CondicionPago varchar(50)
)

CREATE TABLE PROYECTO1_BDTD.dbo.DimArticulo
(
	Id_Articulo int primary key,
	Descripcion varchar(100),
	Codigo varchar(50),
	ColorBase varchar(50),
	ColorDerivado varchar(50),
	UMD varchar(50),
	Tipo varchar(50),
	Grupo varchar(50)
)

CREATE TABLE PROYECTO1_BDTD.dbo.DimVendedor
(
	Id_Vendedor int primary key,
	Nombre varchar(100)
)

CREATE TABLE PROYECTO1_BDTD.dbo.DimCliente
(
	Id_cliente int primary key,
	RazonSocial varchar(100),
	Colonia varchar(50),
	CP varchar(5),
	Ciudad varchar(100),
	Estado varchar(50),
	Pais varchar(50)
)

CREATE TABLE PROYECTO1_BDTD.dbo.DimTiempo
(
	Id_tiempo bigint primary key,
	Anio int,
	Trimestre int,
	Semestre int,
	Mes int,
	Dia int,
	NombreMes varchar(50),
	NombreDia varchar(50)
)

CREATE TABLE PROYECTO1_BDTD.dbo.FactSales
(
	#num_fact decimal(18,17), --Fracción de cantidad de articulos entre el total de articulos por factura
	#num_articulos decimal(18,2),
	#total decimal(18,2),
	#subtotal decimal(18,2),
	#descuento decimal(18,2),
	#IVA decimal(18,2),
	Id_tiempo bigint foreign key references DimTiempo(Id_tiempo),
	Id_articulo int foreign key references DimArticulo(Id_articulo),
	Id_vendedor int foreign key references DimVendedor(id_vendedor),
	Id_factura int foreign key references DimSubFactura(id_factura),
	Id_cliente int foreign key references DimCliente(id_cliente)
)

CREATE TABLE PROYECTO1_BDTD.DBO.DimSubCompra
(
	Id_compra int primary key,
	Folio varchar(10),
	FormaPago varchar(50)
)

CREATE TABLE PROYECTO1_BDTD.DBO.DimComprador
(
	Id_comprador int primary key,
	Nombre varchar(50)
)

CREATE TABLE PROYECTO1_BDTD.DBO.DimProveedor
(
	Id_proveedor int primary key,
	RazonSocial varchar(250),
	Colonia varchar(50),
	Ciudad varchar(100),
	Estado varchar(50),
	Pais varchar(50)
)

CREATE TABLE PROYECTO1_BDTD.dbo.FactCompra
(
	#cantidad_compra decimal(18,17), --Fracción de cantidad de articulos entre el total de articulos por factura
	#total decimal(18,2),
	#cantidad_articulos decimal(18,2),
	#subtotal decimal(18,2),
	#descuento decimal(18,2),
	#IVA decimal(18,2),
	Id_tiempo bigint foreign key references DimTiempo(Id_tiempo),
	Id_articulo int foreign key references DimArticulo(Id_articulo),
	Id_proveedor int foreign key references DimProveedor(id_proveedor),
	Id_comprador int foreign key references DimComprador(id_comprador),
	Id_compra int foreign key references DimSubCompra(id_compra)
)