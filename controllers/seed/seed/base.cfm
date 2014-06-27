<!--- root --->
<cfset root = model("Root").create()>
<cfset rootPerson = model("Person").create(
	rootid=root.key()
	,firstname="Adam"
	,lastname="Chapman"
	,email="adam.p.chapman@gmail.com"
	,password=standardPassword
	,passwordConfirmation=standardPassword
	,utcoffset=0
	,confirmedat=Now()
	,resettoken="foo"
	,tokencreatedat=Now()
	,tokenexpiresat=DateAdd("d", 1, Now())
)>
<cfset $$validObjectCheck("Adam", rootPerson)>

<!--- administrator --->
<cfset administrator = model("Administrator").create()>
<cfset administratorPerson = model("Person").create(
	administratorid=administrator.key()
	,firstname="Dimebag"
	,lastname="Darrell"
	,email="dime@pantera.com"
	,password=standardPassword
	,passwordConfirmation=standardPassword
	,utcoffset=0
	,confirmedat=Now()
)>
<cfset $$validObjectCheck("Dime", administratorPerson)>

<!--- user --->
<cfset user = model("User").create()>
<cfset userPerson = model("Person").create(
	userid=user.key()
	,firstname="Sid"
	,lastname="Vicious"
	,email="sid@sexpistols.co.uk"
	,password=standardPassword
	,passwordConfirmation=standardPassword
	,utcoffset=0
	,confirmedat=Now()
)>
<cfset $$validObjectCheck("Sid", userPerson)>

<cfloop from="1" to="#phonetics.Len()#" index="i">
	<cfset example = model("Example").create(
		name=phonetics[i]
		,number=i*i
		,sampledat=DateAdd("d", -i, Now())
	)>
</cfloop>

<!--- force/insert an error/s --->
<cftry>
	<cfset _void = i_am_null>
	<cfcatch type="any">
		<cfset model("Error").create(server=get("stage"), domain=cgi.server_name, remoteip=cgi.remote_addr, filepath=getCurrentTemplatePath(), controller=params.controller, action=params.action, scriptname=cgi.script_name, querystring=cgi.query_string, diagnostics=cfcatch.message, rawtrace=cfcatch.TagContext[1].raw_trace, browser=cgi.http_user_agent, referrer=cgi.http_referer, post=isPost())>
	</cfcatch>
</cftry>