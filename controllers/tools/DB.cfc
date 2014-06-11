<cfcomponent extends="Controller">
	
	<cffunction name="init">
		<cfset super.init()>
	</cffunction>
	
	<cffunction name="ping">
		<cfset model("Person").findOne(returnAs="query")>
		<cfset renderText(text='{db:"okay"}')>
	</cffunction>

	<cffunction name="migrations">
		<cfset var loc = {}>
		<cfif params.type eq "current">
			<cfset renderText(text='{current:#$$getCurrentMigration()#}')>
		<cfelseif params.type eq "latest">
			<cfset renderText(text='{latest:#$$getLatestAvailableMigration()#}')>
		<cfelseif params.type eq "ismigrated">
			<cfset renderText(text='{ismigrated:#$$getCurrentMigration() eq $$getLatestAvailableMigration() ? true : false#}')>
		<cfelse>
			<cfthrow message="Huh?">
		</cfif>
	</cffunction>

	<cffunction name="migrate">
		<cfset renderText(text=$$dbmigrate().migrateTo($$getLatestAvailableMigration()))>
	</cffunction>

	<!--- 
	** PRIVATE **
	 --->

	<cffunction name="$$getLatestAvailableMigration" access="private" hint="get the latest available migration">
		<cfset var loc = {}>
		<cfset loc.allAvailable = $$dbmigrate().getAvailableMigrations()>
		<cfset loc.available = []>
		<cfloop array="#loc.allAvailable#" index="loc.i">
			<cfset ArrayAppend(loc.available, loc.i.version)>
		</cfloop>
		<cfset ArraySort(loc.available, "numeric", "desc")>
		<cfreturn loc.available[1]>
	</cffunction>

	<cffunction name="$$getCurrentMigration" access="private" hint="get the latest record from the schemainfo table">
		<cfreturn model("DBMigrateVersion").findLast().version>
	</cffunction>

	<cffunction name="$$dbmigrate" access="private">
		<cfreturn application.wheels.plugins.dbmigrate>
	</cffunction>

</cfcomponent>