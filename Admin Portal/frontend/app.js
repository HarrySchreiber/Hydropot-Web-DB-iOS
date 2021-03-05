// Lambda API URL
var API_URL = 'https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/web';

var plantTypesLocal = {};


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

function postToLambda(content, actionFunction){
    var options = { 
        method: 'POST',
        headers: { 'Content-Type':  'application/json' }, 
        body: content
        
    }
    fetch(API_URL,options) 
    .then(res => res.json())
    .then(data => {
        // There was not an error
        actionFunction(data);
    })
    .catch((error) => {
        // There was an error
        console.log(error);
    });

}

function packageData(data){
    var plantTypes = {}
    for(var i = 0; i < data.length; i++){
        var obj = data[i];
        var plantData = {};

        plantData["plantType"] = obj.plantType;
        plantData["idealTempHigh"] = Number(obj.idealTempHigh);
        plantData["idealTempLow"] = Number(obj.idealTempLow);
        plantData["idealMoistureHigh"] = Number(obj.idealMoistureHigh);
        plantData["idealMoistureLow"] = Number(obj.idealMoistureLow);
        plantData["idealLightHigh"] = Number(obj.idealLightHigh);
        plantData["idealLightLow"] = Number(obj.idealLightLow);
        plantData["description"] = obj.description;
        plantData["imageURL"] = obj.imageURL;
        plantData["display"] = "flex";


        plantTypes[obj.id] = plantData;
    }
    return plantTypes;
}

function loadPage(){
    postToLambda(JSON.stringify({
        'operation':'getAll',
        'tableName':'HydroPotPlantTypes'
    }),
    function(data){
        buildHeaderBar();
        buildSearchField();
        buildInputFields();
        plantTypesLocal = packageData(data['Items']);
        buildTable(plantTypesLocal);
    });
}

function authenticateUser(){
    var email = document.getElementById("email");
    var password = document.getElementById("password");

    postToLambda(JSON.stringify({
        'operation':'login',
        'tableName':'HydroPotPlantTypes',
        'payload':{
            'Item':{
                'email':email.value,
                'password':password.value
            }
        }
    }),
    function(data){
        if(data['Count'] === 1){
            $("#login").remove();
            loadPage();
        }else{
            warningModal("No account registered with those credentials");
        }
    });
}

function buildField(fieldId, fieldType, fieldWidthPercentage, fieldPlaceHolder, content){

    var div = document.createElement("div");
    div.setAttribute("class","fields no-gutters");
    div.setAttribute("style",`width: ${fieldWidthPercentage}%`);
    var field = document.createElement("input");
    field.setAttribute("id",fieldId);
    field.setAttribute("type",fieldType);
    field.setAttribute("class","form-control");
    field.setAttribute("placeholder", fieldPlaceHolder);
    field.value = content;
    div.appendChild(field);
    return div;
}

