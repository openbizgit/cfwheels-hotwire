<cffunction name="personDirectoryPath" output="false" description="returns an absolute path to the person's folder">
	<cfargument name="personid" type="numeric" required="true">	
	<cfreturn get("bucketPath") & "person/#arguments.personid#/">
</cffunction>

<cffunction name="personFilePath" output="false" description="returns an absolute path to a person's file">
	<cfargument name="personid" type="numeric" required="true">	
	<cfargument name="filename" type="string" required="true">
	<cfreturn personDirectoryPath(argumentCollection=arguments) & arguments.filename>
</cffunction>

<cffunction name="personDirectoryURL" output="false" description="returns a URL to the person's folder">
	<cfargument name="personid" type="numeric" required="true">	
	<cfreturn get("bucketURL") & "person/#arguments.personid#/">
</cffunction>

<cffunction name="personFileURL" output="false" description="returns a URL to the person's file">
	<cfargument name="personid" type="numeric" required="true">	
	<cfargument name="filename" type="string" required="true">
	<cfreturn personDirectoryURL(argumentCollection=arguments) & arguments.filename> 
</cffunction>