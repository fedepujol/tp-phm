package viewModel

import domain.OrdenDeCompra
import domain.Producto
import domain.Proveedor
import java.time.LocalDate
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.TransactionalAndObservable
import org.uqbar.commons.model.exceptions.UserException
import repositorios.RepoOrdenDeCompra
import repositorios.RepoProducto
import repositorios.RepoProveedor

@Accessors
@TransactionalAndObservable
class ConsultaOrdenesModel {
	RepoProducto repoProductos
	RepoProveedor repoProveedores
	RepoOrdenDeCompra repoOrden

	LocalDate fechaDesde
	LocalDate fechaHasta
	Double totalDesde
	Double totalHasta
	OrdenDeCompra orden
	Producto producto
	Proveedor proveedor
	List<OrdenDeCompra> ordenesCompra = newArrayList

	new() {
		repoProductos = RepoProducto.instance
		repoProveedores = RepoProveedor.instance
		repoOrden = RepoOrdenDeCompra.instance
		refrescarOrdenes
	}

	def buscar() {
		validarBusqueda
		ordenesCompra = filtroOrden()
	}

	def void limpiarPantalla() {
		this.limpiarBusqueda
		this.refrescarOrdenes
	}

	def limpiarBusqueda() {
		producto = null
		proveedor = null
		fechaDesde = null
		fechaHasta = null
		this.totalDesde = null
		this.totalHasta = null
	}

	def validarBusqueda() {
		validarFechas
		validarTotal
	}

	def filtroOrden() {
		repoOrden.filtrar(producto, proveedor, fechaDesde, fechaHasta, totalDesde, totalHasta)
	}

////////////////////////////////VALIDAR FECHAS//////////////////////////////////////
	def validarFechas() {
		if (!fechasNulas) {
			validarFechasFueraRango
		}
	}

	def fechasNulas() {
		fechaDesde === null || fechaHasta === null
	}

	def validarFechasFueraRango() {
		if (!fechasValidas) {
			throw new UserException("Rango de fechas invalido")
		}
	}

	def fechasValidas() {
		fechaHasta.isAfter(fechaDesde)
	}

//////////////////////////VALIDAR TOTALES/////////////////////////
	def validarTotal() {
		if (!totalesNulos) {
			totalesNoValidos
		}
	}

	def totalesNoValidos() {
		if (!totalesValidos) {
			throw new UserException("Rango de totales Incorrecto")
		}
	}

	def totalesValidos() {
		totalHasta >= totalDesde
	}

	def totalesNulos() {
		totalDesde === null || totalHasta === null
	}

/////////////////////////////////////////////////////////////
	def listaOrdenes() {
		repoOrden.ordenes
	}

	def getProveedores() {
		repoProveedores.proveedores
	}

	def getProductos() {
		repoProductos.productos
	}

	def refrescarOrdenes() {
		ordenesCompra = listaOrdenes
	}
}
