package de.michaelpoetz.backendgenerator.generator

import de.michaelpoetz.backendgenerator.backendGenerator.App
import de.michaelpoetz.backendgenerator.backendGenerator.Configuration
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
	
	protected String CLASS_NAME;
	protected String VARIABLE_NAME;
	protected String PATH;
	protected String ID_TYPE;
	protected String ID_VALUE;
	
	protected Configuration CONFIG;
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		var a = resource.allContents.filter(typeof(App)).head;
		CONFIG = a.importConfig;
		
		for(Model m : resource.allContents.filter(typeof(Model)).toIterable){
			CLASS_NAME = m.name.toFirstUpper;
			VARIABLE_NAME = m.name.toFirstLower;
			PATH = m.package.replace(".", "/") + "/";
			ID_TYPE = "";
			ID_VALUE = "";
			fsa.generateFile("main/java/" + PATH + "entity/" + CLASS_NAME + ".java", m.generateEntity);
			new POMGenerator(fsa, m);
			new ServiceGenerator(fsa, m, CONFIG);
			new WebserviceGenerator(fsa,m, CONFIG);	
		}
	}
	/**
	 * These methods avoid the print of the variables in the template when they are assigned like this «ID_VALUE = p.name»
	 */
	def void assignIdType(String type){
		ID_TYPE = type;
	}
	def void assignIdName(String name){
		ID_VALUE = name;
	}
	
	/**
	 * This method generates the basic entity. Service and Webservice and the respective tests are generated in separate classes.
	 */
	def CharSequence generateEntity(Model model)'''
	package «model.package».entity;

	//TODO Generate imports by pressing your IDEs hot key combination

	/**
	 * «model.comment»
	 * 
	 * @since «model.since»
	 */
	@Entity
	@Table(name="«model.name.toLowerCase»")
	@NamedQueries({
	 	@NamedQuery(name=«CLASS_NAME».Query.GET_ALL_«CLASS_NAME.toUpperCase», query="SELECT x FROM «CLASS_NAME» x")
	 })
	public class «CLASS_NAME» {
		
		/**
		 * Queries for working with «CLASS_NAME» objects.
		 */
		public static final class Query {
			public final static String GET_ALL_«CLASS_NAME.toUpperCase» = "«CLASS_NAME».Query.getAll«CLASS_NAME»"
		}
		
		«FOR p : model.properties »
			«FOR a : p.annotations»
			@«a.name»
			«IF a.name.equals("Id")»
			«p.type.assignIdType»
			«p.name.assignIdName»
			«ENDIF»
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
}
