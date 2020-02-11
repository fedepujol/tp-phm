package viewModel

import domain.TipoPersistencia
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable
import org.uqbar.commons.model.exceptions.UserException
import repositorios.RepoPersistencia

@Accessors
@Observable
class PersistenciaModel {
	TipoPersistencia persistenciaSeleccionada
	TipoPersistencia persistenciaSeleccionadaList
	RepoPersistencia repoPersistencia
	Set<TipoPersistencia> listaSelector = newHashSet
	Set<TipoPersistencia> listaPersistencia = newHashSet

	new() {
		repoPersistencia = RepoPersistencia.instance
		persistenciaSeleccionada = null
		persistenciaSeleccionadaList = null
		listaSelector = repoPersistencia.persistencias
		listaPersistencia = repoPersistencia.persistenciasGuardadas
	}

	def void agregarPersistencia() {
		if (listaPersistencia.contains(persistenciaSeleccionada)) {
			throw new UserException("Elemento ya seleccionado")
		}
		listaPersistencia.add(persistenciaSeleccionada)
	}

	def void deletePersistencia() {
		if (!listaPersistencia.contains(persistenciaSeleccionadaList)) {
			throw new UserException("No se puede eliminar")
		}
		repoPersistencia.delete(persistenciaSeleccionadaList)
		listaPersistencia.remove(persistenciaSeleccionadaList)
	}

	def void aceptarFiltro() {
		repoPersistencia.configurarPersistencia(listaPersistencia)
	}
}
