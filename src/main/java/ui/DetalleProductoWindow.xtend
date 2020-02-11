package ui

import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.WindowOwner
import viewModel.DetalleProductoModel

class DetalleProductoWindow extends DetalleProductoGenerico{
	
	new(WindowOwner owner, DetalleProductoModel model) {
		super(owner, model)
		title = "Detalle Producto"
	}
	
	override createSegundoPanel(Panel mainPanel) {
		
	}
	
}
