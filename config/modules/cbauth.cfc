component {

	/**
	 * Configure CBAuth for operation
	 * https://cbauth.ortusbooks.com/installation-and-usage#configuration
	 */
	function configure(){
		return {
			/**
			 *--------------------------------------------------------------------------
			 * User Service Class
			 *--------------------------------------------------------------------------
			 * The user service class to use for authentication which must implement IUserService
			 * https://cbauth.ortusbooks.com/iuserservice
			 * The User object that this class returns must implement IUser as well
			 * https://cbauth.ortusbooks.com/iauthuser
			 */
			"userServiceClass" : "UserService",
			/**
			 *-------------------------------------------------------------------------
			 * Storage Classes
			 *-------------------------------------------------------------------------
			 * Which storages to use for tracking session and the request scope
			 */
			"sessionStorage" : "SessionStorage@cbstorages",
			"requestStorage" : "RequestStorage@cbstorages"
		};
	}

}
