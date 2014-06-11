<cfoutput>

	#pageTitle("[NamePluralLowercase]")#

	<p>#linkTo(text="New [NameSingularLowercase]", action="new", class="btn btn-default")#</p>
	
	<table class="table table-striped">
		<thead>
			<tr>
				<th>Name</th>

				<!--- <th>s here --->

				<th>Created</th>
				<th class="span1"></th>
				<th class="span1"></th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="[NamePluralLowercase]">
				<tr>
					<td>#linkTo(text=name, action='show', key=id)#</td>

					<!--- START Columns --->
					[INDEXLISTINGCOLUMNS]
					<!--- END Columns --->

					<td>#timeAgoInWords(createdAt)# ago</td>
					<td>#linkTo(text='Edit', action='edit', key=id)#</td>
					<td>#linkTo(text='Delete', action='delete', key=id, confirm='Are you sure?')#</td>
				</tr>
			</cfoutput>
		</tbody>
	</table>
</cfoutput>