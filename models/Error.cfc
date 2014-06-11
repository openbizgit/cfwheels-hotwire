<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<!--- associations --->
		<cfset belongsTo(name="People")>
	</cffunction>

	<!--- 
		** PUBLIC **
	 --->

	<cffunction name="createError" access="public" output="false" returntype="any" hint="creates an error row from an exception or cfcatch struct">
		<cfargument name="exception" type="struct" required="true">
		<cfset var error = model("Error").create(
			$$parseException(arguments.exception)
		)>
		<cfreturn error>
	</cffunction>

	<!--- 
		** PRIVATE **
	 --->

	<cffunction name="$$parseException" access="private" output="false" returntype="struct" hint="converts an exception structure to simple structure for use with wheels ORM">
		<cfargument name="exception" type="struct" required="true">
		
		<cfset var loc = {}>
		<cfset loc.error = arguments.exception>
		<cfset loc.return = {}>

		<cfset loc.return.administratorid = ! getCurrentPersonId() ? "" : getCurrentPersonId()>
		<cfset loc.return.server = "no-name">		
		<cfset loc.return.domain = extractHTTPHeader("x-host")>
		<cfset loc.return.remoteIP = extractHTTPHeader("x-real-ip")>
		<cfset loc.return.scriptName = extractHTTPHeader("x-request-uri")>
		<cfset loc.return.querystring = extractHTTPHeader("x-query-string")>
		<cfset loc.return.browser = extractHTTPHeader("user-agent")>
		<cfset loc.return.referrer = extractHTTPHeader("referer")>
		<cfset loc.return.controller = StructKeyExists(url, "controller") ? url.action : "">
		<cfset loc.return.action = StructKeyExists(url, "action") ? url.action : "">
		
		<!--- extract template path --->
		<cfif StructKeyExists(loc.error,"tagContext") AND arrayLen(loc.error.tagContext) gt 0 AND structKeyExists(loc.error.tagContext[1],"template")>
			<cfset loc.return.filePath = loc.error.tagContext[1].template />
		<cfelseif structKeyExists(loc.error,"rootCause") AND structKeyExists(loc.error.rootCause,"tagContext") AND arrayLen(loc.error.rootCause.tagContext) gt 0 AND structKeyExists(loc.error.rootCause.tagContext[1],"template")>
			<cfset loc.return.filePath = loc.error.rootCause.tagContext[1].template />
		<cfelse>
			<cfset loc.return.filePath = "" />
		</cfif>
		
		<!--- extract diagnostics --->
		<cfif structKeyExists(loc.error,"rootCause") AND structKeyExists(loc.error.rootCause,"message")>
			<cfset loc.return.diagnostics = loc.error.rootCause.message />
			<cfif len(loc.error.rootCause.detail) gt 0>
				<cfset loc.return.diagnostics = loc.return.diagnostics & ". " & loc.error.rootCause.detail />
			</cfif>
		<cfelseif structKeyExists(loc.error,"diagnostics")>
			<cfset loc.return.diagnostics = loc.error.diagnostics />
		<cfelseif structKeyExists(loc.error,"message")>
			<cfset loc.return.diagnostics = loc.error.message & ". " & loc.error.detail />
		<cfelse>
			<cfset loc.return.diagnostics = "">
		</cfif>
		<!--- trim diagnostics --->
		<cfset loc.return.diagnostics = Left(loc.return.diagnostics, 1024)>
		
		<!--- extract raw trace --->
		<cfif structKeyExists(loc.error,"tagContext") AND arrayLen(loc.error.tagContext) gt 0 AND structKeyExists(loc.error.tagContext[1],"raw_trace")>
			<cfset loc.return.rawTrace = $$buildTagContextList(loc.error.tagContext) />
		<cfelseif structKeyExists(loc.error,"rootCause") AND structKeyExists(loc.error.rootCause,"tagContext") AND arrayLen(loc.error.rootCause.tagContext) gt 0 AND structKeyExists(loc.error.rootCause.tagContext[1],"raw_trace")>
			<cfset loc.return.rawTrace = $$buildTagContextList(rootCause.tagContext) />
		<cfelseif structKeyExists(loc.error,"diagnostics")>
			<cfset loc.return.rawTrace = loc.error.diagnostics />
		<cfelseif structKeyExists(loc.error,"detail")>
			<cfset loc.return.rawTrace = loc.error.detail />
		<cfelse>
			<cfset loc.return.rawTrace = "" />
		</cfif>
		
		<!--- JSON form scope.. but first, blitz any password field --->
		<cfset loc.form = Duplicate(form)>
		<cfset StructDelete(loc.form, "fieldnames")>
		<cfif IsDefined("loc.form.password") AND loc.form.password neq "">
			<cfset loc.form.password = "blitzed!">
		</cfif>
		<cfif IsDefined("loc.form.passwordConfirmation") AND loc.form.passwordConfirmation neq "">
			<cfset loc.form.passwordConfirmation = "blitzed!">
		</cfif>
		<cfset loc.return.post = (! StructIsEmpty(loc.form)) ? SerializeJSON(loc.form) : "" />
		<!--- JSON entire exception --->
		<cfset loc.return.json = SerializeJSON(loc.error) />
		
		<cfreturn loc.return>
	</cffunction>	

	<cffunction name="$$buildTagContextList" access="private" output="false">
		<cfargument name="tagContext" type="array" required="true">
		<cfset var loc = {}>
		<cfset loc.return = "">
		<cfloop array="#arguments.tagContext#" index="loc.i">
			<cfset loc.return = ListAppend(loc.return, "#ListLast(loc.i.template,"/\")#:#loc.i.line#")>
		</cfloop>
		<cfreturn loc.return>
	</cffunction>
	
</cfcomponent>
