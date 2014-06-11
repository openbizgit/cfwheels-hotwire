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
        loc.args = {controller="public.Signin", action="undefined", params={}}
    }

    // teardown runs after every test
    public void function teardown() 
    {
         super.teardown()
    }

    /*
    * INDEX
    */

    public void function test_should_display_signin_form() 
    {
        // override some default arguments
        loc.args.action = "signin"
        // get copy of the code the view generated
        loc.response = getResponse(argumentCollection=loc.args)
        // make sure these strings appear
        assert('loc.response contains "Sign in"')
        assert('loc.response contains "email"')
        assert('loc.response contains "password"')
        assert('loc.response contains "/images/logo.png"')
        // forgotten link
        loc.forgottenRoute = 'public/signin/reset'
        assert('loc.response contains loc.forgottenRoute')
        // signin button
        loc.submit = '<button class="btn btn-lg btn-primary btn-block" type="submit"'
        assert('loc.response contains loc.submit')

    }

}