package persistencia

import abstractPersistencia.AbstractNeo4J
import abstractPersistencia.GenericProveedor
import domain.Proveedor
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.ogm.cypher.ComparisonOperator
import org.neo4j.ogm.cypher.Filter

@Accessors
class ProveedorNeo4J extends AbstractNeo4J<Proveedor> implements GenericProveedor{
	List<Proveedor> proveedores = newArrayList
	static ProveedorNeo4J instance

	def static ProveedorNeo4J getInstance() {
		if (instance === null) {
			instance = new ProveedorNeo4J
		}
		instance
	}

	private new() {
		proveedores = this.getListaRepo
		this.descripcion = "Proveedor Neo4J"
	}

	override nombre() {
		this.descripcion
	}

	override getListaRepo() {
		session.loadAll(typeof(Proveedor), PROFUNDIDAD_BUSQUEDA_LISTA).toList
	}

	override createOrUpdate(Proveedor unProveedor) {
		val listaProveedores = session.loadAll(typeof(Proveedor),
			new Filter("nombre", ComparisonOperator.STARTING_WITH, unProveedor.nombre), PROFUNDIDAD_BUSQUEDA_LISTA)
		if (listaProveedores.isEmpty) {
			session.save(unProveedor)

		}
	}

	override searchById(Proveedor unProveedor) {
		session.load(typeof(Proveedor), unProveedor.idNeo, PROFUNDIDAD_BUSQUEDA_CONCRETA)
	}

}
