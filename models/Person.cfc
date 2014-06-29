<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<!--- associations --->
		<cfset belongsTo(name="Root")>
		<cfset belongsTo(name="Administrator")>
		<cfset belongsTo(name="User")>
		<!--- calculated properties --->
		<cfset property(name="fullname", sql="CONCAT(firstname, ' ', lastname)")>
		<!--- property labels --->
		<cfset property(name="firstname", label="first name")>		
		<cfset property(name="lastname", label="last name")>		
		<!--- validation --->
		<cfset validatesConfirmationOf("password") />
		<!--- only validate if password is not empty and has not already been hashed --->
		<cfset validate(method="$$validatePassword", condition="StructKeyExists(this, 'password') && ListFind('0,128', Len(this.password)) eq 0")>
		<cfset validatesFormatOf(property="email", type="email", unless="this.email is ''") />
		<cfset validatesUniquenessOf(property="email", unless="this.email is ''") />
		<!--- callbacks --->
		<cfset beforeValidation("$$massage,$$setSalt,$$setRememberToken")>
		<cfset beforeSave("$$securePassword")>
		<cfset afterFind("$$setPropertiesAfterFind")>
	</cffunction>
	
	<!---
	** CALLBACKS **
	 --->

	<cffunction name="$$massage" access="private">
		<cfif StructKeyExists(this,"firstName")>
			<cfset this.firstName = HtmlEditFormat(this.firstName) />
		</cfif>
		<cfif StructKeyExists(this,"lastName")>
			<cfset this.lastName = HtmlEditFormat(this.lastName) />
		</cfif>
	</cffunction>
	
	<!--- Secures the password property before saving it. --->
	<cffunction name="$$securePassword" access="private">
		<cfif ( StructKeyExists(this, "passwordConfirmation") )>
			<cfset this.password = hashPassword(this.password, this.salt) />
			<cfset this.passwordConfirmation = hashPassword(this.passwordConfirmation, this.salt) />
		</cfif>
	</cffunction>

	<!--- Creates a salt string to use for hashing the password. --->
	<cffunction name="$$setSalt" access="private">
		<cfif ( StructKeyExists(this, "passwordConfirmation") )>
			<cfset this.salt = bCrypt().genSalt() />
		</cfif>
	</cffunction>

	<cffunction name="$$setRememberToken" access="private">
		<cfif this.isNew() && ! this.propertyIsPresent("remembertoken")>
			<cfset generateRememberToken()>
		</cfif>
	</cffunction>

	<cffunction name="$$setPropertiesAfterFind" access="private" hint="add some handy properties to the object">
		<cfset var loc = {}>
		<cfif StructKeyExists(this,"rootid") && Val(this.rootid) gt 0>
			<cfset arguments["namespace"] = "root">
			<cfset arguments["persontype"] = "root">
			<cfset arguments["keycolumn"] = "rootid">
			<cfset arguments["namevaluepair"] = "rootid=#this.rootid#">
		<cfelseif StructKeyExists(this,"administratorid") && Val(this.administratorid) gt 0>
			<cfset arguments["namespace"] = "administrator">
			<cfset arguments["persontype"] = "administrator">
			<cfset arguments["keycolumn"] = "administratorid">
			<cfset arguments["namevaluepair"] = "administratorid=#this.administratorid#">
		<cfelseif StructKeyExists(this,"userid") && Val(this.userid) gt 0>
			<cfset arguments["namespace"] = "user">
			<cfset arguments["persontype"] = "user">
			<cfset arguments["keycolumn"] = "userid">
			<cfset arguments["namevaluepair"] = "userid=#this.userid#">
		</cfif>
		<cfreturn arguments>
	</cffunction>

	<!--- 
	** CUSTOM VALIDATORS **
	 --->
	<cffunction name="$$validatePassword" access="private">
	    <cfif Len(Trim(this.password)) LT 8>
			<cfset addError(property="password", message="Your password must be at least 8 characters long.")>
	    <cfelseif ReFindNoCase('[a-z]',this.password) eq 0>
	    	<cfset addError(property="password", message="Your password must contain at least one letter.")>
	    <cfelseif ReFind('[0-9]',this.password) eq 0>
	    	<cfset addError(property="password", message="Your password must contain at least one number.")>
	    <cfelseif ReFind('[!@##$&*]',this.password) eq 0>
			<cfset addError(property="password", message="Your password must contain at least one symbol.")>
		<!--- <cfelseif ReFindNoCase('[A-Z]',this.password) eq 0>
	    	<cfset addError(property="password", message="Your password must contain at least one uppercase letter.")> --->
		</cfif>
	</cffunction>

	<!---
	** PUBLIC **
	 --->

	<!--- Authenticates a user object. --->	
	<cffunction name="authenticate">
		<cfargument name="password" required="true" type="string">
		<cfreturn ! Compare(this.password, hashPassword(arguments.password, this.salt))>
	</cffunction>

	<!--- Generates an expiring security token for password resets. --->
	<cffunction name="generateSecurityToken">
		<cfset this.resetToken = randomString("urlsafe", 64)>
		<cfset this.tokenCreatedAt = Now()>
		<cfset this.tokenExpiresAt = DateAdd("h", 24, Now())>
	</cffunction>

	<!--- Generates a temporary password when users reset their password. --->
	<cffunction name="generateTemporaryPassword">
		<cfset this.password = randomString("secure", 128) & "!">
	</cffunction>

	<cffunction name="generateRememberToken">
		<cfset this.remembertoken = randomString("urlsafe", 64)>
	</cffunction>
	
	<!---
	** PRIVATE **
	 --->

	<!--- Hashes a password string. --->
	<cffunction name="hashPassword" access="private">
		<cfargument name="password" required="true" type="string">
		<cfargument name="salt" required="true" type="string">
		<cfreturn bCrypt().hashpw(arguments.password, arguments.salt)>
	</cffunction>

	<cffunction name="bCrypt" access="private" hint="Creates bCrypt object for authentication and password encryption">
		<cfreturn CreateObject("java", "BCrypt", "../lib")>
	</cffunction>

	<!---
	** PRIVATE (but public so it's testable) **
	 --->

	<cffunction name="_securePassword">
		<cfreturn hashPassword(argumentCollection=arguments) />
	</cffunction>

</cfcomponent>