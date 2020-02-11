//package domain
//
//import org.junit.Assert
//import org.junit.Before
//import org.junit.Test
//
//class testItem extends testGenerico{
//
//	@Before
//	def void init() {
//		tipoSimple = new Simple(20.5)
//
//		stockProd1 = new Stock(10, 20, 6)
//
//		prodSimple = new Producto("Llanta", tipoSimple, stockProd1)
//		prodSimple2 = new Producto("Levas", tipoSimple, stockProd1)
//
//		itemSimple = new ItemDeCompuesto(prodSimple, 4)
//		itemSimple2 = new ItemDeCompuesto(prodSimple2, 20)
//	}
//
//	@Test
//	def void testCostoItem() {
//		Assert.assertEquals(82.0, itemSimple.costoProducto, 0.0)
//	}
//	
//	@Test
//	def void testActualizarProductoDeUnItem() {
//		itemSimple.actualizar(itemSimple2)
//		Assert.assertEquals("Levas", itemSimple.getDescripcionProducto())
//	}
//
//}
