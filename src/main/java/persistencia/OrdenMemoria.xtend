package persistencia

import abstractPersistencia.GenericOrden
import domain.Item
import domain.OrdenDeCompra
import domain.Producto
import domain.Proveedor
import java.time.LocalDate
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class OrdenMemoria implements GenericOrden {
	String descripcion
	Long id = new Long(1)
	List<OrdenDeCompra> ordenes = newArrayList
	static OrdenMemoria instance

	static def getInstance() {
		if (instance === null) {
			instance = new OrdenMemoria()
		}
		return instance
	}

	private new() {
		this.descripcion = "Orden Memoria"
	}
	
	override nombre(){
		this.descripcion
	}

	override getListaRepo() {
		this.ordenes
	}

	override createOrUpdate(OrdenDeCompra unaOrden) {
		val ordenAux = this.searchById(unaOrden)
		if(ordenAux === null){
			unaOrden.idMemoria = id
			ordenes.add(unaOrden)
			id++		
		}else{
			ordenAux.proveedor = unaOrden.proveedor
			ordenAux.productos = unaOrden.productos
			ordenAux.fecha = unaOrden.fecha
		}
	}

	override searchById(OrdenDeCompra unaOrden) {
		ordenes.findFirst[orden|orden.idMemoria == unaOrden.idMemoria]
	}

	override List<OrdenDeCompra> filtrarOrden(Producto unProducto, Proveedor unProveedor, LocalDate fechaDesde,
		LocalDate fechaHasta, Double totalDesde, Double totalHasta) {

		filtrarProductos(unProducto,
			filtrarProveedores(unProveedor,
				filtrarFechaDesde(fechaDesde, filtrarFechaHasta(fechaHasta, filtrarTotalDesde(totalDesde,
					filtrarTotalHasta(totalHasta, ordenes))))))
	}

	def filtrarFechaDesde(LocalDate unaFecha, List<OrdenDeCompra> unasOrdenes) {
		if (unaFecha !== null) {
			unasOrdenes.filter[ord|condicionFiltrado(ord.fecha, unaFecha)].toList
		} else {
			unasOrdenes
		}
	}

	def filtrarFechaHasta(LocalDate unaFecha, List<OrdenDeCompra> unasOrdenes) {
		if (unaFecha !== null) {
			unasOrdenes.filter[ord|condicionFiltrado(unaFecha, ord.fecha)].toList
		} else {
			unasOrdenes
		}
	}

	def condicionFiltrado(LocalDate fecha, LocalDate fecha2) {
		fecha.isAfter(fecha2) || fecha.equals(fecha2)
	}

	def filtrarProductos(Producto unProducto, List<OrdenDeCompra> unasOrdenes) {
		if (unProducto !== null) {
			unasOrdenes.filter[ord|ordenContieneProducto(ord, unProducto)].toList
		} else {
			unasOrdenes
		}
	}

	def ordenContieneProducto(OrdenDeCompra orden, Producto unProducto) {
		itemsContienenProducto(orden.productos, unProducto)
	}

	def itemsContienenProducto(List<Item> items, Producto unProducto) {
		items.exists[item|this.itemContieneProducto(item, unProducto)]
	}

	def itemContieneProducto(Item item, Producto unProducto) {
		item.producto.descripcion == unProducto.descripcion
	}

	def filtrarProveedores(Proveedor unProveedor, List<OrdenDeCompra> unasOrdenes) {
		if (unProveedor !== null) {
			unasOrdenes.filter [ ord |
				ord.proveedor.nombre == unProveedor.nombre
			].toList
		} else {
			unasOrdenes
		}
	}

	def filtrarTotalDesde(Double unaTotal, List<OrdenDeCompra> unasOrdenes) {
		if (unaTotal !== null) {
			unasOrdenes.filter[ord|ord.total >= unaTotal].toList
		} else {
			unasOrdenes
		}
	}

	def filtrarTotalHasta(Double unaTotal, List<OrdenDeCompra> unasOrdenes) {
		if (unaTotal !== null) {
			unasOrdenes.filter[ord|ord.total <= unaTotal].toList
		} else {
			unasOrdenes
		}
	}
}
