package persistencia

import abstractPersistencia.AbstractMongo
import abstractPersistencia.GenericProveedor
import domain.Proveedor

class ProveedorMongoDao extends AbstractMongo<Proveedor> implements GenericProveedor {
	static ProveedorMongoDao instance

	static def ProveedorMongoDao getInstance() {
		if (instance.identityEquals(null)) {
			instance = new ProveedorMongoDao
		}
		instance
	}

	private new() {
		this.descripcion = "Proveedor Mongo"
	}

	override searchByExample(Proveedor unProveedor) {
		val query = ds.createQuery(entityType)
		if (unProveedor.nombre !== null) {
			query.field("nombre").equal(unProveedor.nombre)
		}
		query.asList
	}

	override defineUpdateOperations(Proveedor unProveedor) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override getEntityType() {
		typeof(Proveedor)
	}

	override nombre() {
		this.descripcion
	}

	override getListaRepo() {
		this.allInstances
	}

	override createOrUpdate(Proveedor unProveedor) {
		this.createIfNotExists(unProveedor)
	}

	override searchById(Proveedor proveedor) {
		val query = ds.createQuery(entityType)
		if (proveedor !== null) {
			query.field("_id").equal(proveedor.idMongo)
		}
		query.asList
		query.get(0)		
	}

}
