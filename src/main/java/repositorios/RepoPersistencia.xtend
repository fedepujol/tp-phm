package repositorios

import abstractPersistencia.AbstractNeo4J
import domain.Documental
import domain.Grafos
import domain.Memoria
import domain.Relacional
import domain.TipoPersistencia
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors
import persistencia.OrdenHibernate
import persistencia.OrdenMemoria
import persistencia.OrdenMongoDao
import persistencia.OrdenNeo4J
import persistencia.ProductoHibernate
import persistencia.ProductoMemoria
import persistencia.ProductoMongoDao
import persistencia.ProductoNeo4J
import persistencia.ProveedorHibernate
import persistencia.ProveedorMemoria
import persistencia.ProveedorMongoDao
import persistencia.ProveedorNeo4J
import java.util.List
import org.neo4j.ogm.cypher.Filter
import org.neo4j.ogm.cypher.ComparisonOperator

@Accessors
class RepoPersistencia extends AbstractNeo4J<TipoPersistencia> {
	static RepoPersistencia instance
	Set<TipoPersistencia> persistenciasGuardadas = newHashSet
	Set<TipoPersistencia> persistencias = newHashSet
	RepoDeRepos repoDeRepos = RepoDeRepos.instance

	static def RepoPersistencia getInstance() {
		if (instance.identityEquals(null)) {
			instance = new RepoPersistencia
		}
		instance
	}

	private new() {
		this.initialize
		this.persistenciasNoVacias
	}

	override nombre() {
	}

	def void initialize() {
		persistenciasGuardadas = this.listaRepo.toSet
		persistencias.addAll(
			new Memoria("Memoria", #[ProductoMemoria.instance, OrdenMemoria.instance, ProveedorMemoria.instance]),
			new Relacional("Relacional",
				#[ProductoHibernate.instance, OrdenHibernate.instance, ProveedorHibernate.instance]),
			new Grafos("Grafos", #[ProductoNeo4J.instance, OrdenNeo4J.instance, ProveedorNeo4J.instance]),
			new Documental("Documental",
				#[ProductoMongoDao.instance, OrdenMongoDao.instance, ProveedorMongoDao.instance]))
	}

	def void persistenciasNoVacias() {
		val Set<TipoPersistencia> aux = newHashSet
		if (persistenciasGuardadas.size > 0) {
			persistenciasGuardadas.forEach[p|aux.add(persistencias.findFirst[l|l.nombre.contains(p.nombre)])]
			persistenciasGuardadas = aux
		}
	}

	def void configurarPersistencia(Set<TipoPersistencia> unaColeccion) {
		if (unaColeccion.isEmpty) {
			repoDeRepos.configureAppDefault
		} else {
			unaColeccion.forEach[p|repoDeRepos.configureRepos(p)]
			unaColeccion.forEach[p|this.createOrUpdate(p)]
			repoDeRepos.configureTipo
			repoDeRepos.configureApp
		}
	}

	override getListaRepo() {
		session.loadAll(typeof(TipoPersistencia), PROFUNDIDAD_BUSQUEDA_CONCRETA).toList
	}

	def delete(TipoPersistencia tipo) {
		val aux = tipo.searchById
		if (aux !== null) {
			session.delete(aux)
		}
	}

	def List<TipoPersistencia> createFilterNombre(TipoPersistencia unTipo) {
		val Filter filtro = new Filter("nombre", ComparisonOperator.STARTING_WITH, unTipo.nombre)
		val listaFiltro = session.loadAll(typeof(TipoPersistencia), filtro).toList
		listaFiltro
	}

	def Boolean existeEnRepo(TipoPersistencia unTipo) {
		unTipo.createFilterNombre.isEmpty
	}

	override createOrUpdate(TipoPersistencia tipo) {
		if (existeEnRepo(tipo)) {
			session.save(tipo)
		}
	}

	override searchById(TipoPersistencia tipo) {
		val result = tipo.createFilterNombre.head
		if (result !== null) {
			session.load(typeof(TipoPersistencia), result.idNeo, PROFUNDIDAD_BUSQUEDA_LISTA)
		}
	}

}
