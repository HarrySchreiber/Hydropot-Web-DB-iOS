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
    var table = document.getElementById("plant-types-table");
    for(var i = 0; i < data.length; i++){
        var obj = data[i];
        var row = table.insertRow(i + 1);
        var plantName = row.insertCell(0);
        var plantNameInput = document.createElement("input");
        plantNameInput.setAttribute("type","text");
        plantNameInput.value = obj.name;
        plantName.appendChild(plantNameInput);
        var lowTemp = row.insertCell(1);
        var lowTempInput = document.createElement("input");
        lowTempInput.setAttribute("type","number");
        lowTempInput.value = obj.idealTempLow;
        lowTemp.appendChild(lowTempInput);
        var highTemp = row.insertCell(2);
        var highTempInput = document.createElement("input");
        highTempInput.setAttribute("type","number");
        highTempInput.value = obj.idealTempHigh;
        highTemp.appendChild(highTempInput);
        var lowMoisture = row.insertCell(3);
        var lowMoistureInput = document.createElement("input");
        lowMoistureInput.setAttribute("type","number");
        lowMoistureInput.value = obj.idealMoistureLow;
        lowMoisture.appendChild(lowMoistureInput);
        var highMoisture = row.insertCell(4);
        var highMoistureInput = document.createElement("input");
        highMoistureInput.setAttribute("type","number");
        highMoistureInput.value = obj.idealMoistureHigh;
        highMoisture.appendChild(highMoistureInput);
        var lowLight = row.insertCell(5);
        var lowLightInput = document.createElement("input");
        lowLightInput.setAttribute("type","number");
        lowLightInput.value = obj.idealMoistureLow;
        lowLight.appendChild(lowLightInput);
        var highLight = row.insertCell(6);
        var highLightInput = document.createElement("input");
        highLightInput.setAttribute("type","number");
        highLightInput.value = obj.idealMoistureLow;
        highLight.appendChild(highLightInput);
        var description = row.insertCell(7);
        var descriptionInput = document.createElement("input");
        descriptionInput.setAttribute("type","text");
        descriptionInput.value = obj.description;
        description.appendChild(descriptionInput);
    }
}