//package domain
//
//import java.time.LocalDate
//import java.util.ArrayList
//import org.junit.Assert
//import org.junit.Before
//import org.junit.Test
//import org.uqbar.commons.model.exceptions.UserException
//import repositorios.RepoOrdenDeCompra
//import viewModel.CrearOrdenModel
//
//class testCrearOrdenModel extends testGenerico {
//
//	OrdenDeCompra orden
//	Proveedor proveedor = new Proveedor("Pepito")
//	Proveedor proveedorSinProductos = new Proveedor("SinProductos")
//	CrearOrdenModel crearOrdenes = new CrearOrdenModel
//	RepoOrdenDeCompra repoOrdenes = RepoOrdenDeCompra.instance
//
//	def resetCrear() {
//		crearOrdenes = new CrearOrdenModel
//		repoOrdenes.listaRepositorio = newArrayList
////		repoOrdenes.create(orden)
//	}
//
//	def tamanioListaItems() {
//		crearOrdenes.productosAgregados.size
//	}
//
//	@Before
//	def void init() {
//		recetaProdsOC = new ArrayList<Item>
//		recetaProdsOC2 = new ArrayList<Item>
//
//		stockProd1 = new Stock(10, 20, 6)
//		stockProd2 = new Stock(5, 50, 25)
//		stockProd3 = new Stock(250, 500, 350)
//		stockProdCompuesto = new Stock(2, 5, 3)
//
//		tipoSimple = new Simple(20.5)
//
//		prodSimple = new Producto("Llanta", tipoSimple, stockProd1)
//		prodSimple2 = new Producto("Levas", tipoSimple, stockProd2)
//		prodSimple3 = new Producto("Tornillos", tipoSimple, stockProd3)
//
//		itemSimpleOC = new Item(prodSimple, 4)
//		itemSimpleOC2 = new Item(prodSimple2, 20)
//		itemSimpleOC3 = new Item(prodSimple3, 150)
//
//		recetaProdsOC => [
//			add(itemSimpleOC2)
//			add(itemSimpleOC3)
//		]
//
//		tipoCompuesto = new Compuesto(recetaProds)
//		prodCompuesto = new Producto("Arbol de leva", tipoCompuesto, stockProdCompuesto)
//		itemCompuestoOC = new Item(prodCompuesto, 3)
//
//		recetaProdsOC2 => [
//			add(itemCompuestoOC)
//			add(itemSimpleOC)
//		]
//
//		tipoCompuesto2 = new Compuesto(recetaProds2)
//		prodCompuesto2 = new Producto("Motor", tipoCompuesto2, stockProdCompuesto)
//
//		orden = new OrdenDeCompra(LocalDate.of(2000, 10, 19), proveedor, #[new Item(prodSimple, 5)])
//		repoOrdenes.create(orden)
//	}
//
//	@Test
//	def void agregoUnProductoQUeNoExisteYTieneCantidadSeAgrega() {
//		resetCrear
//		crearOrdenes.producto = prodSimple
//		crearOrdenes.cantidadDeItem = 5
//		Assert.assertEquals(0, tamanioListaItems)
//		crearOrdenes.agregarProducto()
//		Assert.assertEquals(1, tamanioListaItems)
//	}
//
//	@Test(expected=UserException)
//	def void agregoUnProductoQUeNoExisteYNOTieneCantidadTiraException() {
//		resetCrear
//		crearOrdenes.producto = prodSimple
//		crearOrdenes.agregarProducto()
//	}
//
//	@Test(expected=UserException)
//	def void agregoUnProductoYaAgregadoTiraUnaExcepcion() {
//		resetCrear
//		crearOrdenes.producto = prodSimple
//		crearOrdenes.agregarProducto()
//		crearOrdenes.agregarProducto()
//	}
//
//	@Test(expected=UserException)
//	def void agregoUnProductoConCantidad0TiraUnaExcepcion() {
//		resetCrear
//		crearOrdenes.producto = prodSimple
//		crearOrdenes.cantidadDeItem = 0
//		crearOrdenes.agregarProducto
//
//	}
//
//	@Test(expected=UserException)
//	def void fechaNulaTiraException() {
//		resetCrear
//		crearOrdenes.fechaNula
//	}
//
//	@Test(expected=UserException)
//	def void siLaFechaSuperaLaFechaActualTiraException() {
//		resetCrear
//		crearOrdenes.fecha = LocalDate.of(2100, 10, 11)
//		crearOrdenes.validarFecha
//	}
//
//	@Test(expected=UserException)
//	def void laListaDeItemVaciaTiraException() {
//		resetCrear
//		crearOrdenes.validarLista
//	}
//
//	@Test
//	def void creoUnaOrdenConTodosSusDatosYLoAgregaEnElRepo() {
//		resetCrear
//		crearOrdenes.fecha = LocalDate.now
//		crearOrdenes.cantidadDeItem = 10
//		crearOrdenes.producto = prodSimple
//		crearOrdenes.agregarProducto
//		Assert.assertEquals(0, repoOrdenes.listaRepositorio.size)
//		crearOrdenes.crear()
//		Assert.assertEquals(1, repoOrdenes.listaRepositorio.size)
//	}
//
//}
