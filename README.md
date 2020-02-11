# Trabajo Practico de Persistencia

## Objetivo:
Desarrollar una aplicacion con persistencia poliglota con las tecnologias MongoDB, MySQL y Hibenate, Neo4J y Memoria (CollectionBasedRepo de Arena).  

### Grupo:
- Arancibia, Leonel
- Pujol, Federico Daniel
- Ruax, Juan Pablo

### Enunciado:
Desarrollar una aplicación que trabaja en el depósito de mercaderías de una distribuidora autopartista, se necesita modelar el stock de nuestros productos. 
1. Cada producto tiene:
    - Una descripción
    - Stock mínimo, sobre el cual deberíamos comprar.
    - Stock máximo, que no deberíamos sobrepasar.
    - Stock actual, es decir, la cantidad de existencia del producto.
    - Un costo, valuado en pesos.
2. Existen productos simples y productos compuestos de otros productos (simples o compuestos):
    - El costo de un producto compuesto es la sumatoria de costos de los productos simples.
    - El stock de los productos compuestos y los simples es independiente, ya que un producto compuesto requiere un proceso de fabricación que suele consistir en ensamblar las partes

3. Una orden de compra relaciona:
    - Una fecha de compra.
    - Un proveedor.
    - Un conjunto de renglones, que consiste en una cantidad y un producto.

[Enunciado completo (Primera Parte)](https://docs.google.com/document/d/1wvYK3qr9QBfxUWm_KMwjXeXo7IJabMNgpyDE1XvWKI4/edit)

### Diagrama de Clases (Dominio):
![dominio](https://github.com/phm-unsam/tp-2018-rap/blob/master/resources/diagrama.png)

### Modelo Entidad Relacion:
![der](https://github.com/phm-unsam/tp-2018-rap/blob/master/resources/der.png)

[Enunciado Segunda Parte](https://docs.google.com/document/d/1mlfia91BOTgXp6hNTaQJgy33wwIirMd-6zSSJEY4KXE/edit)

### Modelo Neo4J:

![neo4j](https://github.com/phm-unsam/tp-2018-rap/blob/master/resources/modeloNeo4j.png)

#### Nodos
- __Producto/ProductoCompuesto:__
    Contiene las propiedades Id, Descripcion y Costo.
- __Orden de Compra:__
    Contiene las propiedades Id y Fecha.
- __Proveedor:__
    Contiene las propiedades Id y Nombre.
- __Stock:__
    Contiene las propiedades Id, Actual, Minimo y Maximo.
#### Relaciones
- _TIENE:_
    Conecta los Producto/ProductoCompuesto con su Stock.
- _ITEM_COMPUESTO:_
    Conecta los ProductosCompuestos con sus productos simples. Tiene la propiedad cantidad.
- _PROVEE:_
    Conecta los Proveedores con sus Productos.
- _CONTIENE:_
    Conecta las Ordenes de Compra con los productos (Renglones) que posee. Tiene la propiedad cantidad.
- _PERTENCE_A:_
    Conecta los Proveedores con las Ordenes de Compra.
   
[Enunciado Tercera Parte](https://docs.google.com/document/d/13eMD374oPeQgkyYCKsa6Ad-Qx_SXmh1miE8Cv19R8Ig/edit)

### TO-DO:
- [ ] Persistencia MongoDB
