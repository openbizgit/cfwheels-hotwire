<cfoutput>
	<p>Dear #person.firstname#,</p>
	<p>Thank you for registering with #get("appName")#.</p>
	<p>You need to confirm your e-mail address. Please click on the link below to do so:</p>
	<p>#URLFor(route="publicSignupConfirm", onlyPath=false, params="token=#person.resettoken#")#</p>
	<p>
	Thanks,<br/>
	The #get("appName")# Team
	</p>
</cfoutput>