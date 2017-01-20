/**
* My RESTFul Event Handler
*/
component extends="BaseHandler"{
	
	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only 	= "";
	this.prehandler_except 	= "";
	this.posthandler_only 	= "";
	this.posthandler_except = "";
	this.aroundHandler_only = "";
	this.aroundHandler_except = "";		

	// REST Allowed HTTP Methods Ex:
	// this.allowedMethods={
	// 	'index'		= METHODS.GET ,
	// 	'list'		= METHODS.GET,
	// 	'get' 		= METHODS.GET,
	// 	'create' 	= METHODS.POST,
	// 	'update' 	= METHODS.PUT & ',' & METHODS.PATCH,
	// 	'delete'	= METHODS.DELETE
	// };

	this.allowedMethods = {"index":METHODS.GET};
	
	/**
	* Index
	*/
	any function index( event, rc, prc ){
		prc.response.setData( {"echo":"Welcome to my ColdBox RESTFul Service"} );
	}
	
}