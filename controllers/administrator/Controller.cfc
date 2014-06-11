<cfcomponent extends="hotwire.controllers.controller">
	
	<cffunction name="init">
		<cfset super.init()>
		<cfset filters("isAuthenticated,authenticateAdministrator")>
	</cffunction>

	<cffunction name="authenticateAdministrator" access="private">
		<cfif Val(currentPerson.administratorid) eq 0>
			<cfset redirectTo(route="jointDetourDashboard", message=constant("unauthorisedAccessMessage"), messageType="warning")>
		</cfif>
	</cffunction>

</cfcomponent>