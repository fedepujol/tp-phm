package domain

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.ManyToOne
import javax.persistence.Transient
import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.ogm.annotation.NodeEntity
import org.neo4j.ogm.annotation.Property
import org.neo4j.ogm.annotation.Relationship
import org.uqbar.commons.model.annotations.Observable
import org.mongodb.morphia.annotations.Reference

@Entity
@NodeEntity(label="ItemCompuesto")
@Observable
@Accessors
@org.mongodb.morphia.annotations.Entity
class ItemDeCompuesto {

	@Id @GeneratedValue @Column(name="id_itemCompuesto")
	@org.neo4j.ogm.annotation.Transient
	Long idHibernate

	@org.neo4j.ogm.annotation.Id
	@org.neo4j.ogm.annotation.GeneratedValue
	@Transient
	Long idNeo

	@Transient
	@org.neo4j.ogm.annotation.Transient
	Long idMemoria

	@ManyToOne(fetch=FetchType.EAGER)
	@Relationship(type="DECORA",direction ="INCOMING")
	Producto producto

	@Column
	@Property(name = "cantidad")
	Integer cantidad

	new() {
	}

	new(Producto unProducto, Integer unaCantidad) {
		producto = unProducto
		cantidad = unaCantidad
	}

	def getCostoProducto() {
		producto.dameCosto(cantidad)
	}

	def getDescripcionProducto() {
		producto.descripcion
	}

	def actualizar(ItemDeCompuesto unItem) {
		this.producto = unItem.producto
		this.cantidad = unItem.cantidad
	}
}
