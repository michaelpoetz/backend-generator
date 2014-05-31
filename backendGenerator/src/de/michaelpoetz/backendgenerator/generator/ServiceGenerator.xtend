package de.michaelpoetz.backendgenerator.generator

import de.michaelpoetz.backendgenerator.backendGenerator.Configuration
import de.michaelpoetz.backendgenerator.backendGenerator.Model
import org.eclipse.xtext.generator.IFileSystemAccess

/**
 * Generator for API, Bean and Test.
 */
class ServiceGenerator extends BackendGeneratorGenerator {
	
	new(IFileSystemAccess fsa, Model m, Configuration c) {
		CONFIG = c;
		CLASS_NAME = m.name.toFirstUpper;
		VARIABLE_NAME = m.name.toFirstLower;
		PATH = m.package.replace(".", "/") + "/";
		ID_TYPE = "";
		ID_VALUE = "";
		if (CONFIG.interface != null) {
			fsa.generateFile("main/java/" + PATH + "service/api/" + CLASS_NAME + CONFIG.interface + ".java", m.generateRepository);
		}
		fsa.generateFile("main/java/" + PATH + "service/" + CLASS_NAME + CONFIG.service + ".java", m.generateBean);
		if (CONFIG.service_test != null) {
			fsa.generateFile("test/java/it/" + PATH + "service/" + CLASS_NAME + CONFIG.service_test + ".java", m.generateBeanIT);
		}
	}
	
	def String generateRepository(Model model)'''
	package «model.package».service.api;
	
	/**
	 * This is the Interface for the service operations for the «CLASS_NAME».
	 * 
	 * @since «model.since»
	 */
	 public interface «CLASS_NAME»«CONFIG.interface» {
	 	
	 	/**
	 	 * Saves a «CLASS_NAME» object.
	 	 * @param «VARIABLE_NAME» - the «CLASS_NAME» object to be saved.
	 	 * @return the persisted «CLASS_NAME» object.
	 	 * @since «model.since»
	 	 */
	 	«CLASS_NAME» save«CLASS_NAME»(final «CLASS_NAME» «VARIABLE_NAME»);
	 	
	 	/**
	 	 * Updates a «CLASS_NAME» object.
	 	 * @param «VARIABLE_NAME» - the «CLASS_NAME» object to be updated and saved.
	 	 * @return the updated and persisted «CLASS_NAME» object.
	 	 * @since «model.since»
	 	 */
	 	«CLASS_NAME» edit«CLASS_NAME»(final «CLASS_NAME» «VARIABLE_NAME»);
	 	
	 	/**
	 	 * Deletes a «CLASS_NAME» object with the given ID.
	 	 * @param «ID_VALUE» - the ID of the «CLASS_NAME» object to be deleted.
	 	 * @since «model.since»
	 	 */
	 	void delete«CLASS_NAME»(final «ID_TYPE» «ID_VALUE»);
	 	
	 	/**
	 	 * Retrieves all «CLASS_NAME» objects.
	 	 * @return the list of «CLASS_NAME» objects.
	 	 * @since «model.since»
	 	 */
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
	 @Stateless
	 public class «CLASS_NAME»«CONFIG.service» implements «CLASS_NAME»«CONFIG.interface» {
	 	
	 	@PersistenceContext(unitName = "default")
	 	private EntityManager em;
	 	
	 	@Override
	 	public «CLASS_NAME» save«CLASS_NAME»(final «CLASS_NAME» «VARIABLE_NAME»){
	 		«IF CONFIG.exception != null»
	 		Set<ConstraintViolation<«CLASS_NAME»>> errors = validator.validate(«VARIABLE_NAME»);
	 		if(!errors.isEmpty()){
	 			throw new «CONFIG.exception»;
	 		}
	 		«ENDIF»
	 		em.persist(«VARIABLE_NAME»);
	 		em.flush();
	 		em.refresh(«VARIABLE_NAME»);
	 		return «VARIABLE_NAME»;
	 	}
	 	
	 	@Override
	 	public «CLASS_NAME» edit«CLASS_NAME»(final «CLASS_NAME» «VARIABLE_NAME»){
	 		«IF CONFIG.exception != null»
	 		Set<ConstraintViolation<«CLASS_NAME»>> errors = validator.validate(«VARIABLE_NAME»);
	 		if(!errors.isEmpty()){
	 			throw new «CONFIG.exception»;
	 		}
	 		«ENDIF»
	 		em.merge(«VARIABLE_NAME»);
	 		em.flush();
	 		//em.refresh(«VARIABLE_NAME»);
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
	 «IF CONFIG.testConfig.testrunner != null»@RunWith(«CONFIG.testConfig.testrunner».class)«ENDIF»
	 public class «CLASS_NAME»«CONFIG.service_test» «IF CONFIG.testConfig.parent != null»«CONFIG.testConfig.parent»«ENDIF» {
	 	
	 	@Inject
	 	private «CLASS_NAME»«CONFIG.interface» «VARIABLE_NAME»«CONFIG.service»;
	 	
	 	@Test
	 	public void shouldSave«CLASS_NAME»(){
	 		assertTrue(false);
	 	}
	 	
	 	@Test
	 	public void shouldEdit«CLASS_NAME»(){
	 		assertTrue(false);
	 	}
	 	
	 	@Test
	 	public void shouldDelete«CLASS_NAME»(){
	 		assertTrue(false);
	 	}
	 	
	 	@Test
	 	public void shouldGet«CLASS_NAME»(){
	 		assertTrue(false);
	 	}
	 }
	'''
}