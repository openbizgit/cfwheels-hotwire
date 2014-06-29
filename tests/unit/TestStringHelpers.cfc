component extends="Tests.TestBase"
{
	
	public void function setup() {
		//
	}

	public void function teardown() {
		//
	}

	public any function test_randomstring_helper_should_create_random_string_of_correct_length() {
		loc.string = randomString("alpha", 50)
		assert("Len(loc.string) eq 50")
	}
	
	public any function test_randomstring_helper_should_create_random_string_of_correct_type() {
		loc.alpha = randomString("alpha", 50)
		loc.numeric = randomString("numeric", 50)
		loc.alphanumeric = randomString("alphanumeric", 50)
		loc.secure = randomString("secure", 50)
		loc.mixedCase = randomString("alphanumeric", 50, true)
		// TODO: ReFind() correct strings
		
	}

	randomString

}