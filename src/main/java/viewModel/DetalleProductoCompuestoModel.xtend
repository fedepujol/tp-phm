package viewModel

import domain.ProductoCompuesto
import repositorios.RepoProducto

class DetalleProductoCompuestoModel extends DetalleProductoModelGenerico<ProductoCompuesto> {
	
	new(ProductoCompuesto unProducto) {
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
