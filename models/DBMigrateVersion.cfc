<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset table("schemainfo")>
		<cfset setPrimaryKey("version")>
	</cffunction>

</cfcomponent>
