<!--- Creates a cookie for an authenticated person object. --->
<cffunction name="arrive" output="false">
	<cfargument name="person" required="true" type="any">
	<cfcookie name="#constant('sessionCookieName')#" value="#arguments.person.remembertoken#" expires="never">
</cffunction>

<!--- Destroys current cookies. --->
<cffunction name="depart" output="false">
	<cfif isPresent()>
		<cfloop collection="#cookie#" item="i">
			<cfset StructDelete(cookie, i)>
		</cfloop>
	</cfif>
</cffunction>

<!--- Checks if a person is logged in --->
<cffunction name="isPresent" output="false">
	<cfreturn StructKeyExists(cookie, constant("sessionCookieName")) && IsObject(getPresentPerson())>
</cffunction>

<cffunction name="getRememberToken">
	<cfreturn cookie[constant("sessionCookieName")]>
</cffunction>

<cffunction name="getPresentPerson" output="false" hint="this differs from getCurrentPerson in that it is available globally">
	<cfargument name="base" type="boolean" required="false" default="false" hint="when impersonation is in effect, return the base person">
	<cfset var loc = {}>
	<cfset loc.person = model("Person").findOne(where="remembertoken = '#getRememberToken()#' AND confirmedat IS NOT NULL")>

	<cfif ! IsObject(loc.person)>
		<cfreturn false>
	</cfif>
	
	<cfset loc.return = Duplicate(loc.person)>
	<cfif arguments.base>
		<cfreturn loc.return>
	</cfif>
	<!--- serialise JSON sessiom data --->
 	<cfif IsJSON(loc.person.sessiondata)>
		<cfset loc.return.session = DeserializeJSON(loc.person.sessiondata)>
	</cfif> 
	<!--- store the impersonating person --->
	<!--- <cfif StructKeyExists(loc.return, "session") && StructKeyExists(loc.return.session, "impersonates")>
		<cfset loc.return = model("Person").findByKey(key=loc.return.session.impersonates.id)>
		<cfset loc.return.isImpersonated = true>
		<cfset loc.return.impersonator = {id=loc.person.id, name=loc.person.firstname}>
	</cfif>	 --->
	<cfreturn loc.return>
</cffunction>

<!--- <cfscript>

	 /**
	 * @hint Is this administrator imoersonating someone?
	 */
	 public boolean function isImpersonator() {
	 	return StructKeyExists(getPresentPerson(), "isImpersonated") && getPresentPerson().isImpersonated;
	 }

	 /**
	 * @hint Impersonates a person.
	 */
	 public void function impersonatePerson(required numeric key) {
	 	var loc = {};
	 	var loc.impersonator = getPresentPerson(base=true);
	 	var loc.impersonatee = model("Person").findByKey(key=arguments.key);
	 	if (Val(loc.impersonator.administratorid)) {
	 		// store who I'm impersonating
		 	loc.impersonator.sessiondata = sessionInsert(loc.impersonator.sessiondata, "impersonates", loc.impersonatee.properties());
		 	loc.impersonator.save();
	 	}
	 }

	 /**
	 * @hint Stop impersonating a person.
	 */
	 public void function depersonatePerson() {
	 	var person = getPresentPerson(base=true);
	 	person.sessionData = sessionDelete(person.sessionData, "impersonates");
	 	person.save()
	 }
</cfscript> --->