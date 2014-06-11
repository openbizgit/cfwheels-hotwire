<cfsilent>
	
	<!--- parse the error struct, create a nice simple struct for use in the db --->
	<cfset error = model("Error").createError(arguments.exception)>
	<cfset errorKey = error.key()>
	<cfif ! IsObject(error)>
		<cfset errorKey = -1>
		<p>Error could not be processed</p>
	</cfif>
	
	<!--- get the cfwheels error output --->
	<cfsavecontent variable="CFMLError">
		<cfinclude template="/rattlesnake/wheels/events/onerror/cfmlerror.cfm" />
	</cfsavecontent>
	
	<cfset sendErrorEmail = true>
	<!--- don't send the emails for the following errors --->
	<cfif arguments.exception.message eq "Wheels couldn't find a route that matched this request.">
		<cfif cgi.request_url contains ".php" OR cgi.request_url contains "cgi-bin">
			<cfset sendErrorEmail = false>
		</cfif>
	</cfif>
	<cfif sendErrorEmail>
		<cfif get("stage") eq "production">
			<cfmail to="#get('errorEmailAddress')#" from="#get('fromEmailAddress')#" subject="#get('appName')# Error #errorKey# Occurred : #arguments.exception.message#" type="html">#CFMLError#</cfmail>
		</cfif>
	</cfif>

</cfsilent>
<cfheader statuscode="500" statustext="Internal Server Error">
<!--- Place HTML here that should be displayed when an error is encountered while running in "production" mode. --->
<h1>Error!</h1>
<p>
	Sorry, that caused an unexpected error.<br />
	Please try again later.
</p>
<cfif get("stage") neq "production">
	<cfdump var="#arguments.exception#">
	<cfoutput>#CFMLError#</cfoutput>
</cfif>