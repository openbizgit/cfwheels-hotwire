<cfcomponent extends="Controller">
	
	<cffunction name="init">
		<cfset super.init()>
	</cffunction>
	
	<!--- if no action specified --->
	<cffunction name="index">
		<cfset ping()>
	</cffunction>
	
	<cffunction name="ping" hint="Returns true if wheels is running">
		<cfset renderText(text="{ping:true}")>
	</cffunction>

	<cffunction name="release" hint="returns the current capistrano release number">
		<cfinclude template="release.cfm">
		<cfset renderText(text="{release:#release#}")>
	</cffunction>

	<cffunction name="isreleased" hint="returns true if the release number matches the param">
		<cfinclude template="release.cfm">
		<cfset renderText(text="{isreleased:#release eq params.release ? 'true' : 'false'#}")>
	</cffunction>
	
</cfcomponent>