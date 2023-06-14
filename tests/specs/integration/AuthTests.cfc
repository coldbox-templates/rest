component extends="coldbox.system.testing.BaseTestCase" autowire {

	property name="jwtService" inject="provider:JwtService@cbsecurity";
	property name="cbauth"     inject="provider:authenticationService@cbauth";

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "RESTFul Authentication", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();

				// Make sure nothing is logged in to start our calls
				cbauth.logout();
				jwtService.getTokenStorage().clearAll();
			} );

			story( "I want to authenticate a user and receive a JWT token", function(){
				given( "a valid username and password", function(){
					then( "I will be authenticated and will receive the JWT token", function(){
						// Use a user in the seeded db
						var event = this.post(
							route  = "/api/login",
							params = { username : "admin", password : "admin" }
						);
						var response = event.getPrivateValue( "Response" );
						expect( response.getError() ).toBeFalse( response.getMessages().toString() );
						expect( response.getData() ).toBeString();

						// debug( response.getData() );

						var decoded = jwtService.decode( response.getData() );
						expect( decoded.sub ).toBe( 1 );
						expect( decoded.exp ).toBeGTE( dateAdd( "h", 1, decoded.iat ) );
					} );
				} );
				given( "invalid username and password", function(){
					then( "I will receive a 401 exception ", function(){
						var event = this.post(
							route  = "/api/login",
							params = { username : "invalid", password : "invalid" }
						);
						var response = event.getPrivateValue( "Response" );
						expect( response.getError() ).toBeTrue();
						expect( response.getStatusCode() ).toBe( 401 );
					} );
				} );
			} );

			story( "I want to register into the system", function(){
				given( "valid registration details", function(){
					then( "I should register, log in and get a token", function(){
						// Use a user in the seeded db
						var event = this.post(
							route  = "/api/register",
							params = {
								firstName : "luis",
								lastName  : "majano",
								username  : "lmajano@coldbox.org",
								password  : "lmajano"
							}
						);
						var response = event.getPrivateValue( "Response" );
						expect( response.getError() ).toBeFalse( response.getMessages().toString() );
						expect( response.getData() ).toHaveKey( "token,user" );

						// debug( response.getData() );

						var decoded = jwtService.decode( response.getData().token );
						expect( decoded.sub ).toBe( response.getData().user.id );
						expect( decoded.exp ).toBeGTE( dateAdd( "h", 1, decoded.iat ) );
					} );
				} );
				given( "invalid registration details", function(){
					then( "I should get an error message", function(){
						var event    = this.post( route = "/api/register", params = {} );
						var response = event.getPrivateValue( "Response" );
						// debug( response.getMemento() );
						expect( response.getError() ).toBeTrue();
						expect( response.getStatusCode() ).toBe( 400 );
					} );
				} );
			} );

			story( "I want to be able to logout from the system using my JWT token", function(){
				given( "a valid incoming jwt token", function(){
					then( "my token should become invalidated and I will be logged out", function(){
						// Log in first to get a valid token to logout with
						var token   = jwtService.attempt( "admin", "admin" );
						var payload = jwtService.decode( token );
						expect( cbauth.isLoggedIn() ).toBeTrue();

						// Now Logout
						var event = this.post( route = "/api/logout", params = { "x-auth-token" : token } );

						var response = event.getPrivateValue( "Response" );
						expect( response.getError() ).toBeFalse( response.getMessages().toString() );
						expect( response.getStatusCode() ).toBe( 200 );
						expect( cbauth.isLoggedIn() ).toBeFalse();
					} );
				} );
				given( "an invalid incoming jwt token", function(){
					then( "I should see an error message", function(){
						// Now Logout
						var event = this.post( route = "/api/logout", params = { "x-auth-token" : "123" } );

						var response = event.getPrivateValue( "Response" );
						expect( response.getError() ).toBeTrue( response.getMessages().toString() );
						// debug( response.getStatusCode( 500 ) );
					} );
				} );
			} );
		} );
	}

}
