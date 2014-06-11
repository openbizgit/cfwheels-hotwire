<cfif thisTag.executionMode IS "Start">
	<cfsilent>
		<cfparam name="attributes.label" default="">
		<cfparam name="attributes.for" default="void">
		<cfparam name="attributes.control_group_id" default="">
		<cfparam name="attributes.input_prepend" default="">
		<cfparam name="attributes.help_block" default="">
	</cfsilent>
	<cfoutput>
	<div class="form-group"#attributes.control_group_id neq '' ? ' id="#attributes.control_group_id#"' : ''#>
		<label for="#attributes.for#" class="control-label">#attributes.label#</label>
		<div class="controls">
		<cfif attributes.input_prepend neq "">
			<div class="input-prepend">
				<span class="add-on">#attributes.input_prepend#</span>
		</cfif>
	</cfoutput>
<cfelse>
	<cfoutput>
			<cfif attributes.input_prepend neq ""></div></cfif>
			<cfif attributes.help_block neq ""><p class="help-block">#attributes.help_block#</p></cfif>
		</div>
	</div>
	</cfoutput>
</cfif>