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
        loc.args = {controller="user.Dashboard", action="undefined", params={}}
    }

    // teardown runs after every test
    public void function teardown() 
    {
         super.teardown()
    }

    /*
    * INDEX
    */

    public void function test_should_display_dashboard() 
    {
        // override some default arguments
        loc.args.action = "index"
        // get copy of the code the view generated
        loc.response = getResponse(argumentCollection=loc.args)
        // make sure this string is displayed 
        assert('loc.response contains "<h2>#get('appName')# User Dashboard</h2>"')

        // check additional strings
        assertLayoutExists(loc.response)
    }

}