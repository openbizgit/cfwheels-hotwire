<cfcomponent extends="Controller">
	
	<cffunction name="init">
		<cfset super.init()>
		<cfset usesLayout("/public/layout")>
		<cfset filters(through="verifySigninParams", only="create") />
	</cffunction>
	
	<!--- 
	** FILTERS **
	 --->
	 
	<cffunction name="verifySigninParams" access="private" hint="Intercepts requests without valid params">
		<cfif ( (! StructKeyExists(params, "email") || ! Len(params.email) gt 0) || (! StructKeyExists(params, "password") || ! Len(params.password) gt 0) ) >
			<cfset failedSignin() />
		</cfif>
	</cffunction>
	
	<!--- 
	** PUBLIC **
	 --->
	
	<cffunction name="new" hint="The sign in form">
		<cfset people = model("Person").findAll()><!--- remove this line during development --->
		<cfset depart() />
	</cffunction>
	
	<cffunction name="create" hint="Sign in a user">
		<cfset var person = model("Person").findOneByEmail(params.email) />

		<cfif ( ! IsObject(person) || ! person.authenticate(params.password) ) >
			<cfset failedSignin() />
		<!--- check if this person has confirmed their account via email --->
		<cfelseif person.confirmedat EQ "">
			<!--- not yet confirmed --->
			<cfreturn redirectTo(route="publicSignupRequestConfirmation", params="personid=#person.id#&email=#params.email#")>
		<cfelse>
			<cfset localTime = parseDateTimeString(params.dt)>
			<cfset utcoffset = DateDiff("n", Now(), localTime)>

			<cfset person.update(lastSigninAt=Now(), lastSigninAttemptAt=Now(), lastSigninAttemptIPAddress=CGI.REMOTE_ADDR, utcoffset=utcoffset)>

			<cfset arrive(person) />
			<cfset flashInsert(message="Hi #person.firstname#, welcome to #get("appName")#", messageType="success") />
			<cfreturn redirectTo(route="jointDetourRoot")>
		</cfif>		
	</cffunction>
	
	<cffunction name="delete" hint="Sign out a user">
		<cfif isPresent()>
			<cfset model("Person").updateOne(where="remembertoken = '#getRememberToken()#'", remembertoken=randomString("secure", 64, true))>
			<cfset depart()>
		</cfif>
		<cfset flashInsert(message="You have been signed out", messageType="info") />
		<cfreturn redirectTo(route="publicSessionsNew")>
	</cffunction>
		
		<!--- 
		** PRIVATE **
		 --->
		<cffunction name="failedSignin" hint="Handles bad signin attempts">
			<cfparam name="params.email" type="string" default="" />
			<cfset flashInsert(message="Sign in was unsuccessful. Please try again.", messageType="error") />
			<cfset renderPage(action="new", params=params.email) />
		</cffunction>

</cfcomponent>