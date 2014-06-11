<cfset this.name = Hash(GetCurrentTemplatePath())>
<cfset this.mappings["/base"] = "">
<cfset this.mappings['/plugins'] = "plugins">
<cfset this.mappings['/tests'] = "tests">
<cfset this.customtagpaths = "customtags">
<!--- amazon S3 --->
<cfinclude template="s3.cfm">