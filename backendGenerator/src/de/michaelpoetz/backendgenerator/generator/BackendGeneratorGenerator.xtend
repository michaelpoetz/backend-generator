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
			fsa.generateFile(m.name.toFirstUpper + '.java', m.generateEntity);	
		}
	}
	
	def CharSequence generateEntity(Model model)'''
	package «model.package»;
	
	//TODO Generate imports by pressing your IDEs hot key combination

	/**
	 * «model.comment»
	 * 
	 * @since «model.since»
	 */
	@Entity
	@Table(name="«model.name.toLowerCase»")
	public class «model.name.toFirstUpper» {
		
		«FOR p : model.properties »
			@Column(name="«p.name.toLowerCase»")
			private «p.string» «p.name»;
			
		«ENDFOR»
		
		«FOR p : model.properties »
			public «p.string» get«p.name.toFirstUpper»(){
				return this.«p.name»;
			};
			
			public void set«p.name.toFirstUpper»(«p.string» «p.name»){
				this.«p.name» = «p.name»;
			}
			
		«ENDFOR»
		
		@Override
		public String toString(){
			return "«model.name.toFirstUpper» [«FOR p : model.properties» «p.name»="+this.«p.name»+"«IF !(p == model.properties.last)»,«ENDIF» «ENDFOR»]";
		}
	}
	'''
	
}
