<cfsilent>
	<!----------------------------------------------------------------------------
	Name:   cf_head
	Author: Adam Chapman (Inspired by Dan G. Switzer, II) 
	Date:   August 20, 2013

	Description:
	This tag is a replacement for the <CFHTMLHEAD> tag. It will take all the 
	output between the <CF_HEAD> and </CF_HEAD> tags and place the content into
	a variable called HTMLHead. This variable should be output between the <head></head>
	tags in your HTML.

	Usage:
	<CF_HEAD><SCRIPT SRC="./lib/general.js"></SCRIPT></CF_HEAD>
	  Then output the HTMLHead variable like so:  
	  <HEAD>#HTMLHead#</HEAD>
	----------------------------------------------------------------------------->
	<cfif ThisTag.ExecutionMode IS "END">
		<!--- initialise the variable --->
		<cfif ! structKeyExists(caller, "HTMLHead")>
			<cfset caller.HTMLHead = "">
		</cfif>
		<!--- append the tag content to the variable --->
		<cfset caller.HTMLHead = caller.HTMLHead & Chr(13) & Chr(10) & Trim(ThisTag.GeneratedContent)>
	</cfif>
</cfsilent>