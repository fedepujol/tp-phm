package ui

import domain.Producto
import domain.ProductoCompuesto
import org.uqbar.arena.bindings.NotNullObservable
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.CheckBox
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.NumericField
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.widgets.tables.Column
import org.uqbar.arena.widgets.tables.Table
import org.uqbar.arena.windows.Dialog
import org.uqbar.arena.windows.WindowOwner
import repositorios.RepoProducto
import viewModel.AutopartistaModel
import viewModel.DetalleProductoCompuestoModel
import viewModel.DetalleProductoModel

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class AutopartistaWindow extends Dialog<AutopartistaModel> {
	val elementSelected = new NotNullObservable("productoSeleccionado")

	new(WindowOwner parent) {
		super(parent, new AutopartistaModel)
		title = "Consulta Stock de Productos"
	}

	override protected createFormPanel(Panel mainPanel) {
		// Primer Panel		
		val primerPanel = new Panel(mainPanel) => [
			layout = new HorizontalLayout()
		]

		val subPanel1 = new Panel(primerPanel) => [
			layout = new ColumnLayout(1)

			new Label(it).text = "Descripcion"
			new TextBox(it) => [
				width = 200
				value <=> "producto.descripcion"
			]
		]

		val subPanel2 = new Panel(primerPanel) => [

			layout = new ColumnLayout(2)

			new Label(it).text = "Stock mayor a"
			new Label(it).text = "Stock menor a"

			new NumericField(it) => [
				value <=> "producto.stock.minimo"
				width = 100
			]
			new NumericField(it) => [
				value <=> "producto.stock.maximo"
				width = 100
			]
		]
		// Segundo Panel	
		val segundoPanel = new Panel(mainPanel) => [
			layout = new HorizontalLayout

			new CheckBox(it) => [
				value <=> "stockMinimo"
			]
			new Label(it).text = "Por debajo del stock minimo"
		]

		new Button(segundoPanel) => [
			caption = "Buscar"
			onClick([|modelObject.search])
			alignCenter
		]

		new Button(segundoPanel) => [
			caption = "Limpiar"
			onClick([|modelObject.limpiar])
			alignCenter
		]

		// Tercer Panel
		val tercerPanel = new Panel(mainPanel)

		val table = new Table<Producto>(tercerPanel, typeof(Producto)) => [
			items <=> "productos"
			value <=> "productoSeleccionado"
			numberVisibleRows = 10
		]

		new Column<Producto>(table) => [
			title = "Producto"
			fixedSize = 250
			bindContentsToProperty("descripcion")
		]

		new Column<Producto>(table) => [
			title = "Stock Actual"
			fixedSize = 100
			bindContentsToProperty("stock.actual")
		]

		new Column<Producto>(table) => [
			title = "Stock Minimo"
			fixedSize = 100
			bindContentsToProperty("stock.minimo")
		]
	}

	override protected addActions(Panel actionsPanel) {
		new Button(actionsPanel) => [
			caption = "Aceptar"
			onClick([|this.close])
			setAsDefault
			disableOnError
		]

		new Button(actionsPanel) => [
			caption = "Detalle"
			onClick([|this.detalleProducto(modelObject.productoSeleccionado)])
			disableOnError
			bindEnabled(elementSelected)
		]

		new Button(actionsPanel) => [
			caption = "Orden de Compra"
			onClick([|this.dialogOrdenCompra()])
			disableOnError
		]		
	}

	def dispatch detalleProducto(Producto unProducto) {		
		this.openDialog(new DetalleProductoWindow(this, new DetalleProductoModel(unProducto)))
	}

	def dispatch detalleProducto(ProductoCompuesto unProducto) {
		this.openDialog(new DetalleProductoCompuestoWindow(this, new DetalleProductoCompuestoModel(RepoProducto.instance.traerProductoCompuesto(unProducto))))
	}

	def dialogOrdenCompra() {
		this.openDialog(new ConsultaOrdenesWindow(this))
	}

	def openDialog(Dialog<?> dialog) {
		dialog.onAccept[|modelObject.search]
		dialog.open
	}

}
