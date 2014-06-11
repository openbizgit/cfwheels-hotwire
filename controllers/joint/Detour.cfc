<cfcomponent extends="Controller" hint="A common controller redirecting requests to the correct route based on params">
	
	<cffunction name="init">
		<cfset super.init()>
	</cffunction>

	<cffunction name="dashboard">
		<cfset redirectTo(route="#currentPerson.nameSpace#DashboardRoot")>
	</cffunction>

</cfcomponent>