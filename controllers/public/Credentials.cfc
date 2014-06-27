<cfcomponent extends="Controller">
	
	<cffunction name="init">
		<cfset super.init()>
		<cfset usesLayout("/public/layout")>
	</cffunction>
	
	<!--- 
	** PUBLIC **
	 --->
	
	<cffunction name="new" hint="Renders the password reset page. If an email address is passed, looks it up and sends an email confirmation email">
		<cfif ( StructKeyExists(params, "email") )>
			<cfif len(params.email) EQ 0>
				<cfset flashInsert(message="Please enter your email address.", messageType="warning") />
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
							template="/mailers/emailconfirmationresetpassword",
							person=person
						) />
					<cfelse>
						<cfset sendEmail(
							to=person.email,
							from="#get('fromEmailAddress')#",
							subject="#get('appName')# Password Assistance",
							template="/mailers/passwordreset",
							person=person
						) />
					</cfif>
				</cfif>
				<cfset flashInsert(message="Please check your email for reset instructions.", messageType="success") />
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="create" hint="Signs the user in based on a securty token and redirects them to the edit password form">
		<cfif ( StructKeyExists(params, "token") && Len(params.token) )>
			<cfset var person = model("Person").findOne(where="resettoken = '#params.token#' AND tokenexpiresat > '#DateAdd("d", -1, Now())#'") />
			<cfif ( IsObject(person) ) >

				<cfset person.generateTemporaryPassword() />
				<!--- <cfset person.tokenexpiresat = now() /> --->
				<cfif ( person.update() ) >
					<cfreturn redirectTo(
						route="publicPasswordsEdit"
						,params="token=#params.token#"
						,message="Please update your password to continue."
						,messageType="info"
						,delay=true
					) />
				</cfif>

			</cfif>
		</cfif>
		<cfset $$failedSignin() />
	</cffunction>
	
	<!--- Renders the change password form. --->
	<cffunction name="edit">
		<cfif (StructKeyExists(params, "token") )>
		
			<cfset person = model("Person").findOne(where="resettoken = '#params.token#' AND tokenexpiresat > '#DateAdd("d", -1, Now())#'") />

			<cfif ( ! IsObject(person) )>
				<cfset $$failedSignin() />
			</cfif>
			
		<cfelse>
			<cfset $$failedSignin() />
		</cfif>
		
		<cfset person.password = "" />
		<cfset person.passwordConfirmation = "" />
		
	</cffunction>
	
	<cffunction name="update">
		<cfset person = model("Person").findOne(where="resettoken = '#params.token#' AND tokenexpiresat > '#DateAdd("d", -1, Now())#'") />
		
		<!--- expire token.. --->
		<cfset person.tokenexpiresat = now() />
		
		<!--- Verify that the users updates successfully --->
		<cfif person.update(params.person)>
			<cfset flashInsert(message="Your password was updated successfully.", messageType="success") />
			<cfset arrive(person) />	
			<cfreturn redirectTo(route="jointDetourRoot")>			
		<!--- Otherwise --->
		<cfelse>
			<cfset flashInsert(message="There was an error updating your password.", messageType="error") />
			
			<cfset person.password = "" />
			<Cfset person.passwordConfirmation = "" />
			
			<cfset renderPage(action="edit")>
		</cfif>
		
	</cffunction>

		<!--- 
		** PRIVATE **
		 --->
		<cffunction name="$$failedSignin" hint="Handles bad signin attempts">
			<cfparam name="params.email" type="string" default="" />
			<cfset flashInsert(message="Sign in was unsuccessful. Please try again.", messageType="error") />
			<cfset renderPage(action="new", params=params.email) />
		</cffunction>

</cfcomponent>