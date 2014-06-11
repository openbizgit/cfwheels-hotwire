component extends="Tests.TestBase" 
{
    
	// setup runs before every test
    public void function setup() 
    {
    	onstartup();
        super.setup();
        // create an instance
        loc.person = model("Person").new();
        // a struct used to set valid model property values
        loc.validProperties = {
        	firstname='firstname_string',
			lastname='lastname_string',
			bornat=createDateTime(2000,1,1,0,0,0),
			gender='m',
			mobile='mobile_string',
			email='email_string@testemail.com',
			password='password_string*321',
			passwordConfirmation='password_string*321',
			salt='salt_string',
			resettoken='resettoken_string',
			utcoffset=0,
			tokencreatedat=createDateTime(2000,1,1,0,0,0),
			tokenexpiresat=createDateTime(2000,1,1,0,0,0),
			lastloginat=createDateTime(2000,1,1,0,0,0),
			lastloginattemptat=createDateTime(2000,1,1,0,0,0),
			lastloginattemptipaddress='lastloginattemptipaddress_string'
        };
        loc.ids = {root=1, administrator=2, user=3};
    }
    
    // teardown runs after every test
    public void function teardown() 
    {
    	 super.teardown();
    }

    // assert that setup and teardown pass
    public void function test_setup_and_teardown() 
    {
		assert("true");
	}

	public void function test_should_validate_password() 
	{
		loc.person.setProperties(loc.validProperties);
		// less than 8 characters
		loc.person.password="123"
		loc.person.passwordConfirmation = loc.person.password
		assert("! loc.person.valid()");

		// no letter
		loc.person.password="12345678"
		loc.person.passwordConfirmation = loc.person.password
		assert("! loc.person.valid()");

		// no number
		loc.person.password="abcdefgh"
		loc.person.passwordConfirmation = loc.person.password
		assert("! loc.person.valid()");

		// no symbol
		loc.person.password="abcd1234"
		loc.person.passwordConfirmation = loc.person.password
		assert("! loc.person.valid()");

		// valid password
		loc.person.password="abcd*1234"
		loc.person.passwordConfirmation = loc.person.password
		assert("loc.person.valid()");
	}

	public void function test_should_secure_password() 
	{
		loc.person.setProperties(loc.validProperties);
		loc.result = loc.person.save();
        assert("Len(loc.person.password) EQ 60");
	}

	public void function test_should_authenticate() 
	{
		loc.person = model("Person").findByKey(loc.ids.administrator)
		loc.auth = loc.person.authenticate("password*321")
		assert(loc.auth)
	}

	public void function test_should_find_root() 
	{
		loc.person = model("Person").findByKey(loc.ids.root)
		assert("loc.person.namespace EQ 'root'")
	}

	public void function test_should_find_administrator() 
	{
		loc.person = model("Person").findByKey(loc.ids.administrator)
		assert("loc.person.namespace EQ 'administrator'")
	}

	public void function test_should_find_user() 
	{
		loc.person = model("Person").findByKey(loc.ids.user)
		assert("loc.person.namespace EQ 'user'")
	}

}