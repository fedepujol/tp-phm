package persistencia

import abstractPersistencia.GenericProveedor
import domain.Proveedor
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class ProveedorMemoria implements GenericProveedor {
	String descripcion
	Long id = new Long (1)
	List<Proveedor> proveedores = newArrayList
	static ProveedorMemoria instance

	static def getInstance() {
		if (instance === null) {
			instance = new ProveedorMemoria()
		}
		return instance
	}

	private new() {
		descripcion = "Proveedor Memoria"
	}
	
	override nombre(){
		this.descripcion
	}

	override getListaRepo() {
		this.proveedores
	}

	override createOrUpdate(Proveedor unProveedor) {
		val proveedorAux = this.searchById(unProveedor)
		if(proveedorAux === null){
			unProveedor.idMemoria = id
			proveedores.add(unProveedor)
			id++		
		}else{
			proveedorAux.nombre = unProveedor.nombre
			proveedorAux.productos = unProveedor.productos
		}
	}

	override searchById(Proveedor unProveedor) {
		proveedores.findFirst[prov|prov.idMemoria == unProveedor.idMemoria]
	}

}
