<cfoutput>
	<cfsilent>
		<cf_head>
			<script type="text/javascript">
				function writeLocalDate() {
					var d = new Date();
			 		var dt = $.DateFormat(d,"dd/mm/yyyy hh:MM TT");
			 		$("##_dt").val(dt);
				}
				$(window).load(function () {
			 		$("##_username").val("#extractHTTPHeader("host")#");
					writeLocalDate();
					$("##this-form").submit(function () {
						writeLocalDate();
					});
		        });
				<!--- TODO: maybe autofocus password field if email value exists? --->
			</script>
		</cf_head>
	</cfsilent>

	#pageTitle(title="Sign in", show=false)#

	#flashMessageTag()#
	#errorMessageTag()#
    <div class="container">
      	#startFormTag(route="publicSigninSignin", class="form-signin", style="max-width: 400px;")#
		<div style="text-align:center;"><a href="/"><img src="/images/logo.png" width="100" /></a></div>
		    <h3 class="form-signin-heading">#get("appName")# Sign in</h3>
		    <input type="text" class="form-control" placeholder="Email address" value="#getParam("email")#" autofocus name="email">
		    <input type="password" class="form-control" placeholder="Password" name="password">
			<div style="display:none;">
				<!--- honeypot fields (decoys) --->
				#textFieldTag(name="username", id="_username", label=false, placeholder="Username")#
				#passwordFieldTag(name="passwordConfirm", id="_confirm", label=false, placeholder="Confirm your password")#
				<input id="_dt" name="dt" placeholder="Empty" type="text" value="" />
			</div>					    
		    <button class="btn btn-lg btn-primary btn-block" type="submit", id="submit">Sign in</button>
		    #linkTo(route="publicSigninReset", text="Forgotten?", class="btn")# <br><br>
      	#endFormTag()#

      	<cfif get("stage") eq "development" && IsDefined("people")>
	      	<div class="well">
	      		<h3>People</h3>
		      	<table class="table table-striped">
					<thead>
						<tr>
							<th>Name</th>
							<th>Type</th>
							<th>Username</th>
							<th>Password</th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="people">
							<tr>
								<td>#firstname# #lastname#</td>
								<td>
									<cfif rootid neq "">
										Root
									<cfelseif administratorid neq "">
										Administrator
									<cfelseif userid neq "">
										User
									</cfif>
								</td>
								<td>#email#</td>
								<td>password*321</td>
							</tr>
						</cfoutput>
					</tbody>
				</table>
	      	</div>
      	</cfif>

    </div>	
 
</cfoutput>