<cfcomponent extends="Test">
	
	<cffunction name="onstartup">
		<cfset loc = {}>
		<!--- don't run populate script if this url param is false --->
		<cfif StructKeyExists(url, "populate") AND ! url.populate>
		<cfelse>
			<!--- only run the populate script once --->
			<cfif ! StructKeyExists(request, "populated")>
				<cfset loc.response = getResponse(controller="seed.Seed", action="index", params={type="ci"})>				
				<cfset assert("loc.response contains 'data populated'")>
				<cfset request.populated = true>
			</cfif>
		</cfif>
	</cffunction>

	<!--- this will be called as super.setup() in the setup of each test package --->
	<cffunction name="setup">
         <!--- save the orginal environment --->
		<cfset loc.originalApplication = Duplicate(application) />
		<!--- turn transactions off for testing --->
		<cfset application.wheels.transactionMode = "rollback">
    </cffunction>

    <!--- this will be called as super.teardown() in the setup of each test package --->
	<cffunction name="teardown">
         <!--- re-instate the original application scope --->
        <cfset application = loc.originalApplication />
    </cffunction>

	<!--- how to do this? --->
	<cffunction name="onshutdown">
		
	</cffunction>

	<!--- 
		** TESTS **
	 --->

	<!--- assert that setup and teardown pass --->
    <!--- <cffunction name="test_setup_and_teardown">  
		<cfset assert("true")>
	</cffunction> --->

	<!--- 
		** HELPERS **
	 --->

	 <!--- Place functions here that should be globally available to your tests. --->
	<cffunction name="processControllerAction">
		<cfargument name="controller" type="string" required="true">
		<cfargument name="action" type="string" required="true">
		<cfargument name="params" type="struct" required="true">
		<cfset var loc = {}>
		<cfset loc.params = arguments.params>
		<cfset loc.params.controller = arguments.controller>
		<cfset loc.params.action = arguments.action>
		<cfset loc.controller = variables.controller(arguments.controller, loc.params)> <!--- variables scoped to avoid naming collision with arguments scope --->
	    <cfset loc.controller.init()>	<!--- this is a workaround.. testing coldroute namespaced controllers doesn't call the controller's init method --->
		<cfset loc.controller.$processAction()>
		<cfreturn loc.controller>
	</cffunction>

	<cffunction name="getResponse">
		<cfargument name="controller" type="string" required="true">
		<cfargument name="action" type="string" required="true">
		<cfargument name="params" type="struct" required="true">
		<cfset var controller = processControllerAction(argumentCollection=arguments)>
		<cfreturn controller.response()>
	</cffunction>

	<cffunction name="getRedirect">
		<cfargument name="controller" type="string" required="true">
		<cfargument name="action" type="string" required="true">
		<cfargument name="params" type="struct" required="true">
		<cfset var controller = processControllerAction(argumentCollection=arguments)>
		<cfreturn StructKeyExists(controller.$getRedirect(), "$args") ? controller.$getRedirect().$args : "Sorry! $getRedirect().$args undefined">
	</cffunction>

	<cffunction name="createRootSession" access="private">
		<cfset createSession(1)>
	</cffunction>

	<cffunction name="createAdministratorSession" access="private">
		<cfset createSession(2)>
	</cffunction>

	<cffunction name="createUserSession" access="private">
		<cfset createSession(3)>
	</cffunction>

	<cffunction name="createSession" access="private">
		<cfargument name="id" type="numeric" required="true">
		<cfset var sessionPerson = model("Person").findByKey(arguments.id)>
		<!--- TODO: defined a dedicated user for tests --->
		<cfif ! isPresent() OR cookie[constant('sessionCookieName')] neq sessionPerson.remembertoken>
			<cfset var person = model("Person").findByKey(sessionPerson.key())>
			<cfset arrive(person)>
			<cfset cookie["cfid"] = CreateUUID()>
		</cfif>
	</cffunction>

	<cffunction name="killSession" access="private">
		<!--- kill the unti test session --->
		<!--- 
		<cfset depart()>
		 --->
		<!--- re-create the original session --->
		<!--- 
		<cfif StructKeyExists(variables,"orig")>
			<cfcookie name="#constant('sessionCookieName')#" value="#orig.sessionCookie#" expires="#constant('midnight')#">
			<cfif StructKeyExists(orig, "siteCookie")>
				<cfcookie name="#constant('siteCookieName')#" value="#orig.siteCookie#" expires="#constant('midnight')#">
			</cfif>
		</cfif>
		 --->
	</cffunction>

	<cffunction name="commit">
		<cfset application.wheels.transactionMode = "commit">
	</cffunction>

	<cffunction name="rollback">
		<cfset application.wheels.transactionMode = "rollback">
	</cffunction>

	<cffunction name="setConstants">
		<!--- common message strings --->
		<cfset loc.errorMessage = 'class="alert alert-error"'>
		<cfset loc.infoMessage = 'class="alert alert-info"'>
		<cfset loc.successMessage = 'class="alert alert-success"'>
	</cffunction>

	<cffunction name="assertLayoutExists">
		<cfargument name="response" type="string" required="true" />
		
		<cfset loc.response = arguments.response>
		
		<cfset loc.present = '<!-- [present:true] -->'>
		<cfset loc.doctype = '<!DOCTYPE html>'>
		<cfset loc.bodyopen = '<body'>
		<cfset loc.navbar = '<div class="navbar navbar-inverse navbar-fixed-top">'>
		<cfset loc.pagetitle = '<title>'>
		<cfset loc.container = '<div class="container">'>
		<cfset loc.bodyclose = '</body>'>
		<cfset loc.htmlclose = '</html>'>	
		<cfset loc.gitmergeconflict = '<<<<<<< HEAD'>
		<cfset loc.railodump = 'class="-railo-dump"'>
		
		<cfif isPresent()>
			<cfset assert('loc.response contains loc.present') />
		</cfif>
		<cfset assert('loc.response contains loc.doctype') />
		<cfset assert('loc.response contains loc.bodyopen') />
		<cfset assert('loc.response contains loc.navbar') />
		<cfset assert('loc.response contains loc.pagetitle') />
		<cfset assert('loc.response contains loc.container') />
		<cfset assert('loc.response contains loc.bodyclose') />
		<cfset assert('loc.response contains loc.htmlclose') />
		<cfset assert('loc.response DOES NOT contain loc.gitmergeconflict') />
		<cfset assert('loc.response DOES NOT contain loc.railodump') />
		
	</cffunction>

</cfcomponent>