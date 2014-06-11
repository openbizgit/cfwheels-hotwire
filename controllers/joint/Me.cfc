<cfcomponent extends="Controller" hint="A common controller for users's settings">
	
	<cffunction name="init">
		<cfset super.init()>
	</cffunction>

	<!--- 
	** PUBLIC **
	 --->
	<cffunction name="editEmail">
	</cffunction>

	<!--- email/update --->
	<cffunction name="updateEmail">	
		<!--- Verify that the email updates successfully --->
		<cfif currentperson.update(params.currentperson)>
			<cfset flashInsert(message="Your email was updated successfully.", messageType="success")>	
            <cfreturn redirectTo(route="jointDetourDashboard", delay=true)>
		<!--- Otherwise --->
		<cfelse>
			<cfset flashInsert(message="There was an error updating your email.", messageType="error")>
			<cfset renderPage(action="editEmail")>
		</cfif>
	</cffunction>

	<cffunction name="editPassword">
		<cfset currentperson.password = "" />
		<cfset currentperson.passwordConfirmation = "" />
	</cffunction>

	<!--- password/update --->
	<cffunction name="updatePassword">	
		<cfif currentperson.authenticate(params.oldpassword)>
			<!--- Verify that the password updates successfully --->
			<cfif currentperson.authenticate(params.oldpassword) AND currentperson.update(params.currentperson)>
				<cfset flashInsert(message="Your password was updated successfully.", messageType="success")>	
	            <cfreturn redirectTo(route="jointDetourDashboard", delay=true)>
			<!--- Otherwise --->
			<cfelse>
				<cfset flashInsert(message="There was an error updating your password.", messageType="error")>
				<cfset currentperson.password = "" />
				<cfset currentperson.passwordConfirmation = "" />			
				<cfset renderPage(action="editPassword")>
			</cfif>
		<cfelse>
			<cfset flashInsert(message="Your old password is incorrect.", messageType="error")>
			<cfset currentperson.password = "" />
			<cfset currentperson.passwordConfirmation = "" />			
			<cfset renderPage(action="editPassword")>			
		</cfif>

	</cffunction>	

	<cffunction name="attachment">
		<cfset var loc = {file={}}>
		<cfset loc.id = model("Attachment").findByKey(params.key)>
		<!--- get the personid --->
		<cfset loc.repair = model("Repair").findAll(where="id=#loc.id.repairid#", include="Consumer(Person)")>
		<!--- check the params passed match the db record --->
		<cfif loc.repair.personid eq params.personid AND loc.id.filename contains params.filename AND ListLast(loc.id.filename,".") eq params.format>
			<!--- see if the size=thumb param exists --->
			<cfif StructKeyExists(params, "size") AND params.size eq "thumb">
				<cfset loc.file.name = ListFirst(loc.id.filename,".") & "-200-stf." & ListLast(loc.id.filename,".")>
			<cfelse>
				<cfset loc.file.name = loc.id.filename>
			</cfif>
			<cfset loc.file.mimetype = ListLast(loc.id.filename,".")>			
			<cfset loc.file.path = personFilePath(personid=loc.repair.personid, filename=loc.file.name)>
			<!--- serve the image --->
			<cfimage action="read" source="#loc.file.path#" name="loc.img">
			<cfcontent type="image/#ListLast(loc.id.filename,".")#" variable="#imageGetBlob(loc.img)#">
		<cfelse>
			<!--- 404 --->
			<cfheader statuscode="404" statustext="Not Found">
			<cfset renderText("Not Found")>
		</cfif>
	</cffunction>

</cfcomponent>