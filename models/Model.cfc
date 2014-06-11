<!---
	This is the parent model file that all your models should extend.
	You can add functions to this file to make them globally available in all your models.
	Do not delete this file.
--->
<cfcomponent extends="Wheels">
	
	<cffunction name="sanitiseDate" access="package">
		<cfargument name="string" required="true" type="string" />
		<cfreturn arguments.string IS "" ? "" : parseDate(arguments.string)>
	</cffunction>
	
	<cffunction name="humaniseDate" access="package">
		<cfargument name="string" required="true" type="string" />
		<cfreturn Left(arguments.string,1) IS "{" AND Right(arguments.string,1) IS "}" ? DateFormat(arguments.string,"dd/mm/yyyy") : "">
	</cffunction>

	<cffunction name="isPostedDate" access="package">
		<cfargument name="string" required="true" type="string" />
		<!--- TODO: use regex to test format of string --->
		<cfreturn ListLen(arguments.string, "/") eq 3>
	</cffunction>

</cfcomponent>