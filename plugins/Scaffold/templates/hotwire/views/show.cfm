<cfoutput>
	
	#pageTitle([NameSingularLowercase].name)#

	[SHOWLISTINGCOLUMNS]

	#linkTo(text="Back", route="[NamePluralUppercase]Root", class="btn btn-default")#
	#linkTo(text="Edit [NameSingularLowercase]", route="[NamePluralUppercase]Edit", key=[NameSingularLowercase].key(), class="btn btn-primary")#
	
</cfoutput>