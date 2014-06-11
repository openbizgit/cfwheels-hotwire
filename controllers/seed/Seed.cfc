<cfcomponent extends="Controller">
		
	<cffunction name="init">
		<cfset super.init()>
	</cffunction>

	<cffunction name="options">
		<cfoutput>
			<cfsavecontent variable="html">
				<h4>Reset Data</h4>
				<hr/>
				#linkTo(route="seedSeedIndex", text="Developer", type="developer")#<br/>
				#linkTo(route="seedSeedIndex", text="Demo", type="demo")#<br/>
				#linkTo(route="seedSeedIndex", text="Testing", type="ci")#<br/>
			</cfsavecontent>
		</cfoutput>
		<cfset renderText(html)>
	</cffunction>

	<cffunction name="index">

		<cfset set(transactionMode="commit")>

		<cfset alphabet = ListToArray("A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z")>
		<cfset phonetics = ListToArray("Alpha,Bravo,Charlie,Delta,Echo,Foxtrot,Golf,Hotel,India,Juliet,Kilo,Lima,Mike,November,Oscar,Papa,Quebec,Romeo,Sierra,Tango,Uniform,Victor,Whiskey,X-ray,Yankee,Zulu")>
		<cfset nouns = ListToArray("Anvil,Brick,Crab,Drain,Empire,Finch,Goanna,Hammer,Iceberg,Jupiter,Kangaroo,Lemon,Mint,Nylon,Octagon,Propeller,Quack,Rope,Silver,Teepee,Umbrella,Vegetable,Wagon,X-ray,Yam,Zip")>
		<cfset names = ListToArray("Anton,Bradley,Cameron,David,Edward,Fiona,Gregory,Harrison,Ivy,Jane,Kerry,Liam,Max,Nancy,Owen,Philip,Quincy,Randall,Serena,Thomas,Uma,Vaughan,William,Xu,Yvette,Zultan")>
		<cfset surnames = ListToArray("Anderson,Blythe,Cranston,Dempsey,Evans,Frampton,Goldsworthy,Haines,Ingermann,Jordison,Kilburn,Lovegrove,Mahoney,Nelson,O'Donnell,Pendlebury,Quinn,Rainford,Slater,Tompkins,Underhill,Valentine,Westlake,Xenophon,Yardley,Zimmerman")>	
		<cfset standardPassword = "password*321">
		<cfset loremipsum = "Lorem ipsum dolor sit amet, cum ut veniam nonumes deserunt, noster appetere vim ad. Consul delectus petentium in vis. Pro diam eros ea, ius dicta democritum constituam ei. Sea aperiam oportere et, facer dolore officiis nam in.">

		<cfset var loc = {}>
		<cfset var crlf = Chr(13) & Chr(10)>
		<cfsetting requesttimeout="1200">
		<cfset application.wheels.transactionMode = "commit">

		<!--- recreate files folder --->
		<cfset bucketFolder = ExpandPath("/#get("appKey")#/s3-bucket")>
			
		<cfif DirectoryExists(bucketFolder)>
			<cfdirectory action="delete" directory="#bucketFolder#" recurse="true">
		</cfif>
		<cfdirectory action="create" directory="#bucketFolder#">
	
		<cfset $$truncateTable("people,roots,administrators,users,examples,errors")>

		<cfswitch expression="#params.type#">
			<cfcase value="developer">

				<!--- safety catch --->
				<cfif get("stage") eq "development" AND cgi.server_name eq get("appKey")>
				<cfelse>
					<cfheader statuscode="500" statustext="Internal Server Error">
					This seed script is only available in the development stage..
					<cfabort>
				</cfif>

				<cfinclude template="seed/base.cfm">
				<cfinclude template="seed/developer.cfm">
				
			</cfcase>
			<cfcase value="ci">
				<!--- safety catch --->
				<cfif get("stage") eq "development" AND cgi.server_name eq get("appKey")>
				<cfelseif get("stage") eq "ci" AND FileExists("/var/lib/jenkins/config.xml")>
				<cfelse>
					<cfheader statuscode="500" statustext="Internal Server Error">
					This seed script is only available to Jenkins..
					<cfabort>
				</cfif>
				
				<cfinclude template="seed/base.cfm">
				<cfinclude template="seed/ci.cfm">

			</cfcase>
			<cfdefaultcase>
				<cfabort showerror="I'm sorry.. I'm not familiar with that term.">
			</cfdefaultcase>
		</cfswitch>

		<cfif params.type NEQ "ci" AND cgi.http_referer neq "">
			<cfset flashInsert(message="#titleize(params.type)# data populated!", messageType="info")>
	        <cfreturn redirectTo(route="publicSiteRoot")>
		<cfelse>
			<cfset renderText("#params.type# data populated!")>
		</cfif>

	</cffunction>

	<!--- gets a corresponding element.. consistent but differnt so names etc dont always start with the same letter --->
	<cffunction name="$$complementary" access="private">
		<cfargument name="value" type="numeric" required="true">
		<cfset var loc = {} />
		<cfset loc.return = arguments.value - 10>
		<cfset loc.return = loc.return lt 1 ? 26 + loc.return : loc.return>
		<cfreturn loc.return>
	</cffunction>

	<cffunction name="$$makeName" access="private">
		<cfargument name="value" type="numeric" required="true">
		<cfset var loc = {} />
		<cfif ! StructKeyExists(request,'emailIndexCount')>
			<cfset request.emailIndexCount = 0>
		</cfif>
		<cfset request.emailIndexCount++>
		<cfif arguments.value gt 26>
			<cfset arguments.value = $$under26(arguments.value)>
		</cfif>
		<cfset loc.value = arguments.value>
		<cfset loc.firstname = names[arguments.value]>
		<cfset loc.lastname = surnames[$$complementary(arguments.value)]>
		<cfset loc.name = "#loc.firstname# #loc.lastname#">
		<cfset loc.emailname = LCase("#loc.firstname#.#loc.lastname#_#request.emailIndexCount#")>
		<cfreturn loc>
	</cffunction>

	<cffunction name="$$under26" access="private">
		<cfargument name="value" type="numeric" required="true">
		<!--- ensure number is under 26.. if not produce a 'repeatable random' value --->
		<cfif arguments.value gt 26>
			<cfloop condition="arguments.value gt 26">
				<cfset arguments.value = Left(arguments.value * 666, 2)>
			</cfloop>
		</cfif>
		<cfreturn arguments.value>
	</cffunction>

	<cffunction name="$$truncateTable" access="private">
		<cfargument name="table" type="string" required="true">
		<cfset var loc = {} />
		<cfset loc.return = true>
		<cfloop list="#arguments.table#" index="loc.i">
			<!--- <cftry> --->
			<cfquery name="truncate_tables" datasource="#get('dataSourceName')#">
			SET FOREIGN_KEY_CHECKS=0;
			TRUNCATE TABLE #loc.i#;
			SET FOREIGN_KEY_CHECKS=1;
			</cfquery>
				<!--- <cfcatch type="database">
					<cfset loc.return = false>
				</cfcatch>
			</cftry> --->
		</cfloop>
		<cfreturn loc.return>
	</cffunction>

	<cffunction name="$$validObjectCheck" access="private">
		<cfargument name="objectName" type="string" required="true">
		<cfargument name="object" type="any" required="true">
		<cfif ! arguments.object.valid()> 
			<cfdump var="#arguments.object.allErrors()#" label="#arguments.objectName#" abort="true">
		</cfif>
	</cffunction>

</cfcomponent>