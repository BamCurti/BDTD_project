//para revisar los más comprados por año
    match (ar:Articulo)-[:ES_COMPRA]->(v:Compra_d)<-[:EN_COMPRA]-(:Tiempo{anio:2013})
    return ar.id_articulo, count(ar.descripcion)
    order by count(ar.descripcion) desc
    limit 1

//3. Generar  una  consulta  que  reciba  un  artículo  X  y  prediga  cinco  artículos  más  que  podrían  ser 
//comprados con él. Probar la consulta con los 3 artículos más comprados de 2019, 2017 y 2015. 

    //{ //id por año
    //    2019:4194,
    //    2017:4533,
    //    2015:4524
    //}

    //Query para predicción
    match
    (ar:Articulo{id_articulo:4194})-[:ES_COMPRA]->(:Compra_d)<-[:DETALLE_COMPRA]-(:Compra)-[:DETALLE_COMPRA]->(:Compra_d)<-[:ES_COMPRA]-(n:Articulo)
    return n.id_articulo, n.descripcion, count(n.id_articulo)
    order by count(n.id_articulo) desc
    limit 5


//4. Generar una consulta que reciba un tipo de artículo X y prediga dos tipos de artículos más que 
//podrían ser comprados con él. Probar la consulta con el tipo de artículos más comprados de 2016, 2018 y 2020.
//Pide 2020, no hay registros en ese año
    //{
    //    2016: 4194,
    //    2018: 4194,
    //    2020: null
    //}
    MATCH
    (a:Articulo{id_articulo:4194})-[:ES_COMPRA]->(:Compra_d)<-[:DETALLE_COMPRA]-(:Compra)-[:DETALLE_COMPRA]->(:Compra_d)<-[:ES_COMPRA]-(n:Articulo)
    where a.tipo <> n.tipo
    return n.tipo, count(n.tipo)
    order by count(n.tipo) desc
    limit 2

//5. Generar una consulta que reciba un grupo de artículo X y prediga dos grupos de artículos más 
//que  podrían  ser  comprados  con  él.  Probar  la  consulta  con  el  tipo  de  artículos  más  comprados  de 2012, 2016 y 2020. 
//Pide 2020, no hay registros en ese año
    //{
    //    2012: 4310
    //    2016: 4194
    //    2020: null
    //}
    MATCH
    (a:Articulo{id_articulo:4310})-[:ES_COMPRA]->(:Compra_d)<-[:DETALLE_COMPRA]-(:Compra)-[:DETALLE_COMPRA]->(:Compra_d)<-[:ES_COMPRA]-(n:Articulo)
    where a.grupo <> n.grupo
    return n.grupo, count(n.grupo)
    order by count(n.grupo) desc
    limit 2


//6. Generar una consulta que reciba un color X de artículo y prediga dos colores más con los que 
//podría ser vendido. 
    MATCH (ar:Articulo{colorBase:"BLANCO"})-[:ES_COMPRA]->(:Compra_d)<-[:DETALLE_COMPRA]-(:Compra)-[:DETALLE_COMPRA]->(:Compra_d)<-[:ES_COMPRA]-(n:Articulo)
    where ar.colorBase<>n.colorBase
    return n.colorBase, count(n.colorBase)
    order by count(n.colorBase) desc
    limit 2;
    MATCH (ar:Articulo{colorBase:"NEGRO"})-[:ES_COMPRA]->(:Compra_d)<-[:DETALLE_COMPRA]-(:Compra)-[:DETALLE_COMPRA]->(:Compra_d)<-[:ES_COMPRA]-(n:Articulo)
    where ar.colorBase<>n.colorBase AND NOT n.colorDerivado = "N/A"
    return n.colorBase,n.colorDerivado, count(n.colorDerivado)
    order by count(n.colorDerivado) desc
    limit 2;


//7. Generar  una  consulta  que  reciba  un  comprador  X  y  un  comprador  Y.  Analice  los  artículos  de  compra 
//similares y le sugiera artículos a comprar al comprador Y basado en las compras del comprador X. 
    //c1 id = "Carlos"
    //c2 id = "Marco"
    MATCH (x:Comprador {nombre: "Carlos"})-[:COMPRADO_POR]->(vx:Compra_d)<-[:ES_COMPRA]-(ar:Articulo)-[:ES_COMPRA]->(:Compra_d)<-[:COMPRADO_POR]-(y:Comprador {nombre:"Marco"})
    MATCH (vx)<-[:ES_COMPRA]-(n:Articulo)
    return n.descripcion, count(n.descripcion)
    order by count(n.descripcion) desc
    limit 3

//8. Dado un artículo X y un artículo Y encontrar el camino más corto de venta entre los dos. 
    //    x: 4580,
    //    y: 4677
    MATCH(x:Articulo{id_articulo:4580})
    MATCH(y:Articulo{id_articulo:4677}),
    p = SHORTESTPATH((x)-[*]-(y))
    return p

//9. Calcular el degree, in-degree y out-degree de cada comprador. Mostrar un grafo con el top 3. 
MATCH (u:Comprador)
RETURN u.nombre AS name,
size((u)-[:COMPRADO_POR]->()) AS inDegree,
size((u)<-[:COMPRADO_POR]-()) AS outDegree,
size((u)-[:COMPRADO_POR]-())  AS Degree
order by Degree desc
limit 3;

//10.  Calcular el degree, in-degree y out-degree de cada proveedor. Mostrar un grafo con el top 3. 
MATCH (u:Proveedor)
RETURN u.razonSocial AS name,
size((u)-[:PROVEIDO_POR]->()) AS inDegree,
size((u)<-[:PROVEIDO_POR]-()) AS outDegree,
size((u)-[:PROVEIDO_POR]-())  AS Degree
order by Degree desc
limit 3;

//11.  Calcular el degree, in-degree y out-degree de cada artículo. Mostrar un grafo con el top 3. 
MATCH (u:Articulo)
RETURN u.descripcion AS name,
size((u)-[:ES_COMPRA]->()) AS inDegree,
size((u)<-[:ES_COMPRA]-()) AS outDegree,
size((u)-[:ES_COMPRA]-())  AS Degree
order by Degree desc
limit 3;

//12.  Dado una factura de compra calcular la similaridad con otras. Probar con la compra 123. 
///// CONFIGURAMOS /////
:param limit => (5);
:param config => ({
  similarityCutoff: 0.1,
  degreeCutoff: 1,
  nodeProjection: '*',
  relationshipProjection: {
    relType: {
      type: '*',
      orientation: 'UNDIRECTED',
      properties: {}
    }
  }
});
:param communityNodeLimit => ( 10);
///// CALCULAMOS /////
CALL gds.nodeSimilarity.stream($config) YIELD node1, node2, similarity
WHERE gds.util.asNode(node1).id_compra = 123
RETURN gds.util.asNode(node1) AS from, gds.util.asNode(node2) AS to, similarity 
ORDER BY similarity DESC
LIMIT toInteger($limit)