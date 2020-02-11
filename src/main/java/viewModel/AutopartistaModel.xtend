package viewModel

import domain.Producto
import domain.Stock
import java.util.Collection
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable
import repositorios.RepoProducto

@Accessors
@Observable
class AutopartistaModel {
	Producto producto
	Producto productoSeleccionado
	Boolean stockMinimo = false
	Collection<Producto> productos

	new() {
		productoSeleccionado = null
		producto = new Producto(null, new Stock(null, null, null), null)
		productos = RepoProducto.instance.filtrar(producto, stockMinimo)
	}

	def search() {
		productos = RepoProducto.instance.filtrar(producto, stockMinimo)
	}

	def limpiar() {
		producto.descripcion = null
		producto.stock.minimo = null
		producto.stock.maximo = null
		productoSeleccionado = null
		stockMinimo = false

		this.search
	}

}
