//para revisar los más vendidos por año
    match (ar:Articulo)-[:ES_VENTA]->(v:Venta_d)<-[:EN_VENTA]-(:Tiempo{anio:2013})
    return ar.id_articulo, count(ar.descripcion)
    order by count(ar.descripcion) desc
    limit 1

//3. Generar  una  consulta  que  reciba  un  artículo  X  y  prediga  cinco  artículos  más  que  podrían  ser 
//vendidos con él. Probar la consulta con los 3 artículos más vendidos de 2012, 2015 y 2019. 

    //{ //id por año
    //    2012:4194,
    //    2015:4607,
    //    2019:4607
    //}

    //Query para predicción
    match
    (ar:Articulo{id_articulo:4607})-[:ES_VENTA]->(:Venta_d)<-[:DETALLE_VENTA]-(:Venta)-[:DETALLE_VENTA]->(:Venta_d)<-[:ES_VENTA]-(n:Articulo)
    return n.id_articulo, n.descripcion, count(n.id_articulo)
    order by count(n.id_articulo) desc
    limit 5


//4. Generar una consulta que reciba un tipo de artículo X y prediga dos tipos de artículos más que 
//podrían ser vendidos con él. Probar la consulta con el tipo de artículos más vendidos de 2013, 
//2015 y 2017. 

    //{
    //    2013: 4607,
    //    2015: 4607,
    //    2017: 4067
    //}
    MATCH
    (a:Articulo{id_articulo:4607})-[:ES_VENTA]->(:Venta_d)<-[:DETALLE_VENTA]-(:Venta)-[:DETALLE_VENTA]->(:Venta_d)<-[:ES_VENTA]-(n:Articulo)
    where a.tipo <> n.tipo
    return n.tipo, count(n.tipo)
    order by n.tipo desc

//5. Generar una consulta que reciba un grupo de artículo X y prediga dos grupos de artículos más 
//que  podrían  ser  vendidos  con  él.  Probar  la  consulta  con  el  tipo  de  artículos  más  vendidos  de 
//2016, 2017 y 2018. 
    //{
    //    2016: 4607
    //    2017: 4607
    //    2018: 4607
    //}
    MATCH
    (a:Articulo{id_articulo:4607})-[:ES_VENTA]->(:Venta_d)<-[:DETALLE_VENTA]-(:Venta)-[:DETALLE_VENTA]->(:Venta_d)<-[:ES_VENTA]-(n:Articulo)
    where a.grupo <> n.grupo
    return n.grupo, count(n.grupo)
    order by n.grupo


//6. Generar una consulta que reciba un color X de artículo y prediga dos colores más con los que 
//podría ser vendido. 
    MATCH (ar:Articulo{id_articulo:4607})-[:ES_VENTA]->(:Venta_d)<-[:DETALLE_VENTA]-(:Venta)-[:DETALLE_VENTA]->(:Venta_d)<-[:ES_VENTA]-(n:Articulo)
    where ar.colorBase<>n.colorBase
    return n.colorBase, count(n.colorBase)
    order by count(n.colorBase) desc

//7. Generar  una  consulta  que  reciba  un  cliente  X  y  un  cliente  Y.  Analice  los  artículos  de  compra 
//similares y le sugiera artículos a comprar al cliente Y basado en las compras del cliente X. 
    //c1 id = 4029
    //c2 id = 3999
    MATCH (x:Cliente {id_cliente: 4029})-[:CLIENTE]->(vx:Venta_d)<-[:ES_VENTA]-(ar:Articulo)-[:ES_VENTA]->(:Venta_d)<-[:CLIENTE]-(y:Cliente {id_cliente:3999})
    MATCH (vx)<-[:ES_VENTA]-(n:Articulo)
    return n.descripcion, count(n.descripcion)
    order by count(n.descripcion) desc
    limit 3

//8. Dado un artículo X y un artículo Y encontrar el camino más corto de venta entre los dos. 
    //    x: 4728,
    //    y: 4484
    MATCH(x:Articulo{id_articulo:4728})
    MATCH(y:Articulo{id_articulo:4484}),
    p = SHORTESTPATH((x)-[*]-(y))
    return p


//9. Calcular el degree, in-degree y out-degree de cada cliente. Mostrar un grafo con el top 3. 

//10.  Calcular el degree, in-degree y out-degree de cada vendedor. Mostrar un grafo con el top 3. 

//11.  Calcular el degree, in-degree y out-degree de cada artículo. Mostrar un grafo con el top 3. 

//12.  Dado una factura calcular la similaridad con otras. Probar con la factura 768. 
