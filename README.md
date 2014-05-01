backend-generator
=================

Create a model for your system's backend in a simple DSL. This program then generates Java classes from Entity to Webservice including test classes for Bean and Webservice.

* This project is still in early development phase.


Prerequisites
=============
* This project relies on Xtext, an Eclipse plugin for DSLs.
  -> https://www.eclipse.org/Xtext/index.html
* The generator is written in Xtend (which comes with Xtext
  -> https://www.eclipse.org/xtend/index.html)


What's working already?
=======================
* Generate Entity-classes
* Adds Annotations (Entity, Table, Column) by guessing table names and column names
* Adds a toString-method for all fields 
* Generates a Javadoc-comment including "since" field

