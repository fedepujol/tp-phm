package runnable

import org.uqbar.arena.Application
import org.uqbar.arena.windows.Window
import ui.PersistenciaWindow

class AutopartistaApplication extends Application {

	static def void main(String[] args) {
		new AutopartistaApplication().start
	}

	override protected Window<?> createMainWindow() {
		return new PersistenciaWindow(this)
	}
}
