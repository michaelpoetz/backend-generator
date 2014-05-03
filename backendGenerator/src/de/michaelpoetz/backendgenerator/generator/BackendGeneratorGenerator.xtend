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
	
	static String CLASS_NAME;
	static String VARIABLE_NAME;
	static String PATH;
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		for(Model m : resource.allContents.filter(typeof(Model)).toIterable){
			CLASS_NAME = m.name.toFirstUpper;
			VARIABLE_NAME = m.name.toFirstLower;
			PATH = m.package.replace(".", "/") + "/";
			fsa.generateFile("main/java/" + PATH + m.name.toFirstUpper + ".java", m.generateEntity);
			fsa.generateFile("main/java/" + PATH + m.name.toFirstUpper + "Repository.java", m.generateRepository);
			fsa.generateFile("main/java/" + PATH + m.name.toFirstUpper + "Bean.java", m.generateBean);
			fsa.generateFile("test/java/it/" +m.package.split(".").last + "/" + m.name.toFirstUpper + "BeanIT.java", m.generateBeanIT);	
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
	public class «CLASS_NAME» {
		
		«FOR p : model.properties »
			«FOR a : p.annotations»
			«IF !a.name.startsWith("@")»@«ENDIF»«a.name»
			«ENDFOR»
			@Column(name="«p.name.toLowerCase»")
			private «p.type» «p.name»;
			
		«ENDFOR»
		«FOR p : model.properties »
			public «p.type» get«p.name.toFirstUpper»(){
				return this.«p.name»;
			};
			
			public void set«p.name.toFirstUpper»(«p.type» «p.name»){
				this.«p.name» = «p.name»;
			}
			
		«ENDFOR»
		@Override
		public String toString(){
			return "«CLASS_NAME» [«FOR p : model.properties» «p.name»="+this.«p.name»+"«IF !(p == model.properties.last)»,«ENDIF» «ENDFOR»]";
		}
	}
	'''
	
	def String generateRepository(Model model)'''
	package «model.package.replace("entity","service.api")»;
	
	/**
	 * This is the Interface for the service operations for the «CLASS_NAME».
	 * 
	 * @since «model.since»
	 */
	 public interface «CLASS_NAME»Repository {
	 	
	 	«CLASS_NAME» save«CLASS_NAME»(final «CLASS_NAME» «VARIABLE_NAME»);
	 	
	 	«CLASS_NAME» edit«CLASS_NAME»(final «CLASS_NAME» «VARIABLE_NAME»);
	 	
	 	// TODO Determine id type
	 	void delete«CLASS_NAME»();
	 	
	 	List<«CLASS_NAME»> getAll«CLASS_NAME»s();
	 }
	'''
	
	def String generateBean(Model model)'''
	package «model.package.replace("entity","service")»;
	
	/**
	 * This is the implementing class for the service operations for the «CLASS_NAME».
	 * 
	 * @since «model.since»
	 */
	 public class «CLASS_NAME»Bean implements «CLASS_NAME»Repository {
	 	
	 	@PersistenceContext(unitName = "default")
	 	private EntityManager em;
	 	
	 	@Override
	 	public «CLASS_NAME» save«CLASS_NAME»(final «CLASS_NAME» «VARIABLE_NAME»){
	 		return null;
	 	}
	 	
	 	@Override
	 	public «CLASS_NAME» edit«CLASS_NAME»(final «CLASS_NAME» «VARIABLE_NAME»){
	 		return null;
	 	}
	 	
	 	// TODO Determine id type
	 	@Override
	 	public void delete«CLASS_NAME»(){
	 		
	 	}
	 	
	 	@Override
	 	public List<«CLASS_NAME»> getAll«CLASS_NAME»s(){
	 		return null;
	 	}
	 }
	'''
	
	def String generateBeanIT(Model model)'''
	package it.«model.package.split(".").last»;
	
	/**
	 * Class under Test: «CLASS_NAME»Bean.
	 * 
	 * @since «model.since»
	 */
	 public class «CLASS_NAME»BeanIT {
	 	
	 	@Inject
	 	private «CLASS_NAME»Repository «VARIABLE_NAME»Bean;
	 	
	 	@Test
	 	public void shouldSave«CLASS_NAME»(){
	 		fail();
	 	}
	 	
	 	@Test
	 	public void shouldEdit«CLASS_NAME»(){
	 		fail();
	 	}
	 	
	 	@Test
	 	public void shouldDelete«CLASS_NAME»(){
	 		fail();
	 	}
	 	
	 	@Test
	 	public void shouldGet«CLASS_NAME»(){
	 		fail();
	 	}
	 }
	'''
	
}
