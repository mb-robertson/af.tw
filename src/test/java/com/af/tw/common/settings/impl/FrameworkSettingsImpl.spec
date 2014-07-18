package com.af.tw.common.settings.impl 
import com.af.tw.common.settings.FrameworkSettings
import com.af.tw.resources.framework_settings.FrameworkSettingsConsumer

describe FrameworkSettingsImpl {

	context "with the default config (reference.conf)"{
		context "as itself"{
			extension FrameworkSettingsImpl = new FrameworkSettingsImpl
			
			def verifyAccessors{
				| actual        | expected |
				| isInitialized | true     |
				| loggingLevel  | "ERROR"    |
			}
			

			fact "accessors provide expected values"{
				verifyAccessors.forEach[actual should be expected]
				setIsInitialized(false)
			}

			def verifyMutators{
				| actual                | expected |
				| isInitialized = true  | true     |
				| isInitialized = false | false    |
				
			}
			
			fact "mutators update state to expected values"{
				verifyMutators.forEach[actual should be expected]
			}
		}

		context "as the interface"{
			extension FrameworkSettings = new FrameworkSettingsImpl 
			def verifyInterface{
				| actual       | expected |
				| loggingLevel | "ERROR"    |
			}
			
			fact "interfaceAccessors provide expected values" {
				verifyInterface.forEach[actual should be expected]
			}
		}
	}
	
}