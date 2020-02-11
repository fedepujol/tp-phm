package ui

import abstractPersistencia.Generic
import domain.TipoPersistencia
import org.uqbar.arena.bindings.NotNullObservable
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.List
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.Selector
import org.uqbar.arena.windows.Dialog
import org.uqbar.arena.windows.WindowOwner
import viewModel.PersistenciaModel

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class PersistenciaWindow extends Dialog<PersistenciaModel> {
	val elementSelected = new NotNullObservable("persistenciaSeleccionada")
	val elementSelectedLista = new NotNullObservable("persistenciaSeleccionadaList")

	new(WindowOwner parent) {
		super(parent, new PersistenciaModel)
		title = "Configuracion de Persistencia"
	}

	override protected createFormPanel(Panel mainPanel) {
		// Primer Panel		
		val primerPanel = new Panel(mainPanel) => [
			layout = new HorizontalLayout()
		]

		val subPanel1 = new Panel(primerPanel) => [
			layout = new ColumnLayout(2)
		]

		new Selector(subPanel1) => [
			val bindingAcciones = items <=> "listaSelector"
			bindingAcciones.adapter = new PropertyAdapter(typeof(TipoPersistencia), "nombre")
			value <=> "persistenciaSeleccionada"
			allowNull(false)
			width = 165
		]

		val subPanel2 = new Panel(subPanel1) => [
			layout = new HorizontalLayout
		]

		new Button(subPanel2) => [
			caption = "Agregar"
			onClick([|this.modelObject.agregarPersistencia])
			bindEnabled(elementSelected)
		]

		new Button(subPanel2) => [
			caption = "Eliminar"
			onClick([|this.modelObject.deletePersistencia])
			bindEnabled(elementSelectedLista)
		]

		new List<Generic<?>>(mainPanel) => [
			allowNull(false)
			width = 100
			height = 100
			value <=> "persistenciaSeleccionadaList"
			val bindingAcciones = items <=> "listaPersistencia"
			bindingAcciones.adapter = new PropertyAdapter(typeof(TipoPersistencia), "nombre")
		]
	}

	override protected addActions(Panel actionsPanel) {
		actionsPanel.layout = new HorizontalLayout

		new Button(actionsPanel) => [
			caption = "Aceptar"
			onClick([|
				this.modelObject.aceptarFiltro()
				this.initApp
			])
			setAsDefault
		]

		new Button(actionsPanel) => [
			caption = "Cancelar"
			onClick([|this.cancel])
			alignRight
		]

	}

	def initApp() {
			this.close
			this.openDialog(new AutopartistaWindow(this))
	}

	def openDialog(Dialog<?> dialog) {
		dialog.open
	}
}
