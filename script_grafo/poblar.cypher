//Crear los nodos articulo
LOAD CSV WITH HEADERS FROM "file:///articulo.csv" as row
CREATE(n:Articulo)
SET n = row,
n.id_articulo = toInteger(row.id_articulo);

CREATE INDEX index_Articulo FOR (n:Articulo) ON (n.id_articulo);

//Crear los nodos cliente
LOAD CSV WITH HEADERS FROM "file:///cliente.csv" as row
CREATE(n:Cliente)
SET n = row,
n.id_cliente = toInteger(row.id_cliente),
n.cp = toInteger(row.cp);

CREATE INDEX index_Cliente FOR (n:Cliente) on (n.id_cliente);

//Crear los nodos compra
LOAD CSV WITH HEADERS FROM "file:///compra.csv" as row
CREATE(n:Compra)
SET n = row,
n.id_compra = toInteger(row.id_compra);

CREATE INDEX index_Compra FOR (n:Compra) on (n.id_compra);

//Crear los nodos compra_d
LOAD CSV WITH HEADERS FROM "file:///compra_d.csv" as row
CREATE (n: Compra_d)
SET n = row,
n.cantidad_compra = toFloat(row.cantidad_compra),
n.total = toFloat(row.total),
n.cantidad_articulos = toInteger(row.cantidad_articulos),
n.subtotal = toFloat(row.subtotal),
n.descuento = toFloat(row.descuento),
n.iva = toFloat(row.iva),
n.id_articulo = toInteger(row.id_articulo),
n.id_proveedor = toInteger(row.id_proveedor),
n.id_comprador = toInteger(row.id_comprador),
n.id_compra = toInteger(row.id_compra);

//Crear los nodos comprador
LOAD CSV WITH HEADERS FROM "file:///comprador.csv" as row
CREATE (n:Comprador)
SET n = row,
n.id_comprador = toInteger(row.id_comprador);

CREATE INDEX index_Comprador FOR (n:Comprador) on (n.id_comprador);

//Crear los nodos proveedor
LOAD CSV WITH HEADERS FROM "file:///proveedor.csv" as row
CREATE (n:Proveedor)
SET n = row,
n.id_proveedor = toInteger(row.id_proveedor);

CREATE INDEX index_Proveedor FOR (n:Proveedor) on (n.id_proveedor);

//Crear los nodos tiempo
LOAD CSV WITH HEADERS FROM "file:///tiempo.csv" as row
CREATE (n:Tiempo)
SET n = row,
n.anio = toInteger(row.anio),
n.trimestre = toInteger(row.trimestre),
n.semestre = toInteger(row.semestre),
n.mes = toInteger(row.mes),
n.dia = toInteger(row.dia);

CREATE INDEX index_Tiempo FOR (n:Tiempo) on (n.id_tiempo);

//Crear los nodos vendedor
LOAD CSV WITH HEADERS FROM "file:///vendedor.csv" as row
CREATE (n:Vendedor)
SET n = row,
n.id_vendedor = toInteger(row.id_vendedor);

CREATE INDEX index_Vendedor FOR (n:Vendedor) on (n.id_vendedor);

//Crear los nodos venta
LOAD CSV WITH HEADERS FROM "file:///venta.csv" as row
CREATE (n:Venta)
SET n = row,
n.id_factura = toInteger(row.id_factura);

CREATE INDEX index_Venta FOR (n:Venta) on (n.id_factura);

//Crear los nodos venta_d
LOAD CSV WITH HEADERS FROM "file:///venta_d.csv" as row
CREATE (n:Venta_d)
SET n = row,
n.num_fact = toFloat(row.num_fact),
n.num_articulos = toInteger(row.num_articulos),
n.total = toFloat(row.total),
n.subtotal = toFloat(row.subtotal),
n.descuento = toFloat(row.descuento),
n.iva = toFloat(row.iva),
n.id_articulo = toInteger(row.id_articulo),
n.id_vendedor = toInteger(row.id_vendedor),
n.id_factura = toInteger(row.id_factura),
n.id_cliente = toInteger(row.id_cliente);

//Relacionar nodo de compras
MATCH(c: Compra)
MATCH(cd: Compra_d)
MATCH(co: Comprador)
MATCH(a: Articulo)
MATCH(p: Proveedor)
MATCH(t: Tiempo)
WHERE cd.id_compra = c.id_compra
and cd.id_comprador = co.id_comprador
and cd.id_articulo = a.id_articulo
and cd.id_proveedor = p.id_proveedor
and cd.id_tiempo = t.id_tiempo
MERGE (c)-[:DETALLE_COMPRA]->(cd)
MERGE (co)-[:COMPRADO_POR]->(cd)
MERGE (a)-[:ES_COMPRA]->(cd)
MERGE (p)-[:PROVEIDO_POR]->(cd)
MERGE (t)-[:EN_COMPRA]->(cd);

//relacionar nodo de ventas
MATCH(vd: Venta_d)
MATCH(v: Venta)
MATCH(ve: Vendedor)
MATCH(c: Cliente)
MATCH(a: Articulo)
MATCH(t: Tiempo)
WHERE vd.id_factura = v.id_factura
and vd.id_vendedor = ve.id_vendedor
and vd.id_cliente = c.id_cliente
and vd.id_articulo = a.id_articulo
and vd.id_tiempo = t.id_tiempo
MERGE (v)-[:DETALLE_VENTA]->(vd)
MERGE (ve)-[:VENDIDO_POR]->(vd)
MERGE (c)-[:CLIENTE]->(vd)
MERGE (a)-[:ES_VENTA]->(vd)
MERGE (t)-[:EN_VENTA]->(vd);