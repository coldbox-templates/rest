component {

	/**
	 * CBSwagger Configuration
	 * https://github.com/coldbox-modules/cbswagger
	 */
	function configure(){
		return {
			// The route prefix to search.  Routes beginning with this prefix will be determined to be api routes
			"routes"        : [ "api" ],
			// Any routes to exclude
			"excludeRoutes" : [],
			// The default output format: json or yml
			"defaultFormat" : "json",
			// A convention route, relative to your app root, where request/response samples are stored ( e.g. resources/apidocs/responses/[module].[handler].[action].[HTTP Status Code].json )
			"samplesPath"   : "resources/apidocs",
			// Information about your API
			"info"          : {
				// A title for your API
				"title"          : "ColdBox REST Template",
				// A description of your API
				"description"    : "This API produces amazing results and data.",
				// A terms of service URL for your API
				"termsOfService" : "",
				// The contact email address
				"contact"        : {
					"name"  : "API Support",
					"url"   : "https://www.swagger.io/support",
					"email" : "info@ortussolutions.com"
				},
				// A url to the License of your API
				"license" : {
					"name" : "Apache 2.0",
					"url"  : "https://www.apache.org/licenses/LICENSE-2.0.html"
				},
				// The version of your API
				"version" : "1.0.0"
			},
			// Tags
			"tags"         : [],
			// https://swagger.io/specification/#externalDocumentationObject
			"externalDocs" : {
				"description" : "Find more info here",
				"url"         : "https://blog.readme.io/an-example-filled-guide-to-swagger-3-2/"
			},
			// https://swagger.io/specification/#serverObject
			"servers" : [
				{
					"url"         : "https://mysite.com/v1",
					"description" : "The main production server"
				},
				{
					"url"         : "http://127.0.0.1:60299",
					"description" : "The dev server"
				}
			],
			// An element to hold various schemas for the specification.
			// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#componentsObject
			"components" : {
				// Define your security schemes here
				// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#securitySchemeObject
				"securitySchemes" : {
					"ApiKeyAuth" : {
						"type"        : "apiKey",
						"description" : "User your JWT as an Api Key for security",
						"name"        : "x-api-key",
						"in"          : "header"
					},
					"bearerAuth" : {
						"type"         : "http",
						"scheme"       : "bearer",
						"bearerFormat" : "JWT"
					}
				}
			}

			// A default declaration of Security Requirement Objects to be used across the API.
			// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#securityRequirementObject
			// Only one of these requirements needs to be satisfied to authorize a request.
			// Individual operations may set their own requirements with `@security`
			// "security" : [
			//	{ "APIKey" : [] },
			//	{ "UserSecurity" : [] }
			// ]
		};
	}

}
