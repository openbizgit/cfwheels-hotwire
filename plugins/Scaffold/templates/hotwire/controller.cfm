<cfcomponent extends="Controller" output="false">
	
	<!--- 
	** COLDROUTES **

	.controller("[NamePluralLowercase]")
        .get("new")
        .post("create")
        .get(name="show", pattern="show/[key]")
        .get(name="edit", pattern="edit/[key]")
        .post(name="update", pattern="update/[key]")
        .get(name="delete", pattern="delete/[key]")
        .root(action="index")
    .end()
	
	--->

	<cffunction name="init">
		<cfset super.init()>
		<cfset filters(through="findOne", only="show,edit,update,delete")>
	</cffunction>

	<!--- 
	** FILTERS **
	 --->
	<cffunction name="findOne" access="private">
		<!--- Find the record --->
    	<cfset [NameSingularLowercase] = model("[NameSingularUppercase]").findByKey(params.key)>

    	<cfif ! IsObject([NameSingularLowercase])>
	        <cfset flashInsert(message="[NameSingularLowercase] #params.key# was not found", messageType="error")>
	        <cfreturn redirectTo(route="[NamePluralLowercase]Root")>
	    </cfif>

	</cffunction>

	<!--- 
	** PARTIAL DATA FUNCTIONS **
	 --->

	<cffunction name="fields" access="private" returntype="struct">
		<!--- <cfset things = model("Thing").findAll()> --->
		<cfreturn {}>
	</cffunction>

	<!--- 
	** PUBLIC CRUD **
	 --->

	<!--- [NamePluralLowercaseDeHumanized]/index --->
	<cffunction name="index">
		<cfset [NamePluralLowercase] = model("[NameSingularUppercase]").findAll()>
	</cffunction>
	
	<!--- [NamePluralLowercaseDeHumanized]/show/key --->
	<cffunction name="show">
	
	</cffunction>
	
	<!--- [NamePluralLowercaseDeHumanized]/new --->
	<cffunction name="new">
		<cfset [NameSingularLowercase] = model("[NameSingularUppercase]").new()>
	</cffunction>
	
	<!--- [NamePluralLowercaseDeHumanized]/edit/key --->
	<cffunction name="edit">

	</cffunction>
	
	<!--- [NamePluralLowercaseDeHumanized]/create --->
	<cffunction name="create">
		<cfset [NameSingularLowercase] = model("[NameSingularUppercase]").new(params.[NameSingularLowercase])>
		
		<!--- Verify that the [NameSingularLowercase] creates successfully --->
		<cfif [NameSingularLowercase].save()>
			<cfset flashInsert(message="The [NameSingularLowercase] was created successfully.", messageType="success")>
            <cfreturn redirectTo(route="[NamePluralLowercase]Root")>
		<!--- Otherwise --->
		<cfelse>
			<cfset flashInsert(message="There was an error creating the [NameSingularLowercase].", messageType="error")>
			<cfset renderPage(action="new")>
		</cfif>
	</cffunction>
	
	<!--- [NamePluralLowercaseDeHumanized]/update --->
	<cffunction name="update">

		<!--- Verify that the [NameSingularLowercase] updates successfully --->
		<cfif [NameSingularLowercase].update(params.[NameSingularLowercase])>
			<cfset flashInsert(message="The [NameSingularLowercase] was updated successfully.", messageType="success")>	
            <cfreturn redirectTo(route="[NamePluralLowercase]Root")>
		<!--- Otherwise --->
		<cfelse>
			<cfset flashInsert(message="There was an error updating the [NameSingularLowercase].", messageType="error")>
			<cfset renderPage(action="edit")>
		</cfif>
	</cffunction>
	
	<!--- [NamePluralLowercaseDeHumanized]/delete/key --->
	<cffunction name="delete">

		<!--- Verify that the [NameSingularLowercase] deletes successfully --->
		<cfif [NameSingularLowercase].delete()>
			<cfset flashInsert(message="The [NameSingularLowercase] was deleted successfully.", messageType="success")>	
		<!--- Otherwise --->
		<cfelse>
			<cfset flashInsert(message="There was an error deleting the [NameSingularLowercase].", messageType="error")>
		</cfif>
		<cfreturn redirectTo(route="[NamePluralLowercase]Root")>
	</cffunction>
	
</cfcomponent>