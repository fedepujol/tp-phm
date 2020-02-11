package ui

import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.NumericField
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.Dialog
import org.uqbar.arena.windows.WindowOwner
import viewModel.DetalleProductoModelGenerico

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

@Accessors
abstract class DetalleProductoGenerico extends Dialog<DetalleProductoModelGenerico<?>> {

	new(WindowOwner owner, DetalleProductoModelGenerico<?> model) {
		super(owner, model)
	}

	override protected createFormPanel(Panel mainPanel) {
		createPrimerPanel(mainPanel)
		createSegundoPanel(mainPanel)
		createTercerPanel(mainPanel)
		createCuartoPanel(mainPanel)
	}

	override protected addActions(Panel actionsPanel) {
		new Button(actionsPanel) => [
			caption = "Volver a Consulta"
			onClick([|
				accept
//				this.close
			])
			setAsDefault
			disableOnError
			alignCenter
		]
	}

	def createPrimerPanel(Panel mainPanel) {
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
	}

	abstract def void createSegundoPanel(Panel mainPanel)

	def createTercerPanel(Panel mainPanel) {
		val tercerPanel = new Panel(mainPanel) => [

			layout = new ColumnLayout(4)

			new Label(it).text = "Stock Actual"
			new Label(it).text = "Stock Minimo"
			new Label(it).text = "Stock Maximo"
			new Label(it).text = "Costo"

			new Label(it) => [
				width = 30
				value <=> "producto.stock.actual"
			]
			new Label(it) => [
				width = 30
				value <=> "producto.stock.minimo"
			]
			new Label(it) => [
				width = 30
				value <=> "producto.stock.maximo"
			]
			new Label(it) => [
				width = 100
				value <=> "costoUnitario"
			]
		]
	}

	def createCuartoPanel(Panel mainPanel) {
		val cuartoPanel = new Panel(mainPanel) => [

			layout = new ColumnLayout(2)

			new Label(it).text = "Cantidad a Vender"
			new Label(it).text = ""

			new NumericField(it) => [
				width = 200
				value <=> "producto.cantidadAVender"
			]
		]

		new Button(cuartoPanel) => [
			caption = "Realizar Venta"
			onClick([|modelObject.vender])
		]
	}

}
