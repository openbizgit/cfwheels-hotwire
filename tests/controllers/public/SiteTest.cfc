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
        loc.args = {controller="public.Site", action="undefined", params={}}
    }

    // teardown runs after every test
    public void function teardown() 
    {
         super.teardown()
    }

    /*
    * INDEX
    */

    public void function test_should_display_website_landing_page() 
    {
        // override some default arguments
        loc.args.action = "index"
        // get copy of the code the view generated
        loc.response = getResponse(argumentCollection=loc.args)
        // make sure these strings appear
        assert('loc.response contains "/images/logo.png"')
        assert('loc.response contains "<h1>#get("appName")#</h1>"')
        assert('loc.response contains "A baseplate for Coldfusion on Wheels applications"')
        assert('loc.response contains "Create database"')
        assert('loc.response contains "Create seed data"')
        assert('loc.response contains "Sign in"')
        assert('loc.response contains "Tests"')
    }

}