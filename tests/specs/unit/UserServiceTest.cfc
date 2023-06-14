component extends="coldbox.system.testing.BaseTestCase" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "UserService", function(){
			beforeEach( function( currentSpec ){
				setup();
				model = getInstance( "UserService" );
			} );

			it( "can be created", function(){
				expect( model ).toBeComponent();
			} );

			it( "can get a valid mock user by id", function(){
				var oUser = model.retrieveUserById( 1 );
				expect( oUser.getId() ).toBe( 1 );
				expect( oUser.isLoaded() ).toBeTrue();
			} );

			it( "can get a new mock user with invalid id", function(){
				var oUser = model.retrieveUserById( 100 );
				expect( oUser.getId() ).toBe( "" );
				expect( oUser.isLoaded() ).toBeFalse();
			} );

			it( "can get a valid mock user by username", function(){
				var oUser = model.retrieveUserByUsername( "admin" );
				expect( oUser.getId() ).toBe( 1 );
				expect( oUser.isLoaded() ).toBeTrue();
			} );

			it( "can get a new mock user with invalid username", function(){
				var oUser = model.retrieveUserByUsername( "bogus@admin" );
				expect( oUser.getId() ).toBe( "" );
				expect( oUser.isLoaded() ).toBeFalse();
			} );

			it( "can validate valid credentials", function(){
				var result = model.isValidCredentials( "admin", "admin" );
				expect( result ).toBeTrue();
			} );

			it( "can validate invalid credentials", function(){
				var result = model.isValidCredentials( "badadmin", "dd" );
				expect( result ).toBeFalse();
			} );
		} );
	}

}
