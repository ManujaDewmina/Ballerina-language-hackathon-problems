
import ballerina/io;

//album record
type Record record {
    string employeeId;
    int gasFillUpCount;
    float totalFuelCost;
    float totalGallons;
    int totalMilesAccrued;
};


function processFuelRecords(string inputFilePath, string outputFilePath) returns error? {
    //create a new xml file
    //xml newXml = xml `<records></records>`;

    //read the input xml file
    xml xmlData = check io:fileReadXml(inputFilePath);

    //create string array
    string[] uniqueId = [];

    //iterate through the xml file to get uniqui id array
    foreach var item in xmlData.elementChildren() {
        string id = check item.employeeId;
        boolean isDuplicate = false;
        foreach string j in uniqueId {
            if (id == j) {
                isDuplicate = true;
                break;
            }
        }
        if (!isDuplicate) {
            uniqueId.push(id);
        }
    }

    //store data in records for each unique id
    Record[][] records = [];
    foreach string id in uniqueId {
        Record[] record_a = [];
        int count = 0;
        float totalFuelCost = 0;
        float totalGallons = 0;
        int totalMilesAccrued = 0;
        int first_meter_reading = 0;
        foreach var item in xmlData.elementChildren() {
            string employeeId = check item.employeeId;
            if (id == employeeId) {
                if(count == 0)
                {
                    first_meter_reading = check int:fromString(item.elementChildren().get(0).data());
                }
                count = count + 1;
                totalFuelCost = totalFuelCost + check float:fromString(item.elementChildren().get(1).data())*check float:fromString(item.elementChildren().get(2).data());
                totalGallons = totalGallons + check float:fromString(item.elementChildren().get(1).data());
                totalMilesAccrued = check int:fromString(item.elementChildren().get(0).data()) - first_meter_reading;
            }            
        }
        Record rec = {
                    employeeId: id,
                    gasFillUpCount: count,
                    totalFuelCost: totalFuelCost,
                    totalGallons: totalGallons,
                    totalMilesAccrued: totalMilesAccrued
                };
                record_a.push(rec);
        records.push(record_a);
    }

    //print the records
    // foreach Record[] record_b in records {
    //     foreach Record record_a in record_b {
    //         io:println("Employee ID: ", record_a.employeeId);
    //         io:println("Gas Fill Up Count: ", record_a.gasFillUpCount);
    //         io:println("Total Fuel Cost: ", record_a.totalFuelCost);
    //         io:println("Total Gallons: ", record_a.totalGallons);
    //         io:println("Total Miles Accrued: ", record_a.totalMilesAccrued);
    //     }
    // }
    
}

//main function
public function main() {
    string inputFilePath = "./resources/example02_input.xml";
    string outputFilePath = "./resources/output01.xml";
    var result = processFuelRecords(inputFilePath, outputFilePath);
    if (result is error) {
        io:println("Error: ", result);
    }
}