import ballerina/io;
import ballerina/file;
import ballerinax/java.jdbc;
import ballerina/sql;
import ballerina/regex;

//album record
type Record record {
    int employee_id;
    float amount;
    string reason;
    string date;
};


function addPayments(string dbFilePath, string paymentFilePath) returns error|int[] {
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
                //open the input file
                json content = check io:fileReadJson(paymentFilePath);

                Record[] records = [];

                //make it string add match to map array with out iterrating json object
                string contentString = content.toString();

                //split the string and assign it to record array
                string[] contentArray = regex:split(contentString, "},");
                foreach var item in contentArray {
                    string[] recordArray = regex:split(item, ",");
                    string[] a = regex:split(recordArray[0].trim(), ":");
                    string[] b = regex:split(recordArray[1].trim(), ":");
                    string[] c = regex:split(recordArray[2].trim(), ":");

                    
                    string lastElement = recordArray[3].trim();
                    if (lastElement.endsWith("}]")) {
                        lastElement = lastElement.substring(0, lastElement.length() - 2);
                    }
                    string[] d = regex:split(lastElement, ":");


                    Record record_a = {
                        employee_id: check int:fromString(a[1]),
                        amount: check float:fromString(b[1]),
                        reason: (c[1]),
                        date: (d[1])
                    };
                    records.push(record_a);
                }

                //iterate through the records
                int[] ids = [];	
                foreach var record_a in records {
                    string dateS = record_a.date;
                    //remove the quotes
                    dateS = dateS.substring(1, dateS.length() - 1);
                    sql:DateValue date = new(dateS);	
                    float amount = record_a.amount;
                    int employee_id = record_a.employee_id;
                    string reason = record_a.reason;

                    //add the record to the database
                    sql:ParameterizedQuery sqlQuery = `INSERT INTO Payment (date, amount, employee_id, reason) VALUES (${date}, ${amount}, ${employee_id}, ${reason})`;

                    //execute the query
                    sql:ExecutionResult|sql:Error result = jdbcClient->execute(sqlQuery);

                    if (result is sql:Error) {
                        io:println("Error while executing the query: " + result.message());
                        return [];
                    } else {
                        //get the auto-generated key
                        string|int? generatedKey = result.lastInsertId;

                        if (generatedKey is ()) {
                            io:println("Error while getting the auto-generated key");
                            return [];
                        } else {
                            //add the generated key to the array
                            ids.push(<int>generatedKey);
                        }
                    }
                }
                io:print(ids);
                return ids;
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



