package domain

import java.time.LocalDate
import java.util.List
import javax.persistence.CascadeType
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.ForeignKey
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import javax.persistence.OneToMany
import org.bson.types.ObjectId
import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.ogm.annotation.NodeEntity
import org.neo4j.ogm.annotation.Property
import org.neo4j.ogm.annotation.Relationship
import org.neo4j.ogm.annotation.Transient
import org.uqbar.commons.model.annotations.Observable

@Entity
@NodeEntity(label="OrdenDeCompra")
@Accessors
@Observable
@org.mongodb.morphia.annotations.Entity
class OrdenDeCompra {

	@Id @GeneratedValue @Column(name="id_orden")
	@Transient
	@org.mongodb.morphia.annotations.Transient
	Long idHibernate

	@javax.persistence.Transient
	@org.mongodb.morphia.annotations.Transient
	@org.neo4j.ogm.annotation.Id
	@org.neo4j.ogm.annotation.GeneratedValue
	Long idNeo

	@Transient
	@javax.persistence.Transient
	@org.mongodb.morphia.annotations.Transient
	Long idMemoria

	@Transient
	@javax.persistence.Transient
	@org.mongodb.morphia.annotations.Id ObjectId idMongo

	@Column
	@Property(name="fecha")
	LocalDate fecha

	@ManyToOne(fetch=FetchType.EAGER)
	@Relationship(type="PERTENECE_A", direction="INCOMING")
	Proveedor proveedor

	@JoinColumn(foreignKey=@ForeignKey(name="id_item"))
	@OneToMany(fetch=FetchType.EAGER, cascade=CascadeType.ALL)
	@Relationship(type="CONTIENE", direction="OUTGOING")
	List<Item> productos = newArrayList

	@Column
	@Property(name="total")
	Double total

	new() {
	}

	new(LocalDate _fecha, Proveedor _proveedor, List<Item> _productos) {
		fecha = _fecha
		proveedor = _proveedor
		productos = _productos
		total = this.calcularTotal
	}

	def Double calcularTotal() {
		(Math.floor(productos.fold(0.0, [acum, item|acum + item.costoProducto]) * 100) / 100)
	}

	def getItems() {
		val StringBuilder str = new StringBuilder
		productos.forEach [ prod |
			str.append(prod.cantidad + " ")
			str.append(prod.producto.descripcion + " ")
		]
		str
	}
}
