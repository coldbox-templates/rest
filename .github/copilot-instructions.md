# ColdBox REST API Template - AI Coding Instructions

This is a ColdBox template specialized for building RESTful APIs with JWT authentication, OpenAPI/Swagger documentation, and security via CBSecurity. Compatible with Adobe ColdFusion, Lucee, and BoxLang.

## 🏗️ Architecture Overview

**Key Design Decision**: This template extends `coldbox.system.RestHandler` instead of the standard `EventHandler`, providing built-in REST capabilities including automatic error handling, content negotiation, and response formatting.

### Directory Structure

```
/                      - Application root (webroot)
├── Application.cfc    - Bootstrap with flat structure
├── index.cfm          - Front controller
├── config/            - Configuration
│   ├── ColdBox.cfc   - Framework settings
│   └── Router.cfc    - RESTful route definitions
├── handlers/          - REST handlers (extend RestHandler)
│   ├── Echo.cfc      - Example API endpoint
│   └── Auth.cfc      - Authentication endpoints
├── models/            - Business logic
│   ├── User.cfc      - User entity with delegates
│   └── UserService.cfc - IUserService implementation
├── resources/         - API documentation
│   └── apidocs/      - OpenAPI/Swagger specs
└── lib/               - Framework dependencies
    ├── coldbox/      - ColdBox framework
    └── testbox/      - TestBox testing
```

### Key Dependencies (box.json)

- **coldbox** - HMVC framework
- **cbsecurity** (^3.0.0) - JWT authentication and authorization
- **mementifier** (^3.3.0) - Entity serialization
- **cbvalidation** (^4.1.0) - Validation framework
- **relax** (^4.1.0) - REST API visualizer (dev)
- **route-visualizer** - Route debugging tool (dev)

## 📝 REST Handler Patterns

**CRITICAL**: All API handlers extend `coldbox.system.RestHandler`, NOT `EventHandler`:

```cfml
component extends="coldbox.system.RestHandler" {

    // HTTP Method security - RestHandler enforces these
    this.allowedMethods = {
        "index"  : "GET",
        "create" : "POST",
        "update" : "PUT,PATCH",
        "delete" : "DELETE"
    };

    /**
     * OpenAPI annotations in doc blocks
     * @x        -route     (GET) /api/echo
     * @response -default   ~echo/index/responses.json##200
     */
    function index(event, rc, prc){
        // RestHandler provides event.getResponse()
        event.getResponse().setData("Welcome to my API");
    }

    /**
     * Secured endpoint using CBSecurity
     * @x        -route     (GET) /api/whoami
     * @security bearerAuth,ApiKeyAuth
     * @response -default   ~echo/whoami/responses.json##200
     * @response -401       ~echo/whoami/responses.json##401
     */
    function whoami(event, rc, prc) secured {
        // jwtAuth() helper provided by CBSecurity
        event.getResponse().setData(
            jwtAuth().getUser().getMemento()
        );
    }
}
```

### RestHandler Built-in Features

**Automatic Error Handling**:
- `onError()` - Catches all runtime exceptions
- `onInvalidHTTPMethod()` - Handles wrong HTTP methods
- `onMissingAction()` - Handles 404s

**HTTP Constants**:
```cfml
// Available in all RestHandlers
METHODS.GET, METHODS.POST, METHODS.PUT, METHODS.PATCH, METHODS.DELETE

STATUS.SUCCESS (200), STATUS.CREATED (201), STATUS.NO_CONTENT (204)
STATUS.BAD_REQUEST (400), STATUS.NOT_AUTHORIZED (401), STATUS.NOT_FOUND (404)
STATUS.INTERNAL_ERROR (500)
```

## 🔐 Authentication Patterns (CBSecurity + JWT)

### Login Flow

```cfml
component extends="coldbox.system.RestHandler" {
    
    property name="userService" inject="UserService";

    /**
     * @x           -route          (POST) /api/login
     * @requestBody ~auth/login/requestBody.json
     * @response    -default ~auth/login/responses.json##200
     */
    function login(event, rc, prc){
        param rc.username = "";
        param rc.password = "";

        // jwtAuth() helper from CBSecurity
        // Throws InvalidCredentials if failed (caught by RestHandler)
        var token = jwtAuth().attempt(rc.username, rc.password);

        event.getResponse()
            .setData(token)
            .addMessage("Token expires in #jwtAuth().getSettings().jwt.expiration# minutes");
    }
}
```

### Registration Flow

```cfml
function register(event, rc, prc){
    // Populate model from rc
    prc.oUser = userService.create(
        populateModel("User").validateOrFail() // Uses cbvalidation
    );

    // Generate token for new user
    event.getResponse().setData({
        "token": jwtAuth().fromUser(prc.oUser),
        "user": prc.oUser.getMemento() // mementifier
    });
}
```

### Securing Endpoints

Use `secured` annotation on function:
```cfml
function whoami(event, rc, prc) secured {
    // Only accessible with valid JWT token
    var user = jwtAuth().getUser();
}
```

## 👤 User Model Pattern

The User model uses **delegates** for cross-cutting concerns:

```cfml
component
    extends="cbsecurity.models.auth.User"
    delegates="
        Validatable@cbvalidation,
        Population@cbDelegates,
        Auth@cbSecurity,
        Authorizable@cbSecurity,
        JwtSubject@cbSecurity
    "
{
    // Inherits IAuthUser and IJWTSubject implementations
    // Gets validation, population, authorization methods
}
```