function buildTable(data){
    $("#plant-table").empty();
    for(var id in data){
        //Declare the json object
        var obj = data[id];
        //Declare Columns and rows
        var fullRow = document.createElement("div");
        fullRow.setAttribute("class","row no-gutters plant-type-row");
        fullRow.setAttribute("id",id);
        fullRow.setAttribute("style", `display:${obj.display}`);
        var pictureCol = document.createElement("div");
        pictureCol.setAttribute("class", "col-md-1 no-gutters parent");
        pictureCol.setAttribute("style","position: relative; top:0; left:0;");
        var contentCol = document.createElement("div");
        contentCol.setAttribute("class", "col-md-10 no-gutters");
        var buttonsCol = document.createElement("div");
        buttonsCol.setAttribute("class", "col-md-1 no-gutters");

        //TODO: Image Code
        var image = document.createElement("img");
        image.setAttribute("id",`image-output-${id}`);
        image.setAttribute("src",obj['imageURL']);
        image.setAttribute("savedURL",obj['imageURL']);
        image.setAttribute("alt",`Picture of ${obj['plantType']}`);
        image.setAttribute("style","position: relative; top:0; left:0; width:75px; height:75px;");
        
        var imageUploadDialogue = document.createElement("input");
        imageUploadDialogue.setAttribute("type","file");
        imageUploadDialogue.setAttribute("id",`image-button-${id}`);
        imageUploadDialogue.setAttribute("onchange",`displayCurrentImage('image-button-${id}','image-output-${id}')`);
        imageUploadDialogue.setAttribute("style","display:none");
        imageUploadDialogue.setAttribute("accept","image/*");
        
        var imageOverlay = document.createElement("img");
        imageOverlay.setAttribute("id",`image-overlay-${id}`);
        imageOverlay.setAttribute("src","https://s3.us-east-2.amazonaws.com/hydropot.com/imageUploadOverlay.png");
        imageOverlay.setAttribute("alt","image overlay");
        imageOverlay.setAttribute("onclick",`document.getElementById('image-button-${id}').click()`);
        imageOverlay.setAttribute("style","position: absolute; top: 0; left: 0; width: 75px; height: 75px; cursor:pointer;");

        
        pictureCol.appendChild(image);
        pictureCol.appendChild(imageOverlay);
        pictureCol.appendChild(imageUploadDialogue);

        //Content Code
        var topRow = document.createElement("div");
        topRow.setAttribute("class","row no-gutters top-row");
        var bottomRow = document.createElement("div");
        bottomRow.setAttribute("class","row no-gutters bottom-row");
        for(var key in obj){
            if(key != "imageURL" && key != "display"){
                if(key == "plantType"){
                    var input = buildField(`${key}-${id}`,"text",22,"",obj[key]);
                    topRow.appendChild(input);
                }else if(key == "description"){
                    var input = buildField(`${key}-${id}`,"text",100,"",obj[key]);
                    bottomRow.appendChild(input);
                }else{
                    var input = buildField(`${key}-${id}`,"number",13,"",obj[key]);
                    topRow.appendChild(input);
                }
            }
        }
        contentCol.appendChild(topRow);
        contentCol.appendChild(bottomRow);

        //Buttons Cols
        var saveButton = document.createElement("input");
        saveButton.setAttribute("type","button");
        saveButton.setAttribute("style","width: 50%; height: 100%");
        saveButton.setAttribute("onclick",`confirmActionModal("${id}","${obj['imageURL']}","${obj['plantType']}","edit")`);
        saveButton.value = "💾";
        var deleteButton = document.createElement("input");
        deleteButton.setAttribute("type","button");
        deleteButton.setAttribute("style","width: 50%; height: 100%");
        deleteButton.setAttribute("onclick",`confirmActionModal("${id}","${obj['imageURL']}","${obj['plantType']}","delete")`);
        deleteButton.value = "🗑";
        buttonsCol.appendChild(saveButton);
        buttonsCol.appendChild(deleteButton);

        fullRow.appendChild(pictureCol);
        fullRow.appendChild(contentCol);
        fullRow.appendChild(buttonsCol);

        $("#plant-table").append(fullRow);
        
    }
}

function buildHeaderBar(){
    $("#header-field").empty();
    var fullRow = document.createElement("div");
    fullRow.setAttribute("class","row no-gutters");

    var titleCol = document.createElement("div");
    titleCol.setAttribute("class","col-md-11 no-gutters");
    var heading = document.createElement("h2");
    heading.textContent = "Hydro Pot Admin Portal";
    titleCol.appendChild(heading);

    var logOutCol = document.createElement("div");
    logOutCol.setAttribute("class","col-md-1 no-gutters");
    var logOutButton = document.createElement("input");
    logOutButton.setAttribute("class","form-control btn btn-primary");
    logOutButton.setAttribute("type","button");
    logOutButton.value = "Log Out";
    logOutButton.setAttribute("onclick","logout()");
    logOutCol.appendChild(logOutButton);

    fullRow.appendChild(titleCol);
    fullRow.appendChild(logOutCol);

    $("#header-field").append(fullRow);
}

