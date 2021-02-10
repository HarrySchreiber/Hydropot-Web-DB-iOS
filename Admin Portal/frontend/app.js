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

    var keyArray = ["plantType","idealTempHigh","idealTempLow","idealMoistureHigh","idealMoistureLow","idealLightHigh","idealLightLow","description"];
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
        for(key of keyArray){
            var input = document.createElement("input");
            if(key == "plantType"){
                input.setAttribute("type","text");
                input.setAttribute("style","width: 22%;"); //TODO: Dummy Values for percent
                input.setAttribute("id",`${key}-${obj['id']}`);
                input.value = obj[key];
                topRow.appendChild(input);
            }else if(key == "description"){
                input.setAttribute("type","text");
                input.setAttribute("style","width: 100%;"); //TODO: Dummy Values for percent
                input.setAttribute("id",`${key}-${obj['id']}`);
                input.value = obj[key];
                bottomRow.appendChild(input);
            }else{
                input.setAttribute("type", "number");
                input.setAttribute("style","width: 13%;"); //TODO: Dummy Values for percent
                input.setAttribute("id",`${key}-${obj['id']}`);
                input.value = obj[key];
                topRow.appendChild(input);
            }
        }
        contentCol.appendChild(topRow);
        contentCol.appendChild(bottomRow);

        //Buttons Cols
        var saveButton = document.createElement("input");
        saveButton.setAttribute("type","button");
        saveButton.setAttribute("style","width: 50%; height: 100%");
        saveButton.setAttribute("onclick",`confirmActionModal("${obj['id']}","${obj['plantType']}","edit")`);
        saveButton.value = "💾";
        var deleteButton = document.createElement("input");
        deleteButton.setAttribute("type","button");
        deleteButton.setAttribute("style","width: 50%; height: 100%");
        deleteButton.setAttribute("onclick",`confirmActionModal("${obj['id']}","${obj['plantType']}","delete")`);
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

    var addplantType = document.createElement("input");
    addplantType.setAttribute("id","add-plant-name");
    addplantType.setAttribute("type","text");
    addplantType.setAttribute("style","width: 22%");
    addplantType.setAttribute("placeholder","Plant Name");
    topRow.appendChild(addplantType);
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
    var keyValueStore = {}
    keyValueStore["plantType"] = document.getElementById("add-plant-name").value;
    keyValueStore["idealTempHigh"] = document.getElementById("add-temp-high").value;
    keyValueStore["idealTempLow"] = document.getElementById("add-temp-low").value;
    keyValueStore["idealMoistureHigh"] = document.getElementById("add-moisture-high").value;
    keyValueStore["idealMoistureLow"] = document.getElementById("add-moisture-low").value;
    keyValueStore["idealLightHigh"] = document.getElementById("add-light-high").value;
    keyValueStore["idealLightLow"] = document.getElementById("add-light-low").value;
    keyValueStore["description"] = document.getElementById("add-description").value;

    for(var key in keyValueStore){
        if(keyValueStore[key] === ""){
            warningModel("All fields must have values!");
            return
        }
    }

    for(var key in keyValueStore){
        if(!(key == "plantType"||key == "description")){
            if(isNaN(keyValueStore[key])){
                warningModel("All ideals must be numerical");
                return
            }
            keyValueStore[key] = Number(keyValueStore[key]);
        }
    }

    if(keyValueStore["idealTempHigh"] < keyValueStore["idealTempLow"]){
        warningModel("Ideal Temperature High must be greater than Ideal Temperature Low");
        return
    }

    if(keyValueStore["idealMoistureHigh"] < keyValueStore["idealMoistureLow"]){
        warningModel("Ideal Moisture High must be greater than Ideal Moisture Low");
        return
    }

    if(keyValueStore["idealLightHigh"] < keyValueStore["idealLightLow"]){
        warningModel("Ideal Light High must be greater than Ideal Light Low");
        return
    }

    var options = { 
        method: 'POST',
        headers: { 'Content-Type':  'application/json' }, 
        body: JSON.stringify({
            'operation':'add',
            'tableName':'HydroPotPlantTypes',
            'payload':{
                'Item':{
                    'plantType':keyValueStore["plantType"],
                    'idealTempLow':keyValueStore["idealTempHigh"],
                    'idealTempHigh':keyValueStore["idealTempLow"],
                    'idealMoistureLow':keyValueStore["idealMoistureLow"],
                    'idealMoistureHigh':keyValueStore["idealMoistureHigh"],
                    'idealLightLow':keyValueStore["idealLightHigh"],
                    'idealLightHigh':keyValueStore["idealLightLow"],
                    'description':keyValueStore["description"]
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
    var keyArray = ["plantType","idealTempHigh","idealTempLow","idealMoistureHigh","idealMoistureLow","idealLightHigh","idealLightLow","description"];
    var keyValueStore = {};
    for(key of keyArray){
        var fieldValue = document.getElementById(`${key}-${id}`).value;
        if(key == "plantType" || key == "description"){
            keyValueStore[key] = fieldValue;
        }else{
            keyValueStore[key] = Number(fieldValue);
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
                    'plantType':keyValueStore['plantType'],
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
    cleanModel();
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

function confirmActionModal(id, plantType, action){
    console.log(action == "delete");
    var modal = document.createElement("div");
    modal.setAttribute("class","modal");
    modal.setAttribute("id","confirmActionModal");
    modal.setAttribute("data-backdrop","static");

    var modalDialog = document.createElement("div");
    modalDialog.setAttribute("class","modal-dialog");

    var modalContent = document.createElement("div");
    modalContent.setAttribute("class","modal-content");

    var modalHeader = document.createElement("div");
    modalHeader.setAttribute("class","modal-header");

    var modalTitle = document.createElement("div");
    modalTitle.setAttribute("class","h5");

    if(action == "delete"){
        modalTitle.textContent = "Confirm Delete?";
    }else if (action == "edit"){
        modalTitle.textContent = "Confirm Edit?";
    }
    

    var closeButton = document.createElement("button");
    closeButton.setAttribute("type","button");
    closeButton.setAttribute("class","close");
    closeButton.setAttribute("onclick","cleanModel()");
    closeButton.setAttribute("data-dismiss","modal");
    closeButton.setAttribute("aria-label","Close");

    var hidden = document.createElement("span");
    hidden.setAttribute("aria-hidden","true");
    hidden.append("X");
    closeButton.appendChild(hidden);

    var modalBody = document.createElement("div");
    modalBody.setAttribute("class","modal-body");
    var message = document.createElement("p");
    if(action == "delete"){
        message.append("Deleting ");
        var boldSection = document.createElement("b");
        boldSection.append(plantType);
        message.append(boldSection);
        message.append(" will permenantly remove it from the database, are you sure?");
    }else if(action == "edit"){
        message.append("Editing ");
        var boldSection = document.createElement("b");
        boldSection.append(plantType);
        message.append(boldSection);
        message.append(" will permenantly change it's values in the database, are you sure?");
    }
    modalBody.appendChild(message);

    var modalFooter = document.createElement("div");
    modalFooter.setAttribute("class","modal-footer");
    var cancelButton = document.createElement("div");
    cancelButton.setAttribute("type","button");
    cancelButton.setAttribute("class","btn btn-secondary");
    cancelButton.setAttribute("data-dismiss","modal");
    cancelButton.setAttribute("onclick","cleanModel()");
    cancelButton.append("Cancel");
    var actionButton = document.createElement("div");
    actionButton.setAttribute("type","button");
    if(action == "delete"){
        actionButton.setAttribute("class","btn btn-danger");
        actionButton.setAttribute("data-dismiss","modal");
        actionButton.setAttribute("onclick",`deletePlant("${id}")`);
        actionButton.append("Delete");
    }else if(action == "edit"){
        actionButton.setAttribute("class","btn btn-primary");
        actionButton.setAttribute("data-dismiss","modal");
        actionButton.setAttribute("onclick",`editPlant("${id}")`);
        actionButton.append("Save Changes");
    }
    modalFooter.appendChild(cancelButton);
    modalFooter.appendChild(actionButton);

    modalHeader.appendChild(modalTitle);
    modalHeader.appendChild(closeButton);
    modalContent.appendChild(modalHeader);
    modalContent.appendChild(modalBody);
    modalContent.appendChild(modalFooter);
    modalDialog.appendChild(modalContent);
    modal.appendChild(modalDialog);

    $(document.body).append(modal);
    $("#confirmActionModal").modal();
}

function warningModel(warningMessage){
    var modal = document.createElement("div");
    modal.setAttribute("class","modal");
    modal.setAttribute("id","warningModel");
    modal.setAttribute("data-backdrop","static");

    var modalDialog = document.createElement("div");
    modalDialog.setAttribute("class","modal-dialog");

    var modalContent = document.createElement("div");
    modalContent.setAttribute("class","modal-content");

    var modalHeader = document.createElement("div");
    modalHeader.setAttribute("class","modal-header");

    var modalTitle = document.createElement("div");
    modalTitle.setAttribute("class","h5");
    modalTitle.textContent = "ERROR";
    

    var closeButton = document.createElement("button");
    closeButton.setAttribute("type","button");
    closeButton.setAttribute("class","close");
    closeButton.setAttribute("data-dismiss","modal");
    closeButton.setAttribute("aria-label","Close");
    closeButton.setAttribute("onclick","cleanModel()");

    var hidden = document.createElement("span");
    hidden.setAttribute("aria-hidden","true");
    hidden.append("X");
    closeButton.appendChild(hidden);

    var modalBody = document.createElement("div");
    modalBody.setAttribute("class","modal-body");
    var message = document.createElement("p");
    message.append(warningMessage)
    modalBody.appendChild(message);

    var modalFooter = document.createElement("div");
    modalFooter.setAttribute("class","modal-footer");
    var cancelButton = document.createElement("div");
    cancelButton.setAttribute("type","button");
    cancelButton.setAttribute("class","btn btn-primary");
    cancelButton.setAttribute("data-dismiss","modal");
    cancelButton.setAttribute("onclick","cleanModel()");
    cancelButton.append("Close");
    modalFooter.appendChild(cancelButton);

    modalHeader.appendChild(modalTitle);
    modalHeader.appendChild(closeButton);
    modalContent.appendChild(modalHeader);
    modalContent.appendChild(modalBody);
    modalContent.appendChild(modalFooter);
    modalDialog.appendChild(modalContent);
    modal.appendChild(modalDialog);

    $(document.body).append(modal);
    $("#warningModel").modal();
}

function cleanModel(){
    $("#confirmActionModal").remove();
    $("#warningModel").remove();
    $(".modal-backdrop").remove();
}