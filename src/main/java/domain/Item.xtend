package domain

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.ManyToOne
import javax.persistence.Transient
import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.ogm.annotation.EndNode
import org.neo4j.ogm.annotation.Property
import org.neo4j.ogm.annotation.RelationshipEntity
import org.neo4j.ogm.annotation.StartNode
import org.uqbar.commons.model.annotations.Observable
import org.mongodb.morphia.annotations.Reference

@Entity
@RelationshipEntity(type="CONTIENE")
@Observable
@Accessors
@org.mongodb.morphia.annotations.Entity
class Item {

	@Id @GeneratedValue @Column(name="id_item")
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
	@EndNode
	Producto producto
	
	@StartNode
	@Transient
	@org.mongodb.morphia.annotations.Transient
	OrdenDeCompra orden
	
	@Column
	@Property(name="cantidad")
	Integer cantidad

	new() {
	}

	new(Producto unProducto, Integer unaCantidad, OrdenDeCompra unaOrden) {		
		producto = unProducto
		cantidad = unaCantidad
		orden = unaOrden
	}

	def costoProducto() {
		producto.dameCosto(cantidad)
	}

	def descripcionProducto() {
		producto.descripcion
	}

	def actualizar(Item unItem) {
		this.producto = unItem.producto
		this.cantidad = unItem.cantidad
	}
}
