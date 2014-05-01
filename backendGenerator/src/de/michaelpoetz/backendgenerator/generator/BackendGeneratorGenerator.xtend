package de.michaelpoetz.backendgenerator.generator

import de.michaelpoetz.backendgenerator.backendGenerator.Model
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator

/**
 * Generates code from your model files on save.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#TutorialCodeGeneration
 */
class BackendGeneratorGenerator implements IGenerator {
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		for(Model m : resource.allContents.filter(typeof(Model)).toIterable){
			fsa.generateFile(m.name + '.txt', m.generate);	
		}
	}
	
	def CharSequence generate(Model model){
		return "Test"
	}
	
}
