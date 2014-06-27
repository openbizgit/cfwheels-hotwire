<cffunction name="getParam" output="false" returnType="any">
	<cfargument name="key" type="string" required="true" />
	<cfargument name="default" type="any" default="" />
	<cfargument name="accepted" type="string" default="" />
	<cfset var loc = {} />
	
	<cfif not structKeyExists(params,arguments.key)>
		<cfset params[arguments.key] = arguments.default />
	</cfif>
	
	<cfset loc.result = params[arguments.key] />
	
	<cfif len(arguments.accepted) gt 0>
		<cfset arguments.accepted = ListAppend(arguments.accepted, arguments.default) />
		<cfif ListFindNoCase( arguments.accepted, loc.result) eq 0>
			<cfset loc.result = arguments.default />
		</cfif>
	</cfif>
	<cfreturn loc.result />
</cffunction>

<cffunction name="isFalse" output="false" hint="checks whether a value is a boolean and is false">
	<cfargument name="value" type="any" required="true">
	<cfreturn IsBoolean(arguments.value) && ! arguments.value>
</cffunction>

<cffunction name="isTest" output="false">
	<cfreturn (StructKeyExists(url,"controller") AND url.controller IS "wheels") AND (StructKeyExists(url,"action") AND url.action IS "wheels") AND (StructKeyExists(url,"view") AND url.view IS "tests") AND (StructKeyExists(url,"type") AND url.type IS "app") OR (StructKeyExists(url,"controller") AND url.controller IS "junify")>
</cffunction>

<cffunction name="constant" output="false">
	<cfargument name="name" type="string" required="true">
	<cfset var loc = {} />
	<cfset loc.sessionCookieName = "hotwire">
	<cfset loc.lastPageCookieName = "last_page">
	<cfset loc.securityString = "change_this_to_something_else">
	<cfset loc.tomorrow = DateAdd("d", 1, Now())>
	<cfset loc.midnight = CreateDateTime(Year(loc.tomorrow), Month(loc.tomorrow), Day(loc.tomorrow), 0, 0, 0, 0)>
	<cfset loc.unauthorisedAccessMessage="401 Unauthorized">
	<cfreturn loc[arguments.name]>
</cffunction>

<cffunction name="extractHTTPHeader" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfset var loc = {}>
	<cfset loc.headers = GetHTTPRequestData().headers>
	<cfreturn StructKeyExists(loc.headers, arguments.name) ? loc.headers[arguments.name] : "">
</cffunction>

<cffunction name="UTCToLocalSQL" output="false">
	<cfargument name="property" type="string" required="true">
	<cfreturn "DATE_ADD(#arguments.property#, INTERVAL #getPresentPerson().utcoffset# minute)">
</cffunction>

<cffunction name="spamDetector" returntype="struct" output="false">
	<cfargument name="emailParam" type="string" required="false" default="consumer[person][email]">
	<cfargument name="expectedParams" type="string" required="false" default="person[email],person[password],username,passwordConfirm,dt">
	<cfargument name="honeyPotParams" type="string" required="false" default="passwordConfirm">
	<cfargument name="javascriptNameValue" type="string" required="false" default="username=#extractHTTPHeader("host")#">

	<cfset var loc = {}>
	<cfset loc.return = {}>
	<cfset loc.return.info = "ok"><!--- for debug only --->
	<cfset loc.return.success = true>

	<!--- separate javascript name/value --->
	<cfset loc.javascriptParamName = ListFirst(arguments.javascriptNameValue, "=")>
	<cfset loc.javascriptParamValue = ListLast(arguments.javascriptNameValue, "=")>

	<!--- check that all expected params are found --->
	<cfset loc.expectedParamsFound = true>
	<cfloop list="#arguments.expectedParams#" index="loc.i">
		<cfif ! StructKeyExists(form,loc.i)>
			<cfset loc.expectedParamsFound = false>
			<cfbreak>
		</cfif>
	</cfloop>

	<cfset loc.honeypotdParamsEmpty = true>
	<cfloop list="#arguments.honeyPotParams#" index="loc.i">
		<cfif StructKeyExists(form,loc.i) AND form[loc.i] neq "">
			<cfset loc.honeypotdParamsEmpty = false>
			<cfbreak>
		</cfif>
	</cfloop>
	<!--- // email param must be present --->
	<cfif ! isPost()>
		<cfset loc.return.success = false>
		<cfset loc.return.info = "post data not found">
	<cfelseif ! StructKeyExists(form, arguments.emailParam)>
		<cfset loc.return.success = false>
		<cfset loc.return.info = "email param not found">
	<!--- // only 4 params must be present in form scope --->
	<cfelseif Len(arguments.expectedParams) gt 0 AND (ListLen(form.fieldnames) neq ListLen(arguments.expectedParams))>
		<cfset loc.return.success = false>
		<cfset loc.return.info = "incorrect number of params found">
	<cfelseif ! loc.expectedParamsFound>
		<cfset loc.return.success = false>
		<cfset loc.return.info = "expected params not found">
	<!--- // honeypot field/s must be empty --->
	<cfelseif ! loc.honeypotdParamsEmpty>
		<cfset loc.return.success = false>
		<cfset loc.return.info = "honeypot fields not empty">
	<!--- // referrer must be the same domain --->
	<cfelseif Find(extractHTTPHeader("host"), extractHTTPHeader("referer")) eq 0>
		<cfset loc.return.success = false>
		<cfset loc.return.info = "invalid referrer">
	<!--- // detect javascript (this value written into hidden field via js) --->
	<cfelseif params[loc.javascriptParamName] != loc.javascriptParamValue>
		<cfset loc.return.success = false>
		<cfset loc.return.info = "javascript params not found">
	</cfif>

	<cfreturn loc.return>

</cffunction>

<cffunction name="hideDebug" output="false">
	<cfsetting showdebugoutput="false">
	<cfset set(showDebugInformation=false)>
</cffunction>

<cffunction name="service" returntype="any" output="false"  hint="I am the method used to access any service layer object from within any controller">
	<cfargument name="service" type="string" required="true" />
	<cfset var return = "" />
	<cfif StructkeyExists(application.$_ServiceObjects,arguments.service)>
		<cfset return = application.$_ServiceObjects[arguments.service] />
	</cfif>
	<cfreturn return />
</cffunction>

<cfscript>
	/**
	 * @hint Redirects to a stored location or default location.
	 */
	 public any function redirectBackOr(string controller="#adminNamespace(signedInUser().isAdministrator)#.dash", string action="index") {

	 	redirectTo(argumentCollection = arguments);

	 	// check that admin namespaces in session arent different to those in params (really only happens in dev when testing between master and admin accounts)
	 	/*
	 	TODO: get this working..
	 	if ( StructKeyExists(session, "returnTo") && adminNamespace(signedInUser().isAdministrator) != ListFirst(session.returnTo, "./")) {
	 		StructDelete(session, "returnTo");
	 	}

	 	 if ( StructKeyExists(session, "returnTo") ) {
			var returnTo = Duplicate(session.returnTo);
			StructDelete(session, "returnTo");
	 	 	redirectTo(argumentCollection = returnTo);
	 	 }
	 	 else {
			redirectTo(argumentCollection = arguments);
	 	 }
	 	 */
	 }

	/**
	 * @hint Stores return path to use for friendly redirects.
	 */
	 public void function storeLocation(required struct parameters) {
	 	 session.returnTo = arguments.parameters;
	 }
	
</cfscript>