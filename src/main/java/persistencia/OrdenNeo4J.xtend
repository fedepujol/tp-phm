package persistencia

import abstractPersistencia.AbstractNeo4J
import abstractPersistencia.GenericOrden
import domain.OrdenDeCompra
import domain.Producto
import domain.Proveedor
import java.time.LocalDate
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.ogm.cypher.ComparisonOperator
import org.neo4j.ogm.cypher.Filter
import org.neo4j.ogm.cypher.Filters

@Accessors
class OrdenNeo4J extends AbstractNeo4J<OrdenDeCompra> implements GenericOrden {
	List<OrdenDeCompra> ordenes = newArrayList
	static OrdenNeo4J instance

	def static OrdenNeo4J getInstance() {
		if (instance === null) {
			instance = new OrdenNeo4J
		}
		instance
	}

	private new() {
		ordenes = this.getListaRepo
		this.descripcion = "Orden Neo4J"
	}

	override nombre() {
		this.descripcion
	}

	override getListaRepo() {
		val Filter filterProveedor = new Filter("nombre", ComparisonOperator.STARTING_WITH, "")
		filterProveedor.nestedPropertyName = "Proveedor"
		filterProveedor.nestedEntityTypeLabel = "Proveedor"
		filterProveedor.nestedPropertyType = Proveedor
		filterProveedor.relationshipDirection = INCOMING
		session.loadAll(typeof(OrdenDeCompra), filterProveedor).toList
	}

	override createOrUpdate(OrdenDeCompra unaOrden) {
		val listaOrdenes = session.loadAll(typeof(OrdenDeCompra),
			new Filter("fecha", ComparisonOperator.EQUALS, unaOrden.fecha), PROFUNDIDAD_BUSQUEDA_LISTA)
		if (listaOrdenes.isEmpty) {
			session.save(unaOrden)
		}
	}

	override searchById(OrdenDeCompra unaOrden) {
		session.load(typeof(OrdenDeCompra), unaOrden.idNeo, PROFUNDIDAD_BUSQUEDA_LISTA)
	}

	override filtrarOrden(Producto producto, Proveedor proveedor, LocalDate fechaDesde, LocalDate fechaHasta,
		Double totalDesde, Double totalHasta) {

		val Filters filters = new Filters()

		if (fechaDesde !== null) {
			val Filter filtroFechaDesde = new Filter("fecha", ComparisonOperator.GREATER_THAN, fechaDesde)
			filters.add(filtroFechaDesde)
		}

		if (fechaHasta !== null) {
			val Filter filterFechaHasta = new Filter("fecha", ComparisonOperator.LESS_THAN, fechaHasta)
			filters.and(filterFechaHasta)
		}

		if (proveedor !== null) {
			val Filter filterProveedor = new Filter("nombre", ComparisonOperator.EQUALS, proveedor.nombre)
			filterProveedor.nestedPropertyName = "Proveedor"
			filterProveedor.nestedEntityTypeLabel = "Proveedor"
			filterProveedor.nestedPropertyType = Proveedor
			filterProveedor.relationshipDirection = INCOMING // Relationship.INCOMING
			filters.and(filterProveedor)
		}
		
		if (producto !== null) {
			val Filter filterProducto = new Filter("descripcion", ComparisonOperator.EQUALS, producto.descripcion)
			filterProducto.nestedEntityTypeLabel = "Producto"
			filterProducto.nestedPropertyName = "productos"
			filterProducto.nestedPropertyType = Producto
			filterProducto.relationshipDirection = OUTGOING // Relationship.INCOMING
			filters.and(filterProducto)
		}

		if (totalDesde !== null) {
			val Filter filterTotalDesde = new Filter("total", ComparisonOperator.GREATER_THAN, totalDesde)
			filters.and(filterTotalDesde)
		}

		if (totalHasta !== null) {
			val Filter filterTotalHasta = new Filter("total", ComparisonOperator.LESS_THAN, totalHasta)
			filters.and(filterTotalHasta)
		}
		session.loadAll(typeof(OrdenDeCompra), filters).toList
	}

}
