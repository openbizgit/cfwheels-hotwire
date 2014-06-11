<cfcomponent extends="hotwire.controllers.controller">
	
	<cffunction name="init">
		<cfset super.init()>
		<cfset filters("isAuthenticated")>
	</cffunction>

</cfcomponent>