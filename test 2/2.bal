import ballerina/io;
import ballerina/regex;

//album record
type Record record {
    int employeeId;
    int odometerReading;
    float gallons;
    float gasPrice;
};

function processFuelRecords(string inputFilePath, string outputFilePath) returns error? {

    //open the input file
    json content = check io:fileReadJson(inputFilePath);

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
            employeeId: check int:fromString(a[1]),
            odometerReading: check int:fromString(b[1]),
            gallons: check float:fromString(c[1]),
            gasPrice: check float:fromString(d[1])
        };
        records.push(record_a);
    }

    int[] uniqueIDnotSort = [];

    foreach Record record_b in records {
        boolean isDuplicate = false;
        foreach int j in uniqueIDnotSort {
            if (record_b.employeeId == j) {
                isDuplicate = true;
                break;
            }
        }
        if (!isDuplicate) {
            uniqueIDnotSort.push(record_b.employeeId);
        }
    }

    //sort the uniqueID array
    int[] uniqueID = uniqueIDnotSort.sort();

    //Details for each employee ID
    string[][] rows = [];
    foreach int i in uniqueID {
        int gas_fill_up_count = 0;
        float total_fuel_cost = 0;
        float total_gallons = 0;
        int total_miles_accrued = 0;
        int first_meter_reading = 0;
        foreach Record record_c in records {
            if (record_c.employeeId == i) {
                if(gas_fill_up_count == 0)
                {
                    first_meter_reading = record_c.odometerReading;
                }
                gas_fill_up_count = gas_fill_up_count + 1;
                total_fuel_cost = total_fuel_cost + (record_c.gallons * record_c.gasPrice);
                total_gallons = total_gallons + record_c.gallons;
                total_miles_accrued = record_c.odometerReading - first_meter_reading;
            }
        }
        //add the row to the rows array
        rows.push([string `${i}`, string `${gas_fill_up_count}`, string `${total_fuel_cost}`, string `${total_gallons}`, string `${total_miles_accrued}`]);
    }

    //create json array
    json[] jsonArr = [];

    //convert the rows array to json
    foreach string[] row in rows {
        json jsonOutput={ 
                        "employeeId" : check int:fromString(row[0]), 
                        "gas_fill_up_count" : check int:fromString(row[1]), 
                        "total_fuel_cost" : check float:fromString(row[2]), 
                        "total_gallons" : check float:fromString(row[3]), 
                        "total_miles_accrued" : check int:fromString(row[4]) 
                    };
        //add the json to the json array
        jsonArr.push(jsonOutput);
    }

    //write the json array to the output file
    check io:fileWriteJson(outputFilePath, jsonArr);
}

//main function
public function main() {
    string inputFilePath = "./resources/example02_input.json";
    string outputFilePath = "./resources/output02.json";
    var result = processFuelRecords(inputFilePath, outputFilePath);
    if (result is error) {
        io:println("Error: ", result);
    }
}