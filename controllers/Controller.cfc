<cfcomponent extends="Wheels">
	
	<cffunction name="init" hint="Constructor">
		<cfset filters(through="getCurrentPerson")>
		<cfset filters(through="everyRequest")>
	</cffunction>
	
	<!--- 
	** FILTERS **
	 --->

	<cffunction name="everyRequest" access="private">
		<!--- Sets some default params scoped variables if they don't exist. --->
		<cfif ! StructKeyExists(params, "pg")>
			<cfset params.pg = 1>
		</cfif>
		<!--- turn off debug for ajax requests --->
		<cfif isAjax() && ! StructKeyExists(params, "showdebugoutput")>
			<cfsetting showdebugoutput="no">
		</cfif>
	</cffunction>

	<cffunction name="getCurrentPerson" access="private" hint="Loads the current person. Is used primarily as a filter to make currentPerson var available to views">
		<cfif isPresent()>
			<cfset currentPerson = getPresentPerson()>
		</cfif>
	</cffunction>

	<cffunction name="isAuthenticated" access="private" hint="Ensures person is authenticated">
		<cfif ! isPresent() OR ! IsObject(getPresentPerson())>
			<cfset storeLocation(params)>
			<cfset redirectTo(route="root")>
		</cfif>
	</cffunction>

	<cffunction name="redirectIfSignedIn" access="private" hint="Redirects the person away if its signed in">
		<cfif isPresent()>
			<!--- TODO: redirect to last remembered page --->
			<cfset redirectTo(route="jointDetourDashboard")>
		</cfif>
	</cffunction>

	<!--- 
	** HELPERS **
	 --->

	<cffunction name="urlFor" access="public" hint="append a token to all urls.. seems the only way to prevent an odd caching issue">
		<!--- ensure routes are used for all urls --->
		<cfif ! StructKeyExists(arguments, "noroute")>
			<cfif ! (StructKeyExists(arguments, "route") && Len(arguments.route) gt 0)>
				<cfthrow message="Please use a route rather than an action.. Thanks!">
			</cfif>
		</cfif>
		<cfif ! StructKeyExists(arguments, "params")>
			<cfset arguments.params = "">
		</cfif>
		<cfset arguments.params = ListAppend(arguments.params, generateToken(), "&")>
		<cfreturn core.urlFor(argumentCollection=arguments)>
	</cffunction>

</cfcomponent>