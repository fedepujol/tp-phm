package persistencia

import abstractPersistencia.AbstractMongo
import abstractPersistencia.GenericOrden
import domain.OrdenDeCompra
import domain.Producto
import domain.Proveedor
import java.time.LocalDate

class OrdenMongoDao extends AbstractMongo<OrdenDeCompra> implements GenericOrden {
	static OrdenMongoDao instance

	static def OrdenMongoDao getInstance() {
		if (instance.identityEquals(null)) {
			instance = new OrdenMongoDao
		}
		instance
	}

	private new() {
		this.descripcion = "Orden Mongo"
	}

	override searchByExample(OrdenDeCompra unaOrden) {
		val query = ds.createQuery(entityType)
		if (unaOrden.idMongo !== null) {
			query.field("_id").equal(unaOrden.idMongo)
		}
		query.asList
	}

	override defineUpdateOperations(OrdenDeCompra unaOrden) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override getEntityType() {
		typeof(OrdenDeCompra)
	}

	override filtrarOrden(Producto producto, Proveedor proveedor, LocalDate fechaDesde, LocalDate fechaHasta,
		Double totalDesde, Double totalHasta) {
		val queryProducto = ds.createQuery(entityType)
		if (producto !== null) {
			queryProducto.field("productos.producto").equal(producto)
		}

		if (proveedor !== null) {
			queryProducto.field("proveedor").equal(proveedor)
		}

		if (totalDesde !== null) {
			queryProducto.field("total").greaterThanOrEq(totalDesde)
		}

		if (totalHasta !== null) {
			queryProducto.field("total").lessThanOrEq(totalHasta)
		}

		if (fechaDesde !== null) {
			queryProducto.field("fecha").greaterThanOrEq(fechaDesde)
		}

		if (fechaHasta !== null) {
			queryProducto.field("fecha").lessThanOrEq(fechaHasta)
		}

		queryProducto.asList

	}

	override nombre() {
		this.descripcion
	}

	override getListaRepo() {
		this.allInstances
	}

	override createOrUpdate(OrdenDeCompra unaOrden) {
		this.create(unaOrden)
	}

	override searchById(OrdenDeCompra id) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

}
