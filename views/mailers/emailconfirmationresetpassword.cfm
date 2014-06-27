<cfoutput>
	<p>Dear #person.firstname#,</p>
	<p>We heard you have forgotten your #get("appName")# password.</p>
	<p>However, you have not confirm your email address with us.</p>
	<p>Use the following link within the next 24 hours to confirm your email, and then you are able to reset your password:</p>
	<p>#URLFor(route="publicSignupConfirm", onlyPath=false, params="token=#person.resettoken#&isChangePassword=true")#</p>
	<p>
	Thanks,<br/>
	The #get("appName")# Team
	</p>
</cfoutput>