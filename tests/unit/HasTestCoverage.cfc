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

	<!--- see if all controllers have a corresponding view (*_spec.rb) test file --->
	<cffunction name="test_capybara_integration_tests_exist">
		<cfset var skip = "">
		<cfset $$hasTests("view", skip)>
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
				<cfset loc.testsFilter = "*.cfc">
				<cfset loc.testsSuffix = "Test.cfc">
				<!--- core files must be skipped --->
				<!--- you can skip namespaced files by using "admin/SomeController.cfc" --->
				<cfset loc.skip = "tools/Junify.cfc,seed/Seed.cfc">
			</cfcase>
			<cfcase value="model">
				<cfset loc.mvcFolder = ExpandPath("models/")>
				<cfset loc.testsFolder = ExpandPath("tests/models/")>
				<cfset loc.testsFilter = "*.cfc">
				<cfset loc.testsSuffix = "Test.cfc">
				<cfset loc.skip = "Error.cfc,DBMigrateVersion.cfc">
			</cfcase>
			<cfcase value="view">
				<!--- check that every controller has a corresponding *_spec.rb file --->
				<cfset loc.mvcFolder = ExpandPath("controllers/")>
				<cfset loc.testsFolder = ExpandPath("tests/views/")>
				<cfset loc.testsFilter = "*.rb">
				<cfset loc.testsSuffix = "_spec.rb">
				<cfset loc.skip = "tools/Junify.cfc,seed/Seed.cfc,joint/Detour.cfc,tools/Checks.cfc,tools/DB.cfc">
			</cfcase>
		</cfswitch>

		<!--- also skip files passed in as an argument --->
		<cfif arguments.skip neq "">
			<cfset loc.skip = ListAppend(loc.skip, arguments.skip)>
		</cfif>
		
		<!--- get the models and tests --->
		<cfdirectory action="list" directory="#loc.mvcFolder#" filter="*.cfc" recurse="true" name="mvc">
		<cfdirectory action="list" directory="#loc.testsFolder#" filter="#loc.testsFilter#" recurse="true" name="tests">
		<!--- assert there are some tests --->
		<cfset assert("tests.recordCount gt 0", "loc.testsFolder")>
		<!--- check if there is corresponding test file --->
		<cfset loc.testsExist = true>
		<cfset loc.existingTestFiles = []>
		<cfset loc.missingTestFiles = []>
		<cfoutput>
		<cfloop query="mvc">
			<cfset loc.mvcFolder = Replace(loc.mvcFolder, "\", "/", "all")>
			<cfset loc.directory = Replace(mvc.directory, "\", "/", "all")>
			<cfset loc.folder = $$folder(loc.mvcFolder, loc.directory & "/")>
			<!--- define this file's "skip key" --->
			<cfset loc.skipKey = loc.folder & mvc.name>
			<!--- also skip anything named Controller.cfc --->
			<cfif ListFindNoCase(loc.skip, loc.skipKey) gt 0>
				<!--- do nothing.. i already know which files are being skipped --->
			<cfelseif 
				Compare(mvc.name, "Controller.cfc") neq 0
				AND Compare(mvc.name, "Wheels.cfc") neq 0
				AND Compare(mvc.name, "Model.cfc") neq 0
			>
				<cfset loc.mvcFilePath = loc.directory & "/" & mvc.name>
				<cfif arguments.type eq "view">
					<cfset loc.testFileName = LCase(ListFirst(mvc.name, ".") & loc.testsSuffix)>
				<cfelse>
					<cfset loc.testFileName = ListFirst(mvc.name, ".") & loc.testsSuffix>
				</cfif>
				<cfset loc.testFilePath = loc.testsFolder & $$folder(loc.mvcFolder, loc.directory & "/") & loc.testFileName>
				
				<cfif ! FileExists(loc.testFilePath)>
					<cfset ArrayAppend(loc.missingTestFiles, loc.folder & loc.testFileName)>
					<cfset loc.testsExist = false>
				<cfelse>
					<cfset ArrayAppend(loc.existingTestFiles, loc.folder & loc.testFileName)>
				</cfif>
			</cfif>
		</cfloop>
		</cfoutput>
		<cfset loc.missingTestFiles = ArrayToList(loc.missingTestFiles, ', ')>
		<cfset loc.existingTestFiles = ArrayToList(loc.existingTestFiles, ', ')>
		<cfset assert("loc.testsExist", "loc.missingTestFiles", "loc.existingTestFiles", "loc.skip")>
	</cffunction>

	<cffunction name="$$folder" access="private" output="false" hint="gets the folder name after the 'root'">
		<cfargument name="path1" type="string" required="true" hint="the root path">
		<cfargument name="path2" type="string" required="true" hint="subfolder of the the root path">
		<cfreturn ReplaceNoCase(arguments.path2, arguments.path1, "", "all")>
	</cffunction>

</cfcomponent>