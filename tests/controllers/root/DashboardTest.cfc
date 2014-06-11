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
        createRootSession()
        loc.args = {controller="root.Dashboard", action="undefined", params={}}
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

        assert('loc.response contains "<h2>#get('appName')# Root Dashboard</h2>"')
        assert('loc.response contains "Examples"')

        // check additional strings
        assertLayoutExists(loc.response)
    }

}