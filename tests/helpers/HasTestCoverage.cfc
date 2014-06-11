<cfcomponent extends="Tests.TestBase">

	<!--- see if all controllers have a corresponding functional test file --->
	<cffunction name="test_controller_functional_tests_exist">
		<!--- add files to this list if you don't want to enforce test file existence --->
		<cfset var skip = "">
		<!--- run the hasTest helper --->
		<cfset $$hasTests("controller", skip)>
	</cffunction>
	
	<!--- see if all models have a corresponding unit test file --->
	<cffunction name="test_model_unit_tests_exist">
		<cfset var skip = "">
		<cfset $$hasTests("model", skip)>
	</cffunction>

	<!--- just for DRYness --->
	<cffunction name="$$hasTests" access="private">
		<cfargument name="type" type="string" required="true">
		<cfargument name="skip" type="string" required="false" default="">

		<!--- paths to folders --->
		<cfswitch expression="#arguments.type#">
			<cfcase value="controller">
				<cfset loc.mvcFolder = ExpandPath("controllers/")>
				<cfset loc.testsFolder = ExpandPath("tests/controllers/")>
				<!--- core files must be skipped --->
				<!--- you can skip namespaced files by using "admin/SomeController.cfc" --->
				<cfset loc.skip = "tools/Junify.cfc,seed/Seed.cfc">
			</cfcase>
			<cfcase value="model">
				<cfset loc.mvcFolder = ExpandPath("models/")>
				<cfset loc.testsFolder = ExpandPath("tests/models/")>
				<cfset loc.skip = "Error.cfc,DBMigrateVersion.cfc">
			</cfcase>
		</cfswitch>

		<!--- also skip files passed in as an argument --->
		<cfif arguments.skip neq "">
			<cfset loc.skip = ListAppend(loc.skip, arguments.skip)>
		</cfif>
		
		<!--- get the models and tests --->
		<cfdirectory action="list" directory="#loc.mvcFolder#" filter="*.cfc" recurse="true" name="mvc">
		<cfdirectory action="list" directory="#loc.testsFolder#" filter="*.cfc" recurse="true" name="tests">
		<!--- assert there are some tests --->
		<cfset assert("tests.recordCount gt 0", "loc.testsFolder")>
		<!--- check if there is corresponding test file --->

		<cfloop query="mvc">
			<cfset loc.mvcFolder = Replace(loc.mvcFolder, "\", "/", "all")>
			<cfset loc.directory = Replace(mvc.directory, "\", "/", "all")>
			<!--- define this file's "skip key" --->
			<cfset loc.skipKey = $$folder(loc.mvcFolder, loc.directory & "/") & mvc.name>
			<!--- also skip anything named Controller.cfc --->
			<cfif 
				ListFindNoCase(loc.skip, loc.skipKey) eq 0 
				AND Compare(mvc.name, "Controller.cfc") neq 0
				AND Compare(mvc.name, "Wheels.cfc") neq 0
				AND Compare(mvc.name, "Model.cfc") neq 0
			>
				<cfset loc.mvcFilePath = loc.directory & "/" & mvc.name>
				<cfset loc.testFileName = ListFirst(mvc.name, ".") & "Test.cfc">
				<cfset loc.testFilePath = loc.testsFolder & $$folder(loc.mvcFolder, loc.directory & "/") & ListFirst(mvc.name, ".") & "Test.cfc">
				<cfset assert("FileExists(loc.testFilePath)", "loc.mvcFilePath", "loc.testFilePath", "loc.skipKey")>
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="$$folder" access="private" output="false" hint="gets the folder name after the 'root'">
		<cfargument name="path1" type="string" required="true" hint="the root path">
		<cfargument name="path2" type="string" required="true" hint="subfolder of the the root path">
		<cfreturn ReplaceNoCase(arguments.path2, arguments.path1, "", "all")>
	</cffunction>

</cfcomponent>