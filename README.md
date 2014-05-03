backend-generator
=================

Create a model for your system's backend in a simple DSL. This program then generates Java classes from Entity to Webservice including test classes for Bean and Webservice.

* **This project is still in early development phase.**
* Classes use Java EE specific classes, like EntityManager, Annotations like Inject, PersistenceContext, Table, Entity, Column etc.
* This is, because it's specifically designed with a project I am working on in mind.

Prerequisites
-------------
* This project relies on Xtext, an Eclipse plugin for DSLs.
  -> https://www.eclipse.org/Xtext/index.html
* The generator is written in Xtend (which comes with Xtext
  -> https://www.eclipse.org/xtend/index.html)

What's working already?
-----------------------
* Generate Entity-classes
* Adds Annotations (Entity, Table, Column) by guessing table names and column names
* Adds a toString-method for all fields 
* Generates a Javadoc-comment including "since" field
* Generates simple interface (Repository) and implementing Bean
* Generates empty Test-class

TODO
----
* Write a configuration file
	* configure which Exception should be thrown (if any)
	* should DTOs be generated and how
	* configure generation path

