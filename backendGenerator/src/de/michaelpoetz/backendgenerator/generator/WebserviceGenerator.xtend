package de.michaelpoetz.backendgenerator.generator

import de.michaelpoetz.backendgenerator.backendGenerator.Configuration
import de.michaelpoetz.backendgenerator.backendGenerator.Model
import org.eclipse.xtext.generator.IFileSystemAccess

/**
 * Webservice (& -Test) generator.
 */
class WebserviceGenerator extends BackendGeneratorGenerator {
	
	new(IFileSystemAccess fsa, Model m, Configuration c){
		CONFIG = c;
		CLASS_NAME = m.name.toFirstUpper;
		VARIABLE_NAME = m.name.toFirstLower;
		PATH = m.package.replace(".", "/") + "/";
		ID_TYPE = "";
		ID_VALUE = "";
		if (CONFIG.webservice != null) fsa.generateFile("main/java/" + PATH + "webservice/" + CLASS_NAME + CONFIG.webservice + ".java", m.generateWebservice);
		if (CONFIG.webservice_test != null) fsa.generateFile("test/java/it/" + PATH + "webservice/" + CLASS_NAME + CONFIG.webservice_test + ".java", m.generateWebserviceIT);
	}
	
	def String generateWebservice(Model model)'''
	package «model.package».webservice;
	
	/**
	 * This is the Webservice for handling the «CLASS_NAME» objects.
	 * @since «model.since»
	 */
	 @Stateless
	 @Path("/«CLASS_NAME.toLowerCase»")
	 public class «CLASS_NAME»«CONFIG.webservice» {
	 	
	 	@Inject
	 	private «CLASS_NAME»«CONFIG.interface» «VARIABLE_NAME»«CONFIG.service»;
	 	
	 	@GET
	 	@Produces(MediaType.APPLICATION_JSON)
	 	public Response get«CLASS_NAME»s(){
	 		return Response.ok(«VARIABLE_NAME»«CONFIG.service».get«CLASS_NAME»s()).build();
	 	}
	 	
	 	@POST
	 	@Consumes(MediaType.APPLICATION_JSON)
	 	@Produces(MediaType.APPLICATION_JSON)
	 	public Response create«CLASS_NAME»(final «CLASS_NAME» «VARIABLE_NAME»){
	 		return Response.ok(«VARIABLE_NAME»«CONFIG.service».save«CLASS_NAME»(«VARIABLE_NAME»)).build();
	 	}
	 	
	 	@PUT
	 	@Path("/edit")
	 	@Consumes(MediaType.APPLICATION_JSON)
	 	@Produces(MediaType.APPLICATION_JSON)
	 	public Response edit«CLASS_NAME»(final «CLASS_NAME» «VARIABLE_NAME»){
	 		return Response.ok(«VARIABLE_NAME»«CONFIG.service».edit«CLASS_NAME»(«VARIABLE_NAME»)).build();
	 	}
	 	
	 	@DELETE
	 	@Path("/delete/{id}")
	 	@Produces(MediaType.APPLICATION_JSON)
	 	public Response delete«CLASS_NAME»(@PathParam("id") final «ID_TYPE» «ID_VALUE»){
	 		return Response.ok(«VARIABLE_NAME»«CONFIG.service».delete«CLASS_NAME»(«ID_VALUE»)).build();
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
	 «IF CONFIG.testConfig.testrunner != null»@RunWith(«CONFIG.testConfig.testrunner».class)«ENDIF»
	 public class «CLASS_NAME»«CONFIG.webservice_test» {
	 	
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