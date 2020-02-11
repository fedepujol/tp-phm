package domain

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.Transient
import org.bson.types.ObjectId
import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.ogm.annotation.NodeEntity
import org.neo4j.ogm.annotation.Property
import org.uqbar.commons.model.annotations.Observable
import org.uqbar.commons.model.exceptions.UserException

@Entity
@Accessors
@Observable
@NodeEntity(label="Stock")
@org.mongodb.morphia.annotations.Entity
class Stock {
	@Id @GeneratedValue @Column(name="id_stock")
	@org.neo4j.ogm.annotation.Transient
	@org.mongodb.morphia.annotations.Transient
	Long idHibernate

	@org.neo4j.ogm.annotation.Id
	@org.neo4j.ogm.annotation.GeneratedValue
	@Transient
	@org.mongodb.morphia.annotations.Transient
	Long idNeo

	@Transient
	@org.neo4j.ogm.annotation.Transient
	Long idMemoria

	@Transient
	@org.neo4j.ogm.annotation.Transient
	@org.mongodb.morphia.annotations.Id ObjectId idMongo

	@Column
	@Property(name="minimo")
	Integer minimo

	@Column
	@Property(name="maximo")
	Integer maximo

	@Column
	@Property(name="actual")
	Integer actual

	new() {
	}

	new(Integer unMinimo, Integer unMaximo, Integer unActual) {
		minimo = unMinimo
		maximo = unMaximo
		actual = unActual
	}

	def comprar(int unaCantidad) {
		cantidadMaximaValida(unaCantidad)
		actual + unaCantidad
	}

	def descontar(int unaCantidad) {
		cantidadMinimaValida(unaCantidad)
		actual = actual - unaCantidad
	}

	def cantidadMaximaValida(int unaCantidad) {
		if ((actual + unaCantidad) < maximo) {
			throw new UserException("La cantidad de compra del producto no puede exceder su stock maximo")
		}
	}

	def cantidadMinimaValida(int unaCantidad) {
		if ((actual - unaCantidad) < minimo) {
			throw new UserException(
				"La cantidad de venta no puede ser que el stock actual sea menor que el stock minimo")
		}
	}

	def validar() {
		minimo !== null || maximo !== null || actual !== null
	}
}
