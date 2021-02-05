// Lambda API URL
var API_URL = 'https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/web';


// // Working GET exammple
// var options = { 
//     method: 'GET',
//     headers: { 'Content-Type':  'application/json' }
// }
// fetch(API_URL,options) 
// .then(res => res.json())
// .then(data => {
//     // There was not an error
//     console.log(data);
// })
// .catch((error) => {
//     // There was an error
//     console.log(error);
// });

function loadPage(){
    var options = { 
        method: 'POST',
        headers: { 'Content-Type':  'application/json' }, 
        body: JSON.stringify({
            'operation':'getAll',
            'tableName':'HydroPotPlantTypes'
        })
    }
    fetch(API_URL,options) 
    .then(res => res.json())
    .then(data => {
        // There was not an error
        buildTable(data['Items']);
        console.log(data);
    })
    .catch((error) => {
        // There was an error
        console.log(error);
    });
}

function buildTable(data){
    $("#plant-table").empty();

    buildInputFields();

    var keyArray = ["plantName","idealTempHigh","idealTempLow","idealMoistureHigh","idealMoistureLow","idealLightHigh","idealLightLow","description"];
    for(var i = 0; i < data.length; i++){
        //Declare the json object
        var obj = data[i];
        //Declare Columns and rows
        var fullRow = document.createElement("div");
        fullRow.setAttribute("class","row no-gutters");
        fullRow.setAttribute("id",obj["id"]);
        var pictureCol = document.createElement("div");
        pictureCol.setAttribute("class", "col-md-1 no-gutters");
        var contentCol = document.createElement("div");
        contentCol.setAttribute("class", "col-md-10 no-gutters");
        var buttonsCol = document.createElement("div");
        buttonsCol.setAttribute("class", "col-md-1 no-gutters");

        //TODO: Image Code
        

        //Content Code
        var topRow = document.createElement("div");
        topRow.setAttribute("class","row no-gutters");
        var bottomRow = document.createElement("div");
        bottomRow.setAttribute("class","row no-gutters");
        for(var key in keyArray){
            var input = document.createElement("input");
            if(keyArray[key] == "plantName"){
                input.setAttribute("type","text");
                input.setAttribute("style","width: 22%;"); //TODO: Dummy Values for percent
                input.setAttribute("id",`${keyArray[key]}-${obj['id']}`);
                input.value = obj[keyArray[key]];
                topRow.appendChild(input);
            }else if(keyArray[key] == "description"){
                input.setAttribute("type","text");
                input.setAttribute("style","width: 100%;"); //TODO: Dummy Values for percent
                input.setAttribute("id",`${keyArray[key]}-${obj['id']}`);
                input.value = obj[keyArray[key]];
                bottomRow.appendChild(input);
            }else{
                input.setAttribute("type", "number");
                input.setAttribute("style","width: 13%;"); //TODO: Dummy Values for percent
                input.setAttribute("id",`${keyArray[key]}-${obj['id']}`);
                input.value = obj[keyArray[key]];
                topRow.appendChild(input);
            }
        }
        contentCol.appendChild(topRow);
        contentCol.appendChild(bottomRow);

        //Buttons Cols
        var saveButton = document.createElement("input");
        saveButton.setAttribute("type","button");
        saveButton.setAttribute("style","width: 50%; height: 100%");
        saveButton.setAttribute("onclick",`editPlant("${obj['id']}")`);
        saveButton.value = "💾";
        var deleteButton = document.createElement("input");
        deleteButton.setAttribute("type","button");
        deleteButton.setAttribute("style","width: 50%; height: 100%");
        deleteButton.setAttribute("onclick",`deletePlant("${obj['id']}")`);
        deleteButton.value = "🤮";
        buttonsCol.appendChild(saveButton);
        buttonsCol.appendChild(deleteButton);

        fullRow.appendChild(pictureCol);
        fullRow.appendChild(contentCol);
        fullRow.appendChild(buttonsCol);

        $("#plant-table").append(fullRow);
    }
}

