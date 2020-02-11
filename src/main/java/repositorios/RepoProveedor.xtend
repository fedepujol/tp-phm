package repositorios

import abstractPersistencia.GenericProveedor
import domain.Proveedor
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class RepoProveedor extends AbstractRepo<Proveedor>{
	GenericProveedor tipo
	static RepoProveedor instance
	Set<GenericProveedor> persistencia = newHashSet

	static def RepoProveedor getInstance() {
		if (instance === null) {
			instance = new RepoProveedor()
		}
		return instance
	}

	private new() {
	}

	override createOrUpdate(Proveedor unProveedor) {
		persistencia.forEach[repo|repo.createOrUpdate(unProveedor)]
	}

	def getProveedores() {
		tipo.listaRepo
	}

	def Proveedor searchById(Proveedor unProveedor) {
		tipo.searchById(unProveedor)
	}
	
	def agregarPersistencia(GenericProveedor unaPersistencia){
		persistencia.add(unaPersistencia)
	}
	
	override initTipo() {
		tipo = persistencia.head
	}

}
