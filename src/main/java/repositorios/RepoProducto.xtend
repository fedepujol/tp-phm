package repositorios

import abstractPersistencia.GenericProducto
import domain.Producto
import domain.ProductoCompuesto
import java.util.List
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class RepoProducto extends AbstractRepo<Producto> {
	GenericProducto tipo
	static RepoProducto instance
	Set<GenericProducto> persistencia = newHashSet

	static def getInstance() {
		if (instance === null) {
			instance = new RepoProducto()
		}
		return instance
	}

	private new() {
	}

	override createOrUpdate(Producto unProducto) {
		persistencia.forEach[repo|repo.createOrUpdate(unProducto)]
	}

	def List<Producto> filtrar(Producto example, Boolean stockMenorMinimo) {
		tipo.filtrarProducto(example, stockMenorMinimo)
	}

	def Producto searchById(Producto unProducto) {
		tipo.searchById(unProducto)
	}

	def getProductos() {
		tipo.listaRepo
	}

	def ProductoCompuesto traerProductoCompuesto(ProductoCompuesto unProducto) {
		tipo.traerProductoCompuesto(unProducto)
	}

	def agregarPersistencia(GenericProducto unaPersistencia) {
		persistencia.add(unaPersistencia)
	}

	override initTipo() {
		tipo = persistencia.head
	}

}
