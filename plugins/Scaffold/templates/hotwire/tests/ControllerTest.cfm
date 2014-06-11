component extends="Tests.TestBase"
{

    /*
    * SETUP & TEARDOWN
    */

    // setup runs before every test
    public void function setup() 
    {
        onstartup();
        super.setup();
        // a struct used to set valid model property values
        loc.validProperties = {
        	[validModelProperties]
        };
        // a struct used to set invalid model property values
        loc.invalidProperties = {
        	[invalidModelProperties]
        };
        // database table keys i will be using for tests
        loc.ids = {read=1, write=2, delete=3};
        loc.names = {read="[NamePluralUppercase] Name"};
        loc.args = {controller="[NamePluralUppercase]", action="undefined", params={}};
    }

    // teardown runs after every test
    public void function teardown() 
    {
         super.teardown();
    }

    /*
    * INDEX
    */

    public void function test_get_index_page_should_display_[NameSingularLowercase]_listings() 
    {
        // override some default arguments
        loc.args.action = "index";
        // get copy of the code the view generated
        loc.response = getResponse(argumentCollection=loc.args);
        // make sure this string is displayed 
        loc.string = '<h2>[NamePluralUppercase]</h2>';
        assert('loc.response contains loc.string');
        assert('loc.response contains loc.names.read');
        // check additional strings
        assertLayoutExists(loc.response);
    }

    /*
    * SHOW
    */

    public void function test_get_show_page_should_display_[NameSingularLowercase]()
    {
        // define the key param
        // define the key param
        loc.args.params = {key=loc.ids.read};
        loc.args.action = "show";
        loc.response = getResponse(argumentCollection=loc.args);
        loc.string = '<h2>#loc.names.read#</h2>';
        assert('loc.response contains loc.string');
        assertLayoutExists(loc.response);
    }

    public void function test_get_show_page_should_redirect_to_index_if_a_[NameSingularLowercase]_is_not_found()
    {
        // provide a key that doesn't exist
        loc.args.params = {key=-1};
        loc.args.action = "show";
        loc.redirect = getRedirect(argumentCollection=loc.args);
        assert('loc.redirect.route eq "[NamePluralUppercase]Root"');
    }

    /*
    * NEW
    */

    public void function test_get_new_page_should_display_[NameSingularLowercase]_form()
    {
        loc.args.action = "new";
        loc.response = getResponse(argumentCollection=loc.args);
        loc.string = '<h2>New [NameSingularUppercase]</h2>';
        assert('loc.response contains loc.string');
        assertLayoutExists(loc.response);
    }

    /*
    * EDIT
    */

    public void function test_get_edit_page_should_display_[NameSingularLowercase]_form()
    {
        loc.args.params = {key=loc.ids.read};
        loc.args.action = "edit";
        loc.response = getResponse(argumentCollection=loc.args);
        loc.string = '<h2>Edit [NameSingularUppercase] - #loc.names.read#</h2>';
        assert('loc.response contains loc.string');
        assertLayoutExists(loc.response);
    }

    public void function test_get_edit_page_should_redirect_to_index_if_a_[NameSingularLowercase]_is_not_found()
    {
        loc.args.params = {key=-1};
        loc.args.action = "edit";
        loc.redirect = getRedirect(argumentCollection=loc.args);
        assert('loc.redirect.route eq "[NamePluralUppercase]Root"');
    }

    /*
    * CREATE
    */

    public void function test_post_to_create_should_redirect_to_index_after_a_[NameSingularLowercase]_is_created()
    {
        loc.args.params = {[NameSingularLowercase]=loc.validProperties};
        loc.args.action = "create";
        loc.redirect = getRedirect(argumentCollection=loc.args);
        assert('loc.redirect.route eq "[NamePluralUppercase]Root"');
    }

    public void function test_post_to_create_should_display_errors_when_[NameSingularLowercase]_is_invalid() 
    {
        loc.args.params = {[NameSingularLowercase]=loc.invalidProperties};
        loc.args.action = "create";
        loc.response = getResponse(argumentCollection=loc.args);
        loc.message = 'There was an error creating the [NameSingularLowercase]';
        assert('loc.response contains loc.message');
        assertLayoutExists(loc.response);
    }

    /*
    * UPDATE
    */

    public void function test_post_to_update_should_redirect_to_index_after_a_[NameSingularLowercase]_is_updated()
    {
        loc.args.params.key = loc.ids.write;
        loc.args.params.[NameSingularLowercase] = loc.validProperties;
        loc.args.action = "update";
        loc.redirect = getRedirect(argumentCollection=loc.args);
        assert('loc.redirect.route eq "[NamePluralUppercase]Root"');
    }

    public void function test_post_to_update_should_display_errors_when_[NameSingularLowercase]_is_invalid()
    {
        loc.args.params.key = loc.ids.write;
        loc.args.params.[NameSingularLowercase] = loc.invalidProperties;
        loc.args.action = "update";
        loc.response = getResponse(argumentCollection=loc.args);
        loc.message = 'There was an error updating the [NameSingularLowercase]';
        assert('loc.response contains loc.message');
        assertLayoutExists(loc.response);
    }

    /*
    * DELETE
    */

    public void function test_get_delete_should_redirect_to_index_after_a_[NameSingularLowercase]_is_deleted()
    {
        loc.args.params.key = loc.ids.delete;
        loc.args.action = "delete";
        loc.redirect = getRedirect(argumentCollection=loc.args);
        assert('loc.redirect.route eq "[NamePluralUppercase]Root"');
    }

}