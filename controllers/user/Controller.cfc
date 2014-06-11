<cfcomponent extends="hotwire.controllers.controller">
	
	<cffunction name="init">
		<cfset super.init()>
		<cfset filters("isAuthenticated,authenticateUser")>
	</cffunction>

	<cffunction name="authenticateUser" access="private">
		<cfif Val(currentPerson.userid) eq 0>
			<cfset redirectTo(route="jointDetourDashboard", message=constant("unauthorisedAccessMessage"), messageType="warning")>
		</cfif>
	</cffunction>

</cfcomponent>