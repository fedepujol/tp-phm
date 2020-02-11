package domain

import java.util.ArrayList
import java.util.Collection
import javax.persistence.CascadeType
import javax.persistence.Column
import javax.persistence.DiscriminatorColumn
import javax.persistence.DiscriminatorType
import javax.persistence.DiscriminatorValue
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.ForeignKey
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.Inheritance
import javax.persistence.InheritanceType
import javax.persistence.JoinColumn
import javax.persistence.OneToMany
import javax.persistence.OneToOne
import javax.persistence.Transient
import org.bson.types.ObjectId
import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.ogm.annotation.NodeEntity
import org.neo4j.ogm.annotation.Property
import org.neo4j.ogm.annotation.Relationship
import org.uqbar.commons.model.annotations.Observable


@Entity
@Inheritance(strategy=InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name="tipoProducto", discriminatorType=DiscriminatorType.INTEGER)
@DiscriminatorValue("0")
@NodeEntity(label="Producto")
@org.mongodb.morphia.annotations.Entity('Producto')
@Observable
@Accessors
class Producto {
	@Id @GeneratedValue @Column(name="id_producto")
	@org.neo4j.ogm.annotation.Transient
	@org.mongodb.morphia.annotations.Transient
	Long idHibernate

	@Transient
	@org.neo4j.ogm.annotation.Id
	@org.neo4j.ogm.annotation.GeneratedValue
	@org.mongodb.morphia.annotations.Transient
	Long idNeo

	@Transient
	@org.neo4j.ogm.annotation.Transient
	@org.mongodb.morphia.annotations.Transient
	Long idMemoria

	@Transient
	@org.neo4j.ogm.annotation.Transient
	@org.mongodb.morphia.annotations.Id ObjectId idMongo

	@Transient
	@org.neo4j.ogm.annotation.Transient
	@org.mongodb.morphia.annotations.Transient
	Integer cantidadAVender

	@Column
	@Property(name="descripcion")
	String descripcion

	@OneToOne(fetch=FetchType.EAGER, cascade=CascadeType.ALL)
	@Relationship(type="TIENE", direction="OUTGOING")
	Stock stock

	@Column
	@Property(name="costo")
	Double costo

	new() {
	}

	new(String unaDescripcion, Stock unStock, Double unCosto) {
		descripcion = unaDescripcion
		stock = unStock
		costo = unCosto
	}

	def double dameCosto(Integer unaCantidad) {
		costo * unaCantidad
	}

	def stockActual() {
		stock.actual
	}

	def stockMinimo() {
		stock.minimo
	}

	def stockMaximo() {
		stock.maximo
	}

	def validarStock() {	
		stock.validar
	}

	def vender() {
		stock.descontar(cantidadAVender)
	}

}

@Entity
@NodeEntity(label="ProductoCompuesto")
@Observable
@Accessors
@DiscriminatorValue("1")
@org.mongodb.morphia.annotations.Entity('Producto')
class ProductoCompuesto extends Producto {

	@JoinColumn(foreignKey=@ForeignKey(name="id_itemCompuesto"))
	@OneToMany(fetch=FetchType.EAGER, cascade=CascadeType.ALL)
	@Relationship(type="COMPUESTO", direction="INCOMING")
	Collection<ItemDeCompuesto> items = new ArrayList<ItemDeCompuesto>

	new() {
	}

	new(String unaDescripcion, Stock unStock, Double unCosto, Collection<ItemDeCompuesto> unosItems) {
		super(unaDescripcion, unStock, unCosto)
		items = unosItems
	}

	override dameCosto(Integer unaCantidad) {
		items.fold(0.0, [acum, item|acum + item.costoProducto]) * unaCantidad
	}

}
