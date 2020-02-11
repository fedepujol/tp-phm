package viewModel

import domain.Producto
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable
import repositorios.RepoProducto

@Accessors
@Observable
class DetalleProductoModel extends DetalleProductoModelGenerico<Producto> {

	new(Producto unProducto) {		
		producto = unProducto
	}

	override vender() {
		producto.vender()
		RepoProducto.instance.createOrUpdate(producto)
	}

	override costoUnitario() {
		producto.dameCosto(1)
	}
}
