component extends="Tests.TestBase" {

    /*
    * SETUP & TEARDOWN
    */

    // setup runs before every test
    public void function setup() 
    {
        onstartup()
        super.setup()
        loc.args = {controller="tools.DB", action="", params={}}
    }

    // teardown runs after every test
    public void function teardown() 
    {
         super.teardown()
    }

    public void function test_ping_should_succeed() 
    {
        loc.args.action = "ping"
        loc.response = getResponse(argumentCollection=loc.args)
        loc.okay = '{db:"okay"}'
        assert('loc.response contains loc.okay')
    }

    public void function test_migrations_should_succeed() 
    {
        loc.args.action = "migrations";

        loc.args.params.type = "current";
        loc.response = getResponse(argumentCollection=loc.args);
        assert('loc.response contains "{current:"');

        loc.args.params.type = "latest";
        loc.response = getResponse(argumentCollection=loc.args);
        assert('loc.response contains "{latest:"');

        loc.args.params.type = "ismigrated";
        loc.response = getResponse(argumentCollection=loc.args);
        assert('loc.response contains "{ismigrated:"');
    }

}