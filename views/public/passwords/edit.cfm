<cfoutput>

	#pageTitle(title="Password Reset", show=false)#


  <div class="container">
   	#startFormTag(route="publicPasswordsUpdate", params="token=#params.token#", class="form-signin", style="max-width: 550px;")#
      <div style="text-align:center;"><a href="/"><img src="/images/logo.png" width="100" /></a></div>
      #flashMessageTag()#
      #errorMessageTag()#
 	    <h2 class="form-signin-heading">Password Reset</h2>

 	    <input type="text" class="form-control" placeholder="Email address" name="dummy" value="#person.email#" disabled="disabled">
			<br>
			#passwordField(objectName="person", property="password", label="", class="form-control", placeholder="New Password")#
			#passwordField(objectName="person", property="passwordConfirmation", label="", class="form-control", placeholder="Confirm Password")#
   		<br><br>
      <div class="pull-right">
        #linkTo(text="Cancel", route="signin", class="btn btn-default")#
  			#submitTag(value="Save", class="btn btn-primary")#
      </div>
   	#endFormTag()#
  </div>	

</cfoutput>