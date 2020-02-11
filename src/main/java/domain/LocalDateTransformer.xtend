package domain

import java.text.ParseException
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import org.apache.commons.lang.StringUtils
import org.uqbar.arena.bindings.ValueTransformer
import org.uqbar.commons.model.exceptions.UserException

class LocalDateTransformer implements ValueTransformer<LocalDate, String> {
	val String pattern = "dd/MM/yyyy";
	val DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern)

	override LocalDate viewToModel(String valueFromView) {
		try {
			if (StringUtils.isBlank(valueFromView))
				return null
			else {
				return LocalDate.parse(valueFromView, formatter);
			}

		} catch (ParseException e) {
			// TODO: i18n
			throw new UserException("Debe ingresar una fecha en formato: " + this.pattern);
		}
	}

	override String modelToView(LocalDate valueFromModel) {
		if (valueFromModel === null) {
			return null;
		}
		return valueFromModel.format(formatter)
	}

	override Class<LocalDate> getModelType() {
		typeof(LocalDate)
	}

	override Class<String> getViewType() {
		typeof(String)
	}

}