function buildSearchField(){
    $("#search-field").empty();
    var fullRow = document.createElement("div");
    fullRow.setAttribute("class","row no-gutters");

    var searchBar = document.createElement("input");
    searchBar.setAttribute("class","form-control")
    searchBar.setAttribute("type","text");
    searchBar.setAttribute("placeholder","Search");
    searchBar.setAttribute("id","search-bar-input");
    searchBar.setAttribute("style","width: 100%;");
    searchBar.addEventListener("keyup", function(){
        runSearchQuery();
    });

    fullRow.appendChild(searchBar);

    $("#search-field").append(fullRow);
}

function buildInputFields(){
    $("#input-fields").empty();
    var fullRow = document.createElement("div");
    fullRow.setAttribute("class","row no-gutters input-fields-row");


    var pictureCol = document.createElement("div");
    pictureCol.setAttribute("class", "col-md-1 no-gutters");
    
    var addImageOutput = document.createElement("img");
    addImageOutput.setAttribute("id","add-image-output");
    addImageOutput.setAttribute("width","75px");
    addImageOutput.setAttribute("height","75px");
    pictureCol.appendChild(addImageOutput);

    var addImageButton = document.createElement("input");
    addImageButton.setAttribute("type","file");
    addImageButton.setAttribute("id","addImageButton");
    addImageButton.setAttribute("onchange","displayCurrentImage('addImageButton','add-image-output')");
    addImageButton.setAttribute("style","display:none");
    addImageButton.setAttribute("accept","image/*");
    pictureCol.appendChild(addImageButton);

    var imageOverlay = document.createElement("img");
    imageOverlay.setAttribute("src","https://s3.us-east-2.amazonaws.com/hydropot.com/imageUploadOverlay.png");
    imageOverlay.setAttribute("alt","image overlay");
    imageOverlay.setAttribute("id","add-image-overlay");
    imageOverlay.setAttribute("style","position: absolute; top: 0; left: 0; cursor:pointer; height: 75px; width:75px;");
    imageOverlay.setAttribute("onclick","document.getElementById('addImageButton').click()");
    pictureCol.appendChild(imageOverlay);

    var contentCol = document.createElement("div");
    contentCol.setAttribute("class", "col-md-10 no-gutters");

    var topRow = document.createElement("div");
    topRow.setAttribute("class","row no-gutters");

    topRow.appendChild(buildField("add-plantType","text",22,"Plant Name",""));
    topRow.appendChild(buildField("add-idealTempHigh","number",13,"High Temp",""));
    topRow.appendChild(buildField("add-idealTempLow","number",13,"Low Temp"));
    topRow.appendChild(buildField("add-idealMoistureHigh","number",13,"High Moisture",""));
    topRow.appendChild(buildField("add-idealMoistureLow","number",13,"Low Moisture",""));
    topRow.appendChild(buildField("add-idealLightHigh","number",13,"High Light",""));
    topRow.appendChild(buildField("add-idealLightLow","number",13,"Low Light",""));

    var bottomRow = document.createElement("div");
    bottomRow.setAttribute("class","row no-gutters");

    bottomRow.appendChild(buildField("add-description","text",100,"Description",""));

    contentCol.appendChild(topRow);
    contentCol.appendChild(bottomRow);


    var buttonsCol = document.createElement("div");
    buttonsCol.setAttribute("class", "col-md-1 no-gutters");
    
    var addButton = document.createElement("input");
    addButton.setAttribute("id","add-button");
    addButton.setAttribute("onclick",`imageUpload('','add','addImageButton')`);
    addButton.value = "➕";
    addButton.setAttribute("type","button");
    addButton.setAttribute("style","width: 100%; height: 100%;");
    buttonsCol.appendChild(addButton);

    fullRow.appendChild(pictureCol);
    fullRow.appendChild(contentCol);
    fullRow.appendChild(buttonsCol);

    $("#input-fields").append(fullRow);
}

