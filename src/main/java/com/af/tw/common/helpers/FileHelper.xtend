package com.af.tw.common.helpers

import java.io.File
import java.util.List
import java.util.HashMap
import java.util.Map
import java.util.regex.Pattern
import org.slf4j.LoggerFactory
import org.reflections.Reflections
import org.reflections.util.ConfigurationBuilder
import org.reflections.scanners.ResourcesScanner
import org.reflections.util.ClasspathHelper
import static extension org.apache.commons.io.FileUtils.*
import java.util.Set

/**
 * @MONO_STATE
 * Handles common I/O tasks from a centralized class
 */
class FileHelper {
	val LOG = LoggerFactory.getLogger(this.class)
	static var Set<String> resources

	static var isInitialized = false;

	public new() {
		LOG.trace("attempting to initialize {}", this.class)
		if(!isInitialized) {
			LOG.trace("{} was not previously initialized", this.class)
			resources = new Reflections(
				new ConfigurationBuilder().setUrls(
					ClasspathHelper.forPackage("com.af.tw")).setScanners(
					new ResourcesScanner())).getResources(
				Pattern.compile(".*(\\.csv|\\.conf|\\.txt|\\.xpi)"))
			isInitialized = true
		} else {
			LOG.trace("{} was already initialized, see the resources: {}",
				this.class, resources)
		}
	}

	/**
	* FOR INTERNAL USE ONLY
	* gets the uri of resource
	* @Param the name of the resource file (expected to be on the classpath)
	* @Return the URI for the named resource
	*/
	package def getResourceUri(String resourceName) {
		LOG.trace("getting URI for: {}", resourceName)

		//FileHelper class used as a guaranteed-to-exist reference point
		this.class.getResource(resourceName).toURI
	}

	/**
	* @param the name of the resource file (expected to be on the classpath)
	* @Return the File Located associated with that resource name
	*/
	def getResourceAsFile(String resourceName) {

		//ensure the file is coming from either com.inadco.acceptance or undertest 
		LOG.trace("getting resource: {} as a file", resourceName)
		var uri = (File.separator + resources.filter[
			it.endsWith(resourceName)].head).resourceUri

		if(uri == null) {
			LOG.error("no file was found for resource: {}", resourceName)
			throw new IllegalArgumentException
		}
		val f = new File(uri)
		LOG.trace("{} was found at: {}", resourceName, f.canonicalPath)

		f
	}

	/**
	* FOR INTERNAL USE ONLY
	* @param a File to read
	* @return the file's contents as a list of lines
	*/
	package def List<String> asList(File file) {
		file.readLines.toList
	}

	/**
	* @param a resource to read
	* @return the file's contents as a list of lines
	*/
	def List<String> asList(String resourceName) {
		resourceName.resourceAsFile.asList
	}

	/**
	* FOR INTERNAL USE ONLY
	* @param a File to read
	* the file should have a header row and it should be tab-separated 
	* @return the file's contents as a mapped list of lines (header-row derived)
	*/
	package def List<Map<String, String>> asMapsList(File file) {
		LOG.trace("creating maps list from file: {} located at: {}", file.name,
			file.canonicalPath)
		val List<String> lines = file.asList
		val headerRow = lines.head.replaceAll(" ", "").toLowerCase.split('\t').
			toList

		val unfilteredElements = lines.map [ row |
			//skip header row and comments, capture all others
			if(row.equals(lines.head) || row.startsWith('//') ||
				row.startsWith('#')) {
				return null
			} else {
				val cell = row.split('\t').toList

				//create a map: header(key), cell(value)
				val map = new HashMap<String, String>
				headerRow.forEach[
					map.put(it, cell.get(headerRow.indexOf(it)))]
				LOG.trace("the map: {}", map)

				//create an Element using the map
				map as Map<String, String>
			}
		]

		unfilteredElements.filterNull.toList

	}

	/**
	* @param a File to read
	* the file should have a header row and it should be tab-separated 
	* @return the file's contents as a mapped list of lines (header-row derived)
	*/
	def List<Map<String, String>> asMapsList(String resourceName) {
		resourceName.resourceAsFile.asMapsList
	}

}
