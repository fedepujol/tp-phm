package ui

import domain.ItemDeCompuesto
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.tables.Column
import org.uqbar.arena.widgets.tables.Table
import org.uqbar.arena.windows.WindowOwner
import viewModel.DetalleProductoCompuestoModel

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class DetalleProductoCompuestoWindow extends DetalleProductoGenerico {
	
	new(WindowOwner owner, DetalleProductoCompuestoModel model) {
		super(owner, model)
		title = "Detalle Producto Compuesto"
	}
	
	override createSegundoPanel(Panel mainPanel) {
		val segundoPanel = new Panel(mainPanel)
		
		val table = new Table<ItemDeCompuesto>(segundoPanel, typeof(ItemDeCompuesto)) => [
			items <=> "producto.items"
			numberVisibleRows = 10
		]

		new Column<ItemDeCompuesto>(table) => [
			title = "Cantidad"
			fixedSize = 100
			bindContentsToProperty("cantidad")
		]

		new Column<ItemDeCompuesto>(table) => [
			title = "Producto"
			fixedSize = 250
			bindContentsToProperty("descripcionProducto")
]
	}

}
