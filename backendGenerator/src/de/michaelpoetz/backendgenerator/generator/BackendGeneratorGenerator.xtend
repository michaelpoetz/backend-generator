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
			fsa.generateFile(m.name.toFirstUpper + ".java", m.generateEntity);
			fsa.generateFile(m.name.toFirstUpper + "Repository.java", m.generateRepository);
			fsa.generateFile(m.name.toFirstUpper + "Bean.java", m.generateBean);
			fsa.generateFile(m.name.toFirstUpper + "BeanIT.java", m.generateBeanIT);	
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
	
	def String generateRepository(Model model)'''
	package «model.package.replace("entity","service.api")»;
	
	/**
	 * This is the Interface for the service operations for the «model.name.toFirstUpper».
	 * 
	 * @since «model.since»
	 */
	 public interface «model.name.toFirstUpper»Repository {
	 	
	 	«model.name.toFirstUpper» save«model.name.toFirstUpper»(final «model.name.toFirstUpper» «model.name.toFirstLower»);
	 	
	 	«model.name.toFirstUpper» edit«model.name.toFirstUpper»(final «model.name.toFirstUpper» «model.name.toFirstLower»);
	 	
	 	// TODO Determine id type
	 	void delete«model.name.toFirstUpper»();
	 	
	 	List<«model.name.toFirstUpper»> getAll«model.name.toFirstUpper»s();
	 }
	'''
	
	def String generateBean(Model model)'''
	package «model.package.replace("entity","service")»;
	
	/**
	 * This is the implementing class for the service operations for the «model.name.toFirstUpper».
	 * 
	 * @since «model.since»
	 */
	 public class «model.name.toFirstUpper»Bean implements «model.name.toFirstUpper»Repository {
	 	
	 	@Override
	 	public «model.name.toFirstUpper» save«model.name.toFirstUpper»(final «model.name.toFirstUpper» «model.name.toFirstLower»){
	 		return null;
	 	}
	 	
	 	@Override
	 	public «model.name.toFirstUpper» edit«model.name.toFirstUpper»(final «model.name.toFirstUpper» «model.name.toFirstLower»){
	 		return null;
	 	}
	 	
	 	// TODO Determine id type
	 	@Override
	 	public void delete«model.name.toFirstUpper»(){
	 		
	 	}
	 	
	 	@Override
	 	public List<«model.name.toFirstUpper»> getAll«model.name.toFirstUpper»s(){
	 		return null;
	 	}
	 }
	'''
	
	def String generateBeanIT(Model model)'''
	package it.«model.package.split(".").last»;
	
	/**
	 * Class under Test: «model.name.toFirstUpper»Bean.
	 * 
	 * @since «model.since»
	 */
	 public class «model.name.toFirstUpper»BeanIT {
	 	
	 }
	'''
	
}
