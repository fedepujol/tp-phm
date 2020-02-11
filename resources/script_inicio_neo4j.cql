CREATE (paragolpe:Producto{descripcion:'Paragolpe', costo: 1500.99})
CREATE (chasis:Producto{descripcion:'Chasis', costo: 2500.50})
CREATE (disco:Producto{descripcion:'Disco de Freno', costo:550.5})
CREATE (autoParte:ProductoCompuesto{descripcion:'Autoparte', costo:7500})
CREATE (stockParagolpe:Stock{minimo:50, maximo:100, actual:20})
CREATE (stockChasis:Stock{minimo:100, maximo:500, actual:200})
CREATE (stockDisco:Stock{minimo:50, maximo:100, actual:75})
CREATE (stockAutoparte:Stock{minimo:10, maximo:15, actual:11})
CREATE (tesla:Proveedor{nombre:'Tesla Motors'})
CREATE (ford:Proveedor{nombre:'Ford'})
CREATE (ferrari:Proveedor{nombre:'Ferrari'})
CREATE
    (paragolpe)-[:TIENE]->(stockParagolpe),
    (chasis)-[:TIENE]->(stockChasis),
    (disco)-[:TIENE]->(stockDisco),
    (autoParte)-[:TIENE]->(stockAutoparte),
    (autoParte)-[:COMPUESTO{cantidad:3}]->(paragolpe),
    (autoParte)-[:COMPUESTO{cantidad:12}]->(chasis),
    (autoParte)-[:COMPUESTO{cantidad:33}]->(disco),
    (tesla)-[:PROVEE]->(paragolpe),
    (tesla)-[:PROVEE]->(chasis),
    (ford)-[:PROVEE]->(disco),
    (ferrari)-[:PROVEE]->(autoParte),
    (tesla)-[:ORDEN_DE_COMPRA{fecha:'15/10/2016', cantidad:3}]->(paragolpe),
    (ferrari)-[:ORDEN_DE_COMPRA{fecha:'19/08/1990', cantidad:5}]->(chasis),
    (ferrari)-[:ORDEN_DE_COMPRA{fecha:'19/08/1990', cantidad:10}]->(disco),
    (ford)-[:ORDEN_DE_COMPRA{fecha:'03/11/2017', cantidad:7}]->(autoParte)