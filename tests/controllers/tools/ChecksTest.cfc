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
        loc.args = {controller="tools.Checks", action="undefined", params={}}
        loc.release = 1234567890
    }

    // teardown runs after every test
    public void function teardown() 
    {
         super.teardown()
    }

    public void function test_ping_should_succeed() 
    {
        loc.args.action = "index"
        loc.response = getResponse(argumentCollection=loc.args)
        assert('loc.response contains "{ping:true}"')

        loc.args.action = "ping"
        loc.response = getResponse(argumentCollection=loc.args)
        assert('loc.response contains "{ping:true}"')
    }

    public void function test_release_should_succeed() 
    {
        loc.args.action = "release"
        loc.response = getResponse(argumentCollection=loc.args)
        assert('loc.response contains "{release:#loc.release#}"')
    }

    public void function test_isreleased_should_succeed() 
    {
        loc.args.action = "isreleased"

        loc.args.params.release = loc.release
        loc.response = getResponse(argumentCollection=loc.args)
        assert('loc.response contains "{isreleased:true}"')

        loc.args.params.release = 123
        loc.response = getResponse(argumentCollection=loc.args)
        assert('loc.response contains "{isreleased:false}"')
    }

}