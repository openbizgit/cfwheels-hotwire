component extends="Tests.TestBase" 
{
    
	// setup runs before every test
    public void function setup() 
    {
    	onstartup();
        super.setup();
        // create an instance of our Example
        loc.example = model("Example").new();
        // a struct used to set valid model property values
        loc.validProperties = {
        	name='name_string',
			number=1,
			sampledat=createDateTime(2000,1,1,0,0,0)
        };
        // a struct used to set invalid model property values
        loc.invalidProperties = {
        	name='xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
			number='abcd',
			sampledat='efgh'
        };
        loc.ids = {read=1, write=2, delete=3};
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
    public void function test_example_should_be_valid() 
    {
		// set the properties of the model
		loc.example.setProperties(loc.validProperties);
		loc.result = loc.example.valid();
		assert("loc.result","loc.example.allErrors()");
	}

	// assert the model is invalid when no properties are set
	public void function test_example_should_not_be_valid() 
	{
		loc.example.setProperties(loc.invalidProperties);
        assert("! loc.example.valid()");
	}

	// assert the model creates successfully
	public void function test_example_should_create_successfully() 
	{
		// set the properties of the model
		loc.example.setProperties(loc.validProperties);
		loc.result = loc.example.save();
        assert("loc.result", "loc.example.allErrors()");
	}

	// assert the model updates successfully
	public void function test_example_should_update_successfully() 
	{
		loc.example = model("Example").findByKey(loc.ids.write);
		loc.example.setProperties(loc.validProperties);
		loc.result = loc.example.update();
        assert("loc.result", "loc.example.allErrors()");
	}

	// assert the model deletes successfully
	public void function test_example_should_delete_successfully() 
	{
		loc.example = model("Example").findByKey(loc.ids.delete);
		loc.result = loc.example.delete();
        assert("loc.result");
	}

}