function buildInputFields(){

    var fullRow = document.createElement("div");
    fullRow.setAttribute("class","row no-gutters");
    var pictureCol = document.createElement("div");
    pictureCol.setAttribute("class", "col-md-1 no-gutters");
    

    var contentCol = document.createElement("div");
    contentCol.setAttribute("class", "col-md-10 no-gutters");

    var topRow = document.createElement("div");
    topRow.setAttribute("class","row no-gutters");

    var addPlantName = document.createElement("input");
    addPlantName.setAttribute("id","add-plant-name");
    addPlantName.setAttribute("type","text");
    addPlantName.setAttribute("style","width: 22%");
    addPlantName.setAttribute("placeholder","Plant Name");
    topRow.appendChild(addPlantName);
    var addTempHigh = document.createElement("input");
    addTempHigh.setAttribute("id","add-temp-high");
    addTempHigh.setAttribute("type","number");
    addTempHigh.setAttribute("style","width: 13%");
    addTempHigh.setAttribute("placeholder","High Temp");
    topRow.appendChild(addTempHigh);
    var addTempLow = document.createElement("input");
    addTempLow.setAttribute("id","add-temp-low");
    addTempLow.setAttribute("type","number");
    addTempLow.setAttribute("style","width: 13%");
    addTempLow.setAttribute("placeholder","Low Temp");
    topRow.appendChild(addTempLow);
    var addMoistureHigh = document.createElement("input");
    addMoistureHigh.setAttribute("id","add-moisture-high");
    addMoistureHigh.setAttribute("type","number");
    addMoistureHigh.setAttribute("style","width: 13%");
    addMoistureHigh.setAttribute("placeholder","High Moisture");
    topRow.appendChild(addMoistureHigh);
    var addMoistureLow = document.createElement("input");
    addMoistureLow.setAttribute("id","add-moisture-low");
    addMoistureLow.setAttribute("type","number");
    addMoistureLow.setAttribute("style","width: 13%");
    addMoistureLow.setAttribute("placeholder","Low Moisture");
    topRow.appendChild(addMoistureLow);
    var addLightHigh = document.createElement("input");
    addLightHigh.setAttribute("id","add-light-high");
    addLightHigh.setAttribute("type","number");
    addLightHigh.setAttribute("style","width: 13%");
    addLightHigh.setAttribute("placeholder","High Light");
    topRow.appendChild(addLightHigh);
    var addLightLow = document.createElement("input");
    addLightLow.setAttribute("id","add-light-low");
    addLightLow.setAttribute("type","number");
    addLightLow.setAttribute("style","width: 13%");
    addLightLow.setAttribute("placeholder","Low Light");
    topRow.appendChild(addLightLow);

    var bottomRow = document.createElement("div");
    bottomRow.setAttribute("class","row no-gutters");

    var addDescription = document.createElement("input");
    addDescription.setAttribute("id","add-description");
    addDescription.setAttribute("type","text");
    addDescription.setAttribute("style","width: 100%");
    addDescription.setAttribute("placeholder","Description");
    bottomRow.appendChild(addDescription);

    contentCol.appendChild(topRow);
    contentCol.appendChild(bottomRow);


    var buttonsCol = document.createElement("div");
    buttonsCol.setAttribute("class", "col-md-1 no-gutters");
    
    var addButton = document.createElement("input");
    addButton.setAttribute("id","add-button");
    addButton.setAttribute("onclick","addPlant()");
    addButton.value = "🥵";
    addButton.setAttribute("type","button");
    addButton.setAttribute("style","width: 100%; height: 100%;");
    buttonsCol.appendChild(addButton);

    fullRow.appendChild(pictureCol);
    fullRow.appendChild(contentCol);
    fullRow.appendChild(buttonsCol);

    $("#plant-table").append(fullRow);
}

