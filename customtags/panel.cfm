<cfif thisTag.executionMode IS "Start">
	<cfsilent>
		<cfparam name="attributes.title" default="">
		<cfparam name="attributes.subtitle" default="">
		<cfparam name="attributes.class" default="default">
		<cfparam name="attributes.body" type="boolean" default="true">
	</cfsilent>
	<cfoutput>
	<div class="panel panel-#attributes.class#">
		<div class="panel-heading"><h3 class="panel-title">#attributes.title#<cfif Len(attributes.subtitle)> <small>#attributes.subtitle#</small></cfif></h3></div>
		<cfif attributes.body><div class="panel-body" style="padding-left:30px;"></cfif>
	</cfoutput>
<cfelse>
		<cfif attributes.body></div></cfif>
	</div>
</cfif>