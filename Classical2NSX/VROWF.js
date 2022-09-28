var token = "Basic " + nsxBasicAuth
var nsxt
var vlanNumber
var lswName = "LSW-DCE-"+vlanNumber+"v"+"-01";



// Determine which NSX will be our endpoint
if(nsxt === "vxRailDR")
{
  var transport_zone_path = "/infra/sites/default/enforcement-points/default/transport-zones/1111ed4a-97f8-46b8-a6b1-d0a8f9591111";
  var vlan_transport_zone_path = "/infra/sites/default/enforcement-points/default/transport-zones/1111ac59-5195-4301-b4f5-f9e199811111";
  
}else if(nsxt === "vxRailnonDR")
{
  var transport_zone_path = "/infra/sites/default/enforcement-points/default/transport-zones/11115ddb-a726-4755-aa27-350fe29d1111";
  var vlan_transport_zone_path = "/infra/sites/default/enforcement-points/default/transport-zones/11118cca-aeb8-4ba8-8fe3-5324ed821111";
}


//LSW Creation
var url = "/policy/api/v1/infra/segments/" + lswName

var payload = {
    "type": "DISCONNECTED",
    "vlan_ids": [
        ""+vlanNumber+""
    ],
    "transport_zone_path": ""+vlan_transport_zone_path+"",
    "advanced_config": {
        "connectivity": "ON"
    },
    "admin_state": "UP",


       "tags": [
        {
            "scope": "LSW",
            "tag": ""+lswName+""
        }
    ]
}

//System.log(JSON.stringify(payload))


if(nsxt === "vxRailDR")
{
var response = restContent("PATCH",drNsxtHost,url,payload,token);
if (response.statusCode != 200) throw "HTTP status code :" + response.statusCode + "(" + response.serverMessage + ")";
}else if(nsxt === "vxRailnonDR")
{
var response = restContent("PATCH",nonDrNsxtHost,url,payload,token);
if (response.statusCode != 200) throw "HTTP status code :" + response.statusCode + "(" + response.serverMessage + ")";
}




//Security Group Creation 
var url = "/policy/api/v1/infra/domains/default/groups/" + "SG-LSW-DCE-"+vlanNumber+"v";

var payload = {
    "expression": [
        {
            "member_type": "Segment",
            "key": "Tag",
            "operator": "EQUALS",
            "value": "LSW|"+lswName+"",
            "resource_type": "Condition"

        }
    ],
    "extended_expression": [],
    "reference": false,
    "resource_type": "Group",

        "tags": [
        {
            "scope": "SG",
            "tag": "SG-"+lswName+""
        }
    ]

}


if(nsxt === "vxRailDR")
{
var response = restContent("PATCH",drNsxtHost,url,payload,token);
if (response.statusCode != 200) throw "HTTP status code :" + response.statusCode + "(" + response.serverMessage + ")";
}else if(nsxt === "vxRailnonDR")
{
var response = restContent("PATCH",nonDrNsxtHost,url,payload,token);
if (response.statusCode != 200) throw "HTTP status code :" + response.statusCode + "(" + response.serverMessage + ")";
}




var url = "/policy/api/v1/infra/domains/default/security-policies/" + "FWP-VPC-" + ""+vlanNumber+"" + "v"
var payload = {
    "rules": [
        {
            "action": "ALLOW",
            "resource_type": "Rule",
            "id": "FWR-"+vlanNumber+"v-Out",
            "display_name": "FWR-"+vlanNumber+"v-Out",
            "source_groups": [
                "/infra/domains/default/groups/SG-LSW-DCE-"+vlanNumber+"v"
            ],
            "destination_groups": [
                "ANY"
            ],
            "services": [
                "ANY"
            ],
            "profiles": [
                "ANY"
            ],
            "logged": false,
            "scope": [
                 "/infra/domains/default/groups/SG-LSW-DCE-"+vlanNumber+"v"
            ]
       
        },
        {
            "action": "ALLOW",
            "resource_type": "Rule",
            "id": "FWR-"+vlanNumber+"v-IN",
            "display_name": "FWR-"+vlanNumber+"v-IN",
            "source_groups": [
                "ANY"
            ],
            "destination_groups": [
                "/infra/domains/default/groups/SG-LSW-DCE-"+vlanNumber+"v"
            ],
            "services": [
                "ANY"
            ],
            "profiles": [
                "ANY"
            ],
            "logged": false,
            "scope": [
                "/infra/domains/default/groups/SG-LSW-DCE-"+vlanNumber+"v"
            ]
        }
    ],
    "logging_enabled": false,
    "resource_type": "SecurityPolicy",
    "scope": [
        "ANY"
    ]
}



if(nsxt === "vxRailDR")
{
var response = restContent("PATCH",drNsxtHost,url,payload,token);
if (response.statusCode != 200) throw "HTTP status code :" + response.statusCode + "(" + response.serverMessage + ")";
}else if(nsxt === "vxRailnonDR")
{
var response = restContent("PATCH",nonDrNsxtHost,url,payload,token);
if (response.statusCode != 200) throw "HTTP status code :" + response.statusCode + "(" + response.serverMessage + ")";
}




function restContent(method, host, url, payload, token) {
    //System.debug("**** Requesting endpoint data...");
    req = host.createRequest(method, url, payload ? JSON.stringify(payload) : null);
    req.setHeader("Accept", "application/json");
    req.setHeader("Content-Type", "application/json");
    if (token) { req.setHeader("Authorization", token); }
    return req.execute();
}
