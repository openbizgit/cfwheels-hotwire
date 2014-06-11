<cfoutput>
	
	#pageTitle(example.name)#

	
			
				
					<p><span>Id</span> <br />
						#example.id#</p>
				
					<p><span>Name</span> <br />
						#example.name#</p>
				
					<p><span>Number</span> <br />
						#example.number#</p>
				
					<p><span>Sampledat</span> <br />
						#example.sampledat#</p>
				
					<p><span>Createdat</span> <br />
						#example.createdat#</p>
				
					<p><span>Updatedat</span> <br />
						#example.updatedat#</p>
				
					<p><span>Deletedat</span> <br />
						#example.deletedat#</p>
				
			
		

	#linkTo(text="Back", route="rootExamplesRoot", class="btn")#
	#linkTo(text="Edit example", route="rootExamplesEdit", key=example.key(), class="btn")#
	
</cfoutput>
