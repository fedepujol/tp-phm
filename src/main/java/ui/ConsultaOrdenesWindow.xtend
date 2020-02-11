package ui

import domain.LocalDateTransformer
import domain.OrdenDeCompra
import domain.Producto
import domain.Proveedor
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.NumericField
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.Selector
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.widgets.tables.Column
import org.uqbar.arena.widgets.tables.Table
import org.uqbar.arena.windows.Dialog
import org.uqbar.arena.windows.WindowOwner
import viewModel.ConsultaOrdenesModel

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class ConsultaOrdenesWindow extends Dialog<ConsultaOrdenesModel> {

	new(WindowOwner parent) {
		super(parent, new ConsultaOrdenesModel)
		title = "Consulta Ordenes De Compras"
	}

	override protected createFormPanel(Panel mainPanel) {
		// /// PRODUCTO	
		val productoMain = new Panel(mainPanel)
		
		val productoPanel = new Panel(productoMain) => [
			layout = new HorizontalLayout
		]
		
		new Label(productoPanel) => [
			text = "Fecha Desde"
			width = 100
		]
		new Label(productoPanel) => [
			text = "Fecha Hasta"
			width = 100
		]
		new Label(productoPanel) => [
			text = "Producto"
			width = 165
		]

		val productoControl = new Panel(productoMain) => [
			layout = new HorizontalLayout
		]

		new TextBox(productoControl) => [
			width = 100
			withFilter(new DateTextFilter)
			(value <=> "fechaDesde").transformer = new LocalDateTransformer
		]

		new TextBox(productoControl) => [
			width = 100
			withFilter(new DateTextFilter)
			(value <=> "fechaHasta").transformer = new LocalDateTransformer
		]

		new Selector(productoControl) => [
			allowNull(false)
			items <=> "productos"
			value <=> "producto"
			val bindingAcciones = items <=> "productos"
			bindingAcciones.adapter = new PropertyAdapter(typeof(Producto), "descripcion")
			width = 165
		]

		// //// PROVEEDOR		
		val proveedorPanel = new Panel(productoMain) => [
			layout = new HorizontalLayout
		]

		new Label(proveedorPanel) => [
			text = "Total Desde"
			width = 100
		]
		new Label(proveedorPanel) => [
			text = "Total Hasta"
			width = 100
		]
		new Label(proveedorPanel) => [
			text = "Proveedor"
			width = 165
		]

		val proveedorControl = new Panel(productoMain) => [
			layout = new HorizontalLayout
		]

		new NumericField(proveedorControl) => [
			width = 100
			value <=> "totalDesde"
		]
		new NumericField(proveedorControl) => [
			width = 100
			value <=> "totalHasta"
		]
		new Selector(proveedorControl) => [
			items <=> "proveedores"
			value <=> "proveedor"
			val bindingAcciones = items <=> "proveedores"
			bindingAcciones.adapter = new PropertyAdapter(typeof(Proveedor), "nombre")
			width = 165
		]

		val botonesPanel = new Panel(mainPanel) => [
			layout = new HorizontalLayout
		]

		new Button(botonesPanel) => [
			caption = "Buscar"
			onClick([|modelObject.buscar])
			alignCenter

		]
		new Button(botonesPanel) => [
			caption = "Limpiar"
			onClick([|
				modelObject.limpiarPantalla
			])
			alignCenter

		]

		val tablaPanel = new Panel(mainPanel) => [
			layout = new HorizontalLayout
		]

		val tablaOrdenes = new Table(tablaPanel, typeof(OrdenDeCompra)) => [
			items <=> "ordenesCompra"
			value <=> "orden"
			numberVisibleRows = 10
		]

		new Column<OrdenDeCompra>(tablaOrdenes) => [
			title = "Fecha(A-M-D)"
			fixedSize = 200
			bindContentsToProperty("fecha")
		]

		new Column<OrdenDeCompra>(tablaOrdenes) => [
			title = "Productos"
			fixedSize = 200
			bindContentsToProperty("items")
		]

		new Column<OrdenDeCompra>(tablaOrdenes) => [
			title = "Proveedor"
			fixedSize = 200
			bindContentsToProperty("proveedor.nombre")
		]

		new Column<OrdenDeCompra>(tablaOrdenes) => [
			title = "Total"
			fixedSize = 200			
			bindContentsToProperty("total")
		]
	}

	override protected addActions(Panel actionsPanel) {
		new Button(actionsPanel) => [
			caption = "Crear Orden de Compra"
			onClick([this.openDialog(new CrearOrdenWindow(this))])
			alignCenter
		]
	}

	def openDialog(Dialog<?> dialog) {
		dialog.onAccept [
			modelObject.refrescarOrdenes
			modelObject.limpiarBusqueda
		]
		dialog.open
	}

}
