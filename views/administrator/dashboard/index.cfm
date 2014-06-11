<cfoutput>
	
	<cfsilent>
		<cf_head>
			<script>
				$(function() {
					$("##").click(function() {

					});
				});
			</script>
		</cf_head>
	</cfsilent>

	#pageTitle("#get('appName')# Administrator Dashboard")#
	
	#errorMessageTag()#

	<div class="row">
		<div class="col-lg-12">

			<cf_panel title="Examples">
				<table class="table table-striped">
					<thead>
						<tr>
							<th>Name</th>
							<th>Number</th>
							<th>Sampled</th>
							<th>Created</th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="examples">
							<tr>
								<td>#name#</td>
								<td>#number#</td>
								<td>#sampledat#</td>
								<td>#timeAgoInWords(createdAt)# ago</td>
							</tr>
						</cfoutput>
					</tbody>
				</table>
			</cf_panel>

		</div>
	</div>

</cfoutput>