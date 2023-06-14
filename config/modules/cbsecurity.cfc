component {

	function configure(){
		return {
			/**
			 * --------------------------------------------------------------------------
			 * Authentication Services
			 * --------------------------------------------------------------------------
			 * https://coldbox-security.ortusbooks.com/getting-started/configuration/authentication
			 *
			 * Here you will configure which service is in charge of providing authentication for your application.
			 * By default we leverage the cbauth module which expects you to connect it to a database via your own User Service.
			 *
			 * Available authentication providers:
			 * - cbauth : Leverages your own UserService that determines authentication and user retrieval
			 * - basicAuth : Leverages basic authentication and basic in-memory user registration in our configuration
			 * - custom : Any other service that adheres to our IAuthService interface
			 */
			authentication : {
				// The WireBox ID of the auth service to use which must adhere to the cbsecurity.interfaces.IAuthService interface.
				"provider"        : "authenticationService@cbauth",
				// The name of the variable to use to store an authenticated user in prc scope on all incoming authenticated requests
				"prcUserVariable" : "oCurrentUser"
			},
			/**
			 * --------------------------------------------------------------------------
			 * Basic Auth
			 * --------------------------------------------------------------------------
			 * https://coldbox-security.ortusbooks.com/getting-started/configuration/basic-auth
			 *
			 * If you are using the basicAuth authentication provider, then you can configure it here, else ignore or remove.
			 */
			basicAuth : {
				// Hashing algorithm to use
				hashAlgorithm  : "SHA-512",
				// Iterates the number of times the hash is computed to create a more computationally intensive hash.
				hashIterations : 5,
				// User storage: The `key` is the username. The value is the user credentials that can include
				// { roles: "", permissions : "", firstName : "", lastName : "", password : "" }
				users          : {}
			},
			/**
			 * --------------------------------------------------------------------------
			 * Firewall Settings
			 * --------------------------------------------------------------------------
			 * https://coldbox-security.ortusbooks.com/getting-started/configuration/firewall
			 *
			 * The firewall is used to block/check access on incoming requests via security rules or via annotation on handler actions.
			 * Here you can configure the operation of the firewall and especially what Validator will be in charge of verifying authentication/authorization
			 * during a matched request.
			 */
			firewall : {
				// Auto load the global security firewall automatically, else you can load it a-la-carte via the `Security` interceptor
				"autoLoadFirewall"            : true,
				// The Global validator is an object that will validate the firewall rules and annotations and provide feedback on either authentication or authorization issues.
				"validator"                   : "JwtAuthValidator@cbsecurity",
				// Activate handler/action based annotation security
				"handlerAnnotationSecurity"   : true,
				// The global invalid authentication event or URI or URL to go if an invalid authentication occurs
				"invalidAuthenticationEvent"  : "echo.onAuthenticationFailure",
				// Default Auhtentication Action: override or redirect when a user has not logged in
				"defaultAuthenticationAction" : "override",
				// The global invalid authorization event or URI or URL to go if an invalid authorization occurs
				"invalidAuthorizationEvent"   : "echo.onAuthorizationFailure",
				// Default Authorization Action: override or redirect when a user does not have enough permissions to access something
				"defaultAuthorizationAction"  : "override",
				// Firewall database event logs.
				"logs"                        : {
					"enabled"    : false,
					"dsn"        : "",
					"schema"     : "",
					"table"      : "cbsecurity_logs",
					"autoCreate" : true
				},
				// Firewall Rules, this can be a struct of detailed configuration
				// or a simple array of inline rules
				"rules" : {
					// Use regular expression matching on the rule match types
					"useRegex" : true,
					// Force SSL for all relocations
					"useSSL"   : false,
					// A collection of default name-value pairs to add to ALL rules
					// This way you can add global roles, permissions, redirects, etc
					"defaults" : {},
					// You can store all your rules in this inline array
					"inline"   : [],
					// If you don't store the rules inline, then you can use a provider to load the rules
					// The source can be a json file, an xml file, model, db
					// Each provider can have it's appropriate properties as well. Please see the documentation for each provider.
					"provider" : { "source" : "", "properties" : {} }
				}
			},
			/**
			 * --------------------------------------------------------------------------
			 * Json Web Tokens
			 * --------------------------------------------------------------------------
			 * https://coldbox-security.ortusbooks.com/getting-started/configuration/jwt
			 *
			 * Here you configure how JSON Web Tokens are created, validated and stored.
			 */
			jwt : {
				// The issuer authority for the tokens, placed in the `iss` claim
				issuer                     : "",
				// The jwt secret encoding key, defaults to getSystemEnv( "JWT_SECRET", "" )
				// This key is only effective within the `config/Coldbox.cfc`. Specifying within a module does nothing.
				secretKey                  : getSystemSetting( "JWT_SECRET", "" ),
				// by default it uses the authorization bearer header, but you can also pass a custom one as well.
				customAuthHeader           : "x-auth-token",
				// The expiration in minutes for the jwt tokens
				expiration                 : 60,
				// If true, enables refresh tokens, token creation methods will return a struct instead
				// of just the access token. e.g. { access_token: "", refresh_token : "" }
				enableRefreshTokens        : false,
				// The default expiration for refresh tokens, defaults to 30 days
				refreshExpiration          : 10080,
				// The Custom header to inspect for refresh tokens
				customRefreshHeader        : "x-refresh-token",
				// If enabled, the JWT validator will inspect the request for refresh tokens and expired access tokens
				// It will then automatically refresh them for you and return them back as
				// response headers in the same request according to the customRefreshHeader and customAuthHeader
				enableAutoRefreshValidator : false,
				// Enable the POST > /cbsecurity/refreshtoken API endpoint
				enableRefreshEndpoint      : true,
				// encryption algorithm to use, valid algorithms are: HS256, HS384, and HS512
				algorithm                  : "HS512",
				// Which claims neds to be present on the jwt token or `TokenInvalidException` upon verification and decoding
				requiredClaims             : [],
				// The token storage settings
				tokenStorage               : {
					// enable or not, default is true
					"enabled"    : true,
					// A cache key prefix to use when storing the tokens
					"keyPrefix"  : "cbjwt_",
					// The driver to use: db, cachebox or a WireBox ID
					"driver"     : "cachebox",
					// Driver specific properties
					"properties" : { cacheName : "default" }
				}
			},
			/**
			 * --------------------------------------------------------------------------
			 * Security Headers
			 * --------------------------------------------------------------------------
			 * https://coldbox-security.ortusbooks.com/getting-started/configuration/security-headers
			 *
			 * This section is the way to configure cbsecurity for header detection, inspection and setting for common
			 * security exploits like XSS, ClickJacking, Host Spoofing, IP Spoofing, Non SSL usage, HSTS and much more.
			 */
			securityHeaders : {
				// If you trust the upstream then we will check the upstream first for specific headers
				"trustUpstream"         : false,
				// Content Security Policy
				// Content Security Policy (CSP) is an added layer of security that helps to detect and mitigate certain types of attacks,
				// including Cross-Site Scripting (XSS) and data injection attacks. These attacks are used for everything from data theft, to
				// site defacement, to malware distribution.
				// https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP
				"contentSecurityPolicy" : {
					// Disabled by defautl as it is totally customizable
					"enabled" : false,
					// The custom policy to use, by default we don't include any
					"policy"  : ""
				},
				// The X-Content-Type-Options response HTTP header is a marker used by the server to indicate that the MIME types advertised in
				// the Content-Type headers should be followed and not be changed => X-Content-Type-Options: nosniff
				// https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Content-Type-Options
				"contentTypeOptions" : { "enabled" : true },
				"customHeaders"      : {
					 // Name : value pairs as you see fit.
				},
				// Disable Click jacking: X-Frame-Options: DENY OR SAMEORIGIN
				// https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options
				"frameOptions" : { "enabled" : true, "value" : "SAMEORIGIN" },
				// HTTP Strict Transport Security (HSTS)
				// The HTTP Strict-Transport-Security response header (often abbreviated as HSTS)
				// informs browsers that the site should only be accessed using HTTPS, and that any future attempts to access it
				// using HTTP should automatically be converted to HTTPS.
				// https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security,
				"hsts"         : {
					"enabled"           : true,
					// The time, in seconds, that the browser should remember that a site is only to be accessed using HTTPS, 1 year is the default
					"max-age"           : "31536000",
					// See Preloading Strict Transport Security for details. Not part of the specification.
					"preload"           : false,
					// If this optional parameter is specified, this rule applies to all of the site's subdomains as well.
					"includeSubDomains" : false
				},
				// Validates the host or x-forwarded-host to an allowed list of valid hosts
				"hostHeaderValidation" : {
					"enabled"      : false,
					// Allowed hosts list
					"allowedHosts" : ""
				},
				// Validates the ip address of the incoming request
				"ipValidation" : {
					"enabled"    : false,
					// Allowed IP list
					"allowedIPs" : ""
				},
				// The Referrer-Policy HTTP header controls how much referrer information (sent with the Referer header) should be included with requests.
				// Aside from the HTTP header, you can set this policy in HTML.
				// https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy
				"referrerPolicy"     : { "enabled" : true, "policy" : "same-origin" },
				// Detect if the incoming requests are NON-SSL and if enabled, redirect with SSL
				"secureSSLRedirects" : { "enabled" : false },
				// Some browsers have built in support for filtering out reflected XSS attacks. Not foolproof, but it assists in XSS protection.
				// https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-XSS-Protection,
				// X-XSS-Protection: 1; mode=block
				"xssProtection"      : { "enabled" : true, "mode" : "block" }
			},
			/**
			 * --------------------------------------------------------------------------
			 * Security Visualizer
			 * --------------------------------------------------------------------------
			 * https://coldbox-security.ortusbooks.com/getting-started/configuration/visualizer
			 *
			 * This is a debugging panel that when active, a developer can visualize security settings and more.
			 * You can use the `securityRule` to define what rule you want to use to secure the visualizer but make sure the `secured` flag is turned to true.
			 * You don't have to specify the `secureList` key, we will do that for you.
			 */
			visualizer : {
				"enabled"      : false,
				"secured"      : false,
				"securityRule" : {}
			},
			/**
			 * --------------------------------------------------------------------------
			 * Cross Site Request Forgery (CSRF)
			 * --------------------------------------------------------------------------
			 * https://coldbox-security.ortusbooks.com/getting-started/configuration/csrf
			 *
			 * This section is the way to configure cbsecurity for CSRF detection and mitigation.
			 */
			csrf : {
				// By default we load up an interceptor that verifies all non-GET incoming requests against the token validations
				enableAutoVerifier     : false,
				// A list of events to exclude from csrf verification, regex allowed: e.g. stripe\..*
				verifyExcludes         : [],
				// By default, all csrf tokens have a life-span of 30 minutes. After 30 minutes, they expire and we aut-generate new ones.
				// If you do not want expiring tokens, then set this value to 0
				rotationTimeout        : 30,
				// Enable the /cbcsrf/generate endpoint to generate cbcsrf tokens for secured users.
				enableEndpoint         : false,
				// The WireBox mapping to use for the CacheStorage
				cacheStorage           : "CacheStorage@cbstorages",
				// Enable/Disable the cbAuth login/logout listener in order to rotate keys
				enableAuthTokenRotator : true
			}
		};
	}

}
