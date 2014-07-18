package com.af.tw.resources.framework_settings

import org.slf4j.LoggerFactory

class FrameworkSettingsConsumer {
	val LOG = LoggerFactory.getLogger(this.class)
	new() {
	}
	def traceMethod() {
		LOG.trace("trace message")
	}

	def debugMethod() {
		LOG.debug("debug message")
	}

	def infoMethod() {
		LOG.info("info message")
	}

	def errorMethod() {
		LOG.error("error message")
	}

}
