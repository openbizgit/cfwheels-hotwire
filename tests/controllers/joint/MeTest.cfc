component extends="Tests.TestBase"
{

    /*
    * SETUP & TEARDOWN
    */

    // setup runs before every test
    public void function setup() 
    {
        onstartup()
        super.setup()
        createUserSession()
        loc.args = {controller="joint.Me", action="undefined", params={}}
    }

    // teardown runs after every test
    public void function teardown() 
    {
         super.teardown()
    }


    public void function test_should_show_new_edit_email_form() 
    {
        loc.args.action = "editEmail"

        loc.response = getResponse(argumentCollection=loc.args)

        assert('loc.response contains "<h2>Edit my email</h2>"')
        // form fields
        assert('loc.response contains "currentperson[email]"')

        loc.submit = 'type="submit" value="Update"'
        assert('loc.response contains "sid@sexpistols.co.uk"')
        assert('loc.response contains loc.submit')
        assertLayoutExists(loc.response)
    }

    public void function test_should_show_new_edit_password_form() 
    {
        loc.args.action = "editPassword"

        loc.response = getResponse(argumentCollection=loc.args)

        assert('loc.response contains "<h2>Change my password</h2>"')
        // form fields
        assert('loc.response contains "oldpassword"')
        assert('loc.response contains "currentperson[password]"')
        assert('loc.response contains "currentperson[passwordConfirmation]"')

        loc.submit = 'type="submit" value="Update"'
        assert('loc.response contains loc.submit')
        assertLayoutExists(loc.response)
    }

}