package com.af.tw.common.helpers

import java.util.Map
import org.slf4j.LoggerFactory
import java.lang.reflect.Modifier

/**
 * Helps in creating instances of objects
 */
class InstancePopulator {
	val LOG = LoggerFactory.getLogger(this.class)

	new() {
	}

	/**
	 * @param instance the instance of the object to populate
	 * @param properties the map of properties to use for populating the instance
	 */
	def populate(Object instance, Map<String, String> properties) {

		LOG.trace("populating an instance of: {}", instance.class.name)

		//List of mapped fields in class
		val stringFields = instance.class.declaredFields.filter [
			//only non-final
			!it.modifiers.equals(Modifier.FINAL) && (
				it.type.equals(String) || it.type.equals(boolean)
			)
		]

		//for each field, fetch the field from the map, and assign that to the field
		stringFields.forEach [
			it.setAccessible(true)
			val fName = it.name.toLowerCase
			val fValue = properties.get(fName)
			if(fValue == null) {
				LOG.error("expected property: {} was not found", fName)
				throw new IllegalArgumentException(
					"expected property: " + fName + " was not found")
			}
			//put the value into the field as the correct type
			switch (it.type) {
				case int:
					it.set(instance, Integer.valueOf(fValue))
				case boolean:
					it.set(instance, Boolean.valueOf(fValue))
				case String:
					it.set(instance, fValue)
				default: {
					LOG.error("specified value: {} for property: {} is invalid",
						fValue, fName)
					throw new IllegalArgumentException
				}
			}
		]

	}

	/**
	 * @param instance the instance of the object to populate
	 * @param properties the map of properties to use for populating the instance
	 * @return an instance of Object -- populated by the map
	 * (it WILL need to be cast)
	 */
	def create(Class<?> clazz, Map<String, String> properties) {
		var instance = clazz.getConstructor.newInstance
		instance.populate(properties)
		instance
	}

}
