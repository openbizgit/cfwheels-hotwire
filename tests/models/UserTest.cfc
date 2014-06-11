component extends="Tests.TestBase" 
{
    
	// setup runs before every test
    public void function setup() 
    {
    	onstartup();
        super.setup();
        // create an instance of our User
        loc.user = model("User").new();
        // a struct used to set valid model property values
        loc.validProperties = {
        	
        };
        // a struct used to set invalid model property values
        loc.invalidProperties = {
        	
        };
        loc.ids = {read=1, write=1, delete=1};
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

	// assert that because the properties are set correct and meet validation, the model is valid
    public void function test_user_should_be_valid() 
    {
		// set the properties of the model
		loc.user.setProperties(loc.validProperties);
		loc.result = loc.user.valid();
		assert("loc.result","loc.user.allErrors()");
	}

	// assert the model is invalid when no properties are set
	// public void function test_user_should_not_be_valid() 
	// {
	// 	loc.user.setProperties(loc.invalidProperties);
	//		assert("! loc.user.valid()");
	// }

	// assert the model creates successfully
	public void function test_user_should_create_successfully() 
	{
		// set the properties of the model
		loc.user.setProperties(loc.validProperties);
		loc.result = loc.user.save();
        assert("loc.result", "loc.user.allErrors()");
	}

	// assert the model updates successfully
	public void function test_user_should_update_successfully() 
	{
		loc.user = model("User").findByKey(loc.ids.write);
		loc.user.setProperties(loc.validProperties);
		loc.result = loc.user.update();
        assert("loc.result", "loc.user.allErrors()");
	}

	// assert the model deletes successfully
	public void function test_user_should_delete_successfully() 
	{
		loc.user = model("User").findByKey(loc.ids.delete);
		loc.result = loc.user.delete();
        assert("loc.result");
	}

}
