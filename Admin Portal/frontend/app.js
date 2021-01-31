// Lambda API URL
var API_URL = 'https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/web';

// Working GET exammple
var options = { 
    method: 'GET',
}
fetch(API_URL) 
.then(res => res.json())
.then(data => {
    // There was not an error
    buildTable(data);
})
.catch((error) => {
    // There was an error
    console.log(error);
});

// Working POST exammple with empty body
var options = { 
    method: 'POST',
    headers: { 'Content-Type':  'application/json' }, 
    body: JSON.stringify({})
}
fetch(API_URL) 
.then(res => res.json())
.then(data => {
    // There was not an error
    console.log(data);
})
.catch((error) => {
    // There was an error
    console.log(error);
});

function buildTable(data){
    var keyArray = ["name","idealTempHigh","idealTempLow","idealMoistureHigh","idealMoistureLow","idealLightHigh","idealLightLow","description"];
    for(var i = 0; i < data.length; i++){
        var obj = data[i];
        var row = document.createElement("div");
        row.setAttribute("class","row no-gutters");
        for(var key in keyArray){
            var col = document.createElement("div");
            col.setAttribute("class","col-sm-1");
            var input = document.createElement("input");
            if(keyArray[key] == "name" || keyArray[key] == "description"){
                input.setAttribute("type","text");
            }else{
                input.setAttribute("type","number");
            }
            input.value = obj[keyArray[key]];
            col.appendChild(input);
            row.appendChild(col);
        }
        $("#plant-table").append(row);
    }
}