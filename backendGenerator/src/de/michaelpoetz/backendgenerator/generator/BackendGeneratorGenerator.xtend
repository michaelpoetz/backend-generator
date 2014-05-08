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
	
	private static String CLASS_NAME;
	private static String VARIABLE_NAME;
	private static String PATH;
	private static String ID_TYPE;
	private static String ID_VALUE;
	
	private Configuration CONFIG;
	
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
			if (CONFIG.interface != null) fsa.generateFile("main/java/" + PATH + "service/api/" + CLASS_NAME + CONFIG.interface + ".java", m.generateRepository);
			fsa.generateFile("main/java/" + PATH + "service/" + CLASS_NAME + CONFIG.service + ".java", m.generateBean);
			if (CONFIG.service_test != null) fsa.generateFile("test/java/it/" + PATH + "service/" + CLASS_NAME + CONFIG.service_test + ".java", m.generateBeanIT);
			if (CONFIG.webservice != null) fsa.generateFile("main/java/" + PATH + "webservice/" + CLASS_NAME + CONFIG.webservice + ".java", m.generateWebservice);
			if (CONFIG.webservice_test != null) fsa.generateFile("test/java/it/" + PATH + "webservice/" + CLASS_NAME + CONFIG.webservice_test + ".java", m.generateWebserviceIT);	
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
	public class «CLASS_NAME» {
		
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
	
	def String generateRepository(Model model)'''
	package «model.package».service.api;
	
	/**
	 * This is the Interface for the service operations for the «CLASS_NAME».
	 * 
	 * @since «model.since»
	 */
	 public interface «CLASS_NAME»«CONFIG.interface» {
	 	
	 	«CLASS_NAME» save«CLASS_NAME»(final «CLASS_NAME» «VARIABLE_NAME»);
	 	
	 	«CLASS_NAME» edit«CLASS_NAME»(final «CLASS_NAME» «VARIABLE_NAME»);
	 	
	 	void delete«CLASS_NAME»(final «ID_TYPE» «ID_VALUE»);
	 	
	 	List<«CLASS_NAME»> getAll«CLASS_NAME»s();
	 }
	'''
	
	def String generateBean(Model model)'''
	package «model.package».service;
	
	/**
	 * This is the implementing class for the service operations for the «CLASS_NAME».
	 * 
	 * @since «model.since»
	 */
	 public class «CLASS_NAME»«CONFIG.service» implements «CLASS_NAME»«CONFIG.interface» {
	 	
	 	@PersistenceContext(unitName = "default")
	 	private EntityManager em;
	 	
	 	@Override
	 	public «CLASS_NAME» save«CLASS_NAME»(final «CLASS_NAME» «VARIABLE_NAME»){
	 		«IF CONFIG.exception != null»
	 		Set<ConstraintViolation<«CLASS_NAME»>> errors = validator.validate(«VARIABLE_NAME»);
	 		if(!errors.isEmpty()){
	 			throw new «CONFIG.exception»();
	 		}
	 		«ENDIF»
	 		em.persist(«VARIABLE_NAME»);
	 		em.flush();
	 		em.refresh(«VARIABLE_NAME»);
	 		return «VARIABLE_NAME»;
	 	}
	 	
	 	@Override
	 	public «CLASS_NAME» edit«CLASS_NAME»(final «CLASS_NAME» «VARIABLE_NAME»){
	 		Set<ConstraintViolation<«CLASS_NAME»>> errors = validator.validate(«VARIABLE_NAME»);
	 		if(!errors.isEmpty()){
	 			throw new ConstraintViolationException();
	 		}
	 		em.merge(«VARIABLE_NAME»);
	 		em.flush();
	 		em.refresh(«VARIABLE_NAME»);
	 		return «VARIABLE_NAME»;
	 	}
	 	
	 	@Override
	 	public void delete«CLASS_NAME»(final «ID_TYPE» «ID_VALUE»){
	 		em.remove(«ID_VALUE»);
	 	}
	 	
	 	@Override
	 	public List<«CLASS_NAME»> getAll«CLASS_NAME»s(){
	 		// TODO Use EntityManager to retrieve List ... Usually with a NamedQuery
	 		return new List<«CLASS_NAME»>();
	 	}
	 }
	'''
	
	def String generateBeanIT(Model model)'''
	package it.«model.package».service;
	
	/**
	 * Class under Test: «CLASS_NAME»«CONFIG.service».
	 * 
	 * @since «model.since»
	 */
	 «IF CONFIG.testrunner != null»@RunWith(«CONFIG.testrunner».class)«ENDIF»
	 public class «CLASS_NAME»«CONFIG.service_test» {
	 	
	 	@Inject
	 	private «CLASS_NAME»«CONFIG.interface» «VARIABLE_NAME»«CONFIG.service»;
	 	
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
	
	def String generateWebservice(Model model)'''
	package «model.package».webservice;
	
	/**
	 *
	 * @since «model.since»
	 */
	 @Path("/rs/«CLASS_NAME.toLowerCase»")
	 public class «CLASS_NAME»«CONFIG.webservice» {
	 	
	 	// TODO MediaTypes angeben
	 	@GET
	 	@Consumes()
	 	@Produces()
	 	public Response get«CLASS_NAME»s(){
	 		return Response.ok().build();
	 	}
	 	
	 	@POST
	 	@Consumes()
	 	@Produces()
	 	public Response create«CLASS_NAME»(){
	 		return Response.ok().build();
	 	}
	 	
	 	@PUT
	 	@Consumes()
	 	@Produces()
	 	public Response edit«CLASS_NAME»(){
	 		return Response.ok().build();
	 	}
	 	
	 	@DELETE
	 	@Consumes()
	 	@Produces()
	 	public Response delete«CLASS_NAME»(){
	 		return Response.ok().build();
	 	}
	 }
	'''
	def String generateWebserviceIT(Model model)'''
	package it.«model.package».webservice;
	
	/**
	 * Class under Test: «CLASS_NAME»«CONFIG.webservice».
	 * 
	 * @since «model.since»
	 */
	 «IF CONFIG.testrunner != null»@RunWith(«CONFIG.testrunner».class)«ENDIF»
	 public class «CLASS_NAME»«CONFIG.webservice_test» {
	 	
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
