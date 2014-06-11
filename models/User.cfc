<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<!--- associations --->
		<cfset hasOne(name="Person", dependent="delete")>
		<!--- nested properties --->
		<cfset nestedProperties(associations="Person", allowDelete=true)>
	</cffunction>

</cfcomponent>
