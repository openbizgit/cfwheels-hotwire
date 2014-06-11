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
	
	#pageTitle('#get("appName")# Root Dashboard')#

	<div class="container">
		<div class="row">
			<div class="col-lg-6">

				<cf_panel title="Things">
					<ol>
						<li>#linkTo(text="Examples", route="rootExamplesRoot")#</li>
					</ol>
				</cf_panel>

			</div>
		</div>
	</div>

</cfoutput>