package domain

import java.util.List
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.ManyToMany
import org.bson.types.ObjectId
import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.ogm.annotation.NodeEntity
import org.neo4j.ogm.annotation.Property
import org.neo4j.ogm.annotation.Relationship
import org.neo4j.ogm.annotation.Transient
import org.uqbar.commons.model.annotations.Observable
import org.mongodb.morphia.annotations.Reference

@Entity
@Accessors
@Observable
@NodeEntity(label="Proveedor")
@org.mongodb.morphia.annotations.Entity
class Proveedor {
	
	@Id @GeneratedValue @Column(name="id_proveedor")
	@org.mongodb.morphia.annotations.Transient
	@Transient
	Long idHibernate

	@javax.persistence.Transient
	@org.neo4j.ogm.annotation.Id
	@org.neo4j.ogm.annotation.GeneratedValue
	@org.mongodb.morphia.annotations.Transient
	Long idNeo

	@javax.persistence.Transient
	@Transient
	@org.mongodb.morphia.annotations.Transient
	Long idMemoria

	@javax.persistence.Transient
	@Transient
	@org.mongodb.morphia.annotations.Id ObjectId idMongo

	@Column(length=150)	
	@Property(name="nombre")
	String nombre

	@ManyToMany(fetch=FetchType.LAZY)
	@Relationship(type="PROVEE", direction="OUTGOING")	
	List<Producto> productos = newArrayList

	new() {
	}

	new(String unNombre,List<Producto> prods) {
		nombre = unNombre
		productos = prods
	}

	def agregarProducto(Producto prod) {
		productos.add(prod)
	}

}
