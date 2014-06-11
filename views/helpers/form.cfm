<cffunction name="input" access="public" output="false" returntype="string" hint="render form input types with containing HTML">
	<cfargument name="inputType" type="string" required="true">
	<cfset var loc = {} />
	
	<!--- pass this into the wheels helpers as argumentCollection.. use this to remove unwanted args --->
	<cfset loc.args = Duplicate(arguments)>

	<!--- extract the label, then set to false for actual wheels function call --->
	<cfif !StructKeyExists(arguments,"label")>
		<cfset arguments.label = titleize(StructKeyExists(arguments,"objectName") ? arguments.property : arguments.name)>
	</cfif>
	
	<!--- build an attribute structure for the controlGroup tag --->
	<cfset loc.tagAttr = {}>
	<cfset loc.tagAttr.label = arguments.label>
	<cfset loc.tagAttr.for = StructKeyExists(arguments,"objectName") ? "#arguments.objectName#-#arguments.property#" : arguments.name>

	<!--- TODO: build this as a list and loop thru each... --->
	<cfif StructKeyExists(arguments,"input_prepend")>
		<!--- add to args for the cf_controlGroup tag --->
		<cfset loc.tagAttr.input_prepend = arguments.input_prepend>
		<!--- remove from args that will be passed into wheels form helper --->
		<cfset StructDelete(loc.args,"input_prepend")>
	</cfif>
	<cfif StructKeyExists(arguments,"help_block")>
		<cfset loc.tagAttr.help_block = arguments.help_block>
		<cfset StructDelete(loc.args,"help_block")>
	</cfif>
	<cfif StructKeyExists(arguments,"class") AND len(arguments.class)>
		<cfset loc.args.class="form-control #arguments.class#">
	<cfelse>
		<cfset loc.args.class="form-control">
	</cfif>
	
	<cfset loc.args.label = false>
	<cfset StructDelete(loc.args,"inputType")>
	
	<cfswitch expression="#arguments.inputType#">
		<cfcase value="textField">
			<cfset loc.input = textField(argumentCollection=loc.args)>
		</cfcase>
		<cfcase value="textFieldTag">
			<cfset loc.input = textFieldTag(argumentCollection=loc.args)>
		</cfcase>
		<cfcase value="textArea">
			<cfset loc.input = textArea(argumentCollection=loc.args)>
		</cfcase>
		<cfcase value="textAreaTag">
			<cfset loc.input = textAreaTag(argumentCollection=loc.args)>
		</cfcase>
		<cfcase value="richTextField">
			<cfset loc.input = richTextField(class="rteditor", editor="ckeditor", includeJSLibrary="false", argumentCollection=loc.args)>
		</cfcase>
		<cfcase value="richTextTag">
			<cfset loc.input = richTextTag(class="rteditor", editor="ckeditor", includeJSLibrary="false", argumentCollection=loc.args)>
		</cfcase>
		<cfcase value="passwordField">
			<cfset loc.input = passwordField(argumentCollection=loc.args)>
		</cfcase>
		<cfcase value="passwordFieldTag">
			<cfset loc.input = passwordFieldTag(argumentCollection=loc.args)>
		</cfcase>
		<cfcase value="select">
			<cfset loc.input = select(argumentCollection=loc.args)>
		</cfcase>
		<cfcase value="selectTag">
			<cfset loc.input = selectTag(argumentCollection=loc.args)>
		</cfcase>
		<cfcase value="fileField">
			<cfset loc.input = fileField(argumentCollection=loc.args)>
		</cfcase>
		<cfcase value="fileFieldTag">
			<cfset loc.input = fileFieldTag(argumentCollection=loc.args)>
		</cfcase>
		<cfcase value="datePicker">
			<cfset loc.input = datePicker(argumentCollection=loc.args, changeMonth=true, changeYear=true)>
		</cfcase>
		<cfcase value="checkBox">
			<cfset loc.input = checkBox(argumentCollection=loc.args)>
		</cfcase>
		<cfcase value="checkBoxTag">
			<cfset loc.input = checkBoxTag(argumentCollection=loc.args)>
		</cfcase>		
		<cfcase value="CKEditor">
			<!--- |<cfset arguments.class = listAppend(loc.args.class, "ckeditor", " ")> --->
			<cfset loc.args.class = "ckeditor">
			<cfset javascriptIncludeTag(source="ckeditor/ckeditor.js", head=true)>
			<cfset loc.input = textArea(argumentCollection=loc.args)>
		</cfcase>
		<cfdefaultcase>
			<cfthrow message="Unknown inputType ('#arguments.inputType#') for input() view helper">
		</cfdefaultcase>
	</cfswitch>
	
	<cfoutput>
	
		<cfsavecontent variable="loc.return">
			<cf_controlGroup attributeCollection="#loc.tagAttr#">
				#loc.input#
			</cf_controlGroup>
		</cfsavecontent>
	</cfoutput>
	
	<cfreturn loc.return>
</cffunction>

<cffunction name="hasManyCheckBox">
	<cfset var loc = {} />
	<cfset loc.label = arguments.label>
	
	<cfset arguments.label = false>
	<cfoutput>
		<cfsavecontent variable="loc.return">
			<label class="checkbox">
				#core.hasManyCheckBox(argumentCollection=arguments)##loc.label#
			</label>
		</cfsavecontent>
	</cfoutput>
	
	<cfreturn loc.return>
</cffunction>

<cffunction name="yesNoRadioButtons">
	<cfset var loc = {} />
	<cfoutput>
		<cfsavecontent variable="loc.return">
			#radioButton(argumentCollection=arguments, label="Yes", tagValue="1", labelPlacement="after", prependToLabel="&nbsp;&nbsp;")#
			&nbsp;&nbsp;&nbsp;&nbsp;
			#radioButton(argumentCollection=arguments, label="No", tagValue="0", labelPlacement="after", prependToLabel="&nbsp;&nbsp;")#
		</cfsavecontent>
	</cfoutput>
	<cfreturn loc.return>
</cffunction>

<cffunction name="linkToModal">
	<cfargument name="text" type="string" required="true">
	<cfargument name="key" type="string" required="false">
	<cfargument name="id" type="string" required="false">
	<cfargument name="class" type="string" required="false">
	<cfargument name="obfuscateKey" type="boolean" required="false" default="false">
	<cfargument name="boldText" type="boolean" required="false" default="true">

	<cfset var return = #arguments.boldText ? "<strong>" : ""#>	
	<cfset var return = return & '<a data-backdrop="true" data-keyboard="true" style="cursor:pointer"' />
	<cfif StructKeyExists(arguments,"key")>
		<cfset return = return & ' key="#arguments.obfuscateKey ? obfuscateParam(arguments.key) : arguments.key#"'>
	</cfif>
	<cfif StructKeyExists(arguments,"id")>
		<cfset return = return & ' id="#arguments.id#"'>
	</cfif>
	<cfif StructKeyExists(arguments,"class")>
		<cfset return = return & ' class="#arguments.class#"'>
	</cfif>
	<cfset return = return & '>#arguments.text#</a></strong>'>
	<cfreturn return>
</cffunction>

