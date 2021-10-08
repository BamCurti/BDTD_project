CREATE OR ALTER PROCEDURE POBLAR_PROYECTO1_BDTD
AS
BEGIN
	--ELIMINAR DATA PREVIA
	DELETE PROYECTO1_BDTD.DBO.FactSales;
	DELETE PROYECTO1_BDTD.DBO.FactCompra;
	DELETE PROYECTO1_BDTD.dbo.DimComprador;
	delete PROYECTO1_BDTD.dbo.DimProveedor;
	DELETE PROYECTO1_BDTD.DBO.DimSubCompra;
	DELETE PROYECTO1_BDTD.DBO.DimArticulo;
	DELETE PROYECTO1_BDTD.DBO.DimCliente;
	DELETE PROYECTO1_BDTD.DBO.DimSubFactura;
	DELETE PROYECTO1_BDTD.DBO.DimTiempo;
	DELETE PROYECTO1_BDTD.DBO.DimVendedor;

--POBLAR LA DIMENSIÓN ARTICULO !!!!FALTA COLOR!!!!!!
INSERT INTO PROYECTO1_BDTD.dbo.DimArticulo (Id_Articulo, Descripcion, Codigo, ColorBase, ColorDerivado, UMD, Tipo, Grupo)
	SELECT a.id_articulo, a.descripcion, a.codigo,
	--color base
		case
		WHEN a.descripcion like('%BLANCO%') THEN 'BLANCO'
		When a.descripcion like('%NEGRO%') THEN 'NEGRO'
		WHEN A.descripcion like('%AZUL%') THEN 'AZUL'
		WHEN A.descripcion LIKE('%ROJO%') THEN 'ROJO'
		WHEN A.descripcion like('%AMARILLO%') THEN 'AMARILLO'
		ELSE 'OTRO'
	end,
	case
		--BLANCO
		WHEN a.descripcion like('%OSTRA%') then 'OSTRA'
		WHEN a.descripcion like('%OSTION%') then 'OSTION'
		--AMARILLO
		WHEN A.descripcion LIKE('%CROMO%') THEN 'CROMO'
		WHEN A.descripcion LIKE('%HOLANDA%') THEN 'HOLANDA'
		WHEN A.descripcion LIKE('%LIMON%') THEN 'LIMON'
		WHEN A.descripcion LIKE('%TRIGO%') THEN 'TRIGO'
		WHEN A.descripcion LIKE('%INTENSO%') THEN 'INTENSO'
		WHEN A.descripcion LIKE('%OXIDO%') THEN 'OXIDO'
		WHEN A.descripcion LIKE('%MANGO%') THEN 'MANGO'
		--ROJO
		WHEN A.descripcion LIKE('%LADRILLO%') THEN 'LADRILLO'
		WHEN A.descripcion LIKE('%SULTANA%') THEN 'SULTANA'
		WHEN A.descripcion LIKE('%CORAL%') THEN 'CORAL'
		WHEN A.descripcion LIKE('%FUEGO%') THEN 'FUEGO'
		--AZUL
		WHEN A.descripcion LIKE('%ORGANICO%') THEN 'ORGANICO'
		WHEN A.descripcion LIKE('%REGIO%') THEN 'REGIO'
		WHEN A.descripcion LIKE('%CIELO%') THEN 'CIELO'
		WHEN A.descripcion LIKE('%OBSCURO%') THEN 'OBSCURO'
		WHEN A.descripcion LIKE('%CELESTE%') THEN 'CELESTE'
		WHEN A.descripcion LIKE('%PRINCESA%') THEN 'PRINCESA'
		WHEN A.descripcion LIKE('%INTENSO%') THEN 'INTENSO'
		WHEN A.descripcion LIKE('%MEDITERRANEO%') THEN 'MEDITERRANEO'
		WHEN A.descripcion LIKE('%REY%') THEN 'REY'
		WHEN A.descripcion LIKE('%RIVIERA%') THEN 'RIVIERA'
		WHEN A.descripcion LIKE('%ARTICO%') THEN 'ARTICO'
		WHEN A.descripcion LIKE('%MEDIANO%') THEN 'MEDIANO'
		--NEGRO
		WHEN A.descripcion LIKE('%MATE%') THEN 'MATE'
		WHEN A.descripcion LIKE('%BRILLANTE%') THEN 'BRILLANTE'
		WHEN A.descripcion LIKE('%SATINADO%') THEN 'SATINADO'
		--OTRO
		WHEN A.descripcion LIKE('%CREMA%') THEN 'CREMA'
		WHEN A.descripcion LIKE('%VERDE%') THEN 'VERDE'
		WHEN A.descripcion LIKE('%MARFIL%') THEN 'MARFIL'
		WHEN A.descripcion LIKE('%CASTAÑO%') THEN 'CASTAÑO'
		WHEN A.descripcion LIKE('%GRIS%') THEN 'GRIS'
		WHEN A.descripcion LIKE('%BERMELLON%') THEN 'BERMELLON'
		WHEN A.descripcion LIKE('%NARANJA%') THEN 'NARANJA'
		WHEN A.descripcion LIKE('%TURQUESA%') THEN 'TURQUESA'
		WHEN A.descripcion LIKE('%OCRE%') THEN 'OCRE'
		WHEN A.descripcion LIKE('%VIOLETA%') THEN 'VIOLETA'
		WHEN A.descripcion LIKE('%AGUAMARINA%') THEN 'AGUAMARINA'
		WHEN A.descripcion LIKE('%ORO%') THEN 'ORO'
		WHEN A.descripcion LIKE('%COBRE%') THEN 'COBRE'
		WHEN A.descripcion LIKE('%MELON%') THEN 'MELON'
		WHEN A.descripcion LIKE('%VAINILLA%') THEN 'VAINILLA'
		WHEN A.descripcion LIKE('%LILA%') THEN 'LILA'
		WHEN A.descripcion LIKE('%ROSA%') THEN 'ROSA'
		WHEN A.descripcion LIKE('%NIEBLA%') THEN 'NIEBLA'
		WHEN A.descripcion LIKE('%COCOA%') THEN 'COCOA'
		WHEN A.descripcion LIKE('%APIO%') THEN 'APIO'
		WHEN A.descripcion LIKE('%ALMENDRA%') THEN 'ALMENDRA'
		WHEN A.descripcion LIKE('%CHAMPAÑA%') THEN 'CHAMPAÑA'
		WHEN A.descripcion LIKE('%DURAZNO%') THEN 'DURAZNO'
		WHEN A.descripcion LIKE('%CAFÉ%') THEN 'CAFÉ'
		WHEN A.descripcion LIKE('%SANDALO%') THEN 'SANDALO'
		ELSE 'N/A'
	end,
	u.descripcion, a_t.descripcion, a_g.descripcion
	FROM PinturaO2021.DBO.Articulo a, PinturaO2021.dbo.ArticuloGrupo a_g,
	PinturaO2021.dbo.ArticuloTipo a_t, PinturaO2021.dbo.umd u
	WHERE A.id_articulogrupo = a_g.id_articulogrupo
	and a.id_articulotipo = a_t.id_articulotipo
	and a.id_umd = u.id_umd;

