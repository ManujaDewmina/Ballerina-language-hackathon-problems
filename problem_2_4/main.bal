import ballerina/io;
import ballerina/file;
import ballerinax/java.jdbc;
import ballerina/sql;

type payment record {|
   	// The key must be read-only.
   	readonly int payment_id;
    string date;
   	decimal amount;
    int employee_id;
    string reason;
|};

type employee record {|
   	// The key must be read-only.
   	readonly int employee_id;
    string name;
   	string city;
    string department;
    int age;
|};

type finalTable record {|
   	// The key must be read-only.
   	readonly int payment_id;
    decimal amount;
   	string employee_name;
|};

function getHighPaymentEmployees(string dbFilePath, decimal amount) returns string[]|error {
    //database file path
    string filePath = dbFilePath + ".mv.db";

    //chek if the database file exists
    do {
	    //chek if the database file exists
	    boolean exists = check file:test(filePath, file:EXISTS);

        if (exists) {
            //Create a new database connection for available database file
            jdbc:Client|sql:Error jdbcClient = new("jdbc:h2:file:" + dbFilePath, "root", "root");

            if (jdbcClient is jdbc:Client) {
                
                //create a table for payment
                table<payment> key(payment_id) payments = table [];

                sql:ParameterizedQuery query = `SELECT * FROM Payment`;

                //store the result of the query in a table
                stream<payment, sql:Error?> result = jdbcClient->query(query);
                
                //add the result to the table
                check result.forEach(function(payment payment) {
                    payments.put(payment);
                });

                //create a table for employee
                table<employee> key(employee_id) employees = table [];

                sql:ParameterizedQuery query_2 = `SELECT * FROM Employee`;

                //store the result of the query in a table
                stream<employee, sql:Error?> result_2 = jdbcClient->query(query_2);
                
                //add the result to the table
                check result_2.forEach(function(employee employee) {
                    employees.put(employee);
                });

                //create a new table for the result
                table<finalTable> key(payment_id) finalResults = table [];

                //iterate through the payment table
                foreach payment payment in payments {
                    //check if the payment amount is greater than the given amount
                    if (payment.amount > amount) {
                        //iterate through the employee table
                        foreach employee employee in employees {
                            //check if the employee id is equal to the employee id in the payment table
                            if (payment.employee_id == employee.employee_id) {
                                //create a new record for the final result
                                finalTable finalResult = {
                                    payment_id: payment.payment_id,
                                    amount: payment.amount,
                                    employee_name: employee.name
                                };
                                //add the record to the final result table
                                finalResults.put(finalResult);
                            }
                        }
                    }
                }

                //string array to store the employee names
                string[] employeeNames = [];
                //iterate through the final result table
                foreach finalTable finalResult in finalResults {
                    //add the employee name to the string array
                    employeeNames.push(finalResult.employee_name);
                }
                //process the result
                return employeeNames.sort();

            } else {
                io:println("Error: " + jdbcClient.message());
                return [];
            }
        } else {
            io:println("Database file does not exist");
            return [];
        }
    } on fail var e {
        io:println("Error: " + e.message());  
        return [];
    }   
}
