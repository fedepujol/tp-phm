package domain

import abstractPersistencia.Generic
import abstractPersistencia.GenericOrden
import abstractPersistencia.GenericProducto
import abstractPersistencia.GenericProveedor
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.ogm.annotation.GeneratedValue
import org.neo4j.ogm.annotation.Id
import org.neo4j.ogm.annotation.NodeEntity
import org.neo4j.ogm.annotation.Property
import org.neo4j.ogm.annotation.Transient
import org.uqbar.commons.model.annotations.Observable

@Accessors
@Observable
@NodeEntity(label="TipoPersistencia")
abstract class TipoPersistencia {

	@Id @GeneratedValue
	Long idNeo

	@Property(name="nombre")
	String nombre

	@Transient
	List<Generic<?>> listaDeRepos = newArrayList

	new(String unNombre, List<Generic<?>> unaColeccion) {
		nombre = unNombre
		listaDeRepos = unaColeccion
	}
	
	new(){
		
	}
	
	def GenericProducto repoProducto(){
		listaDeRepos.findFirst[r|r.nombre.contains("Producto")] as GenericProducto	
	}
	
	def GenericOrden repoOrden(){
		listaDeRepos.findFirst[r|r.nombre.contains("Orden")] as GenericOrden
	}
	
	def GenericProveedor repoProveedor(){
		listaDeRepos.findFirst[r|r.nombre.contains("Proveedor")] as GenericProveedor
	}
}

@Accessors
@NodeEntity(label="Memoria")
class Memoria extends TipoPersistencia {

	new() {
	}

	new(String unNombre, List<Generic<?>> unaColeccion) {
		super(unNombre, unaColeccion)
	}

}

@NodeEntity(label="Relacional")
class Relacional extends TipoPersistencia {

	new() {
	}

	new(String unNombre, List<Generic<?>> unaColeccion) {
		super(unNombre, unaColeccion)
	}
	
}

@NodeEntity(label="Grafos")
class Grafos extends TipoPersistencia {

	new() {
	}
	
	new(String unNombre, List<Generic<?>> unaColeccion) {
		super(unNombre, unaColeccion)
	}
}

@NodeEntity(label="Documental")
class Documental extends TipoPersistencia {

	new() {
	}
	
	new(String unNombre, List<Generic<?>> unaColeccion) {
		super(unNombre, unaColeccion)
	}
}

