<cffunction name="flashMessageTag" access="public" output="false" returnType="string" hint="Flashes any avalable messages in the flash.">
	<cfargument name="messageType" type="string" required="false" default="default,warning,info,success">
	<cfif flashKeyExists("message") AND ListFindNoCase(arguments.messageType, flash('messageType')) gt 0>
		<cfreturn '<div id="flash-message" class="alert alert-#flash('messageType')#" data-dismiss="alert" align="center"><a class="close">&times;</a>#flash("message")#</div>'>
	<cfelse>
		<cfreturn "">
	</cfif>
</cffunction>

<cffunction name="errorMessageTag" access="public" output="false" returnType="string" hint="Flashes any avalable messages in the flash. EXCEPT errors">
	<cfargument name="objectNames" type="string" required="false">
	<cfset var loc = {}>
	<cfset loc.ret = "">
	<cfset loc.errors = "">
	<cfif flashKeyExists("message") AND flash('messageType') eq "error">
		<cfset loc.message = '<div class="alert alert-danger">#flash("message")#</div>'>
		<cfsavecontent variable="loc.ret">
			<cfoutput>
				<cfif StructKeyExists(arguments, "objectNames")>
					<div class="panel panel-danger">
						<div class="panel-heading">
							<h3 class="panel-title">#flash("message")#</h3>
						</div>
						<div class="panel-body">
							<cfloop list="#arguments.objectNames#" index="loc.i">
								<cfset loc.errors = loc.errors & errorMessagesFor(objectName=loc.i)>
							</cfloop>
							<cfset loc.errors = replaceNoCase(loc.errors, '<ul class="errorMessages">', "", "all")>
							<cfset loc.errors = replaceNoCase(loc.errors, "</ul>", "", "all")>
							<ol style="margin-left:-15px;">
								#loc.errors#
							</ol>
						</div>
					</div>
				<cfelse>
					<div class="alert alert-danger">#flash("message")#</div>
				</cfif>
			</cfoutput>
		</cfsavecontent>
	</cfif>
	<cfreturn loc.ret>
</cffunction>

<cffunction name="pageTitle" access="public" output="false" returnType="string" hint="Sets and displays page title">
	<cfargument name="title" type="string" required="true">
	<cfargument name="show" type="boolean" required="false" default="true">
	<!--- NOTE: pageTitle variable also used in layout.cfm for html title tag--->
	<cfset contentFor(pageTitle=arguments.title)>
	<cfif arguments.show>
		<cfsavecontent variable="loc.html">
			<cfoutput>
				<div class="page-header">
					<h2>#includeContent("pageTitle")#</h2>
				</div>
			</cfoutput>
		</cfsavecontent>
		<cfreturn loc.html>
	</cfif>
</cffunction>

<cffunction name="heading" access="public" output="false" returnType="string" hint="Displays a heading string">
	<cfargument name="heading" type="string" required="true">
	<cfreturn '<h4>#arguments.heading#</h4>'>
</cffunction>

<!--- overwrite wheels function (i.e. wheels/view/date.cfm) to have word ago after date --->
<cffunction name="timeAgoInWords" returntype="string" access="public" output="false">
	<cfreturn core.timeAgoInWords(argumentCollection=arguments) & " ago">
</cffunction>	