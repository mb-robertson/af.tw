package com.af.tw.xfeatures

Feature: Populate instances of a class
	In order to have non-hard coded instances of certain classes
	As an af.tw user
	I want a facility for populating class instances using data stored in a csv

	Scenario: Use a basic csv to populate a 
	Given I have a csv file: "FieldsBooleanOnly.csv"
	And an instance of "FieldsBoolean"
	When I populate that instance
	Then that instance's content should match "FieldsBooleanExpected" 
	