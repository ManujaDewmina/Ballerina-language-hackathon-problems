import ims/billionairehub;
// import ballerina/io;

type bill record {
    string name;
    float netWorth;
    string country;
    string industry;
};
# Client ID and Client Secret to connect to the billionaire API
configurable string clientId = ?;
configurable string clientSecret = ?;

public function getTopXBillionaires(string[] countries, int x) returns string[]|error {
    // Create the client connector
    billionairehub:Client cl = check new ({auth: {clientId, clientSecret}});

    billionairehub:Billionaire[] billionaires = check cl->getBillionaires("Chaina");

    //string[] AllBillionaires = [];

    // bill[] list = [];

    // // Iterate through the countries\
    // foreach var country in countries {
    //     // Get the billionaires for the country
    //    billionairehub:Billionaire[] billionaires = check cl->getBillionaires(country);
    //     // Iterate through the billionaires
    //     foreach var billionaire in billionaires {
    //         // Add the billionaire to the list
    //         io:print(billionaire.name);
    //         list.push({name: billionaire.name, netWorth: billionaire.netWorth, country: billionaire.country, industry: billionaire.industry});
    //     }
    // }
    return [];
}