function addPlant(imageURL, keyValueStore){
    postToLambda(JSON.stringify({
        'operation':'add',
        'tableName':'HydroPotPlantTypes',
        'payload':{
            'Item':{
                'plantType':keyValueStore["plantType"],
                'idealTempHigh':keyValueStore["idealTempHigh"],
                'idealTempLow':keyValueStore["idealTempLow"],
                'idealMoistureHigh':keyValueStore["idealMoistureHigh"],
                'idealMoistureLow':keyValueStore["idealMoistureLow"],
                'idealLightHigh':keyValueStore["idealLightHigh"],
                'idealLightLow':keyValueStore["idealLightLow"],
                'description':keyValueStore["description"],
                'imageURL':imageURL
            }
        }
    }),
    function(data){
        loadPage();
    });
}

function editPlant(id,imageURL, savedOldURL = "", keyValueStore){
    cleanModal();

    var oldImageKey;
    if(savedOldURL === ""){
        oldImageKey = savedOldURL;
    }else{
        oldImageKey = savedOldURL.split("/");
        oldImageKey = oldImageKey[oldImageKey.length-1];
    }

    postToLambda(JSON.stringify({
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
                'description':keyValueStore['description'],
                'imageURL':imageURL,
                'oldImageKey':oldImageKey
            }
        }
    }),
    function(data){
        loadPage();
    });
}


//TODO: Add url here so that we can ge the key to delete in s3
function deletePlant(id,imageUrl){
    cleanModal();
    var imageKey = imageUrl.split("/");
    imageKey = imageKey[imageKey.length-1];

    postToLambda(JSON.stringify({
        'operation':'delete',
        'tableName':'HydroPotPlantTypes',
        'payload':{
            'Item':{
                'id':id,
                'imageKey':imageKey
            }
        }
    }),
    function(data){
        loadPage();
    });
}

