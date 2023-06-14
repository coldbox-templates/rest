<p align="center">
	<img src="https://www.ortussolutions.com/__media/coldbox-185-logo.png">
	<br>
	<img src="https://www.ortussolutions.com/__media/wirebox-185.png" height="125">
	<img src="https://www.ortussolutions.com/__media/cachebox-185.png" height="125" >
	<img src="https://www.ortussolutions.com/__media/logbox-185.png"  height="125">
</p>

<p align="center">
	<a href="https://github.com/ColdBox/coldbox-platform/actions/workflows/snapshot.yml"><img src="https://github.com/ColdBox/coldbox-platform/actions/workflows/snapshot.yml/badge.svg" alt="ColdBox Snapshots" /></a>
	<a href="https://forgebox.io/view/coldbox"><img src="https://forgebox.io/api/v1/entry/coldbox/badges/downloads" alt="Total Downloads" /></a>
	<a href="https://forgebox.io/view/coldbox"><img src="https://forgebox.io/api/v1/entry/coldbox/badges/version" alt="Latest Stable Version" /></a>
	<a href="https://forgebox.io/view/coldbox"><img src="https://img.shields.io/badge/License-Apache2-brightgreen" alt="Apache2 License" /></a>
</p>

<p align="center">
	Copyright Since 2005 ColdBox Platform by Luis Majano and Ortus Solutions, Corp
	<br>
	<a href="https://www.coldbox.org">www.coldbox.org</a> |
	<a href="https://www.ortussolutions.com">www.ortussolutions.com</a>
</p>

----

# REST API Application Template

This template gives you the base for building RESTFul web services with ColdBox and securing them with `CBSecurity`.  It is fully documented with swagger/open API specs and you can find them in the `resources` folder or by running the cbswagger module directly: http://localhost:{port}/cbswagger.

The handlers all leverage the ColdBox REST Handler: https://coldbox.ortusbooks.com/digging-deeper/rest-handler

## Implicit Methods

The base handler implements an around handler approach to provide consistency and the following actions:

- `onError` - Fires whenever there is a runtime exception in any action
- `onInvalidHTTPMethod` - Fires on invalid HTTP method access
- `onMissingAction` - Fires on invalid missing actions on handlers

## Utility Functions

We also give you some utility functions for RESTFul building:

- `onInvalidRoute` - Can be used to fire of route not founds via 404
- `onExpectationFailed` - Can be called when an expectation of a request fails, like invalid parameters/headers etc.
- `onAuthorizationFailure` - Can be called to send a NOT Authorized status code and message.

## HTTP Security

By default the base handlers leverages ColdBox method security via the `this.allowedMethods` structure:

```js
this.allowedMethods = {
    "index"     : METHODS.GET,
    "get"       : METHODS.GET,
    "list"      : METHODS.GET,
    "update"    : METHODS.PUT & "," & METHODS.PATCH,
    "delete"    : METHODS.DELETE
};
```

## HTTP Methods

The base handler contains a static construct called `METHODS` that implements basic HTTP Methods that you can use for messages and allowed methods.

```js
METHODS = {
    "HEAD"      : "HEAD",
    "GET"       : "GET",
    "POST"      : "POST",
    "PATCH"     : "PATCH",
    "PUT"       : "PUT",
    "DELETE"    : "DELETE"
};
```

## Status Codes

The base handler contains a static construct called `STATUS` that implements basic HTTP status codes you can use:

```js
STATUS = {
    "CREATED"               : 201,
    "ACCEPTED"              : 202,
    "SUCCESS"               : 200,
    "NO_CONTENT"            : 204,
    "RESET"                 : 205,
    "PARTIAL_CONTENT"       : 206,
    "BAD_REQUEST"           : 400,
    "NOT_AUTHORIZED"        : 401,
    "NOT_FOUND"             : 404,
    "NOT_ALLOWED"           : 405,
    "NOT_ACCEPTABLE"        : 406,
    "TOO_MANY_REQUESTS"     : 429,
    "EXPECTATION_FAILED"    : 417,
    "INTERNAL_ERROR"        : 500,
    "NOT_IMPLEMENTED"       : 501
};
```

