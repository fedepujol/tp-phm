package persistencia

import abstractPersistencia.AbstractHibernate
import abstractPersistencia.GenericProveedor
import domain.Proveedor
import javax.persistence.criteria.CriteriaBuilder
import javax.persistence.criteria.CriteriaQuery
import javax.persistence.criteria.Root

class ProveedorHibernate extends AbstractHibernate<Proveedor> implements GenericProveedor {
	static ProveedorHibernate instance

	static def getInstance() {
		if (instance === null) {
			instance = new ProveedorHibernate()
		}
		return instance
	}

	private new() {
		this.descripcion = "Proveedor Hibernate"
	}

	override nombre() {
		this.descripcion
	}

	override getEntityType() {
		typeof(Proveedor)
	}

	override generateWhere(CriteriaBuilder criteria, CriteriaQuery<Proveedor> query, Root<Proveedor> camposProveedor,
		Proveedor proveedor) {
		if (proveedor.nombre !== null) {
			query.where(criteria.equal(camposProveedor.get("nombre"), proveedor.nombre))
		}
	}

	override Proveedor searchById(Proveedor unProveedor) {
		val entityManager = entityManager
		try {
			val criteria = entityManager.criteriaBuilder
			val query = criteria.createQuery
			val camposProveedor = query.from(entityType)
			camposProveedor.fetch("productos")
			query.select(camposProveedor)
			query.where(criteria.equal(camposProveedor.get("idHibernate"), unProveedor.idHibernate))
			val result = entityManager.createQuery(query).resultList

			if (result.isEmpty) {
				null
			} else {
				result.head as Proveedor
			}
		} finally {
			entityManager.close
		}
	}

	override getListaRepo() {
		this.allInstances
	}

	override createOrUpdate(Proveedor unProveedor) {
		val listaProveedores = this.searchByExample(unProveedor)
		if (listaProveedores.isEmpty) {
			this.create(unProveedor)
			println("Proveedor " + unProveedor.nombre + " creado")
		} else {
			val proveedorBD = listaProveedores.head
			unProveedor.idHibernate = proveedorBD.idHibernate
			this.update(unProveedor)
		}
	}

}
