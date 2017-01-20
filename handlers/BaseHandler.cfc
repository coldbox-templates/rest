/**
* ********************************************************************************
* Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ********************************************************************************
* Base RESTFul handler spice up as needed.
* This handler will create a Response model and prepare it for your actions to use
* to produce RESTFul responses.
*/
component extends="coldbox.system.EventHandler"{
	property name="METHODS";
	property name="STATUS";

	//Verb aliases - in case we are dealing with legacy browsers or servers ( e.g. IIS7 default )
	METHODS = {
		"HEAD":"HEAD",
		"GET":"GET",
		"POST":"POST",
		"PATCH":"PATCH",
		"PUT":"PUT",
		"DELETE":"DELETE"
	};
	
	//HTTP STATUS CODES
	STATUS = {
		"CREATED":201,
		"ACCEPTED":202,
		"SUCCESS":200,
		"NO_CONTENT":204,
		"RESET":205,
		"PARTIAL_CONTENT":206,
		"BAD_REQUEST":400,
		"NOT_AUTHORIZED":401,
		"NOT_FOUND":404,
		"NOT_ALLOWED":405,
		"NOT_ACCEPTABLE":406,
		"TOO_MANY_REQUESTS":429,
		"EXPECTATION_FAILED":417,
		"INTERNAL_ERROR":500,
		"NOT_IMPLEMENTED":501
	};
	

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only 		= "";
	this.prehandler_except 		= "";
	this.posthandler_only 		= "";
	this.posthandler_except 	= "";
	this.aroundHandler_only 	= "";
	this.aroundHandler_except 	= "";		

	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {};
	
	/**
	* Around handler for all actions it inherits
	*/
	function aroundHandler( event, rc, prc, targetAction, eventArguments ){
		try{
			// start a resource timer
			var stime = getTickCount();
			// prepare our response object
			prc.response = getModel( "Response" );
			// prepare argument execution
			var args = { event = ARGUMENTS.event, rc = ARGUMENTS.rc, prc = ARGUMENTS.prc };
			structAppend( args, ARGUMENTS.eventArguments );
			// Incoming Format Detection
			if( structKeyExists( rc, "format") ){
				prc.response.setFormat( rc.format );
			}
			// Execute action
			ARGUMENTS.targetAction( argumentCollection=args );
		} catch( Any e ){
			// Log Locally
			log.error( "Error calling #event.getCurrentEvent()#: #e.message# #e.detail#", e );
			// Setup General Error Response
			prc.response
				.setError( true )
				.addMessage( "General application error: #e.message#" )
				.setStatusCode( STATUS.INTERNAL_ERROR )
				.setStatusText( "General application error" );
			// Development additions
			if( getSetting( "environment" ) eq "development" ){
				prc.response.addMessage( "Detail: #e.detail#" )
					.addMessage( "StackTrace: #e.stacktrace#" );
			}
		}
		
		// Development additions
		if( getSetting( "environment" ) eq "development" ){
			prc.response.addHeader( "x-current-route", event.getCurrentRoute() )
				.addHeader( "x-current-routed-url", event.getCurrentRoutedURL() )
				.addHeader( "x-current-routed-namespace", event.getCurrentRoutedNamespace() )
				.addHeader( "x-current-event", event.getCurrentEvent() );
		}
		// end timer
		prc.response.setResponseTime( getTickCount() - stime );

		if( prc.response.getDataPacket().error ){

			var responseData = prc.response.getDataPacket( reset=true )

		} else {

			var responseData = prc.response.getDataPacket().data;

		}
		
		// Magical renderings
		event.renderData( 
			type		= prc.response.getFormat(),
			data 		= responseData,
			contentType = prc.response.getContentType(),
			statusCode 	= prc.response.getStatusCode(),
			statusText 	= prc.response.getStatusText(),
			location 	= prc.response.getLocation(),
			isBinary 	= prc.response.getBinary()
		);
		
		// Global Response Headers
		prc.response.addHeader( "x-response-time", prc.response.getResponseTime() )
				.addHeader( "x-cached-response", prc.response.getCachedResponse() );
		
		// Response Headers
		for( var thisHeader in prc.response.getHeaders() ){
			event.setHTTPHeader( name=thisHeader.name, value=thisHeader.value );
		}
	}

	/**
	* on localized errors
	*/
	function onError( event, rc, prc, faultAction, exception, eventArguments ){
		// Log Locally
		log.error( "Error in base handler (#ARGUMENTS.faultAction#): #ARGUMENTS.exception.message# #ARGUMENTS.exception.detail#", ARGUMENTS.exception );
		
		// Verify response exists, else create one
		if( !structKeyExists( prc, "response" ) ){ prc.response = getModel( "Response" ); }
		
		// Setup General Error Response
		prc.response
			.setError( true )
			.addMessage( "Base Handler Application Error: #ARGUMENTS.exception.message#" )
			.setStatusCode( STATUS.INTERNAL_ERROR )
			.setStatusText( "General application error" );
		
		// Development additions
		if( getSetting( "environment" ) eq "development" ){
			prc.response.addMessage( "Detail: #ARGUMENTS.exception.detail#" )
				.addMessage( "StackTrace: #ARGUMENTS.exception.stacktrace#" );
		}
		
		// Render Error Out
		event.renderData( 
			type		= prc.response.getFormat(),
			data 		= prc.response.getDataPacket( reset=true ),
			contentType = prc.response.getContentType(),
			statusCode 	= prc.response.getStatusCode(),
			statusText 	= prc.response.getStatusText(),
			location 	= prc.response.getLocation(),
			isBinary 	= prc.response.getBinary()
		);
	}

	/**
	* on invalid http verbs
	*/
	function onInvalidHTTPMethod( event, rc, prc, faultAction, eventArguments ){
		// Log Locally
		log.warn( "Invalid HTTP Method Execution of (#ARGUMENTS.faultAction#): #event.getHTTPMethod()#", getHTTPRequestData() );
		// Setup Response
		prc.response = getModel( "Response" )
			.setError( true )
			.addMessage( "Invalid HTTP Method Execution of (#ARGUMENTS.faultAction#): #event.getHTTPMethod()#" )
			.setStatusCode( STATUS.NOT_ALLOWED )
			.setStatusText( "Invalid HTTP Method" );
		// Render Error Out
		event.renderData( 
			type		= prc.response.getFormat(),
			data 		= prc.response.getDataPacket( reset=true ),
			contentType = prc.response.getContentType(),
			statusCode 	= prc.response.getStatusCode(),
			statusText 	= prc.response.getStatusText(),
			location 	= prc.response.getLocation(),
			isBinary 	= prc.response.getBinary()
		);
	}


	/**
	* Invalid method execution
	**/
	function onMissingAction(event,rc,prc,missingAction,eventArguments){
		// Log Locally
		log.warn( "Invalid HTTP Method Execution of (#ARGUMENTS.missingAction#): #event.getHTTPMethod()#", getHTTPRequestData() );
		// Setup Response
		prc.response = getModel( "Response" )
			.setError( true )
			.addMessage( "Action '#arguments.missingAction#' could not be found" )
			.setStatusCode( STATUS.NOT_ALLOWED )
			.setStatusText( "Invalid Action" );
		// Render Error Out
		event.renderData( 
			type		= prc.response.getFormat(),
			data 		= prc.response.getDataPacket( reset=true ),
			contentType = prc.response.getContentType(),
			statusCode 	= prc.response.getStatusCode(),
			statusText 	= prc.response.getStatusText(),
			location 	= prc.response.getLocation(),
			isBinary 	= prc.response.getBinary()
		);			
	}


	/**
	* Utility methods for RESTful responses
	**/

	/**
	* Utility function for miscellaneous 404's
	**/
	public function fourOhFour( event, rc, prc ){
		
		if( !structKeyExists( prc, "response" ) ){
			prc.response = getModel( "Response" );
		}

		prc.response.setError( true )
			.setStatusCode( STATUS.NOT_FOUND )
			.setStatusText( "Not Found" )
			.addMessage( "The object requested could not be found" )
	}

	function onExpectationFailed( 
		event=getRequestContext(), 
		rc=getRequestCollection(), 
		prc=getRequestCollection(private=true) 
	){
		if( !structKeyExists( prc, "response" ) ){
			prc.response = getModel( "Response" );
		}

		prc.response.setError( true )
			.setStatusCode( STATUS.EXPECTATION_FAILED )
			.setStatusText( "Expectation Failed" )
			.addMessage( "An expectation for the request failed. Could not proceed" ) 			
	}

	/**
	* Render the failure of authorization
	**/
	function onAuthorizationFailure( 
		event=getRequestContext(), 
		rc=getRequestCollection(), 
		prc=getRequestCollection(private=true), 
		abort=false 
	){
		if( !structKeyExists( prc, "response" ) ){
			prc.response = getModel( "Response" );
		}

		Log.warn( "Authorization Failure", getHTTPRequestData() );

		prc.response.setError( true )
			.setStatusCode( STATUS.NOT_AUTHORIZED )
			.setStatusText( "Unauthorized Resource" )
			.addMessage( "Your permissions do not allow this operation" ) 

		/**
		* When you need a really hard stop to prevent further execution ( use as last resort )
		**/
		if( ARGUMENTS.abort ){

			cfheader(
	        	name = "Content-Type",
	        	value = "application/json"
		    );
			
			cfheader(
	        	statusCode = "#STATUS.NOT_AUTHORIZED#",
	        	statusText = "Not Authorized"
		    );

		    var response = prc.response.getDataPacket( reset=true );

			writeOutput( serializeJSON( response ) );
			flush;
			abort;	
		}
	}

	/**
	* Throttles the number of requests for a resource
	* Logs out the user on failure and displays the limit message
	**/
	public function throttleRequests( 
		max=5, 
		roles, 
		event=getRequestContext()
	){
		var rc=getRequestCollection();
		var prc = event.getCollection( private=true );
		// Exit out if sessions are not enabled
		if( !APPLICATION.getApplicationSettings().sessionManagement ) return;
		
		var request_key = lCase( REReplace( event.getCurrentRoutedURL(), '[^A-Za-z0-9]', '_', 'all' ) );

		if( isNull( ARGUMENTS.roles ) || isUserInAnyRole( roles ) ){

			if( !structKeyExists( session, 'requestThrottle' ) ) session.requestThrottle={};
			
			if( !structKeyExists( session.requestThrottle, request_key ) );
			
			session.requestThrottle[request_key]=0;
			
			session.requestThrottle[request_key]++;

			if( session.requestThrottle[request_key] > arguments.max ){

				cflogout();

				prc.response.setError( true )
					.addMessage( "You have exceeded the allowed number of requests for this resource" );
				
				cfheader(
		        	name = "Content-Type",
		        	value = "application/json"
			    );
				
				cfheader(
		        	statusCode = "#STATUS.TOO_MANY_REQUESTS#",
		        	statusText = "Resource Request Limit Exceeded"
			    );

			    writeOutput( serializeJSON( prc.response.getDataPacket( reset=true ) ) );

				// hard exit, to prevent further execution
				flush;
				abort;
			}
		}
	}


}