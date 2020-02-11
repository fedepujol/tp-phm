package persistencia

import abstractPersistencia.GenericProducto
import domain.Producto
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class ProductoMemoria implements GenericProducto {
	String descripcion
	Long id = new Long(1)
	List<Producto> productos = newArrayList
	static ProductoMemoria instance

	static def getInstance() {
		if (instance === null) {
			instance = new ProductoMemoria()
		}
		return instance
	}

	private new() {
		descripcion = "Producto Memoria"
	}

	override nombre() {
		this.descripcion
	}

	override getListaRepo() {
		this.productos
	}

	override createOrUpdate(Producto unProducto) {
		val Producto prodAux = this.searchById(unProducto)
		if (prodAux.identityEquals(null)) {
			unProducto.idMemoria = id
			productos.add(unProducto)
			id++
		} else {
			prodAux.descripcion = unProducto.descripcion
			prodAux.costo = unProducto.costo
			prodAux.stock = unProducto.stock
		}
	}

	override searchById(Producto unProducto) {
		productos.findFirst[p|p.idMemoria == unProducto.idMemoria]
	}

	override List<Producto> filtrarProducto(Producto example, Boolean stockMenorMinimo) {
		var List<Producto> aux = newArrayList
		aux = productos

		if (example.descripcion !== null) {
			aux = example.descripcion.search
		}

		if (stockMenorMinimo) {
			aux = this.stockMinimoProd(aux)
		} else {
			aux = this.stockMayorProd(aux)
		}

		aux = this.filtroPorStock(aux, example)
		aux
	}

	def filtroPorStock(List<Producto> unaColeccion, Producto example) {
		var List<Producto> aux = newArrayList

		aux = unaColeccion

		if (example.stockMinimo !== null && example.stockMaximo !== null) {
			aux = searchByStock(example.stockMinimo, example.stockMaximo, aux)
		} else if (example.stockMinimo !== null) {
			aux = searchByStockMin(example.stockMinimo, aux)
		} else if (example.stockMaximo !== null) {
			aux = searchByStockMax(example.stockMaximo, aux)
		}
		aux
	}

	def search(String unValor) {
		productos.filter(
			p |
				p.descripcion == unValor || p.descripcion.contains(unValor)
		).filterNull.toList
	}

	def searchByStockMin(Integer unStockMinimo, List<Producto> unaColeccion) {
		unaColeccion.filter[p|p.stockActual >= unStockMinimo].toList
	}

	def searchByStockMax(Integer unStockMaximo, List<Producto> unaColeccion) {
		unaColeccion.filter[p|p.stockActual <= unStockMaximo].toList
	}

	def searchByStock(Integer unStockMinimo, Integer unStockMaximo, List<Producto> unaColeccion) {
		unaColeccion.filter[p|p.stockActual >= unStockMinimo && p.stockActual <= unStockMaximo].toList
	}

	def stockMinimoProd(List<Producto> unaColeccion) {
		unaColeccion.filter[p|p.stockActual <= p.stockMinimo || p.stockActual >= p.stockMinimo].toList
	}

	def stockMayorProd(List<Producto> unaColeccion) {
		unaColeccion.filter[prod|prod.stockActual > prod.stockMinimo].toList
	}
}
