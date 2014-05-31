package de.michaelpoetz.backendgenerator.generator

import de.michaelpoetz.backendgenerator.backendGenerator.Model
import java.io.File
import org.eclipse.xtext.generator.IFileSystemAccess

/**
 * Simple pom.xml generator.
 */
class POMGenerator extends BackendGeneratorGenerator {
	
	/**
	 * Constructor checks, if pom already in the project's classpath.
	 */
	new(IFileSystemAccess fsa, Model m) {
		var File f = new File("pom.xml");
		if (!f.exists){
			fsa.generateFile("pom.xml", m.generatePOM);
		}
	}
	
	/**
	 * This method can be used to generate a POM-file for the generated project.
	 * Required packages can be added here and can be downloaded on mvn targets.
	 */
	def generatePOM(Model m)'''
	<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	    <modelVersion>4.0.0</modelVersion>
	    <groupId>«m.package.substring(0,m.package.lastIndexOf("."))»</groupId>
	    <artifactId>MyProject</artifactId>
	    <version>1.0-SNAPSHOT</version>
	    <packaging>war</packaging>
	    <dependencies>
	        <dependency>
	            <groupId>javax</groupId>
	            <artifactId>javaee-api</artifactId>
	            <version>7.0</version>
	            <scope>provided</scope>
	        </dependency>
	        <dependency>
	            <groupId>javax.ws.rs</groupId>
	            <artifactId>jsr311-api</artifactId>
	            <version>1.1.1</version>
	        </dependency>
	    </dependencies>
	    <build>
	        <finalName>MyProject</finalName>
	    </build>
	    <properties>
	        <maven.compiler.source>1.8</maven.compiler.source>
	        <maven.compiler.target>1.8</maven.compiler.target>
	        <failOnMissingWebXml>false</failOnMissingWebXml>
	    </properties>
    </project>
	'''
	
}