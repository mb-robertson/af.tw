package com.af.tw.common.settings.impl

import org.slf4j.LoggerFactory
import com.typesafe.config.ConfigFactory
import com.af.tw.common.settings.FrameworkSettings

/**
* @MONO_STATE
* Provides framework settings as defined in reference.conf
*/
class FrameworkSettingsImpl implements FrameworkSettings {
	val LOG = LoggerFactory.getLogger(this.class)
	static var isInitialized = false

	static String loggingLevel

	public new() {
		if(!isInitialized) {
			LOG.trace('was not init')

			extension val c = ConfigFactory.load().getConfig("internal")
			loggingLevel = "logging".string
			LOG.trace("the logging level should be set to: {}", loggingLevel)

			isInitialized = true

		} else {
			LOG.trace('was already init')
		}
	}
	/**
	 * @return the current Logging Level
	 */
	override String getLoggingLevel() {
		loggingLevel
	}

	package def getIsInitialized() {
		isInitialized
	}

	package def setIsInitialized(boolean that) {
		isInitialized = that
	}

}
