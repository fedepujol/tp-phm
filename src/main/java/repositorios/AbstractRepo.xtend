package repositorios

abstract class AbstractRepo<T> {

	def void initTipo()

	def void createOrUpdate(T t)
}
