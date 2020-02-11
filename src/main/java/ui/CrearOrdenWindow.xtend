package ui

import domain.Item
import domain.LocalDateTransformer
import domain.Producto
import domain.Proveedor
import java.util.ArrayList
import org.uqbar.arena.bindings.NotNullObservable
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.filters.TextFilter
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.NumericField
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.Selector
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.widgets.TextInputEvent
import org.uqbar.arena.widgets.tables.Column
import org.uqbar.arena.widgets.tables.Table
import org.uqbar.arena.windows.Dialog
import org.uqbar.arena.windows.WindowOwner
import viewModel.CrearOrdenModel

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class CrearOrdenWindow extends Dialog<CrearOrdenModel> {
	val deshabilitador = new NotNullObservable("producto")

	new(WindowOwner owner) {
		super(owner, new CrearOrdenModel)
		title = "Crear Orden de Compra"
	}

	override protected createFormPanel(Panel mainPanel) {
		val fechaProveedorLabel = new Panel(mainPanel)
		fechaProveedorLabel.layout = new HorizontalLayout
		val fechaProveedor = new Panel(mainPanel)
		fechaProveedor.layout = new HorizontalLayout
		val cantidadProductoLabel = new Panel(mainPanel)
		cantidadProductoLabel.layout = new HorizontalLayout
		val cantidadProducto = new Panel(mainPanel)
		cantidadProducto.layout = new HorizontalLayout
		val tablaPanel = new Panel(mainPanel)

		new Label(fechaProveedorLabel) => [text = "Fecha" width = 100]
		new Label(fechaProveedorLabel) => [text = "Proveedor" width = 100]
		new TextBox(fechaProveedor) => [
			width = 100
			withFilter(new DateTextFilter)
			(value <=> "fecha").transformer = new LocalDateTransformer

		]
		new Selector(fechaProveedor) => [
			enabled <=> "habilitaProveedores"
			width = 100
			allowNull(false)
			items <=> "proveedores"
			value <=> "proveedor"
			val bindingAcciones = items <=> "proveedores"
			bindingAcciones.adapter = new PropertyAdapter(typeof(Proveedor), "nombre")

		]

		new Label(cantidadProductoLabel) => [text = "Cantidad" width = 100]
		new Label(cantidadProductoLabel) => [text = "Producto" width = 100]
		new NumericField(cantidadProducto) => [
			width = 100
			value <=> "cantidadDeItem"
		]
		new Selector(cantidadProducto) => [
			enabled <=> "habilitarProductos"
			width = 100
			allowNull(false)
			items <=> "productosProveedor"
			value <=> "producto"
			val bindingAcciones = items <=> "productosProveedor"
			bindingAcciones.adapter = new PropertyAdapter(typeof(Producto), "descripcion")
		]
		new Button(cantidadProducto) => [
			caption = "Agregar"
			alignCenter
			onClick([|modelObject.agregarProducto()])
			bindEnabled(deshabilitador)
		]

		val tablaProducto = new Table(tablaPanel, typeof(Item)) => [
			items <=> "productosAgregados"
			value <=> "productoTabla"
			numberVisibleRows = 3
		]
		new Column<Item>(tablaProducto) => [
			title = "Cantidad"
			fixedSize = 100
			bindContentsToProperty("cantidad")
		]
		new Column<Item>(tablaProducto) => [
			title = "Producto"
			fixedSize = 200
			bindContentsToProperty("descripcionProducto")
		]
		new Column<Item>(tablaProducto) => [
			title = "Total"
			fixedSize = 100
			bindContentsToProperty("costoProducto")
		]
		new Button(mainPanel) => [
			bindEnabled(deshabilitador)
			caption = "Eliminar"
			alignCenter
			onClick[|modelObject.eliminarProducto]
		]
		new Label(mainPanel) => [
			text = "Total"
			width = 320
			alignRight
		]
		new Label(mainPanel) => [
			alignRight
			width = 320
			value <=> "total"
		]

	}

	override protected addActions(Panel actionsPanel) {
		new Button(actionsPanel) => [
			enabled <=> "habilitarCrear"
			caption = "Crear"
			onClick([|
				modelObject.crear()
				this.accept
			])
			setAsDefault
			disableOnError
			alignCenter
		]
		new Button(actionsPanel) => [
			caption = "Cancelar"
			onClick([|this.close])
			setAsDefault
			disableOnError
			alignCenter
		]
	}

}


class DateTextFilter implements TextFilter {

	override accept(TextInputEvent event) {
		val expected = new ArrayList(#["\\d", "\\d?", "/", "\\d", "\\d?", "/", "\\d{0,4}"])
		val regex = expected.reverse.fold("")[result, element|'''(«element»«result»)?''']
		event.potentialTextResult.matches(regex)
	}

}
