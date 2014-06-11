<cfoutput>

	#pageTitle('New [NameSingularUppercase]')#
			
	#errorMessageTag("[NameSingularLowercase]")#
	
	<div class="row">
		<div class="span12">
			#startFormTag(action="create")#
				<fieldset>
		
					#includePartial("fields")#

					<div class="form-actions">
						#linkTo(text="Cancel", action="index", class="btn btn-default")#
						#submitTag(value="Save", class="btn btn-primary")#
					</div>
				</fieldset>
			#endFormTag()#
		</div>
	</div>

</cfoutput>