package runnable

import domain.Documental
import domain.Grafos
import domain.Item
import domain.ItemDeCompuesto
import domain.Memoria
import domain.OrdenDeCompra
import domain.Producto
import domain.ProductoCompuesto
import domain.Proveedor
import domain.Relacional
import domain.Stock
import domain.TipoPersistencia
import java.time.LocalDate
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.arena.bootstrap.CollectionBasedBootstrap
import persistencia.OrdenHibernate
import persistencia.OrdenMemoria
import persistencia.OrdenMongoDao
import persistencia.OrdenNeo4J
import persistencia.ProductoHibernate
import persistencia.ProductoMemoria
import persistencia.ProductoMongoDao
import persistencia.ProductoNeo4J
import persistencia.ProveedorHibernate
import persistencia.ProveedorMemoria
import persistencia.ProveedorMongoDao
import persistencia.ProveedorNeo4J
import repositorios.RepoOrdenDeCompra
import repositorios.RepoPersistencia
import repositorios.RepoProducto
import repositorios.RepoProveedor

@Accessors
class AutopartistaBootstrap extends CollectionBasedBootstrap {

	List<ItemDeCompuesto> recetaCompuesto

	Stock stockParagolpe
	Stock stockChasis
	Stock stockDisco
	Stock stockCompuesto

	Producto paragolpe = new Producto()
	Producto chasis = new Producto()
	Producto disco = new Producto()
	ProductoCompuesto autoParte = new ProductoCompuesto()

	ItemDeCompuesto itemParagolpe = new ItemDeCompuesto
	ItemDeCompuesto itemChasis = new ItemDeCompuesto
	ItemDeCompuesto itemDisco = new ItemDeCompuesto

	Proveedor tesla = new Proveedor()
	Proveedor ferrari = new Proveedor()
	Proveedor ford = new Proveedor()

	OrdenDeCompra orden1 = new OrdenDeCompra
	OrdenDeCompra orden2 = new OrdenDeCompra
	OrdenDeCompra orden3 = new OrdenDeCompra

	Item itemOrden1
	Item itemOrden2
	Item itemOrden3
	Item itemOrden4

	new() {
		recetaCompuesto = newArrayList
	}

	override run() {
		val repoPersistencia = RepoPersistencia.instance
		if (repoPersistencia.persistenciasGuardadas !== null && repoPersistencia.persistenciasGuardadas.size > 0) {
			repoPersistencia.persistenciasGuardadas.forEach[per|checkDatos(per)]
		} else {
			iniciarProducto()
			iniciarProveedores()
			iniciarOrdenes()
			massiveCreate()
		}
	}

	def checkDatos(TipoPersistencia unTipo) {
		if (unTipo.listaDeRepos.forall[repo|repo.listaRepo.size == 0]) {
			iniciarProducto()
			iniciarProveedores()
			iniciarOrdenes()
			createDatosPorTipo(unTipo)
		}
	}

	def dispatch createDatosPorTipo(Memoria unTipo) {
		val repoProducto = unTipo.listaDeRepos.findFirst[repo|repo.nombre.contains("Producto")] as ProductoMemoria
		val repoOrden = unTipo.listaDeRepos.findFirst[repo|repo.nombre.contains("Orden")] as OrdenMemoria
		val repoProveedor = unTipo.listaDeRepos.findFirst[repo|repo.nombre.contains("Proveedor")] as ProveedorMemoria
		repoProducto.createOrUpdate(paragolpe)
		repoProducto.createOrUpdate(chasis)
		repoProducto.createOrUpdate(disco)
		repoProducto.createOrUpdate(autoParte)
		
		repoProveedor.createOrUpdate(tesla)
		repoProveedor.createOrUpdate(ferrari)
		repoProveedor.createOrUpdate(ford)
		
		repoOrden.createOrUpdate(orden1)
		repoOrden.createOrUpdate(orden2)
		repoOrden.createOrUpdate(orden3)
		
	}

	def dispatch createDatosPorTipo(Grafos unTipo) {
		val repoProducto = unTipo.listaDeRepos.findFirst[repo|repo.nombre.contains("Producto")] as ProductoNeo4J
		val repoOrden = unTipo.listaDeRepos.findFirst[repo|repo.nombre.contains("Orden")] as OrdenNeo4J
		val repoProveedor = unTipo.listaDeRepos.findFirst[repo|repo.nombre.contains("Proveedor")] as ProveedorNeo4J
		repoProducto.createOrUpdate(paragolpe)
		repoProducto.createOrUpdate(chasis)
		repoProducto.createOrUpdate(disco)
		repoProducto.createOrUpdate(autoParte)
		
		repoProveedor.createOrUpdate(tesla)
		repoProveedor.createOrUpdate(ferrari)
		repoProveedor.createOrUpdate(ford)
		
		repoOrden.createOrUpdate(orden1)
		repoOrden.createOrUpdate(orden2)
		repoOrden.createOrUpdate(orden3)
	}

	def dispatch createDatosPorTipo(Relacional unTipo) {
		val repoProducto = unTipo.listaDeRepos.findFirst[repo|repo.nombre.contains("Producto")] as ProductoHibernate
		val repoOrden = unTipo.listaDeRepos.findFirst[repo|repo.nombre.contains("Orden")] as OrdenHibernate
		val repoProveedor = unTipo.listaDeRepos.findFirst[repo|repo.nombre.contains("Proveedor")] as ProveedorHibernate
		repoProducto.createOrUpdate(paragolpe)
		repoProducto.createOrUpdate(chasis)
		repoProducto.createOrUpdate(disco)
		repoProducto.createOrUpdate(autoParte)
		
		repoProveedor.createOrUpdate(tesla)
		repoProveedor.createOrUpdate(ferrari)
		repoProveedor.createOrUpdate(ford)
		
		repoOrden.createOrUpdate(orden1)
		repoOrden.createOrUpdate(orden2)
		repoOrden.createOrUpdate(orden3)
	}

