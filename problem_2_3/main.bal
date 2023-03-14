import ballerina/io;
import ballerina/file;
import ballerinax/java.jdbc;
import ballerina/sql;

//Define a record to load the result of the database query
type Payment record {
    int employee_id;
    decimal amount;
    string reason;
};

type HighPayment record {
    string name;
    string department;
    decimal amount;
    string reason;
};

function getHighPaymentDetails(string dbFilePath, decimal  amount) returns HighPayment[]|error {
    string filePath = dbFilePath + ".mv.db";

    //chek if the database file exists
    do {
	    //chek if the database file exists
	    boolean exists = check file:test(filePath, file:EXISTS);

        if (exists) {
            //Create a new database connection for available database file
            jdbc:Client|sql:Error jdbcClient = new("jdbc:h2:file:" + dbFilePath, "root", "root");

            if (jdbcClient is jdbc:Client) {
                //get all the records from the database sql parameterized query where the amount is greater than the given amount
                sql:ParameterizedQuery query = `SELECT * FROM Payment WHERE Amount > ${amount}`;

                //execute the query and get the result
                stream<Payment, sql:Error?> resultStream = jdbcClient->query(query);	

                //iterate through the result stream and add the records to the HighPayment record array
                Payment[] paymentDetails = [];
                check resultStream.forEach(function(Payment payment) {
                    paymentDetails.push(payment);
                });

                HighPayment[] highPaymentDetails = [];
                //iterate through record array
                foreach Payment payment_a in paymentDetails {
                    sql:ParameterizedQuery query_2 = `SELECT * FROM Employee WHERE employee_id = ${payment_a.employee_id}`;

                    //execute the query and get the result
                    stream<record{}, sql:Error?> resultStream_2 = jdbcClient->query(query_2);

                    //iterate through the result stream and add the records to the HighPayment record array
                    
                    check resultStream_2.forEach(function(record{} employee) {
                        HighPayment highPayment = {
                            name: <string>employee["NAME"],
                            department: <string>employee["DEPARTMENT"],
                            amount: payment_a.amount,
                            reason: payment_a.reason
                        };
                        highPaymentDetails.push(highPayment);
                    });
                }
                
                //close the database connection
                error? closeResult = jdbcClient.close();
                if (closeResult is error) {
                    io:println("Error: " + closeResult.message());
                }

                //return the result
                return highPaymentDetails;
                
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
