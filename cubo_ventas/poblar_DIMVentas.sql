CREATE OR ALTER PROCEDURE POBLAR_PROYECTO1_BDTD
AS
BEGIN
	--ELIMINAR DATA PREVIA
	DELETE PROYECTO1_BDTD.DBO.FactSales;
	DELETE PROYECTO1_BDTD.DBO.DimArticulo;
	DELETE PROYECTO1_BDTD.DBO.DimCliente;
	DELETE PROYECTO1_BDTD.DBO.DimSubFactura;
	DELETE PROYECTO1_BDTD.DBO.DimTiempo;
	DELETE PROYECTO1_BDTD.DBO.DimVendedor;

--POBLAR LA DIMENSIÓN ARTICULO !!!!FALTA COLOR!!!!!!
INSERT INTO PROYECTO1_BDTD.dbo.DimArticulo (Id_Articulo, Descripcion, Codigo, ColorBase, ColorDerivado, UMD, Tipo, Grupo)

	SELECT a.id_articulo, a.descripcion, a.codigo, null, null, u.descripcion, a_t.descripcion, a_g.descripcion
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
	and axf.id_factura = f_d.Id_Factura


--POBLAR LA SUB DIMENSIÓN COMPRA

--POBLAR LA SUB DIMENSIÓN COMPRADOR

--POBLAR LA SUB DIMENSIÓN PROVEEDOR

 --POBLAR LA DIMENSIÓN FACT COMPRA





END

--EXECUTE POBLAR_PROYECTO1_BDTD;
--select * from PROYECTO1_BDTD.dbo.Factsales order by id_factura;