package persistencia

import abstractPersistencia.AbstractHibernate
import abstractPersistencia.GenericProducto
import domain.Producto
import domain.ProductoCompuesto
import java.util.List
import javax.persistence.criteria.CriteriaBuilder
import javax.persistence.criteria.CriteriaQuery
import javax.persistence.criteria.JoinType
import javax.persistence.criteria.Predicate
import javax.persistence.criteria.Root
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class ProductoHibernate extends AbstractHibernate<Producto> implements GenericProducto {
	static ProductoHibernate instance

	static def getInstance() {
		if (instance === null) {
			instance = new ProductoHibernate()
		}
		return instance
	}

	private new() {
		this.descripcion = "Producto Hibernate"
	}

	override nombre() {
		this.descripcion
	}

	override getListaRepo() {
		this.allInstances
	}

	override createOrUpdate(Producto unProducto) {
		val listaProductos = this.searchByExample(unProducto)
		if (listaProductos.isEmpty) {
			this.create(unProducto)
			println("Producto " + unProducto.descripcion + " creado")
		} else {
			val productoBD = listaProductos.head
			unProducto.idHibernate = productoBD.idHibernate
			this.update(unProducto)
		}
	}

	override getEntityType() {
		typeof(Producto)
	}

	override generateWhere(CriteriaBuilder criteria, CriteriaQuery<Producto> query, Root<Producto> camposProducto,
		Producto producto) {
		if (producto.descripcion !== null) {
			query.where(criteria.equal(camposProducto.get("descripcion"), producto.descripcion))
		}
	}

	override filtrarProducto(Producto example, Boolean stockMenorMinimo) {
		val entityManager = this.entityManager
		try {
			val criteria = entityManager.criteriaBuilder
			val query = criteria.createQuery(typeof(Producto))
			val Root<Producto> from = query.from(Producto)
			var List<Predicate> lista = newArrayList
			val joinStock = from.join("stock", JoinType.LEFT)

			if (stockMenorMinimo) {
				lista.add(criteria.le(joinStock.get("actual"), joinStock.get("minimo")))
			} else {
				lista.add(criteria.gt(joinStock.get("actual"), joinStock.get("minimo")))

				if (example.descripcion !== null) {
					lista.add(criteria.like(from.get("descripcion"), example.descripcion + "%"))
				}

				if (example.stockMinimo !== null) {
					lista.add(criteria.greaterThan(joinStock.get("actual"), example.stockMinimo))
				}

				if (example.stockMaximo !== null) {
					lista.add(criteria.lessThan(joinStock.get("actual"), example.stockMaximo))
				}
			}
			query.select(from).where(lista)

			val result = entityManager.createQuery(query).resultList
			result as List<Producto>
		} finally {
			entityManager.close
		}
	}

	override Producto searchById(Producto unProducto) {
		val entityManager = this.entityManager
		try {
			val criteria = entityManager.criteriaBuilder
			val query = criteria.createQuery(typeof(ProductoCompuesto))
			val Root<ProductoCompuesto> from = query.from(ProductoCompuesto)

			from.fetch("items", JoinType.LEFT)
			query.select(from).where(criteria.equal(from.get("id_producto"), unProducto.idHibernate))
			entityManager.createQuery(query).singleResult
		} finally {
			entityManager.close
		}
	}
	
}
