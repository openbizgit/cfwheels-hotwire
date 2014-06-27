<cfoutput>
	<p>Hey #user.firstname#,</p>
	<p>Your password has been changed.</p>
	<p>If you were not aware of this, click the link below to change it immediately.
	<p>#URLFor(route="publicPasswordsCreate", onlyPath=false, key=user.passwordResetToken)#</p>
	<p>
	Thanks!<br/>
	The #get("appName")# Team
	</p>
</cfoutput>