<cfoutput>
	#includePartial(partial="metabs")#
	#pageTitle('Edit my email')#

	#errorMessageTag("currentperson")#

	#startFormTag(route="jointMeUpdateEmail")#
	<fieldset>
		<cf_panel title="Email">
			<div class="row">
				<div class="col-lg-4">						
					#input(inputType="textField", objectName="currentperson", property="email", label="Email (this is used as your username for sign in)", required=true)#
				</div>
			</div>
		</cf_panel>
		<div class="form-actions">
			<div class="pull-right">
				#linkTo(text="Cancel", route="jointDetourDashboard", class="btn btn-default")#
				#submitTag(value="Update", class="btn btn-primary")#
			</div>
		</div>				

	<fieldset>

</cfoutput>


   	    
