package domain

import java.time.LocalDate
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import repositorios.RepoOrdenDeCompra
import repositorios.RepoProducto
import repositorios.RepoProveedor

@Accessors
abstract class testGenerico {
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

	OrdenDeCompra orden1
	OrdenDeCompra orden2
	OrdenDeCompra orden3

	Item itemOrden1
	Item itemOrden2
	Item itemOrden3
	Item itemOrden4

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

		this.createProducto(paragolpe)
		this.createProducto(chasis)
		this.createProducto(disco)
		this.createProducto(autoParte)

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
			cantidad = 3
		]

		itemChasis => [
			producto = chasis
			cantidad = 12
		]

		itemDisco => [
			producto = disco
			cantidad = 33
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

		this.createProveedor(tesla)
		this.createProveedor(ferrari)
		this.createProveedor(ford)
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


		orden1 = new OrdenDeCompra(LocalDate.of(2016, 10, 15), tesla, listaOrden)
		orden2 = new OrdenDeCompra(LocalDate.of(1990, 8, 19), ferrari, listaOrden2)
		orden3 = new OrdenDeCompra(LocalDate.of(2017, 03, 11), ford, listaOrden3)
		
		orden1.total = orden1.calcularTotal
		orden2.total = orden2.calcularTotal
		orden3.total = orden3.calcularTotal
		
		this.createOrdenesCompra(orden1)
		this.createOrdenesCompra(orden2)
		this.createOrdenesCompra(orden3)
	}
	
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
