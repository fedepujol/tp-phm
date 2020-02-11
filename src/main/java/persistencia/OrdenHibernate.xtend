package persistencia

import abstractPersistencia.AbstractHibernate
import abstractPersistencia.GenericOrden
import domain.OrdenDeCompra
import domain.Producto
import domain.Proveedor
import java.time.LocalDate
import java.util.List
import javax.persistence.criteria.CriteriaBuilder
import javax.persistence.criteria.CriteriaQuery
import javax.persistence.criteria.JoinType
import javax.persistence.criteria.Predicate
import javax.persistence.criteria.Root
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class OrdenHibernate extends AbstractHibernate<OrdenDeCompra> implements GenericOrden {
	static OrdenHibernate instance

	static def getInstance() {
		if (instance === null) {
			instance = new OrdenHibernate()
		}
		return instance
	}

	private new() {
		this.descripcion = "Orden Hibernate"
	}

	override nombre() {
		this.descripcion
	}

	override getEntityType() {
		typeof(OrdenDeCompra)
	}

	override generateWhere(CriteriaBuilder criteria, CriteriaQuery<OrdenDeCompra> query,
		Root<OrdenDeCompra> camposOrden, OrdenDeCompra orden) {
		if (orden.fecha !== null) {
			query.where(criteria.equal(camposOrden.get("fecha"), orden.fecha))
		}
	}

	override List<OrdenDeCompra> filtrarOrden(Producto producto, Proveedor proveedor, LocalDate fechaDesde,
		LocalDate fechaHasta, Double totalDesde, Double totalHasta) {
		val entityManager = this.entityManager
		try {
			val criteria = entityManager.criteriaBuilder
			val query = criteria.createQuery(typeof(OrdenDeCompra))
			val Root<OrdenDeCompra> from = query.from(OrdenDeCompra)
			var List<Predicate> lista = newArrayList
			val joinProducto = from.joinList("productos", JoinType.LEFT)
			if (producto !== null) {
				lista.add(criteria.equal(joinProducto.get("producto"), producto))
			}

			if (proveedor !== null) {
				lista.add(criteria.equal(from.get("proveedor"), proveedor))
			}

			if (fechaDesde !== null) {
				lista.add(criteria.greaterThan(from.get("fecha"), fechaDesde))
			}

			if (fechaHasta !== null) {
				lista.add(criteria.lessThan(from.get("fecha"), fechaHasta))
			}

			if (totalDesde !== null) {
				lista.add(criteria.greaterThan(from.get("total"), totalDesde))
			}
			if (totalHasta !== null) {
				lista.add(criteria.lessThan(from.get("total"), totalHasta))
			}

			query.select(from).where(lista)
			val result = entityManager.createQuery(query).resultList
			result as List<OrdenDeCompra>
		} finally {
			entityManager.close
		}
	}

	override getListaRepo() {
		this.allInstances
	}

	override createOrUpdate(OrdenDeCompra unaOrden) {
		val listaOrdenes = this.searchByExample(unaOrden)
		if (listaOrdenes.isEmpty) {
			this.create(unaOrden)
			println("Orden de Compra " + unaOrden.idHibernate + " creada")
		} else {
			val ordenBD = listaOrdenes.head
			unaOrden.idHibernate = ordenBD.idHibernate
			this.update(unaOrden)
		}
	}

	override searchById(OrdenDeCompra unaOrden) {
	}

}