--POBLAR LA DIMENSIÓN CLIENTE
INSERT INTO PROYECTO1_BDTD.DBO.DimCliente (Id_cliente, RazonSocial, Colonia, CP, Ciudad, Estado, Pais)
	SELECT cl.Id_Cliente, cl.RazonSocial, cl.Colonia, cl.CodigoPostal, ci.nombre, ci.estado, ci.pais
	FROM PinturaO2021.dbo.Cliente cl, PinturaO2021.dbo.Ciudad ci
	where cl.id_ciudad = ci.id_ciudad

--POBLAR LA DIMENSIÓN SUB FACTURA
INSERT INTO PROYECTO1_BDTD.DBO.DimSubFactura(Id_Factura, Folio, CondicionPago)
	SELECT F.Id_Factura, f.folio, cp.Descripcion
	FROM PinturaO2021.DBO.Factura F, PinturaO2021.dbo.CondicionesPago cp
	where f.Id_CondicionesPago = cp.Id_CondicionesPago

--POBLAR LA DIMENSIÓN TIEMPO
INSERT INTO PROYECTO1_BDTD.DBO.DimTiempo(Id_tiempo, Anio, Mes, Dia, NombreDia, NombreMes, Trimestre,Semestre)
	select distinct
	cast(
		SUBSTRING(convert(varchar, fecha, 126),1,4) +
		SUBSTRING(convert(varchar, fecha, 126),6,2) +
		SUBSTRING(convert(varchar, fecha, 126),9,2)
		as bigint),
		year(fecha),
		MONTH(fecha),
		DAY(fecha),
		DATENAME(WEEKDAY, fecha),
		DATENAME(MONTH, fecha),
		(month(fecha) - 1) / 3 + 1,
		(month(fecha) - 1) / 6 + 1

	from PinturaO2021.dbo.Factura f
	union select distinct
	cast(
		SUBSTRING(convert(varchar, fecha, 126),1,4) +
		SUBSTRING(convert(varchar, fecha, 126),6,2) +
		SUBSTRING(convert(varchar, fecha, 126),9,2)
		as bigint),
		year(fecha),
		MONTH(fecha),
		DAY(fecha),
		DATENAME(WEEKDAY, fecha),
		DATENAME(MONTH, fecha),
		(month(fecha) - 1) / 3 + 1,
		(month(fecha) - 1) / 6 + 1
	from PinturaO2021.dbo.ProveedorFactura pf;

