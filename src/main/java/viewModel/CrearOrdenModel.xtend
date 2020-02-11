package viewModel

import domain.Item
import domain.OrdenDeCompra
import domain.Producto
import domain.Proveedor
import java.time.LocalDate
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Dependencies
import org.uqbar.commons.model.annotations.Observable
import org.uqbar.commons.model.exceptions.UserException
import repositorios.RepoOrdenDeCompra
import repositorios.RepoProducto
import repositorios.RepoProveedor

@Accessors
@Observable
class CrearOrdenModel {
	RepoProveedor repoProveedores
	RepoProducto repoProducto
	RepoOrdenDeCompra repoOrden
	OrdenDeCompra ordenNueva
	LocalDate fecha
	Proveedor proveedor
	Producto producto
	Item productoTabla
	Integer cantidadDeItem = 0
	List<Item> productosAgregados = newArrayList
	List<Producto> productosProveedor = newArrayList
	LocalDate fechaTopeHasta = LocalDate.now()

	new() {
		repoProveedores = RepoProveedor.instance
		repoProducto = RepoProducto.instance
		repoOrden = RepoOrdenDeCompra.instance
		ordenNueva = new OrdenDeCompra
	}

	def agregarProducto() {
		validarCantidad
		if (existeProducto) {
			throw new UserException("Producto ya ingresado.")
		}
		productosAgregados.add(this.crearItem())
		cantidadDeItem = 0
	}

	def validarCantidad() {
		if (cantidadDeItem <= 0 || cantidadDeItem === null) {
			throw new UserException("El producto debe tener una cantidad.")
		}
	}

	def existeProducto() {
		productosAgregados.exists[item|producto.descripcion == item.descripcionProducto]
	}

	def crearItem() {
		new Item(producto, cantidadDeItem, ordenNueva)
	}

	def eliminarProducto() {
		productosAgregados.remove(productoTabla)
	}

	@Dependencies("productosAgregados")
	def getTotal() {
		productosAgregados.fold(0.0, [acum, item|acum + item.costoProducto])
	}

	def getProveedores() {
		repoProveedores.proveedores
	}

	def void setProveedor(Proveedor unProveedor) {
		proveedor = repoProveedores.searchById(unProveedor)
	}

	def refreshProductosProveedor() {
		productosProveedor = proveedor.productos
	}

	def void crear() {
		validarOrden
		ordenNueva.fecha = fecha
		ordenNueva.proveedor = proveedor
		ordenNueva.productos = productosAgregados
		ordenNueva.total = ordenNueva.calcularTotal
		repoOrden.createOrUpdate(ordenNueva)
	}

	def validarOrden() {
		validarFecha
		validarLista
	}

	def validarLista() {
		if (!hayProductosAgregados) {
			throw new UserException("La orden debe contener Productos")
		}
	}

	def validarFecha() {
		fechaNula
		fechaFueraRango
	}

	def fechaNula() {
		if (fecha === null) {
			throw new UserException("Debes ingresar una fecha")
		}
	}

	def fechaFueraRango() {
		if (!fechaEntreTopes(fecha)) {
			throw new UserException("La fecha esta fuera de rango.")
		}
	}

	def fechaEntreTopes(LocalDate date) {
		fechaTopeHasta.isAfter(date) || fechaTopeHasta == date
	}

	@Dependencies("proveedor")
	def getHabilitarProductos() {
		refreshProductosProveedor
		proveedor !== null
	}

	@Dependencies("productosAgregados")
	def getHabilitaProveedores() {
		!hayProductosAgregados
	}

	@Dependencies("productosAgregados","fecha")
	def getHabilitarCrear() {
		hayProductosAgregados && fecha !== null
	}

	@Dependencies("productosAgregados")
	def hayProductosAgregados() {
		!productosAgregados.isEmpty
	}
}
