<cfoutput>

	#pageTitle('Edit Example - #example.name#')#
			
	#errorMessageTag("example")#

	<div class="row">
		<div class="span12">
			#startFormTag(route="rootExamplesUpdate", key=params.key)#
				<fieldset>
					#includePartial("fields")#
					<div class="form-actions">
						#linkTo(text="Cancel", route="rootExamplesRoot", class="btn btn-default")#
						#submitTag(value="Save", class="btn btn-primary")#
					</div>
				</fieldset>
			#endFormTag()#
		</div>
	</div>

</cfoutput>
