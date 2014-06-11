<cfcomponent extends="Controller">
	
	<cffunction name="init">
		<cfset super.init()>
		<cfset usesLayout("/public/layout")>
		<cfset filters(through="verifySigninParams", only="signin") />
	</cffunction>
	
	<!--- 
	** FILTERS **
	 --->
	<!--- Intercepts requests without valid params. --->
	<cffunction name="verifysigninParams" access="private">
		<cfif ( (! StructKeyExists(params, "email") || ! Len(params.email) gt 0) || (! StructKeyExists(params, "password") || ! Len(params.password) gt 0) ) >
			<cfset failedSignin() />
		</cfif>
	</cffunction>
	
	<!--- 
	** PUBLIC **
	 --->
	
	<!--- The sign in form. --->
	<cffunction name="index">
		<cfset people = model("Person").findAll()><!--- remove this line during development --->
		<cfset depart() />
	</cffunction>
	
	<!--- Attempts to sign in a user. --->
	<cffunction name="signin">
		<!--- <cfset var person = model("Person").findOneByEmail(value=params.email) /> ---><!--- include="role" --->
		<cfset var person = model("Person").findOne(where="email='#params.email#'") />

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
	
	<!--- Attempts to sign out a user. --->
	<cffunction name="signout">
		<cfset depart() />
		<cfset flashInsert(message="You have been signed out", messageType="info") />
		<cfreturn redirectTo(route="publicSigninIndex")>
	</cffunction>
	
	<!--- Renders the password reset page. If an email address is passed, looks it up and sends an email confirmation email. --->
	<cffunction name="reset">
		<cfif ( StructKeyExists(params, "email") )>
			<cfif len(params.email) EQ 0>
				<cfset flashInsert(message="Please enter your e-mail address.", messageType="info") />
			<cfelse>
				<cfset var person = model("Person").findOneByEmail(params.email) />	
				<cfif ( IsObject(person) )>
					<cfset person.generateSecurityToken() />
					<cfset person.save() />

					<cfif Len(person.confirmedat) EQ 0>
						<!--- if the user has not been confirmed, need to send email for them to confirm first, then re-directs to password reset page --->
						<cfset sendEmail(
							to=person.email,
							from="#get('fromEmailAddress')#",
							subject="#get('appName')# Password Assistance",
							template="/templates/emailconfirmationresetpassword",
							person=person
						) />

					<cfelse>
						<cfset sendEmail(
							to=person.email,
							from="#get('fromEmailAddress')#",
							subject="#get('appName')# Password Assistance",
							template="/templates/passwordreset",
							person=person
						) />
					
					</cfif>

						
				</cfif>
				<cfset flashInsert(message="Please check your e-mail for reset instructions.", messageType="success") />
			</cfif>
		</cfif>
	</cffunction>
	
	<!--- Signs the user in based on a securty token and redirects them to the edit password form. --->
	<cffunction name="doPasswordReset">
		<cfif ( StructKeyExists(params, "token") && Len(params.token) )>
			<cfset var person = model("Person").findOne(where="resettoken = '#params.token#' AND tokenexpiresat > '#DateAdd("d", -1, Now())#'") />
			<cfif ( IsObject(person) ) >

				<cfset person.generateTemporaryPassword() />
				<!--- <cfset person.tokenexpiresat = now() /> --->

				<cfif ( person.update() ) >

					<cfreturn redirectTo(
						route="publicSigninChangePassword"
						,params="token=#params.token#"
						,message="Please update your password to continue."
						,messageType="info"
						,delay=true
					) />
				</cfif>
			</cfif>
		</cfif>
		<cfset failedSignin() />
	</cffunction>
	
	<!--- Renders the change password form. --->
	<cffunction name="changePassword">
		<cfif (StructKeyExists(params, "token") )>
		
			<cfset person = model("Person").findOne(where="resettoken = '#params.token#' AND tokenexpiresat > '#DateAdd("d", -1, Now())#'") />

			<cfif ( ! IsObject(person) )>
				<cfset failedSignin() />
			</cfif>
			
		<cfelse>
			<cfset failedSignin() />
		</cfif>
		
		<cfset person.password = "" />
		<cfset person.passwordConfirmation = "" />
		
	</cffunction>
	
	<cffunction name="savePassword">
		<cfset person = model("Person").findOne(where="resettoken = '#params.token#' AND tokenexpiresat > '#DateAdd("d", -1, Now())#'") />
		
		<!--- expire token.. --->
		<cfset person.tokenexpiresat = now() />
		
		<!--- Verify that the users updates successfully --->
		<cfif person.update(params.person)>
			<cfset flashInsert(message="Your password was updated successfully.", messageType="success") />
			<cfset arrive(person) />	
			<cfif StructKeyExists(cookie,"hissPropParams")>
				<cfreturn redirectTo(route="consumerSubmissionsPropertySwitch")>
			<cfelse>
				<cfreturn redirectTo(route="jointDetourRoot")>
			</cfif>			
		<!--- Otherwise --->
		<cfelse>
			<cfset flashInsert(message="There was an error updating your password.", messageType="error") />
			
			<cfset person.password = "" />
			<Cfset person.passwordConfirmation = "" />
			
			<cfset renderPage(action="changePassword")>
		</cfif>
		
	</cffunction>
		
	<!--- 
	** PRIVATE **
	 --->
	<!--- Handles bad signin attempts. --->
	<cffunction name="failedSignin">
		<cfparam name="params.email" type="string" default="" />
		<cfset flashInsert(message="Sign in was unsuccessful. Please try again.", messageType="error") />
		<cfset renderPage(action="index", params=params.email) />

	</cffunction>

</cfcomponent>