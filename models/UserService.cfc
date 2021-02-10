component accessors="true" singleton {

	/**
	 * --------------------------------------------------------------------------
	 * DI
	 * --------------------------------------------------------------------------
	 */

	property name="populator" inject="wirebox:populator";

	/**
	 * --------------------------------------------------------------------------
	 * Properties
	 * --------------------------------------------------------------------------
	 */
	// TODO: Mock users, remove when coding
	property name="mockUsers";

	/**
	 * Constructor
	 */
	function init() {
		// We are mocking only 1 user right now, update as you see fit
		variables.mockUsers = [
			{
				"id"       : 1,
				"fname"    : "admin",
				"lname"    : "admin",
				"email"    : "admin@coldbox.org",
				"password" : "admin"
			}
		];

		return this;
	}

	/**
	 * Construct a new user object via WireBox
	 */
	User function new() provider="User" {}

	/**
	 * Create a new user in the system
	 *
	 * @user The user to create
	 *
	 * @return The created user
	 */
	User function create( required user ) {
		arguments.user.setId( createUUID() );

		variables.mockUsers.append( {
			"id"       : arguments.user.getId(),
			"fname"    : arguments.user.getId(),
			"lname"    : arguments.user.getId(),
			"email"    : arguments.user.getId(),
			"password" : arguments.user.getId()
			
		} );
		return arguments.user;
	}

	/**
	 * Verify if the incoming username/password are valid credentials.
	 *
	 * @username The username
	 * @password The password
	 */
	boolean function isValidCredentials( required username, required password ) {
		var oTarget = retrieveUserByUsername( arguments.username );
		if ( !oTarget.isLoaded() ) {
			return false;
		}

		// Check Password Here: Remember to use bcrypt
		return ( oTarget.getPassword().compareNoCase( arguments.password ) == 0 );
	}

	/**
	 * Retrieve a user by username
	 *
	 * @return User that implements JWTSubject and/or IAuthUser
	 */
	function retrieveUserByUsername( required username ) {
		return variables.mockUsers
			.filter( function( record ) {
				return arguments.record.email == username;
			} )
			.reduce( function( result, record ) {
				return variables.populator.populateFromStruct(
					target : arguments.result,
					memento: arguments.record
				);
			}, new () );
	}

	/**
	 * Retrieve a user by unique identifier
	 *
	 * @id The unique identifier
	 *
	 * @return User that implements JWTSubject and/or IAuthUser
	 */
	User function retrieveUserById( required id ) {
		return variables.mockUsers
			.filter( function( record ) {
				return arguments.record.id == id;
			} )
			.reduce( function( result, record ) {
				return variables.populator.populateFromStruct(
					target : arguments.result,
					memento: arguments.record
				);
			}, new () );
	}

}
