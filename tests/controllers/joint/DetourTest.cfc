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
        loc.args = {controller="joint.Detour", action="undefined", params={}}
    }

    // teardown runs after every test
    public void function teardown() 
    {
         super.teardown()
    }


    public void function test_should_redirect_dashboard_consumer() 
    {
        createUserSession()        
        loc.args.action = "dashboard"
        loc.redirect = getRedirect(argumentCollection=loc.args)
        assert('loc.redirect.route EQ "userDashboardRoot"')
    }

    public void function test_should_redirect_dashboard_agent() 
    {
        createAdministratorSession()
        loc.args.action = "dashboard"
        loc.redirect = getRedirect(argumentCollection=loc.args)
        assert('loc.redirect.route EQ "administratorDashboardRoot"')
    }

    public void function test_should_redirect_dashboard_master() 
    {
        createRootSession()
        loc.args.action = "dashboard"
        loc.redirect = getRedirect(argumentCollection=loc.args)
        assert('loc.redirect.route EQ "rootDashboardRoot"')
    }

}