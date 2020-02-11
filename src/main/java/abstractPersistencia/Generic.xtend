package abstractPersistencia

import domain.OrdenDeCompra
import domain.Producto
import domain.ProductoCompuesto
import domain.Proveedor
import java.time.LocalDate
import java.util.List

interface Generic<T> {

	def String nombre()

	def List<T> getListaRepo()

	def void createOrUpdate(T objeto)

	def T searchById(T id)
}

interface GenericProducto extends Generic<Producto> {
	def List<Producto> filtrarProducto(Producto example, Boolean stockMenorMinimo)

	def ProductoCompuesto traerProductoCompuesto(ProductoCompuesto unProducto) {
		unProducto
	}
}

interface GenericOrden extends Generic<OrdenDeCompra> {

	def List<OrdenDeCompra> filtrarOrden(Producto producto, Proveedor proveedor, LocalDate fechaDesde,
		LocalDate fechaHasta, Double totalDesde, Double totalHasta)
}

interface GenericProveedor extends Generic<Proveedor> {
}
