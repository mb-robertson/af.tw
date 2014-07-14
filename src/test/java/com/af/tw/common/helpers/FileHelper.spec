package com.af.tw.common.helpers

import java.io.File
import java.net.URI
import java.util.List
import java.util.Map

import static extension com.af.tw.common.helpers.FileHelper.*

describe FileHelper {
	val resourcesPath = "/com/af/tw/resources/"

	context "when file exists"{
		val fileName = "fileHelper.txt"
		fact "resourceUri returns requested URI"{
			val uri = (resourcesPath + fileName).resourceUri
			uri should be URI
			uri.toString should contain fileName
		}
	
		fact "resourceAsFile returns requested File"{
			val file = fileName.resourceAsFile
			file should be File
			file.exists should be true
			file.absolutePath should contain fileName
			
		}
		
	}
	
	context "when file doesn't exist"{
		val fileName = "DOES_NOT_EXIST.txt"
		fact "resourceUri throws an exception"{
			(resourcesPath + fileName).resourceUri throws Exception
		}
		
		fact "resourceAsFile throws an exception"{
			fileName.resourceAsFile throws Exception
			
		}
	}
	
	context "with a file that contains a list"{
		val list = "list.txt".resourceAsFile.asList

		def checkTable {
			| listPosition | expectedContents|
			| 0            | "Line 1"        |
			| 1            | "Line 2"        |
			| 2            | "Line 3"        |
		}
		
		fact "asList is a list from the file"{
			list should be List
		}
		
		fact "asList's list should contain Strings"{
			list.forEach[it should be String]
		}
		
		fact "asList's list should contain the expected content"{
			checkTable.forEach[list.get(listPosition) should be expectedContents]
		}
	}
	
	context "with a resource that contains a list" {
		val List<String> list = "list.txt".asList
	


		def checkTable {
			| listPosition | expectedContents|
			| 0            | "Line 1"        |
			| 1            | "Line 2"        |
			| 2            | "Line 3"        |
		}
		
		fact "asList is a list from the file"{
			list should be List
		}
		
		fact "asList's list should contain Strings"{
			list.forEach[it should be String]
		}
		
		fact "asList's list should contain the expected content"{
			checkTable.forEach[list.get(listPosition) should be expectedContents]
		}
	}
	
	context "with a csv file"{
		val mapsList = "mapsList.csv".resourceAsFile.asMapsList

		def checkTable {
			| listPosition | expectedContents                                              |
			| 0            | newHashMap("h1" -> "H1_V1", "h2" -> "H2_V1", "h3" -> "H3_V1") |
			| 1            | newHashMap("h1" -> "H1_V2", "h2" -> "H2_V2", "h3" -> "H3_V2") |
		}

		fact "asMapsList is a list of maps from the file"{
			mapsList should be List
		}
		
		fact "asMapsList's list should contain Maps"{
			checkTable.forEach[mapsList.get(listPosition) should be Map]
		}
		fact "asMapsList's list should contain the content"{
			checkTable.forEach[
				mapsList.get(listPosition).equals(expectedContents) should be true
			]
		}
	}

	context "with a csv resource"{
		val mapsList = "mapsList.csv".asMapsList

		def checkTable {
			| listPosition | expectedContents                                              |
			| 0            | newHashMap("h1" -> "H1_V1", "h2" -> "H2_V1", "h3" -> "H3_V1") |
			| 1            | newHashMap("h1" -> "H1_V2", "h2" -> "H2_V2", "h3" -> "H3_V2") |
		}

		fact "asMapsList is a list of maps from the file"{
			mapsList should be List
		}
		
		fact "asMapsList's list should contain Maps"{
			checkTable.forEach[mapsList.get(listPosition) should be Map]
		}
		fact "asMapsList's list should contain the content"{
			checkTable.forEach[
				mapsList.get(listPosition).equals(expectedContents) should be true
			]
		}
	}
	

	context "special cases with a csv file" {
			val specialCasesMapsList = "specialCasesMapsList.csv".resourceAsFile.asMapsList
		
		fact "header entries are converted to lowercase"{
			specialCasesMapsList.forEach[
				it.keySet.forEach[it.matches(".*[A-Z].*") should be false]
			]

		}

		fact "spaces are removed from header entries"{
			specialCasesMapsList.forEach[
				it.keySet.forEach[it.matches(".*[ ].*") should be false]
			]			
		}
		
		fact "// (double-slash) commented lines are ignored"{
			specialCasesMapsList.forEach[
				it.values.forEach[it.equals("double-slash comment") should be false]
			]
		}
		
		fact "# (octothorp) commented lines are ignored"{
						specialCasesMapsList.forEach[
				it.values.forEach[it.equals("octothorp comment") should be false]
			]
		}
	}
	
	
}
