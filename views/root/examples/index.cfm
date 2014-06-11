<cfoutput>

	#pageTitle("Examples")#

	<p>#linkTo(text="New Example", route="rootExamplesNew", class="btn btn-primary")#</p>
	
	<table class="table table-striped">
		<thead>
			<tr>
				<th>Name</th>
				<th>Number</th>
				<th>Sampled</th>
				<th>Created</th>
				<th class="span1"></th>
				<th class="span1"></th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="examples">
				<tr>
					<td>#linkTo(text=name, route='rootExamplesShow', key=id)#</td>
					<td>#number#</td>
					<td>#sampledat#</td>
					<td>#timeAgoInWords(createdAt)# ago</td>
					<td>#linkTo(text='Edit', route='rootExamplesEdit', key=id)#</td>
					<td>#linkTo(text='Delete', route='rootExamplesDelete', key=id, confirm='Are you sure?')#</td>
				</tr>
			</cfoutput>
		</tbody>
	</table>
</cfoutput>
