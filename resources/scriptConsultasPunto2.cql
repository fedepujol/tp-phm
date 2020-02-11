
///////////////PUNTO 2///////////////////////

// 1) Saber qué órdenes de compra pidieron 2 tornopletes(Paragolpes).
match (o:OrdenDeCompra)-[r:CONTIENE]->(p:Producto ) 
	where r.cantidad > 2 AND p.descripcion = "Paragolpes"
RETURN o,p

// 2) Saber qué productos están por debajo del stock mínimo.
match (p:Producto)-[:TIENE]->(s:Stock)
where s.actual<s.minimo
return p,s

// 3): Saber cuáles fueron órdenes de compra de una semana determinada.
match (o:OrdenDeCompra)
where o.fecha > "19801201" 
and "19941201" > o.fecha
return o

// 4) Saber qué productos comienzan con la letra P
match (p:Producto) 
where p.descripcion STARTS WITH "P"
return p