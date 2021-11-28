--1
--v2
with ventas as
(
	select id_vendedor, count(id_vendedor) as cantidad
	from PinturaO2021.dbo.Factura
	group by Id_Vendedor
)
select v.Nombre, ve.id_vendedor
from ventas ve, PinturaO2021.dbo.vendedor v
where ve.Id_Vendedor = v.Id_vendedor;

--2
--v3 2
select year(fecha) as anio, 
	count(year(fecha)) as cantidad
from PinturaO2021.dbo.Factura
group by year(fecha)

--3
--v4 
select fd.id_articulo, a.codigo, a.descripcion, fd.cantidad, fd.precio, datename(weekday,f.fecha)
from 
	PinturaO2021.dbo.Factura_d fd,
	PinturaO2021.dbo.Factura f,
	PinturaO2021.dbo.Articulo a
where
	fd.Id_Factura = f.Id_Factura
	and fd.id_articulo = a.id_articulo;

--4
--v7
select count(*)
 from 
	 PinturaO2021.dbo.Factura_d fd,
	 PinturaO2021.dbo.Factura f,
	 PinturaO2021.dbo.Articulo a,
	 PinturaO2021.dbo.umd u
 where 
	 u.descripcion = 'CUB 19LT'
	 and year(f.fecha) = 2021
	 and f.Id_Factura = fd.Id_Factura
	 and a.id_articulo = fd.id_articulo
	 and a.id_umd = u.id_umd;

--5
--v8
select distinct
	year(fecha)
from
	PinturaO2021.dbo.Factura;

--6
--v10
select sum(fd.precio)
from
	PinturaO2021.dbo.Articulo a,
	PinturaO2021.dbo.Factura_d fd,
	PinturaO2021.dbo.Factura f
where
	a.id_articulo = fd.id_articulo
	and a.descripcion like('%ROJO%')
	and f.Id_Factura = fd.Id_Factura
	and year(f.fecha) = 2014

--7
--v14
with tipo as
(	
	select a.id_articulotipo, sum(fd.cantidad) as conteo,
	sum(fd.precio) as precio
	from PinturaO2021.dbo.Factura_d fd,
	PinturaO2021.dbo.Articulo a
	where
		a.id_articulo = fd.id_articulo
	group by
		a.id_articulotipo
)
select a_t.descripcion, tipo.conteo, tipo.precio
from tipo, PinturaO2021.dbo.ArticuloTipo a_t
where
	tipo.id_articulotipo = a_t.id_articulotipo;

--8
--v16
select c.Colonia, count(c.Colonia) as ventas,
sum(f.total) as total
from PinturaO2021.dbo.Factura f,
	PinturaO2021.dbo.Cliente c
	where c.Id_Cliente = f.Id_Cliente
group by c.Colonia;

--9
--v24
select sum(fd.precio) as precio
from 
	PinturaO2021.dbo.Articulo a,
	PinturaO2021.dbo.Factura_d fd,
	PinturaO2021.dbo.Factura f,
	PinturaO2021.dbo.ArticuloTipo a_t
where 
	fd.id_articulo = a.id_articulo
	and f.Id_Factura = fd.Id_Factura
	and a_t.id_articulotipo = a.id_articulotipo
	and year(f.fecha) = 2018
	and a_t.descripcion = 'complementos'
group by a.id_articulotipo;

--10
--v33
select f.Id_Vendedor, sum(fd.total) as total, sum(fd.cantidad) as cantidad
from 
	PinturaO2021.dbo.Factura_d fd,
	PinturaO2021.dbo.Factura f
where
	f.Id_Factura = fd.Id_Factura
group by
	f.Id_Vendedor;

--11
--c1
with compras as
(
	select id_comprador, count(*) as conteo
	from PinturaO2021.dbo.ProveedorFactura
	group by id_comprador
)
select c.Nombre, compras.conteo
from compras, PinturaO2021.dbo.Comprador c
where compras.id_comprador = c.id_Comprador;

--12
--c3
with color as
(
	select
		case
			when a.descripcion like ('%rojo%') then 'rojo'
			when a.descripcion like ('%AMARILLO%') then 'AMARILLO'
			when a.descripcion like ('%AZUL%') then 'AZUL'
			when a.descripcion like ('%BLANCO%') then 'BLANCO'
			when a.descripcion like ('%NEGRO%') then 'NEGRO'
			else 'OTRO'
		end as color,
		P.Cantidad

	from PinturaO2021.dbo.Articulo a,
		PinturaO2021.dbo.ProveedorFactura_d p
	where
		a.id_articulo = p.id_articulo
)
select c.color, sum(c.cantidad) as cantidad
from color c
group by c.color;

--13
--c5

select p.Colonia, sum(pf.Total) as total, count(pf.Total) as conteo
from 
	PinturaO2021.dbo.ProveedorFactura pf,
	PinturaO2021.dbo.Proveedor p
where
	p.Id_Proveedor = pf.id_Proveedor
group by
	p.Colonia;
