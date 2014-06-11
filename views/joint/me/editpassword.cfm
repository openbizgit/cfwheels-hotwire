<cfoutput>
	#includePartial(partial="metabs")#
	#pageTitle('Change my password')#

	#errorMessageTag("currentperson")#

	#startFormTag(route="jointMeUpdatePassword")#
	<fieldset>
		<cf_panel title="Password Reset">
			<div class="row">
				<div class="col-lg-4">
					#input(inputType="passwordFieldTag", name="oldpassword", label="Old Password", required=true)#
				</div>
			</div>
			<div class="row">
				<div class="col-lg-4">
					#input(inputType="passwordField", objectName="currentperson", property="password", label="New Password", required=true)#
				</div>
			</div>
			<div class="row">
				<div class="col-lg-4">  						
					#input(inputType="passwordField", objectName="currentperson", property="passwordConfirmation", label="Confirm Password", required=true)#
					</div>
				</div>
		</cf_panel>
		<div class="form-actions">
			<div class="pull-right">
				#linkTo(text="Cancel", route="jointDetourDashboard", class="btn btn-default")#
				#submitTag(value="Update", class="btn btn-primary")#
			</div>
		</div>			

	</fieldset>

</cfoutput>


   	    
