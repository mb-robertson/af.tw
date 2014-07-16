package com.af.tw.common.helpers

import com.af.tw.resources.testclasses.FieldsStringOnly

describe InstancePopulator {
	context "with an object"{
		fact "when the object contains only String type properties"{
			val map = newHashMap("a" -> "a from instance", "b" -> "b from instance", "c" -> "c from instance")
			val object = new FieldsStringOnly
			object.a should be null
			object.b should be null
			object.c should be null
			
			subject.populate(object, map)
			object.a should be "a from instance"
			object.b should be "b from instance"
			object.c should be "c from instance"
		}
	}
	
	context "with a class"{
		fact "when the class contains only String type properties"{
			val map = newHashMap("a" -> "a from class", "b" -> "b from class", "c" -> "c from class")

			val object = subject.create(FieldsStringOnly, map) as FieldsStringOnly
			object.a should be "a from class"
			object.b should be "b from class"
			object.c should be "c from class"
		}
	}
}
	
