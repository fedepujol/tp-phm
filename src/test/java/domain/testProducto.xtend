//package domain
//
//import java.util.ArrayList
//import org.junit.Assert
//import org.junit.Before
//import org.junit.Test
//
//class testProducto extends testGenerico{
//
//	@Before
//	def void init() {
//		recetaProds = new ArrayList<ItemDeCompuesto>
//		recetaProds2 = new ArrayList<ItemDeCompuesto>
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
//		itemSimple = new ItemDeCompuesto(prodSimple, 4)
//		itemSimple2 = new ItemDeCompuesto(prodSimple2, 20)
//		itemSimple3 = new ItemDeCompuesto(prodSimple3, 150)
//
//		recetaProds => [
//			add(itemSimple2)
//			add(itemSimple3)
//		]
//
//		tipoCompuesto = new Compuesto(recetaProds)
//		prodCompuesto = new Producto("Arbol de leva", tipoCompuesto, stockProdCompuesto)
//		itemCompuesto = new ItemDeCompuesto(prodCompuesto, 3)
//
//		recetaProds2 => [
//			add(itemCompuesto)
//			add(itemSimple)
//		]
//
//		tipoCompuesto2 = new Compuesto(recetaProds2)
//		prodCompuesto2 = new Producto("Motor", tipoCompuesto2, stockProdCompuesto)
//	}
//
//	@Test
//	def void testCostoProducto1DeTipoSimple() {
//		Assert.assertEquals(20.5, prodSimple.dameCosto(1), 0.5)
//	}
//
//	@Test
//	def void testCostoProductoCompuestoEsSumatoriaDeSimples() {
//		Assert.assertEquals(3485, prodCompuesto.dameCosto(1), 0.5)
//	}
//
//	@Test
//	def void testCostoProductoCompuestoDeProductoCompuesto() {
//		Assert.assertEquals(10537, prodCompuesto2.dameCosto(1), 0.5)
//	}
//	
//	
//	
//}