--POBLAR LA DIMENSIÓN DIM VENDEDOR
INSERT INTO PROYECTO1_BDTD.dbo.DimVendedor(Id_Vendedor, Nombre)
	select id_vendedor, nombre
	from PinturaO2021.dbo.vendedor;

--POBLAR LA DIMENSIÓN FACT SALES
with a_x_f as (
	select id_factura, sum(cantidad) as cantidad
	from PinturaO2021.dbo.Factura_d
	group by Id_Factura
)
insert into PROYECTO1_BDTD.dbo.FactSales(#num_fact, #num_articulos, #total, #subtotal, #descuento, #IVA, Id_tiempo, Id_articulo, Id_cliente, Id_factura, Id_vendedor)
	SELECT f_d.cantidad / axf.cantidad, --num_fact
	f_d.cantidad, f_d.total, f_d.subtotal, f_d.Descuento, f_d.iva,
		cast( --idtiempo
			SUBSTRING(convert(varchar, f.fecha, 126),1,4) +
			SUBSTRING(convert(varchar, f.fecha, 126),6,2) +
			SUBSTRING(convert(varchar, f.fecha, 126),9,2)
		as bigint), 
		f_d.id_articulo,
		f.Id_Cliente,
		f.Id_Factura,
		f.Id_Vendedor

	FROM a_x_f axf,
	PinturaO2021.dbo.Factura f, PinturaO2021.dbo.Factura_d f_d
	where f.Id_Factura = f_d.Id_Factura
	and axf.id_factura = f_d.Id_Factura;

--POBLAR LA SUB DIMENSIÓN COMPRA
insert into PROYECTO1_BDTD.dbo.DimSubCompra(id_compra,Folio,FormaPago)
	select pf.id_ProveedorFactura, pf.Folio, fp.Descripcion
	from PinturaO2021.dbo.ProveedorFactura pf
	inner join PinturaO2021.dbo.ProveedorFormaPago fp 
	on (pf.id_proveedorformapago = fp.Id_FormaPago);

--POBLAR LA SUB DIMENSIÓN COMPRADOR
insert into PROYECTO1_BDTD.dbo.DimComprador(id_comprador,nombre)
	select id_comprador, nombre 
	from PinturaO2021.dbo.Comprador;

--POBLAR LA SUB DIMENSIÓN PROVEEDOR
insert into PROYECTO1_BDTD.DBO.DimProveedor(Id_proveedor, RazonSocial, Colonia, Ciudad, Estado, Pais)
	select Id_Proveedor, RazonSocial, Colonia, c.nombre, c.estado, c.pais
	from PinturaO2021.dbo.Proveedor p
	inner join PinturaO2021.dbo.Ciudad c on (c.id_ciudad=p.id_Ciudad);

 --POBLAR LA DIMENSIÓN FACT COMPRA
 with cant_x_fact as
 (
	select id_proveedorfactura, sum(Cantidad) as cantidad
	from PinturaO2021.dbo.ProveedorFactura_d
	group by id_proveedorfactura
 )
insert into PROYECTO1_BDTD.dbo.FactCompra(#cantidad_compra, #total, #subtotal,
	#descuento,	#IVA, #cantidad_articulos, 
	Id_tiempo, Id_articulo, Id_proveedor, Id_comprador, Id_compra)
	SELECT f_d.Cantidad / cant_x_fact.cantidad, --cantidad compra
	f_d.total, f_d.subtotal, f_d.Descuento, f_d.iva, 
		f_d.Cantidad,	
		cast( --idtiempo
			SUBSTRING(convert(varchar, f.fecha, 126),1,4) +
			SUBSTRING(convert(varchar, f.fecha, 126),6,2) +
			SUBSTRING(convert(varchar, f.fecha, 126),9,2)
		as bigint), 
		f_d.id_articulo,
		f.id_Proveedor,
		f.id_comprador,
		f.id_ProveedorFactura

	from PinturaO2021.dbo.ProveedorFactura f, PinturaO2021.dbo.ProveedorFactura_d f_d, cant_x_fact
	where f.id_ProveedorFactura = f_d.id_proveedorfactura
	and cant_x_fact.id_proveedorfactura = f_d.id_proveedorfactura;

END

--EXECUTE POBLAR_PROYECTO1_BDTD;