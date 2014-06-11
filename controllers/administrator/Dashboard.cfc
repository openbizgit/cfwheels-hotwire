<cfcomponent extends="Controller" output="false">

	<cffunction name="init">
		<cfset super.init()>
	</cffunction>

	<!--- 
	** PUBLIC **
	 --->

	<!--- administrator/dashboard/index --->
	<cffunction name="index">
		<cfset examples = model("Example").findAll()>
	</cffunction>

</cfcomponent>