**Key Interfaces**:
- `IAuthUser` - Authentication user contract
- `IJWTSubject` - JWT token subject
- `Validatable` - Validation methods (`.validateOrFail()`)
- `Population` - Populate from structs (`.populate()`)

## 🧪 Testing REST APIs

**CRITICAL**: Tests extend `BaseTestCase` with `appMapping="/app"`:

```cfml
component extends="coldbox.system.testing.BaseTestCase" appMapping="/app" {

    function run(){
        describe("REST API", function(){
            beforeEach(function(currentSpec){
                // MUST call setup() for request isolation
                setup();
            });

            it("can handle an echo", function(){
                // Mock HTTP method
                prepareMock(getRequestContext()).$("getHTTPMethod", "GET");
                
                var event = execute(route="echo/index");
                var response = event.getPrivateValue("response");
                
                expect(response.getError()).toBeFalse();
                expect(response.getData()).toBe("Welcome to my ColdBox RESTFul Service");
            });

            it("handles missing actions with 404", function(){
                prepareMock(getRequestContext()).$("getHTTPMethod", "GET");
                
                var event = execute(route="echo/bogus");
                var response = event.getPrivateValue("response");
                
                expect(response.getError()).toBeTrue();
                expect(response.getStatusCode()).toBe(404);
            });
        });
    }
}
```

**Testing Pattern**: Access response via `event.getPrivateValue("response")`, not return value.

## 🛠️ Build Commands

```bash
# Install dependencies (coldbox, cbsecurity, mementifier, etc.)
box install

# Start server
box server start

# View API docs at: http://localhost:PORT/cbswagger
# View routes at: http://localhost:PORT/route-visualizer

# Code formatting
box run-script format              # Format all CFML
box run-script format:check        # Check formatting
box run-script format:watch        # Watch and auto-format

# Testing
box testbox run                    # Run all tests
box testbox run bundles=tests.specs.integration.EchoTests

# Docker
box run-script docker:build        # Build image
box run-script docker:run          # Run container
box run-script docker:stack up     # Start compose stack
```

## 🎯 Routing Patterns (config/Router.cfc)

REST-focused routing:

```cfml
component {
    function configure(){
        // Simple routes
        get("/api/echo", "Echo.index");
        
        // Authentication routes
        post("/api/login", "Auth.login");
        post("/api/register", "Auth.register");
        post("/api/logout", "Auth.logout");
        
        // Secured routes (checked by CBSecurity)
        get("/api/whoami", "Echo.whoami");
        
        // RESTful resources (generates 7 routes)
        resources("users");
        
        // API versioning via groups
        group({prefix: "/api/v1"}, function(){
            resources("products");
        });
    }
}
```

## 📚 OpenAPI/Swagger Documentation

Document APIs using annotations in handler doc blocks:

```cfml
/**
 * @x           -route          (POST) /api/login
 * @requestBody ~auth/login/requestBody.json
 * @response    -default ~auth/login/responses.json##200
 * @response    -401     ~auth/login/responses.json##401
 */
function login(event, rc, prc){}
```

**JSON Schema Files**: Store in `resources/apidocs/` folder referenced by `~path/to/file.json`

**View Docs**: Visit `/cbswagger` when relax module is installed

## 💉 Dependency Injection

```cfml
component extends="coldbox.system.RestHandler" {
    
    // Inject services
    property name="userService" inject="UserService";
    
    // Inject from modules
    property name="log" inject="logbox:logger:{this}";
    property name="cache" inject="cachebox:default";
    
    // Provider injection (lazy)
    property name="userProvider" inject="provider:User";
}
```

## 🚨 Common Pitfalls

1. **Wrong Base Class**: Must extend `RestHandler`, not `EventHandler` for REST APIs
2. **Test Response Access**: Use `event.getPrivateValue("response")`, not `event.getHandlerResults()`
3. **HTTP Method Mocking**: Must mock `getHTTPMethod()` in tests or RestHandler rejects request
4. **Secured Annotation**: Use `function name() secured {}` not `@secured` in doc block
5. **JWT Helper**: Use `jwtAuth()` not `jwt()` - it's a CBSecurity helper
6. **User Service**: Must implement `IUserService` interface from CBSecurity
7. **Validation**: Use `.validateOrFail()` which throws ValidationException (caught by RestHandler)
8. **Mementifier**: User must have `getMemento()` method for serialization

## 📖 Key Files

- `handlers/Echo.cfc` - Example REST endpoint with documentation
- `handlers/Auth.cfc` - JWT authentication flow (login, register, logout)
- `models/User.cfc` - User entity with delegates (IAuthUser, IJWTSubject)
- `models/UserService.cfc` - IUserService implementation (currently mocked users)
- `config/ColdBox.cfc` - Default event: "Echo.index", Exception handler: "Echo.onError"
- `config/Router.cfc` - RESTful route definitions
- `tests/specs/integration/EchoTests.cfc` - REST API testing patterns

## 🔍 Debugging

```cfml
// RestHandler provides detailed error responses
event.getResponse()
    .setError(true)
    .setStatusCode(400)
    .addMessage("Validation failed")
    .setData(validationErrors);

// Log with injected logger
property name="log" inject="logbox:logger:{this}";
log.error("API Error", {exception: exception, rc: rc});
```

## 📚 Documentation

- ColdBox RestHandler: https://coldbox.ortusbooks.com/digging-deeper/rest-handler
- CBSecurity JWT: https://coldbox-security.ortusbooks.com/jwt
- Mementifier: https://forgebox.io/view/mementifier
- CBValidation: https://forgebox.io/view/cbvalidation
- Relax (API Docs): https://forgebox.io/view/relax
