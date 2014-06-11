<!--- Creates a cookie for an authenticated person object. --->
<cffunction name="arrive" output="false">
	<cfargument name="person" required="true" type="any">
	<cfcookie name="#constant('sessionCookieName')#" value="#securify(arguments.person.id)#" expires="#endOfDay(DateAdd('d', 3, Now()))#">
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
	<cfreturn StructKeyExists(cookie, constant("sessionCookieName"))>
</cffunction>

<!--- Returns the id of the current person --->
<cffunction name="getCurrentPersonId" output="false">
	<cfreturn isPresent() ? desecurify(cookie[constant('sessionCookieName')]) : false>
</cffunction>

<cffunction name="getPresentPerson" output="false" hint="this differs from getCurrentPerson in that it is available globally">
	<cfargument name="base" type="boolean" required="false" default="false" hint="when impersonation is in effect, return the base person">
	<cfset var loc = {}>
	<!--- <cfset loc.person = model("Person").findByKey(key=getCurrentPersonId())> --->
	<cfset loc.person = model("Person").findOne(where="id=#getCurrentPersonId()# AND confirmedat IS NOT NULL")>

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

<cffunction name="sessionInsert" access="private">
	<cfargument name="sessionData" type="string" required="true" hint="A JSON (or empty) string">
	<cfargument name="key" type="string" required="true">
	<cfargument name="value" type="any" required="true">
 	<cfset var loc = {}>
 	<cfset loc.return = IsJSON(arguments.sessionData) ? DeserializeJSON(arguments.sessionData) : {}>
 	<cfset loc.return[arguments.key] = arguments.value>
 	<cfreturn SerializeJSON(loc.return)>
</cffunction>

<cffunction name="sessionDelete" access="private">
	<cfargument name="sessionData" type="string" required="true" hint="A JSON (or empty) string">
	<cfargument name="key" type="string" required="true">
 	<cfset var loc = {}>
 	<cfset loc.return = IsJSON(arguments.sessionData) ? DeserializeJSON(arguments.sessionData) : {}>
 	<cfset StructDelete(loc.return, arguments.key)>
 	<cfreturn SerializeJSON(loc.return)>
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