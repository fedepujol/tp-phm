package viewModel

import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable

@Accessors
@Observable
abstract class DetalleProductoModelGenerico<T> {
	T producto
	Boolean condicion

	def void vender()

	def Double costoUnitario()
}
