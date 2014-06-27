<!--- app settings --->
<cfset set(appName="Hotwire")>
<cfset set(appKey=LCase(get("appName")))>
<cfset set(domain="#get("appKey")#.com")>
<cfset set(loadDefaultRoutes=false)><!--- use coldroute --->
<cfset set(URLRewriting="On")>

<!--- email settings --->
<cfset set(fromEmailAddress="#get("appName")# <no-reply@#get("domain")#>")>
<cfset set(errorEmailAddress="developers@#get("domain")#")>
<cfset set(errorEmailSubject="#get("appName")# error occured")>
<cfset set(defaultEmailLayout="/mailers/layouts/public")>
<cfset set(sendEmailOnError=false)>
<cfset set(useExpandedColumnAliases=false)>

<!--- // don't cache --->
<cfset set(cacheActions=false)>
<cfset set(cachePages=false)>
<cfset set(cachePartials=false)>
<cfset set(cacheQueries=false)>

<!--- plugin settings. plugins will be deployed unpacked --->
<cfset set(overwritePlugins=false)>
<cfset set(deletePluginDirectories=false)>

<!--- // function defaults --->
<cfset set(functionName="sendEmail", from=get("fromEmailAddress"), layout=get("defaultEmailLayout"))>
<cfset set(functionName="findAll", perPage=10)>
<cfset set(functionName="startFormTag", id="w-form", class="form-horizontal", role="form")>
<cfset set(functionName="datePicker", style="width:100px;", dateFormat="dd/mm/yy")>
<cfset set(functionName="datePickerTag", style="width:100px;", dateFormat="dd/mm/yy")>
<cfset set(functionName="paginationLinks", name="pg", prepend='<div class="row text-center">', append='</div>', class="badge default", classForCurrent="badge primary", anchorDivider='...', linkToCurrentPage=true, windowSize=5)>
<cfset set(functionName="redirectTo", delay=true)>

<!--- environment (stage) based variables --->
<cfif get('stage') eq "development">
	<cfset set(AWSAccessKeyId="not-required-in-development")>
	<cfset set(AWSSecretKey="not-required-in-development")>
	<cfset set(reloadPassword="")>
<cfelseif ListFindNoCase("ci,demo,staging", get('stage')) gt 0>
	<cfset set(AWSAccessKeyId="same-as-those-in-s3.staging.cfm")>
	<cfset set(AWSSecretKey="same-as-those-in-s3.staging.cfm")>
	<cfset set(reloadPassword="my-reload-password")>
	<cfset set(fromEmailAddress="developers@#get("domain")#")>
<cfelseif get('stage') eq "production">
	<cfset set(AWSAccessKeyId="same-as-those-in-s3.production.cfm")>
	<cfset set(AWSSecretKey="same-as-those-in-s3.production.cfm")>
	<cfset set(reloadPassword="my-reload-password")>
</cfif>

<cfswitch expression="#get('stage')#">
	
	<cfcase value="development">
		<cfset set(dataSourceName="#get("appKey")#-development")>
		<cfset application.pluginManager.requirePassword = false>
		<cfset set(cachePlugins=false)>
		<!--- allow toggling of debug via url --->
		<cfif StructKeyExists(url,"debug")>
			<cfset set(showDebugInformation=url.debug)>
		</cfif>
		<cfset set(reloadPassword="")>
		<cfset set(bucketPath=ExpandPath("s3-bucket") & "/")>
		<cfset set(bucketURL="http#cgi.server_port_secure ? 's' : ''#://#cgi.server_name##cgi.server_port eq 80 ? '' : ':#cgi.server_port#'#/s3-bucket/")>
	</cfcase>

	<cfcase value="ci">
		<cfset set(dataSourceName="#get("appKey")#-ci")>
		<cfset set(bucketPath="s3://#get("appKey")#-ci/")>
		<cfset set(bucketURL="https://s3-ap-southeast-2.amazonaws.com/#get("appKey")#-ci/")>
	</cfcase>
	
	<cfcase value="demo">
		<cfset set(dataSourceName="#get("appKey")#-demo")>
		<cfset set(bucketPath="s3://#get("appKey")#-demo/")>
		<cfset set(bucketURL="https://s3-ap-southeast-2.amazonaws.com/#get("appKey")#-demo/")>
	</cfcase>
	
	<cfcase value="staging">
		<cfset set(dataSourceName="#get("appKey")#-staging")>
		<cfset set(bucketPath="s3://#get("appKey")#-staging/")>
		<cfset set(bucketURL="https://s3-ap-southeast-2.amazonaws.com/#get("appKey")#-staging/")>
	</cfcase>
	
	<cfcase value="production">
		<cfset set(dataSourceName="#get("appKey")#")>
		<cfset set(bucketPath="s3://#get("appKey")#/")>
		<cfset set(bucketURL="https://s3-ap-southeast-2.amazonaws.com/#get("appKey")#/")>
	</cfcase>
	
	<cfdefaultcase>
		<cfthrow type="Application" message="All the world is a stage.. #get('stage')#">
	</cfdefaultcase>

</cfswitch>


<!--- 
	Build lookup struct/arrays so we dont have to join tables just to get lookup type names.
	The try/catch is mainly here when the dbmigrate script is first run and the tables don't exist.
	Lookup tables must be structured as.. sometypes: id, sometype
 --->
<cftry>
	<cfset lookups = {}>
	<cfset StructAppend(lookups, $$lookupBuilder("SomeType"))>
	<cfset set(lookups=Duplicate(lookups))>
	<cfcatch type="any"></cfcatch>
</cftry>

<cffunction name="$$lookupBuilder" returntype="struct" output="false">
	<cfargument name="modelName" type="string" required="true">
	<cfset var loc = {}>
	<cfset loc.ret = {}>
	<cfset loc.query = model(arguments.modelName).findAll(order="id")>
	<cfset loc.ret["#arguments.modelName#Array"] = []>
	<cfset loc.ret["#arguments.modelName#Struct"] = {}>
	<cfloop query="loc.query">
		<cfset loc.key = ReReplaceNoCase(loc.query[arguments.modelName][currentRow], "[^A-Z]", "", "all")>
		<cfset loc.ret["#arguments.modelName#Struct"][loc.key] = id>
		<cfset loc.ret["#arguments.modelName#Array"][id] = loc.query[arguments.modelName][currentRow]>
	</cfloop>
	<cfreturn loc.ret>
</cffunction>