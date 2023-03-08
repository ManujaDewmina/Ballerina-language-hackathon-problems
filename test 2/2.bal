import ballerina/io;

type Record record {
    int employeeId;
    int odometerReading;
    float gallons;
    float gasPrice;
};

function processFuelRecords(string inputFilePath, string outputFilePath) returns error? {
    xml fuelEvents = check io:fileReadXml(inputFilePath);
    
    Record[] fuelRecords = [];

    // Iterate through each FuelEvent element in the XML and create a record object
    foreach xml fuelEvent in fuelEvents/<FuelEvent> {
        Record fuelRecord = {
            employeeId: check int.convert(fuelEvent/<EmployeeId>.getTextValue()),
            odometerReading: check int.convert(fuelEvent/<OdometerReading>.getTextValue()),
            gallons: check float.convert(fuelEvent/<Gallons>.getTextValue()),
            gasPrice: check float.convert(fuelEvent/<GasPrice>.getTextValue())
        };
        fuelRecords.push(fuelRecord);
    }
    // Print the array of record objects
    io:println(fuelRecords.toString());
    
   
    
}

public function main() {
    string inputFilePath = "./resources/example01_input.xml";
    string outputFilePath = "./rresources/example01_output_test.xml";
    error? processFuelRecordsResult = processFuelRecords(inputFilePath,outputFilePath);
    if processFuelRecordsResult is error {
        io:println("Error occurred while processing fuel records: ", processFuelRecordsResult);
    }
}