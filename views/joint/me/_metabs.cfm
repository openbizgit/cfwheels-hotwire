<cfoutput>
	<ul class="nav nav-tabs" style="margin-top:40px;">
		<li <cfif FindNoCase("joint.me", params.controller) GT 0 AND ListFindNoCase("editemail,updateemail", params.action) GT 0>class="active"</cfif>>#linkTo(route="jointMeEditEmail", text="Email")#</li>
		<li <cfif FindNoCase("joint.me", params.controller) GT 0 AND ListFindNoCase("editpassword,updatePassword", params.action) GT 0>class="active"</cfif>>#linkTo(route="jointMeEditPassword", text="Password")#</li>
	</ul>
</cfoutput>