	def dispatch createDatosPorTipo(Documental unTipo) {
		val repoProducto = unTipo.listaDeRepos.findFirst[repo|repo.nombre.contains("Producto")] as ProductoMongoDao
		val repoOrden = unTipo.listaDeRepos.findFirst[repo|repo.nombre.contains("Orden")] as OrdenMongoDao
		val repoProveedor = unTipo.listaDeRepos.findFirst[repo|repo.nombre.contains("Proveedor")] as ProveedorMongoDao
		repoProducto.createOrUpdate(paragolpe)
		repoProducto.createOrUpdate(chasis)
		repoProducto.createOrUpdate(disco)
		repoProducto.createOrUpdate(autoParte)
		
		repoProveedor.createOrUpdate(tesla)
		repoProveedor.createOrUpdate(ferrari)
		repoProveedor.createOrUpdate(ford)
		
		repoOrden.createOrUpdate(orden1)
		repoOrden.createOrUpdate(orden2)
		repoOrden.createOrUpdate(orden3)
	}

	def iniciarProducto() {
		iniciarStock()
		paragolpe = new Producto() => [
			descripcion = "Paragolpes"
			stock = stockParagolpe
			costo = 1500.99
		]
		chasis = new Producto() => [
			descripcion = "Chasis"
			stock = stockChasis
			costo = 2500.50
		]
		disco = new Producto() => [
			descripcion = "Disco de Freno"
			stock = stockDisco
			costo = 550.5
		]

		iniciarItem()

		autoParte = new ProductoCompuesto() => [
			descripcion = "Autoparte (Compuesto)"
			stock = stockCompuesto
			items = recetaCompuesto
		]

//		this.createProducto(paragolpe)
//		this.createProducto(chasis)
//		this.createProducto(disco)
//		this.createProducto(autoParte)
	}

	def iniciarStock() {
		stockParagolpe = new Stock(50, 100, 20)
		stockChasis = new Stock(100, 500, 200)
		stockDisco = new Stock(50, 100, 75)
		stockCompuesto = new Stock(10, 15, 11)
	}

	def iniciarItem() {
		itemParagolpe => [
			producto = paragolpe
			cantidad = 2
		]

		itemChasis => [
			producto = chasis
			cantidad = 1
		]

		itemDisco => [
			producto = disco
			cantidad = 4
		]

		recetaCompuesto.add(itemParagolpe)
		recetaCompuesto.add(itemChasis)
		recetaCompuesto.add(itemDisco)
	}

	def iniciarProveedores() {

		tesla => [
			nombre = "Tesla Motors"
			productos = #[paragolpe, chasis]
		]

		ferrari => [
			nombre = "Ferrari"
			productos = #[disco]
		]

		ford => [
			nombre = "Ford"
			productos = #[autoParte]
		]

//		this.createProveedor(tesla)
//		this.createProveedor(ferrari)
//		this.createProveedor(ford)
	}

	def iniciarOrdenes() {
		val List<Item> listaOrden = newArrayList
		val List<Item> listaOrden2 = newArrayList
		val List<Item> listaOrden3 = newArrayList

		itemOrden1 = new Item(paragolpe, 3, orden1)
		itemOrden2 = new Item(chasis, 5, orden2)
		itemOrden3 = new Item(disco, 10, orden2)
		itemOrden4 = new Item(autoParte, 7, orden3)

		listaOrden.add(itemOrden1)
		listaOrden2.add(itemOrden2)
		listaOrden2.add(itemOrden3)
		listaOrden3.add(itemOrden4)

		orden1 => [
			fecha = LocalDate.of(2016, 10, 15)
			proveedor = tesla
			productos = listaOrden
		]

		orden2 => [
			fecha = LocalDate.of(1990, 8, 19)
			proveedor = ferrari
			productos = listaOrden2
		]

		orden3 => [
			fecha = LocalDate.of(2017, 03, 11)
			proveedor = ford
			productos = listaOrden3
		]

		orden1.total = orden1.calcularTotal
		orden2.total = orden2.calcularTotal
		orden3.total = orden3.calcularTotal

//		this.createOrdenesCompra(orden1)
//		this.createOrdenesCompra(orden2)
//		this.createOrdenesCompra(orden3)
	}

	def massiveCreate() {

		this.createProducto(paragolpe)
		this.createProducto(chasis)
		this.createProducto(disco)
		this.createProducto(autoParte)

		this.createProveedor(tesla)
		this.createProveedor(ferrari)
		this.createProveedor(ford)

		this.createOrdenesCompra(orden1)
		this.createOrdenesCompra(orden2)
		this.createOrdenesCompra(orden3)
	}

/////////////////////// Creacion de Productos, Ordenes y Proveedores en todos los Repos
	def void createProducto(Producto unProducto) {
		val repoProducto = RepoProducto.instance
		repoProducto.persistencia.forEach[r|r.createOrUpdate(unProducto)]
	}

	def void createProveedor(Proveedor unProveedor) {
		val repoProveedor = RepoProveedor.instance
		repoProveedor.persistencia.forEach[r|r.createOrUpdate(unProveedor)]
	}

	def void createOrdenesCompra(OrdenDeCompra unaOrden) {
		val repoOrden = RepoOrdenDeCompra.instance
		repoOrden.persistencia.forEach[r|r.createOrUpdate(unaOrden)]
	}

}
