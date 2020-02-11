package repositorios

import abstractPersistencia.GenericOrden
import domain.OrdenDeCompra
import domain.Producto
import domain.Proveedor
import java.time.LocalDate
import java.util.List
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class RepoOrdenDeCompra extends AbstractRepo<OrdenDeCompra>{
	GenericOrden tipo
	static RepoOrdenDeCompra instance
	Set<GenericOrden> persistencia = newHashSet

	static def getInstance() {
		if (instance === null) {
			instance = new RepoOrdenDeCompra()
		}
		return instance
	}

	private new() {
	}

	override createOrUpdate(OrdenDeCompra unaOrden) {
		persistencia.forEach[repo|repo.createOrUpdate(unaOrden)]
	}

	def searchById(OrdenDeCompra unaOrden) {
		tipo.searchById(unaOrden)
	}

	def List<OrdenDeCompra> filtrar(Producto unProducto, Proveedor unProveedor, LocalDate fechaDesde,
		LocalDate fechaHasta, Double totalDesde, Double totalHasta) {
		tipo.filtrarOrden(unProducto, unProveedor, fechaDesde, fechaHasta, totalDesde, totalHasta)
	}

	def getOrdenes() {
		tipo.listaRepo
	}
	
	def agregarPersistencia(GenericOrden unaPersistencia){
		persistencia.add(unaPersistencia)
	}	
	
	override initTipo() {
		tipo = persistencia.head
	}

}
