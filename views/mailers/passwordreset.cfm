<cfoutput>
	<p>Dear #person.firstname#,</p>
	<p>We heard you have forgotten your #get("appName")# password.</p>
	<p>Use the following link within the next 24 hours to reset your password:</p>
	<p>#URLFor(route="publicPasswordsCreate", onlyPath=false, params="token=#person.resettoken#")#</p>
	<p>If you don't want to change your password, just ignore this message.</p>
	<p>
	Thanks,<br/>
	The #get("appName")# Team
	</p>
</cfoutput>