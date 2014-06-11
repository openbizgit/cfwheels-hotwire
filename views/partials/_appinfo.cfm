<cfoutput>
	<cfif get("stage") eq "development" OR extractHTTPHeader("X-Remote-Addr") eq "59.100.24.98">
		<div class="row">
			<div class="col-lg-12">
				<div class="well well-small">
					<dl class="dl-horizontal">
						<dt>CFWheels Version</dt><dd>#get("version")#</dd>
						<dt>Railo Version</dt><dd>#get("serverVersion")#</dd>
						<dt>Datasource</dt><dd>#get("dataSourceName")#</dd>
						<dt>Transactions</dt><dd>#get("transactionMode")#</dd>
						<dt>Environment</dt>
						<dd>wheels="#get("environment")#"<br/>
							stage="#get("stage")#"
						</dd>
						<dt>Host</dt><dd>#cgi.server_name#</dd>
					</dl>
				</div>
			</div>
		</div>
	</cfif>
</cfoutput>