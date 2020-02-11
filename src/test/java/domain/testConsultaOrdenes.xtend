//package domain
//
//import java.time.LocalDate
//import java.util.ArrayList
//import org.junit.Assert
//import org.junit.Before
//import org.junit.Test
//import org.uqbar.commons.model.exceptions.UserException
//import repositorios.RepoOrdenDeCompra
//import viewModel.ConsultaOrdenesModel
//
//class testConsultaOrdenes extends testGenerico {
//	OrdenDeCompra orden
//	Proveedor proveedor = new Proveedor("Pepito")
//	Proveedor proveedorSinProductos = new Proveedor("SinProductos")
//	ConsultaOrdenesModel consultasOrdenes = new ConsultaOrdenesModel
//	RepoOrdenDeCompra repoOrdenes = RepoOrdenDeCompra.instance
//
//	def resetConsulta() {
//		consultasOrdenes = new ConsultaOrdenesModel
//		repoOrdenes.allInstance = newArrayList
//		repoOrdenes.create(orden)
//	}
//
//	def tamanioListaConsultas() {
//		consultasOrdenes.ordenesCompra.size
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
//	def void fechasNulasSiConsultaNOTieneAsignadaNingunaFechaDaVerdadero() {
//		resetConsulta
//		Assert.assertEquals(true, consultasOrdenes.fechasNulas())
//	}
//
//	@Test(expected=UserException)
//	def void siFechaDesdeEstaDespuesQueFechaHastaTiraExcepcion() {
//		resetConsulta
//		consultasOrdenes.fechaDesde = LocalDate.now()
//		consultasOrdenes.fechaHasta = LocalDate.of(2017, 12, 05)
//		consultasOrdenes.validarFechas
//	}
//
//	@Test
//	def void siFechaDesdeEstaAntesQueFechaHastaDaTRUE() {
//		resetConsulta
//		consultasOrdenes.fechaHasta = LocalDate.now()
//		consultasOrdenes.fechaDesde = LocalDate.of(2017, 12, 05)
//		Assert.assertTrue(consultasOrdenes.fechasValidas)
//	}
//
//	@Test
//	def void siLosTotalesSonNulosTotalesNulosEsVerdadero() {
//		resetConsulta
//		Assert.assertTrue(consultasOrdenes.totalesNulos())
//	}
//
//	@Test
//	def void siTotalHastaEsMayorQueTotalDesdeEsVerdadero() {
//		resetConsulta
//		consultasOrdenes.totalDesde = 5.0
//		consultasOrdenes.totalHasta = 10.5
//		Assert.assertTrue(consultasOrdenes.totalesValidos)
//	}
//
//	@Test(expected=UserException)
//	def void siTotalHastaEsMenorATotalDesdeTiraException() {
//		resetConsulta
//		consultasOrdenes.totalHasta = 5.0
//		consultasOrdenes.totalDesde = 10.5
//		consultasOrdenes.validarTotal
//	}
//
//	@Test
//	def void siFiltroPorUnTotalDesde102Da1() {
//		resetConsulta
//		consultasOrdenes.totalDesde = 102.0
//		consultasOrdenes.buscar()
//		Assert.assertEquals(1, tamanioListaConsultas)
//	}
//
//	@Test
//	def void filtroSinParametrosDeBusquedaMeDevuelveListaCompleta() {
//		resetConsulta
//		consultasOrdenes.buscar()
//		Assert.assertEquals(1, tamanioListaConsultas)
//	}
//
//	@Test
//	def void filtroPorUnTotalHasta100Da0() {
//		resetConsulta
//		consultasOrdenes.totalHasta = 100.0
//		consultasOrdenes.buscar()
//		Assert.assertEquals(0, tamanioListaConsultas)
//	}
//
//	@Test
//	def void filtroPorFechaDesdeAnteriorALaOrdenQueEstaDa1() {
//		resetConsulta
//		consultasOrdenes.fechaDesde = LocalDate.of(1980, 5, 10)
//		consultasOrdenes.buscar
//		Assert.assertEquals(1, tamanioListaConsultas)
//	}
//
//	@Test
//	def void filtroPorFechaDesdeSuperiorALaOrdenQueEstaDa0() {
//		resetConsulta
//		consultasOrdenes.fechaDesde = LocalDate.now()
//		consultasOrdenes.buscar
//		Assert.assertEquals(0, tamanioListaConsultas)
//	}
//
//	@Test
//	def void filtroPorFechaHastaSuperiorALaOrdenQueEstaDa1() {
//		resetConsulta
//		consultasOrdenes.fechaHasta = LocalDate.of(2017, 5, 10)
//		consultasOrdenes.buscar
//		Assert.assertEquals(1, tamanioListaConsultas)
//	}
//
//	@Test
//	def void filtroPorFechaHastaInferiorALaOrdenQueEstaDa0() {
//		resetConsulta
//		consultasOrdenes.fechaHasta = LocalDate.of(1980, 5, 10)
//		consultasOrdenes.buscar
//		Assert.assertEquals(0, tamanioListaConsultas)
//	}
//
//	@Test
//	def void filtroPorProveedorQueTengaAlgunObjetoDeLaListaMeDa1() {
//		resetConsulta
//		consultasOrdenes.proveedor = proveedor
//		consultasOrdenes.buscar
//		Assert.assertEquals(1, tamanioListaConsultas)
//	}
//
//	@Test
//	def void filtroPorProveedorQueNoTengaAlgunObjetoDeLaListaMeDa0() {
//		resetConsulta
//		consultasOrdenes.proveedor = proveedorSinProductos
//		consultasOrdenes.buscar
//		Assert.assertEquals(0, tamanioListaConsultas)
//	}
//
//	@Test
//	def void filtroPorProductoQueEsteEnLaListaMeDa1() {
//		resetConsulta
//		consultasOrdenes.producto = prodSimple
//		consultasOrdenes.buscar
//		Assert.assertEquals(1, tamanioListaConsultas)
//	}
//
//	@Test
//	def void filtroPorProductoQueNOEstaEnLaListaMeDa0() {
//		resetConsulta
//		consultasOrdenes.producto = prodSimple2
//		consultasOrdenes.buscar
//		Assert.assertEquals(0, tamanioListaConsultas)
//	}
//}
