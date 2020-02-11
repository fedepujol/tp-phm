//package domain
//
//import org.junit.Assert
//import org.junit.Before
//import org.junit.Test
//import org.uqbar.commons.model.exceptions.UserException
//
//class testDetalleProducto extends testGenerico {
//
//	@Before
//	def void init() {
//		iniciarProducto
//		iniciarOrdenes
//		iniciarProveedores
//	}
//
//	@Test
//	def void testVentaDeProductoSimpleConStock25QuedaEn24() {
//		paragolpe.cantidadAVender = 1
//		paragolpe.vender()
//		Assert.assertEquals(49, paragolpe.stockActual())
//	}
//
//	@Test
//	def void testVentaDeProductoCompuestoConStock3QuedaEn2() {
//		prodCompuesto.cantidadAVender = 1
//		prodCompuesto.vender()
//		Assert.assertEquals(2, prodCompuesto.stockActual)
//	}
//
//	@Test
//	def void testVentaDeProductoSimpleConStock25QuedaEn24YSeActulizaElStockEnRepo() {
//		prodSimple2.cantidadAVender = 1
//		prodSimple2.vender()
//		Assert.assertEquals(24, repoProducto.searchById(prodSimple2.id_producto).stockActual)
//	}
//
//	@Test
//	def void testVentaDeProductoCompuestoConStock3QuedaEn2YSeActulizaElStockEnRepo() {
//		prodCompuesto.cantidadAVender = 1
//		prodCompuesto.vender()
//		Assert.assertEquals(2, repoProducto.searchById(prodCompuesto.id_producto).stockActual)
//	}
//
//	@Test
//	def void testProductoCompuestoConItemsDevuelveListaDeItemsConDosItems() {
//		Assert.assertEquals(2, prodCompuesto.items.length())
//	}
//
//	@Test(expected=UserException)
//	def void testProductoSimpleMuestraExcepcionAlVenderMasQueElMinimo() {
//		prodSimple.cantidadAVender = 1
//		prodSimple.vender()
//	}
//
//}
