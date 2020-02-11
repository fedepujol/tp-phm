package abstractPersistencia

import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.ogm.config.Configuration
import org.neo4j.ogm.session.SessionFactory

@Accessors
abstract class AbstractNeo4J<T> implements Generic<T> {

	String descripcion
	public static int PROFUNDIDAD_BUSQUEDA_GRAFO = -1
	public static int PROFUNDIDAD_BUSQUEDA_LISTA = 0
	public static int PROFUNDIDAD_BUSQUEDA_CONCRETA = 1
	public static String INCOMING = "INCOMING"
	public static String OUTGOING = "OUTGOING"

	static Configuration configuration = new Configuration.Builder().uri("bolt://localhost").credentials("neo4j",
		"root").build()

	public static SessionFactory sessionFactory = new SessionFactory(configuration, "domain")

	protected def getSession() {
		sessionFactory.openSession
	}
}
