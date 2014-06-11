<!--- Place code here that should be executed on the "onApplicationStart" event. --->
<cffunction name="initServices" returntype="void" output="false" hint="I initialize the services objects for this app">
	<cfset var loc = {}>
	<cfset application.$_ServiceObjects = {}>
	<!--- <cfset application.$_ServiceObjects["my_service"] = CreateObject("component", "services.my_service").init()> --->
</cffunction>
<cfset initServices()>