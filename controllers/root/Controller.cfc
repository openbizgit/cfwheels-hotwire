<cfcomponent extends="base.controllers.controller">
	
	<cffunction name="init">
		<cfset super.init()>
		<cfset filters("isAuthenticated,authenticateRoot")>
	</cffunction>

	<cffunction name="authenticateRoot" access="private">
		<cfif Val(currentPerson.rootid) eq 0>
			<cfset redirectTo(route="jointDetourDashboard", message=constant("unauthorisedAccessMessage"), messageType="warning")>
		</cfif>
	</cffunction>

</cfcomponent>