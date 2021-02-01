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
        //Declare the json object
        var obj = data[i];
        //Declare Columns and rows
        var fullRow = document.createElement("div");
        fullRow.setAttribute("class","row no-gutters");
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
            if(keyArray[key] == "name"){
                input.setAttribute("type","text");
                input.setAttribute("style","width: 22%;"); //TODO: Dummy Values for percent
                input.value = obj[keyArray[key]];
                topRow.appendChild(input);
            }else if(keyArray[key] == "description"){
                input.setAttribute("type","text");
                input.setAttribute("style","width: 100%;"); //TODO: Dummy Values for percent
                input.value = obj[keyArray[key]];
                bottomRow.appendChild(input);
            }else{
                input.setAttribute("type", "number");
                input.setAttribute("style","width: 13%;"); //TODO: Dummy Values for percent
                input.value = obj[keyArray[key]];
                topRow.appendChild(input);
            }
        }
        contentCol.appendChild(topRow);
        contentCol.appendChild(bottomRow);

        //TODO: Buttons Cols
        var saveButton = document.createElement("input");
        saveButton.setAttribute("type","button");
        saveButton.setAttribute("style","width: 50%; height: 100%");
        saveButton.value = "S";
        saveButton.id = "save-button-" + i;
        var deleteButton = document.createElement("input");
        deleteButton.setAttribute("type","button");
        deleteButton.setAttribute("style","width: 50%; height: 100%");
        deleteButton.value = "D";
        deleteButton.id = "delete-button-" + i;
        buttonsCol.appendChild(saveButton);
        buttonsCol.appendChild(deleteButton);

        fullRow.appendChild(pictureCol);
        fullRow.appendChild(contentCol);
        fullRow.appendChild(buttonsCol);

        $("#plant-table").append(fullRow);
    }
}