## Quick Installation

Install the template dependencies by running the `install` command:

```bash
box install
```

This will setup all the needed dependencies for each application template.  You can then start the embedded server:

```bash
box server start
```

Code to your liking and enjoy!

## Dockerfile

We have included a [`build/Dockerfile`](build/Dockerfile) so you can build docker containers from your source code.  We have also added two scripts in your `box.json` so you can build the docker image and run the docker image using our [CommandBox Docker](https://hub.docker.com/r/ortussolutions/commandbox) containers.

```bash
# Build a docker **container**
run-script docker:build
# Run the container
run-script docker:run
# Go into the container's bash prompt
run-script docker:bash
```

## Docker Compose Stack

We have included a [`build/docker-compose.yaml`](build/docker-compose.yml) stack that can be used to run the application in a container alongside a database.  We have included support for MySQL, PostgreSQL and MSSQL.  We have also included the `run-script docker:stack` command you so you compose the stack up or down.

```bash
run-script docker:stack up
run-script docker:stack down
```

## VSCode Helpers

We have included two vscode helpers for you:

- `.vscode/settings.json` - Includes introspection helpers for ColdBox and TestBox
- `.vscode/tasks.json` - Tasks to assist in running a Test Bundle and a CommandBox Task

We have included two custom tasks:

- `Run CommandBox Task` - Open a CommandBox task and run it
- `Run TestBox Bundle` - Open the bundle you want to test and then run it

To run the custom tasks open the command palette and choose `Tasks: Run Build Task` or the shortcut `⇧⌘B`

## Welcome to ColdBox

ColdBox *Hierarchical* MVC is the de-facto enterprise-level [HMVC](https://en.wikipedia.org/wiki/Hierarchical_model%E2%80%93view%E2%80%93controller) framework for ColdFusion (CFML) developers. It's professionally backed, conventions-based, modular, highly extensible, and productive. Getting started with ColdBox is quick and painless.  ColdBox takes the pain out of development by giving you a standardized methodology for modern ColdFusion (CFML) development with features such as:

- [Conventions instead of configuration](https://coldbox.ortusbooks.com/getting-started/conventions)
- [Modern URL routing](https://coldbox.ortusbooks.com/the-basics/routing)
- [RESTFul APIs](https://coldbox.ortusbooks.com/the-basics/event-handlers/rendering-data)
- [A hierarchical approach to MVC using ColdBox Modules](https://coldbox.ortusbooks.com/hmvc/modules)
- [Event-driven programming](https://coldbox.ortusbooks.com/digging-deeper/interceptors)
- [Async and Parallel programming constructs](https://coldbox.ortusbooks.com/digging-deeper/promises-async-programming)
- [Integration & Unit Testing](https://coldbox.ortusbooks.com/testing/testing-coldbox-applications)
- [Included dependency injection](https://wirebox.ortusbooks.com)
- [Caching engine and API](https://cachebox.ortusbooks.com)
- [Logging engine](https://logbox.ortusbooks.com)
- [An extensive eco-system](https://forgebox.io)
- Much More

## Learning ColdBox

ColdBox is the defacto standard for building modern ColdFusion (CFML) applications.  It has the most extensive [documentation](https://coldbox.ortusbooks.com) of all modern web application frameworks.


If you don't like reading so much, then you can try our video learning platform: [CFCasts (www.cfcasts.com)](https://www.cfcasts.com)

## ColdBox Sponsors

ColdBox is a professional open-source project and it is completely funded by the [community](https://patreon.com/ortussolutions) and [Ortus Solutions, Corp](https://www.ortussolutions.com).  Ortus Patreons get many benefits like a cfcasts account, a FORGEBOX Pro account and so much more.  If you are interested in becoming a sponsor, please visit our patronage page: [https://patreon.com/ortussolutions](https://patreon.com/ortussolutions)

### THE DAILY BREAD

 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12
