package persistencia

import abstractPersistencia.AbstractMongo
import abstractPersistencia.GenericProducto
import domain.Producto

class ProductoMongoDao extends AbstractMongo<Producto> implements GenericProducto {
	static ProductoMongoDao instance

	static def ProductoMongoDao getInstance() {
		if (instance.identityEquals(null)) {
			instance = new ProductoMongoDao
		}
		instance
	}

	private new() {
		this.descripcion = "Producto Mongo"
	}

	override searchByExample(Producto unProducto) {
		val query = ds.createQuery(entityType)
		if (unProducto.descripcion !== null) {
			query.field("descripcion").equal(unProducto.descripcion)
		}
		query.asList
	}

	override defineUpdateOperations(Producto unProducto) {
		ds.createUpdateOperations(entityType).set("descripcion", unProducto.descripcion).set("stock", unProducto.stock)
	}

	override getEntityType() {
		typeof(Producto)
	}

	override filtrarProducto(Producto example, Boolean stockMenorMinimo) {
		val query = ds.createQuery(entityType)

		if (stockMenorMinimo) {
			query.where("this.stock.actual <= this.stock.minimo")
		} else {
			query.where("this.stock.actual > this.stock.minimo")
		}
		if (example.descripcion !== null) {
			query.field("descripcion").containsIgnoreCase(example.descripcion)
		}

		if (example.stock.minimo !== null) {
			query.field("stock.actual").greaterThan(example.stockMinimo)
		}

		if (example.stock.maximo !== null) {
			query.field("stock.actual").lessThan(example.stockMaximo)
		}

		query.toList
	}

	override nombre() {
		this.descripcion
	}

	override getListaRepo() {
		this.allInstances
	}

	override createOrUpdate(Producto unProducto) {
		val listaProductos = searchByExample(unProducto) // session.loadAll(typeof(Producto), unProducto.descripcion.createFilterDescripcion)
		if (listaProductos.isEmpty) {
			this.createIfNotExists(unProducto)
		} else {
			this.update(unProducto)
		}
	}

	override searchById(Producto id) {
		val query = ds.createQuery(entityType)
		query.field("_id").equal(id)
		query.toList.head
	}

}
