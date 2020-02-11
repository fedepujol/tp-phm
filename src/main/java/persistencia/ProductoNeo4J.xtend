package persistencia

import abstractPersistencia.AbstractNeo4J
import abstractPersistencia.GenericProducto
import domain.Producto
import domain.ProductoCompuesto
import domain.Stock
import java.util.List
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.ogm.cypher.ComparisonOperator
import org.neo4j.ogm.cypher.Filter
import org.neo4j.ogm.cypher.Filters

@Accessors
class ProductoNeo4J extends AbstractNeo4J<Producto> implements GenericProducto {
	List<Producto> productos = newArrayList
	static ProductoNeo4J instance

	def static ProductoNeo4J getInstance() {
		if (instance === null) {
			instance = new ProductoNeo4J
		}
		instance
	}

	private new() {
		productos = this.listaRepo
		this.descripcion = "Producto Neo4J"
	}

	override nombre() {
		this.descripcion
	}

	override createOrUpdate(Producto unProducto) {
		val listaProductos = cargarProducto(unProducto) // session.loadAll(typeof(Producto), unProducto.descripcion.createFilterDescripcion)
		if (listaProductos.isEmpty) {
			session.save(unProducto)
		} else {
			val productoNeo = listaProductos.head
			productoNeo.descripcion = unProducto.descripcion
			productoNeo.stock.actual = unProducto.stockActual
			productoNeo.stock.minimo = unProducto.stockMinimo
			productoNeo.stock.maximo = unProducto.stockMaximo
			session.save(productoNeo)
		}
	}

	def cargarProducto(Producto unProducto) {
		session.loadAll(typeof(Producto), unProducto.descripcion.createFilterDescripcion)
	}

	override getListaRepo() {
		session.loadAll(typeof(Producto), "".createFilterDescripcion).toList
	}

	override searchById(Producto unProducto) {
		session.load(typeof(Producto), unProducto.idNeo, PROFUNDIDAD_BUSQUEDA_CONCRETA)
	}

	override filtrarProducto(Producto example, Boolean stockMenorMinimo) {
		val Filters filters = new Filters()
		var String cypher
		var Iterable<Producto> result
		var Map<String, String> mapa = newHashMap

		if (example.descripcion === null && example.stock.minimo === null && example.stock.maximo === null &&
			stockMenorMinimo == false) {
			cypher = "MATCH (p:Producto)-[:TIENE]->(s:Stock) WHERE s.actual > s.minimo RETURN (p)-[:TIENE]->(s)"
		}

		if (stockMenorMinimo) {
			cypher = "MATCH (p:Producto)-[:TIENE]->(s:Stock) WHERE s.actual <= s.minimo RETURN (p)-[:TIENE]->(s)"
		}

		if (example.descripcion !== null) {
			filters.add(example.descripcion.createFilterDescripcion)
		}

		if (example.stock.minimo !== null) {
			val Filter filterStockMinimo = new Filter("actual", ComparisonOperator.GREATER_THAN, example.stockMinimo)
			filterStockMinimo.configureFiltroStock
			filters.and(filterStockMinimo)
		}

		if (example.stock.maximo !== null) {
			val Filter filterStockMaximo = new Filter("actual", ComparisonOperator.LESS_THAN, example.stockMaximo)
			filterStockMaximo.configureFiltroStock
			filters.and(filterStockMaximo)
		}

		if (cypher !== null) {
			result = session.query(typeof(Producto), cypher, mapa)
			result.toList
		} else {
			session.loadAll(typeof(Producto), filters).toList
		}
	}

	def Filter createFilterDescripcion(String unCriterio) {
		val Filter filtroDescripcion = new Filter("descripcion", ComparisonOperator.STARTING_WITH, unCriterio)
		filtroDescripcion
	}

	def void configureFiltroStock(Filter unFilter) {
		unFilter.nestedPropertyName = "Stock"
		unFilter.nestedEntityTypeLabel = "Stock"
		unFilter.nestedPropertyType = Stock
		unFilter.relationshipDirection = OUTGOING
	}
	
	override traerProductoCompuesto(ProductoCompuesto unProducto) {
		val String cypher = "
			MATCH (n:`ProductoCompuesto`) 
				WHERE n.`descripcion` STARTS WITH {prod_descripcion}
			RETURN n, [ [ (n)-[r_t1:`TIENE`]->(s1:`Stock`) | [ r_t1, s1 ] ],
						[ (n)<-[r_i1:`COMPUESTO`]-(i1:`ITEM_COMPUESTO`) | [ r_i1, i1 ] ],
						[ (p1:`Producto`)-[r_r1:`DECORA`]->(i1) | [ r_r1, p1 ] ] ], ID(n)"
		val Map<String, String> params = newHashMap
		params.put("prod_descripcion", unProducto.descripcion)
		val result = session.query(typeof(ProductoCompuesto), cypher, params)
		result.head
	}

}
