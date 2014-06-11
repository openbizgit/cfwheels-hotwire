<cfcomponent output="false">

	<cffunction name="init" returntype="any" access="public" output="false">
		<cfset this.version = "0.1.0">
		<cfreturn this />
	</cffunction>

	<cffunction name="sendEmail" returntype="any" access="public" output="false" hint="Changes behaviour in design mode">
		<cfset var loc = {}>
		<!--- don't send whilst developing --->
		<cfif ListFind("design,development", LCase(get("environment"))) gt 0>
			<cfset arguments.$deliver = false>
		<cfelseif ListFind("staging", LCase(get("environment"))) gt 0 OR ListFindNoCase("ci,demo,staging", get('stage')) gt 0>
			<!--- intercept emails in staging --->
			<cfif ListLast(arguments.to,"@") NEQ "valetservice.com.au">
				<cfset arguments.to = "developers@valetservice.com.au">			
			</cfif>	
		</cfif>

		<!--- in case function defaults dont work for plugins --->
		<cfif ! StructKeyExists(arguments, "from")>
			<cfset arguments.from = "no-reply@valetservice.com.au">
		</cfif>

		<!--- log emails if not sending --->
		<cfset loc.return = core.sendEmail(argumentCollection=arguments)>
		<cfif StructKeyExists(arguments, "$deliver") AND ! arguments.$deliver>
			<cfset loc.dir = "#GetDirectoryFromPath(GetBaseTemplatePath())#temp\">
			<cfif ! DirectoryExists(loc.dir)>
				<cfdirectory action="create" directory="#loc.dir#">
			</cfif>			
			<cfif StructKeyExists(arguments,'file') AND Len(arguments.file)>
				<cfset loc.filename = "#arguments.file#-#arguments.to#-#arguments.from#-#arguments.subject#-#DateFormat(Now(),'d.m.yyyy')#-#TimeFormat(Now(),'hh.mm.tt')#">			
			<cfelse>
				<cfset loc.filename = "#arguments.to#-#arguments.from#-#arguments.subject#-#DateFormat(Now(),'d.m.yyyy')#-#TimeFormat(Now(),'hh.mm.tt')#">			
			</cfif>
			<cfset loc.filename = ReReplaceNoCase(loc.filename,"[^a-z0-9.@]","-","all")>
			<!--- in case too long --->			
			<cfset loc.filename = "#Left(loc.filename,220)#.html">
			<cffile action="write" file="#loc.dir##loc.filename#" output="#loc.return.tagContent#">
		</cfif>
		<cfreturn loc.return>
	</cffunction>
	
</cfcomponent>