function addPlant(){
    var plantName = document.getElementById("add-plant-name");
    var idealMoistureHigh = document.getElementById("add-moisture-high");
    var idealMoistureLow = document.getElementById("add-moisture-low");
    var idealLightHigh = document.getElementById("add-light-high");
    var idealLightLow = document.getElementById("add-light-low");
    var idealTempHigh = document.getElementById("add-temp-high");
    var idealTempLow = document.getElementById("add-temp-low");
    var description = document.getElementById("add-description");
    var options = { 
        method: 'POST',
        headers: { 'Content-Type':  'application/json' }, 
        body: JSON.stringify({
            'operation':'add',
            'tableName':'HydroPotPlantTypes',
            'payload':{
                'Item':{
                    'plantName':plantName.value,
                    'idealTempLow':Number(idealTempHigh.value),
                    'idealTempHigh':Number(idealTempLow.value),
                    'idealMoistureLow':Number(idealMoistureLow.value),
                    'idealMoistureHigh':Number(idealMoistureHigh.value),
                    'idealLightLow':Number(idealLightHigh.value),
                    'idealLightHigh':Number(idealLightLow.value),
                    'description':description.value
                }
            }
        })
        
    }
    fetch(API_URL,options) 
    .then(res => res.json())
    .then(data => {
        // There was not an error
        console.log(data);
    })
    .catch((error) => {
        // There was an error
        console.log(error);
    });


    setTimeout(() => {loadPage()},2000); //TODO: Fix this asynchronous, the table is being built before the db is updated
}

function editPlant(id){
    var keyArray = ["plantName","idealTempHigh","idealTempLow","idealMoistureHigh","idealMoistureLow","idealLightHigh","idealLightLow","description"];
    var keyValueStore = {};
    for(var key in keyArray){
        var fieldValue = document.getElementById(`${keyArray[key]}-${id}`).value;
        if(keyArray[key] == "plantName" || keyArray[key] == "description"){
            keyValueStore[keyArray[key]] = fieldValue;
        }else{
            keyValueStore[keyArray[key]] = Number(fieldValue);
        }
    }
    var options = { 
        method: 'POST',
        headers: { 'Content-Type':  'application/json' }, 
        body: JSON.stringify({
            'operation':'edit',
            'tableName':'HydroPotPlantTypes',
            'payload':{
                'Item':{
                    'id':id,
                    'plantName':keyValueStore['plantName'],
                    'idealTempLow':keyValueStore['idealTempLow'],
                    'idealTempHigh':keyValueStore['idealTempHigh'],
                    'idealMoistureLow':keyValueStore['idealMoistureLow'],
                    'idealMoistureHigh':keyValueStore['idealMoistureHigh'],
                    'idealLightLow':keyValueStore['idealLightLow'],
                    'idealLightHigh':keyValueStore['idealLightHigh'],
                    'description':keyValueStore['description']
                }
            }
        })
        
    }
    fetch(API_URL,options) 
    .then(res => res.json())
    .then(data => {
        // There was not an error
        console.log(data);
    })
    .catch((error) => {
        // There was an error
        console.log(error);
    });


    setTimeout(() => {loadPage()},2000); //TODO: Fix this asynchronous, the table is being built before the db is updated
}

function deletePlant(id){
    var options = { 
        method: 'POST',
        headers: { 'Content-Type':  'application/json' }, 
        body: JSON.stringify({
            'operation':'delete',
            'tableName':'HydroPotPlantTypes',
            'payload':{
                'Item':{
                    'id':id
                }
            }
        })
        
    }
    fetch(API_URL,options) 
    .then(res => res.json())
    .then(data => {
        // There was not an error
        console.log(data);
    })
    .catch((error) => {
        // There was an error
        console.log(error);
    });


    setTimeout(() => {loadPage()},2000); //TODO: Fix this asynchronous, the table is being built before the db is updated
}