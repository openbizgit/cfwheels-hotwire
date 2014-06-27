<cfoutput>
	<ol>
		<li>#linkTo(text="Create database", href="/index.cfm?controller=wheels&action=wheels&view=plugins&name=dbmigrate")#</li>
		<li>#linkTo(text="Create seed data", route="seedSeedOptions")#</li>
		<li>#linkTo(text="Sign in", route="signin")#</li>
		<li>#linkTo(text="Tests", href="/index.cfm?controller=wheels&action=wheels&view=packages&type=app")#</li>
	</ol>
</cfoutput>