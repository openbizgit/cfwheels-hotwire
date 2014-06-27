<cfoutput>

	#pageTitle(title="Password Reset", show=false)#

  <div class="container">
    	#startFormTag(route="publicCredentialsNew", class="form-signin", style="max-width: 550px;")#
        <div style="text-align:center;"><a href="/"><img src="/images/logo.png" width="100" /></a></div>
        #flashMessageTag()#
        #errorMessageTag()#

   	    <h2 class="form-signin-heading">Password Reset</h2>
    		<p>Enter your e-mail address to reset your password. If your e-mail address is found, we will e-mail you with instructions.</p>      		
    		<input type="text" class="form-control" placeholder="Email address" autofocus name="email">
    		<br><br>

        <div class="pull-right">
          #linkTo(text="Cancel", route="signin", class="btn btn-default")#
    	    <button class="btn btn-primary" type="submit">Send Email</button>
        </div>
    	#endFormTag()#
  </div>	

</cfoutput>