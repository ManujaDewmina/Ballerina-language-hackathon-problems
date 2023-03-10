import ballerina/io;

type Record record {
    int employee_id;
    int odometer_reading;
    float gallons;
    float gas_price;
};

function processFuelRecords(string inputFilePath, string outputFilePath) returns error? {
        // Read the CSV file as a stream of records.
    string[][] input = check io:fileReadCsv(inputFilePath);

    Record[] RecordArray = [];

    // Convert the input stream of records to an array of records.
    foreach string[] row in input {
        Record Record_a =  {employee_id: check int:fromString(row[0]),
                            odometer_reading: check int:fromString(row[1]),
                            gallons : check float:fromString(row[2]),
                            gas_price: check float:fromString(row[3])};
        RecordArray.push(Record_a);
    }

    int[] uniqueIDnotSort = [];

    //find the unique employee IDs
    foreach Record record_b in RecordArray {
        boolean isDuplicate = false;
        foreach int j in uniqueIDnotSort {
            if (record_b.employee_id == j) {
                isDuplicate = true;
                break;
            }
        }
        if (!isDuplicate) {
            uniqueIDnotSort.push(record_b.employee_id);
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
        foreach Record record_c in RecordArray {
            if (record_c.employee_id == i) {
                if(gas_fill_up_count == 0)
                {
                    first_meter_reading = record_c.odometer_reading;
                }
                gas_fill_up_count = gas_fill_up_count + 1;
                total_fuel_cost = total_fuel_cost + (record_c.gallons * record_c.gas_price);
                total_gallons = total_gallons + record_c.gallons;
                total_miles_accrued = record_c.odometer_reading - first_meter_reading;
            }
        }
        //add the row to the rows array
        rows.push([string `${i}`, string `${gas_fill_up_count}`, string `${total_fuel_cost}`, string `${total_gallons}`, string `${total_miles_accrued}`]);
    }
    //write the rows array to the output file
    check io:fileWriteCsv(outputFilePath, rows);
}
