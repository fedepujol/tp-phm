package abstractPersistencia

import com.mongodb.MongoClient
import domain.OrdenDeCompra
import domain.Producto
import domain.Proveedor
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.mongodb.morphia.Datastore
import org.mongodb.morphia.Morphia
import org.mongodb.morphia.query.UpdateOperations

@Accessors
abstract class AbstractMongo<T> implements Generic<T> {
	String descripcion
	static protected Datastore ds
	static Morphia morphia

	new() {
		if (ds === null) {
			val mongo = new MongoClient("localhost", 27017)
			morphia = new Morphia => [
				map(typeof(Proveedor))
				.map(typeof(Producto))
				.map(typeof(OrdenDeCompra))
				ds = createDatastore(mongo, "autopartes")
				ds.ensureIndexes
			]
			println("Conectado a MongoDB. Bases: " + ds.getDB.collectionNames)
		}
	}

	def T getByExample(T example) {
		val result = searchByExample(example)
		if (result.isEmpty) {
			return null
		} else {
			return result.get(0)
		}
	}

	def List<T> searchByExample(T t)

	def T createIfNotExists(T t) {
		val entidadAModificar = getByExample(t)
		if (entidadAModificar !== null) {
			return entidadAModificar
		}
		create(t)
	}

	def void update(T t) {
		ds.update(t, this.defineUpdateOperations(t))
	}

	abstract def UpdateOperations<T> defineUpdateOperations(T t)

	def T create(T t) {
		ds.save(t)
		t
	}

	def void delete(T t) {
		ds.delete(t)
	}

	def List<T> allInstances() {
		ds.createQuery(this.getEntityType()).asList
	}

	abstract def Class<T> getEntityType()
}
