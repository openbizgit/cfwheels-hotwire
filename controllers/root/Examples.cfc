<cfcomponent extends="Controller" output="false">

	<cffunction name="init">
		<cfset super.init()>
		<cfset filters(through="findOne", only="show,edit,update,delete")>
	</cffunction>

	<!--- 
	** FILTERS **
	 --->
	<cffunction name="findOne" access="private">
		<!--- Find the record --->
    	<cfset example = model("Example").findByKey(params.key)>

    	<cfif ! IsObject(example)>
	        <cfset flashInsert(message="example #params.key# was not found", messageType="error")>
	        <cfreturn redirectTo(route="rootExamplesRoot")>
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

	<!--- examples/index --->
	<cffunction name="index">
		<cfset examples = model("Example").findAll()>
	</cffunction>
	
	<!--- examples/show/key --->
	<cffunction name="show">
	
	</cffunction>
	
	<!--- examples/new --->
	<cffunction name="new">
		<cfset example = model("Example").new()>
	</cffunction>
	
	<!--- examples/edit/key --->
	<cffunction name="edit">

	</cffunction>
	
	<!--- examples/create --->
	<cffunction name="create">
		<cfset example = model("Example").new(params.example)>
		
		<!--- Verify that the example creates successfully --->
		<cfif example.save()>
			<cfset flashInsert(message="The example was created successfully.", messageType="success")>
            <cfreturn redirectTo(route="rootExamplesRoot")>
		<!--- Otherwise --->
		<cfelse>
			<cfset flashInsert(message="There was an error creating the example.", messageType="error")>
			<cfset renderPage(action="new")>
		</cfif>
	</cffunction>
	
	<!--- examples/update --->
	<cffunction name="update">

		<!--- Verify that the example updates successfully --->
		<cfif example.update(params.example)>
			<cfset flashInsert(message="The example was updated successfully.", messageType="success")>	
            <cfreturn redirectTo(route="rootExamplesRoot")>
		<!--- Otherwise --->
		<cfelse>
			<cfset flashInsert(message="There was an error updating the example.", messageType="error")>
			<cfset renderPage(action="edit")>
		</cfif>
	</cffunction>
	
	<!--- examples/delete/key --->
	<cffunction name="delete">

		<!--- Verify that the example deletes successfully --->
		<cfif example.delete()>
			<cfset flashInsert(message="The example was deleted successfully.", messageType="success")>	
		<!--- Otherwise --->
		<cfelse>
			<cfset flashInsert(message="There was an error deleting the example.", messageType="error")>
		</cfif>
		<cfreturn redirectTo(route="rootExamplesRoot")>
	</cffunction>
	
</cfcomponent>
