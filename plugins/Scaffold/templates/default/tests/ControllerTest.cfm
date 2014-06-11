<cfcomponent extends="wheelsMapping.Test">

    <!---
    # SETUP & TEARDOWN
    --->

    <!--- include helper functions --->
    <cfinclude template="../helpers.cfm">
    
    <!--- setup runs before every test --->
    <cffunction name="setup">
        <!--- save the orginal environment --->
        <cfset loc.originalApplication = Duplicate(application)>
        <!--- set transaction mode to rollback, so no records are affected --->
        <cfset application.wheels.transactionMode = "rollback">
        <!--- a struct used to set valid model property values --->
        <cfset loc.validProperties = {
        	[validModelProperties]
        }>
        <!--- a struct used to set invalid model property values --->
        <cfset loc.invalidProperties = {
        	[invalidModelProperties]
        }>
    </cffunction>

    <!--- teardown runs after every test --->
    <cffunction name="teardown">
         <!--- re-instate the original application scope --->
        <cfset application = loc.originalApplication />
    </cffunction>

    <!---
    # INDEX
    --->

    <cffunction name="test_index_displays_[NameSingularLowercase]_listing">
        <!--- setup some params for the tests --->
        <cfset loc.params = {}>
        <!--- get copy of the code the view generated --->
        <cfset loc.response = controllerActionResponse(controller="[NamePluralUppercase]", action="index", params=loc.params)>
        <!--- make sure this string is displayed  --->
        <cfset loc.string = '<h2>[NamePluralUppercase]</h2>'>
        <cfset assert('loc.response contains loc.string')>
        <!--- check additional strings --->
        <cfset assertLayoutExists(loc.response)>
    </cffunction>

    <!---
    # SHOW
    --->

    <cffunction name="test_show_displays_[NameSingularLowercase]">
        <!--- find a [NameSingularLowercase] object --->
        <cfset loc.[NameSingularLowercase] = model("[NameSingularUppercase]").findOne()>
        <!--- define the key param --->
        <cfset loc.params = {key=loc.[NameSingularLowercase].key()}>
        <cfset loc.response = controllerActionResponse(controller="[NamePluralUppercase]", action="show", params=loc.params)>
        <cfset loc.string = '<h2>#[NameSingularUppercase].name#</h2>'>
        <cfset assert('loc.response contains loc.string')>
        <cfset assertLayoutExists(loc.response)>
    </cffunction>

    <cffunction name="test_show_redirects_to_index_if_a_[NameSingularLowercase]_is_not_found">
        <!--- provide a key that doesn't exist --->
        <cfset loc.params = {key=-1}>
        <cfset loc.redirect = controllerActionRedirect(controller="[NamePluralUppercase]", action="show")>
        <cfset assert('StructKeyExists(loc.redirect, "$args")')>
        <cfset assert('loc.redirect.$args.action eq "index"')>
    </cffunction>

    <!---
    # NEW
    --->

    <cffunction name="test_new_displays_[NameSingularLowercase]_form">
        <cfset loc.params = {}>
        <!--- create a new [NameSingularLowercase] object for the form --->
        <cfset loc.response = controllerActionResponse(controller="[NamePluralUppercase]", action="new", params=loc.params)>
        <cfset loc.string = '<h2>New [NameSingularUppercase]</h2>'>
        <cfset assert('loc.response contains loc.string')>
        <cfset assertLayoutExists(loc.response)>
    </cffunction>

    <!---
    # EDIT
    --->

    <cffunction name="test_edit_displays_[NameSingularLowercase]_form">
        <cfset loc.[NameSingularLowercase] = model("[NameSingularUppercase]").findOne()>
        <cfset loc.params = {key=loc.[NameSingularLowercase].key()}>
        <cfset loc.response = controllerActionResponse(controller="[NamePluralUppercase]", action="edit", params=loc.params)>
        <cfset loc.string = '<h2>Edit [NameSingularUppercase] - #[NameSingularLowercase].name#</h2>'>
        <cfset assert('loc.response contains loc.string')>
        <cfset assertLayoutExists(loc.response)>
    </cffunction>

    <cffunction name="test_edit_redirects_to_index_if_a_[NameSingularLowercase]_is_not_found">
        <cfset loc.params = {key=-1}>
        <cfset loc.redirect = controllerActionRedirect(controller="[NamePluralUppercase]", action="edit", params=loc.params)>
        <cfset assert('StructKeyExists(loc.redirect, "$args")')>
        <cfset assert('loc.redirect.$args.action eq "index"')>
    </cffunction>

    <!---
    # CREATE
    --->

    <cffunction name="test_create_redirects_to_index_after_a_[NameSingularLowercase]_is_created">
        <cfset loc.params = {[NameSingularLowercase]=loc.validProperties}>
        <cfset loc.redirect = controllerActionRedirect(controller="[NamePluralUppercase]", action="create", params=loc.params)>
        <cfset assert('StructKeyExists(loc.redirect, "$args")')>
        <cfset assert('loc.redirect.$args.action eq "index"')>
    </cffunction>

    <cffunction name="test_create_errors_display_when_[NameSingularLowercase]_is_invalid">
        <cfset loc.params = {[NameSingularLowercase]=loc.invalidProperties}>
        <cfset loc.response = controllerActionResponse(controller="[NamePluralUppercase]", action="create", params=loc.params)>
        <cfset loc.message = 'There was an error creating the [NameSingularLowercase]'>
        <cfset assert('loc.response contains loc.message')>
        <cfset assertLayoutExists(loc.response)>
    </cffunction>

    <!---
    # UPDATE
    --->

    <cffunction name="test_update_redirects_to_index_after_a_[NameSingularLowercase]_is_updated">
        <cfset loc.[NameSingularLowercase] = model("[NameSingularUppercase]").findOne()>
        <cfset loc.params = {key=loc.[NameSingularLowercase].key()}>
        <cfset loc.params.[NameSingularLowercase] = loc.[NameSingularLowercase].properties()>
        <cfset loc.redirect = controllerActionRedirect(controller="[NamePluralUppercase]", action="update", params=loc.params)>
        <cfset assert('StructKeyExists(loc.redirect, "$args")')>
        <cfset assert('loc.redirect.$args.action eq "index"')>
    </cffunction>

    <cffunction name="test_update_errors_display_when_[NameSingularLowercase]_is_invalid">
        <cfset loc.[NameSingularLowercase] = model("[NameSingularUppercase]").findOne()>
        <cfset loc.params = {key=loc.[NameSingularLowercase].key()}>
        <cfset loc.params.[NameSingularLowercase] = loc.invalidProperties>
        <cfset loc.response = controllerActionResponse(controller="[NamePluralUppercase]", action="update", params=loc.params)>
        <cfset loc.message = 'There was an error updating the [NameSingularLowercase]'>
        <cfset assert('loc.response contains loc.message')>
        <cfset assertLayoutExists(loc.response)>
    </cffunction>

    <!---
    # DELETE
    --->

    <cffunction name="test_delete_redirects_to_index_after_a_[NameSingularLowercase]_is_deleted">
        <cfset loc.[NameSingularLowercase] = model("[NameSingularUppercase]").findOne()>
        <cfset loc.params = {key=loc.[NameSingularLowercase].key()}>
        <cfset loc.redirect = controllerActionRedirect(controller="[NamePluralUppercase]", action="delete", params=loc.params)>
        <cfset assert('StructKeyExists(loc.redirect, "$args")')>
        <cfset assert('loc.redirect.$args.action eq "index"')>
    </cffunction>

</cfcomponent>