function confirmActionModal(id, imageUrl, plantType, action){
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
    closeButton.setAttribute("onclick","cleanModal()");
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
    cancelButton.setAttribute("onclick","cleanModal()");
    cancelButton.append("Cancel");
    var actionButton = document.createElement("div");
    actionButton.setAttribute("type","button");
    if(action == "delete"){
        actionButton.setAttribute("class","btn btn-danger");
        actionButton.setAttribute("data-dismiss","modal");
        actionButton.setAttribute("onclick",`deletePlant("${id}","${imageUrl}")`);
        actionButton.append("Delete");
    }else if(action == "edit"){
        actionButton.setAttribute("class","btn btn-primary");
        actionButton.setAttribute("data-dismiss","modal");
        actionButton.setAttribute("onclick",`imageUpload("${id}","edit","image-button-${id}")`);
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

function warningModal(warningMessage){
    var modal = document.createElement("div");
    modal.setAttribute("class","modal");
    modal.setAttribute("id","warningModal");
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
    closeButton.setAttribute("onclick","cleanModal()");

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
    cancelButton.setAttribute("onclick","cleanModal()");
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
    $("#warningModal").modal();
}

function cleanModal(){
    $("#confirmActionModal").remove();
    $("#warningModal").remove();
    $(".modal-backdrop").remove();
    $(document.body).removeClass("modal-open");
}

/**
 * Displays the add image in the html
 */
function displayCurrentImage(fileUploadId, imageOutputId){
    var image = document.getElementById(fileUploadId);
    var reader = new FileReader();
    reader.onload = function(){
      var output = document.getElementById(imageOutputId);
      output.src = reader.result;
    };
    reader.readAsDataURL(image.files[0]);
    
}

function imageUpload(id,action,fileDialogueId){
    //This bit is just so we can delete things from S3, side effect we can use it to edit if need be
    var savedOldURL;
    if(action === "edit"){
        savedOldURL = $(`#image-output-${id}`).attr('savedURL');
    }

    var keyArray = ["plantType","idealTempHigh","idealTempLow","idealMoistureHigh","idealMoistureLow","idealLightHigh","idealLightLow","description"];
    var keyValueStore = {};
    if(action === "add"){
        for(key of keyArray){
            var fieldValue = document.getElementById(`add-${key}`).value;
            keyValueStore[key] = fieldValue;
        }
    }else if(action === "edit"){
        for(key of keyArray){
            var fieldValue = document.getElementById(`${key}-${id}`).value;
            keyValueStore[key] = fieldValue;
        }
    }

    var image = document.getElementById(fileDialogueId);
    if(image.files.length === 0){
        if(action === "add"){
            warningModal("You cannot add a plant without a picture.");
            return
        }else if(action === "edit"){
            if(validateFieldInput(keyValueStore)){
                for(var key in keyValueStore){
                    if(!(key == "plantType"||key == "description")){
                        keyValueStore[key] = Number(keyValueStore[key]);
                    }
                }
                editPlant(id, savedOldURL,"", keyValueStore);
            }
            return
        }
    }
    var reader = new FileReader();
    reader.onload = function(){
        var fileExtension = reader.result.split(":",2)[1].split("/",2)[1].split(";")[0];
        var encodedImage = reader.result.split(",",2)[1];

        if(validateFieldInput(keyValueStore)){
            for(var key in keyValueStore){
                if(!(key == "plantType"||key == "description")){
                    keyValueStore[key] = Number(keyValueStore[key]);
                }
            }
            postToLambda(JSON.stringify({
                'operation':'imageUpload',
                'tableName':'HydroPotPlantTypes',
                'payload':{
                    'Item':{
                        'encodedImage':encodedImage,
                        'fileExtension':fileExtension
                    }
                }
            }),
            function(data){
                if(action === "add"){
                    addPlant(data, keyValueStore);
                }else if(action === "edit"){
                    editPlant(id,data, savedOldURL, keyValueStore);
                }
            });
        }
    };

    reader.readAsDataURL(image.files[0]);
}

function runSearchQuery(){
    var searchQuerry = document.getElementById("search-bar-input").value.toLowerCase();

    for(var key in plantTypesLocal){
        var obj = plantTypesLocal[key];
        if(obj.plantType.toLowerCase().includes(searchQuerry)){
            obj.display = "flex";
        }else{
            obj.display = "none";
        }
    }

    buildTable(plantTypesLocal);
}

function logout(){
    location.reload(); //TODO this needs to be a real method
}

function validateFieldInput(keyValueStore){

    for(var key in keyValueStore){
        if(keyValueStore[key] === ""){
            warningModal("All fields must have values!");
            return false
        }
    }

    for(var key in keyValueStore){
        if(!(key == "plantType"||key == "description")){
            if(isNaN(keyValueStore[key])){
                warningModal("All ideals must be numerical");
                return false
            }
        }
    }

    for(var key in keyValueStore){
        if(!(key == "plantType"||key == "description")){
            keyValueStore[key] = Number(keyValueStore[key]);
        }
    }

    console.log(keyValueStore);
    if(keyValueStore["idealTempHigh"] <= keyValueStore["idealTempLow"]){
        warningModal("Ideal Temperature High must be greater than Ideal Temperature Low");
        return false
    }

    if(keyValueStore["idealMoistureHigh"] < 0 || keyValueStore["idealMoistureHigh"] > 100){
        warningModal("Ideal Moisture High must be within a 0-100 range");
        return false
    }

    if(keyValueStore["idealMoistureLow"] < 0 || keyValueStore["idealMoistureLow"] > 100){
        warningModal("Ideal Moisture Low must be within a 0-100 range");
        return false
    }

    if(keyValueStore["idealMoistureHigh"] <= keyValueStore["idealMoistureLow"]){
        warningModal("Ideal Moisture High must be greater than Ideal Moisture Low");
        return false
    }

    if(keyValueStore["idealLightHigh"] < 0){
        warningModal("Ideal Light High must not be below 0");
        return false
    }

    if(keyValueStore["idealLightLow"] < 0){
        warningModal("Ideal Light Low must not be below 0");
        return false
    }

    if(keyValueStore["idealLightHigh"] <= keyValueStore["idealLightLow"]){
        warningModal("Ideal Light High must be greater than Ideal Light Low");
        return false
    }
    
    return true;
}