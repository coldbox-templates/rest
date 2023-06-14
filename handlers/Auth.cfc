/**
 * Authentication Handler
 */
component extends="coldbox.system.RestHandler" {

	// Injection
	property name="userService" inject="UserService";

	/**
	 * Login a user into the application
	 *
	 * @x           -route          (POST) /api/login
	 * @requestBody ~auth/login/requestBody.json
	 * @response    -default ~auth/login/responses.json##200
	 * @response    -401     ~auth/login/responses.json##401
	 */
	function login( event, rc, prc ){
		param rc.username = "";
		param rc.password = "";

		// This can throw a InvalidCredentials exception which is picked up by the REST handler
		var token = jwtAuth().attempt( rc.username, rc.password );

		event
			.getResponse()
			.setData( token )
			.addMessage(
				"Bearer token created and it expires in #jwtAuth().getSettings().jwt.expiration# minutes"
			);
	}

	/**
	 * Register a new user in the system
	 *
	 * @x           -route          (POST) /api/register
	 * @requestBody ~auth/register/requestBody.json
	 * @response    -default ~auth/register/responses.json##200
	 * @response    -400     ~auth/register/responses.json##400
	 */
	function register( event, rc, prc ){
		param rc.firstName = "";
		param rc.lastName  = "";
		param rc.username  = "";
		param rc.password  = "";

		// Populate, Validate, Create a new user
		prc.oUser = userService.create( populateModel( "User" ).validateOrFail() );

		// Log them in if it was created!
		event
			.getResponse()
			.setData( {
				"token" : jwtAuth().fromuser( prc.oUser ),
				"user"  : prc.oUser.getMemento()
			} )
			.addMessage(
				"User registered correctly and Bearer token created and it expires in #jwtAuth().getSettings().jwt.expiration# minutes"
			);
	}

	/**
	 * Logout a user
	 *
	 * @x        -route          (POST) /api/logout
	 * @security bearerAuth,ApiKeyAuth
	 * @response -default ~auth/logout/responses.json##200
	 * @response -500     ~auth/logout/responses.json##500
	 */
	function logout( event, rc, prc ){
		jwtAuth().logout();
		event.getResponse().addMessage( "Successfully logged out" )
	}

}
