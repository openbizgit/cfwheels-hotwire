<!--- Place functions here that should be globally available to your tests. --->
<cffunction name="processControllerAction" access="private">
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

<cffunction name="controllerActionResponse" access="private">
	<cfargument name="controller" type="string" required="true">
	<cfargument name="action" type="string" required="true">
	<cfargument name="params" type="struct" required="true">
	<cfset var controller = processControllerAction(argumentCollection=arguments)>
	<cfreturn controller.response()>
</cffunction>

<cffunction name="controllerActionRedirect" access="private">
	<cfargument name="controller" type="string" required="true">
	<cfargument name="action" type="string" required="true">
	<cfargument name="params" type="struct" required="true">
	<cfset var controller = processControllerAction(argumentCollection=arguments)>
	<cfreturn controller.$getRedirect()>
</cffunction>