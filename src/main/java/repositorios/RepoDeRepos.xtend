package repositorios

import domain.TipoPersistencia
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.applicationContext.ApplicationContext
import persistencia.OrdenMemoria
import persistencia.ProductoMemoria
import persistencia.ProveedorMemoria
import runnable.AutopartistaBootstrap

@Accessors
class RepoDeRepos {
	RepoProducto repoProductos
	RepoOrdenDeCompra repoOrdenes
	RepoProveedor repoProveedores
	List<AbstractRepo<?>> repos = newArrayList
	static RepoDeRepos instance

	static def RepoDeRepos getInstance() {
		if (instance.identityEquals(null)) {
			instance = new RepoDeRepos
		}
		instance
	}

	private new() {
		repoProductos = RepoProducto.instance
		repoOrdenes = RepoOrdenDeCompra.instance
		repoProveedores = RepoProveedor.instance
		this.initialize
	}

	def void initialize() {
		repos => [
			add(RepoProducto.instance)
			add(RepoOrdenDeCompra.instance)
			add(RepoProveedor.instance)
		]

	}

	def void configureRepos(TipoPersistencia tipo) {
		repoProductos.agregarPersistencia(tipo.repoProducto)
		repoOrdenes.agregarPersistencia(tipo.repoOrden)
		repoProveedores.agregarPersistencia(tipo.repoProveedor)
	}

	def void configureAppDefault() {
		repoProductos.agregarPersistencia(ProductoMemoria.instance)
		repoOrdenes.agregarPersistencia(OrdenMemoria.instance)
		repoProveedores.agregarPersistencia(ProveedorMemoria.instance)
		this.configureTipo
		this.configureApp
	}

	def void configureTipo() {
		repos.forEach[r|r.initTipo]
	}

	def void configureApp() {
		ApplicationContext.instance.configureSingleton(typeof(RepoProducto), repoProductos)
		ApplicationContext.instance.configureSingleton(typeof(RepoOrdenDeCompra), repoOrdenes)
		ApplicationContext.instance.configureSingleton(typeof(RepoProveedor), repoProveedores)
		val AutopartistaBootstrap bootstrap = new AutopartistaBootstrap
		bootstrap.run
	}
}
