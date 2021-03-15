// Lambda API URL
var API_URL = 'https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/web';

var plantTypesLocal = {};

/**
 * Sends objects Json objects to the AWS lambda and performs the action function on a successful post
 * @param {JSON} content                a json object of fields needed to be sent to the lambda
 * @param {function} actionFunction     a function to manipulate or use the data returned from the lambda
 */
function postToLambda(content, actionFunction){
    var options = { 
        method: 'POST',
        headers: { 'Content-Type':  'application/json' }, 
        body: content
        
    }
    fetch(API_URL,options) 
    .then(res => res.json())
    .then(data => {
        // There was not an error, perform action
        actionFunction(data);
    })
    .catch((error) => {
        // There was an error
        console.log(error);
    });

}

/**
 * Packages the raw json data from the lambda to a well formated javascript object to manipulate the data
 * @param {json} data   a json of all of the plants and their fields
 * @returns             object containing cleaned plant data and other metadata 
 */
function packageData(data){
    var plantTypes = {}
    //Loop through all the plants
    for(var i = 0; i < data.length; i++){
        var obj = data[i];
        var plantData = {};

        //Grab each value
        plantData["plantType"] = obj.plantType;
        plantData["idealTempHigh"] = Number(obj.idealTempHigh);
        plantData["idealTempLow"] = Number(obj.idealTempLow);
        plantData["idealMoistureHigh"] = Number(obj.idealMoistureHigh);
        plantData["idealMoistureLow"] = Number(obj.idealMoistureLow);
        plantData["idealLightHigh"] = Number(obj.idealLightHigh);
        plantData["idealLightLow"] = Number(obj.idealLightLow);
        plantData["description"] = obj.description;
        plantData["imageURL"] = obj.imageURL;
        plantData["display"] = "flex";  //This is for setting the display on a search


        plantTypes[obj.id] = plantData; //Add to the javascript object
    }
    return plantTypes;
}

/**
 * Grabs the plants from the database and reloads the page with the current plants
 */
function loadPage(){
    postToLambda(JSON.stringify({
        'operation':'getAll',
        'userID': checkCookie(),
        'tableName':'HydroPotPlantTypes'
    }),
    function(data){
        buildHeaderBar();
        buildSearchField();
        buildInputFields();
        plantTypesLocal = packageData(data['Items']);   //Set plantTypes array to current data
        buildTable(plantTypesLocal);
    });
}

/**
 * Checks to see if a user is in the DB and if grants them access given the correct credentials
 */
function authenticateUser(){
    var email = document.getElementById("email");
    var password = document.getElementById("password");

    postToLambda(JSON.stringify({
        'operation':'login',
        'userID':'',
        'tableName':'HydroPotPlantTypes',
        'payload':{
            'Item':{
                'email':email.value,
                'password':password.value
            }
        }
    }),
    function(data){
        try{
            var id = data["Items"][0]["id"];    //Grabs the user id
            setCached("userID",id);             //Sets a cookie for the user id
            $("#login").remove();               //Removes html for the login
            loadPage();
        }catch(err){
            warningModal("No account registered with those credentials");
        }
    });
}

/**
 * Creates input fields for user input
 * @param {string} fieldId                  the html id of the field
 * @param {string} fieldType                the input type of the field
 * @param {number} fieldWidthPercentage     the percentage of the screen the field will take up
 * @param {string} fieldPlaceHolder         the placeholder text for the field
 * @param {string} content                  the actual content in the field
 * @returns                                 an html div enclosing a field
 */
function buildField(fieldId, fieldType, fieldWidthPercentage, fieldPlaceHolder, content){
    var div = document.createElement("div");
    div.setAttribute("class","fields no-gutters");
    div.setAttribute("style",`width: ${fieldWidthPercentage}%`);    //TODO: Update this with bootstrap probably
    var field = document.createElement("input");
    field.setAttribute("id",fieldId);
    field.setAttribute("type",fieldType);
    field.setAttribute("class","form-control");
    field.setAttribute("placeholder", fieldPlaceHolder);
    field.value = content;
    div.appendChild(field);
    return div;
}

/**
 * Populates and builds the table of plants
 * @param {JSON} data   object containing all of the plant information and metadata needed for building the table
 */
function buildTable(data){
    $("#plant-table").empty();  //Clears the old plant table
    for(var id in data){
        //Declare the current json object
        var obj = data[id];
        //Declare Columns and Rows divs
        var fullRow = document.createElement("div");
        fullRow.setAttribute("class","row no-gutters plant-type-row");
        fullRow.setAttribute("id",id);
        fullRow.setAttribute("style", `display:${obj.display}`);    //Set the display view attribute
        var pictureCol = document.createElement("div");
        pictureCol.setAttribute("class", "col-md-1 no-gutters parent");
        pictureCol.setAttribute("style","position: relative; top:0; left:0;");
        var contentCol = document.createElement("div");
        contentCol.setAttribute("class", "col-md-10 no-gutters");
        var buttonsCol = document.createElement("div");
        buttonsCol.setAttribute("class", "col-md-1 no-gutters");

        //Actual Image Code
        var image = document.createElement("img");
        image.setAttribute("id",`image-output-${id}`);
        image.setAttribute("src",obj['imageURL']);  //Set the image source from S3
        image.setAttribute("savedURL",obj['imageURL']);
        image.setAttribute("alt",`Picture of ${obj['plantType']}`);
        image.setAttribute("style","position: relative; top:0; left:0; width:75px; height:75px;");  //Set the width and height of the picture to display
        
        //Input dialogue for file upload (overlays on the image)
        var imageUploadDialogue = document.createElement("input");
        imageUploadDialogue.setAttribute("type","file");
        imageUploadDialogue.setAttribute("id",`image-button-${id}`);
        imageUploadDialogue.setAttribute("onchange",`displayCurrentImage('image-button-${id}','image-output-${id}')`);
        imageUploadDialogue.setAttribute("style","display:none");
        imageUploadDialogue.setAttribute("accept","image/*");   //Only accept image files
        
        //Overlay image over the S3 Image
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
        //Save the edited information 
        var saveButton = document.createElement("input");
        saveButton.setAttribute("type","button");
        saveButton.setAttribute("style","width: 50%; height: 100%");
        saveButton.setAttribute("onclick",`confirmActionModal("${id}","${obj['imageURL']}","${obj['plantType']}","edit")`);
        saveButton.value = "💾";    //TODO: Probably replace the emoji with a picture at some point
        //Delete the plant from the DB
        var deleteButton = document.createElement("input");
        deleteButton.setAttribute("type","button");
        deleteButton.setAttribute("style","width: 50%; height: 100%");
        deleteButton.setAttribute("onclick",`confirmActionModal("${id}","${obj['imageURL']}","${obj['plantType']}","delete")`);
        deleteButton.value = "🗑";  //TODO: Probably replace the emoji with a picture at some point
        buttonsCol.appendChild(saveButton);
        buttonsCol.appendChild(deleteButton);

        fullRow.appendChild(pictureCol);
        fullRow.appendChild(contentCol);
        fullRow.appendChild(buttonsCol);

        $("#plant-table").append(fullRow);
        
    }
}

/**
 * Creates and adds the header bar fields to the page
 */
function buildHeaderBar(){
    $("#header-field").empty(); //Clears the header field
    var fullRow = document.createElement("div");
    fullRow.setAttribute("class","row no-gutters");

    //Adds the hydropot admin title
    var titleCol = document.createElement("div");
    titleCol.setAttribute("class","col-md-11 no-gutters");
    var heading = document.createElement("h2");
    heading.textContent = "Hydro Pot Admin Portal";
    titleCol.appendChild(heading);

    //Provides a button to logout of the admin portal
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

/**
 * Builds the section of the site for searching
 */
function buildSearchField(){
    $("#search-field").empty(); //Removes the old search bar
    var fullRow = document.createElement("div");
    fullRow.setAttribute("class","row no-gutters");

    //Adds the search bar
    var searchBar = document.createElement("input");
    searchBar.setAttribute("class","form-control")
    searchBar.setAttribute("type","text");
    searchBar.setAttribute("placeholder","Search");
    searchBar.setAttribute("id","search-bar-input");
    searchBar.setAttribute("style","width: 100%;");
    //Runs the search query for each keyup
    searchBar.addEventListener("keyup", function(){
        runSearchQuery();
    });

    fullRow.appendChild(searchBar);

    $("#search-field").append(fullRow);
}

/**
 * Builds the input fields for adding a new plant to the DB
 */
function buildInputFields(){
    $("#input-fields").empty(); //Clears the old input fields
    var fullRow = document.createElement("div");
    fullRow.setAttribute("class","row no-gutters input-fields-row");


    var pictureCol = document.createElement("div");
    pictureCol.setAttribute("class", "col-md-1 no-gutters");
    
    //Empty image to be filled when the user selects an image
    var addImageOutput = document.createElement("img");
    addImageOutput.setAttribute("id","add-image-output");
    addImageOutput.setAttribute("width","75px");
    addImageOutput.setAttribute("height","75px");
    pictureCol.appendChild(addImageOutput);

    //File input overlayed on the image
    var addImageButton = document.createElement("input");
    addImageButton.setAttribute("type","file");
    addImageButton.setAttribute("id","addImageButton");
    addImageButton.setAttribute("onchange","displayCurrentImage('addImageButton','add-image-output')");
    addImageButton.setAttribute("style","display:none");
    addImageButton.setAttribute("accept","image/*");
    pictureCol.appendChild(addImageButton);

    //Image overlay for styling
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

    //Create and add the fields to the row
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
    
    //Button for adding a plant to the db
    var addButton = document.createElement("input");
    addButton.setAttribute("id","add-button");
    addButton.setAttribute("onclick",`prepForDB('','add','addImageButton')`);
    addButton.value = "➕"; //TODO: Probably replace emojis with images at some point
    addButton.setAttribute("type","button");
    addButton.setAttribute("style","width: 100%; height: 100%;");
    buttonsCol.appendChild(addButton);

    fullRow.appendChild(pictureCol);
    fullRow.appendChild(contentCol);
    fullRow.appendChild(buttonsCol);

    $("#input-fields").append(fullRow);
}

/**
 * Adds a plant to the database
 * @param {string} imageURL         the url of the image from the S3 bucket that has already been generted
 * @param {object} keyValueStore    information about the plant
 */
function addPlant(imageURL, keyValueStore){
    postToLambda(JSON.stringify({
        'operation':'add',
        'userID': checkCookie(),
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
        //Reloads the page
        loadPage();
    });
}

/**
 * Edits a plant in the db
 * @param {string} id               id of the plant to edit
 * @param {string} imageURL         new image url for the plant from the S3 bucket
 * @param {string} savedOldURL      old image url for the plant from the S3 bucket if the old image needs to be deleted
 * @param {object} keyValueStore    information about the plant
 */
function editPlant(id, imageURL, savedOldURL = "", keyValueStore){
    cleanModal();   //Clears the confirmation modal

    var oldImageKey;
    if(savedOldURL === ""){
        //If no image needs to be deleted then nothing needs to happen 
        oldImageKey = savedOldURL;
    }else{
        //If there is an image to delete parse out the key from the url
        oldImageKey = savedOldURL.split("/");
        oldImageKey = oldImageKey[oldImageKey.length-1];
    }

    postToLambda(JSON.stringify({
        'operation':'edit',
        'userID': checkCookie(),
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
        //Reload the page
        loadPage();
    });
}


/**
 * Deletes a plant from the DB
 * @param {string} id           id of the plant to delete
 * @param {string} imageUrl     URL of the image to delete from S3
 */
function deletePlant(id,imageUrl){
    cleanModal();   //Removes the confirmation modal
    //Parse out the image key from the URL
    var imageKey = imageUrl.split("/");
    imageKey = imageKey[imageKey.length-1];

    postToLambda(JSON.stringify({
        'operation':'delete',
        'userID': checkCookie(),
        'tableName':'HydroPotPlantTypes',
        'payload':{
            'Item':{
                'id':id,
                'imageKey':imageKey
            }
        }
    }),
    function(data){
        //Reload the page
        loadPage();
    });
}

/**
 * Creates and builds the modal for confirming an edit or deletion from the database
 * @param {string} id           id of the plant to edit or delete
 * @param {string} imageUrl     url of the image to be deleted from S3          //TODO: This can probably be derived from the id
 * @param {string} plantType    name of the plant type that will be deleted     //TODO: This can probably be derived from the id
 * @param {string} action       the action to be taken, either "delete" or "edit"
 */
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

    //Set the title text content of the modal
    if(action == "delete"){
        modalTitle.textContent = "Confirm Delete?";
    }else if (action == "edit"){
        modalTitle.textContent = "Confirm Edit?";
    }
    
    //Button to dismiss the modal
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

    //Body of the modal
    var modalBody = document.createElement("div");
    modalBody.setAttribute("class","modal-body");
    var message = document.createElement("p");
    if(action == "delete"){
        //Build the delete message
        message.append("Deleting ");
        var boldSection = document.createElement("b");
        boldSection.append(plantType);
        message.append(boldSection);
        message.append(" will permenantly remove it from the database, are you sure?");
    }else if(action == "edit"){
        //Build the edit message
        message.append("Editing ");
        var boldSection = document.createElement("b");
        boldSection.append(plantType);
        message.append(boldSection);
        message.append(" will permenantly change it's values in the database, are you sure?");
    }
    modalBody.appendChild(message);

    //Buttons for taking action
    var modalFooter = document.createElement("div");
    modalFooter.setAttribute("class","modal-footer");
    //Button to cancel the edit or delete
    var cancelButton = document.createElement("div");
    cancelButton.setAttribute("type","button");
    cancelButton.setAttribute("class","btn btn-secondary");
    cancelButton.setAttribute("data-dismiss","modal");
    cancelButton.setAttribute("onclick","cleanModal()");
    cancelButton.append("Cancel");
    //Button to take action on the delete or edit
    var actionButton = document.createElement("div");
    actionButton.setAttribute("type","button");
    if(action == "delete"){
        //Delete button, has danger styling
        actionButton.setAttribute("class","btn btn-danger");
        actionButton.setAttribute("data-dismiss","modal");
        actionButton.setAttribute("onclick",`deletePlant("${id}","${imageUrl}")`);  //Imediate sends to delete function
        actionButton.append("Delete");
    }else if(action == "edit"){
        //Edit button, has primary button styling
        actionButton.setAttribute("class","btn btn-primary");
        actionButton.setAttribute("data-dismiss","modal");
        actionButton.setAttribute("onclick",`prepForDB("${id}","edit","image-button-${id}")`);  //Sends the data to be prepped and cleaned for the DB
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

/**
 * Modal for warning messages
 * @param {string} warningMessage   Message for the warning
 */
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

    //Title to alert user of an error
    var modalTitle = document.createElement("div");
    modalTitle.setAttribute("class","h5");
    modalTitle.textContent = "ERROR";
    
    //Button to close the modal
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

    //Sets the modal content
    var modalBody = document.createElement("div");
    modalBody.setAttribute("class","modal-body");
    var message = document.createElement("p");
    message.append(warningMessage)
    modalBody.appendChild(message);

    //Clear the modal
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

/**
 * Function to remove all parts of the modals
 */
function cleanModal(){
    $("#confirmActionModal").remove();
    $("#warningModal").remove();
    $(".modal-backdrop").remove();
    $(document.body).removeClass("modal-open");
}

/**
 * Displays the add image in the html
 * @param {string} fileUploadId     id for the file upload dialogue where the image information is stored
 * @param {string} imageOutputId    id for the image where the image will be displayed
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

/**
 * Adds an image to the S3 bucket and then sends it to add or edit
 * @param {string} id               id for the plant
 * @param {string} action           action to be taken, either "add" or "edit"
 * @param {string} fileDialogueId   id for the dialogue where the image is stored
 * @param {object} keyValueStore    plant information
 * @returns                         
 */
function imageUpload(id,action,fileDialogueId,keyValueStore){
    //This bit is just so we can delete things from S3, side effect we can use it to edit if need be
    var savedOldURL;
    if(action === "edit"){
        savedOldURL = $(`#image-output-${id}`).attr('savedURL');
    }

    var image = document.getElementById(fileDialogueId);
    //When there is no image in the file dialogue
    if(image.files.length === 0){
        if(action === "add"){
            //Cant have nothing on an add
            warningModal("You cannot add a plant without a picture.");
            return
        }else if(action === "edit"){
            //On an edit we just send back the old url
            editPlant(id, savedOldURL,"", keyValueStore);
            return
        }
    }
    
    //Reads the image and sends it
    var reader = new FileReader();
    reader.onload = function(){
        var fileExtension = reader.result.split(":",2)[1].split("/",2)[1].split(";")[0];    //Grabs just the file extention
        var encodedImage = reader.result.split(",",2)[1];                                   //Parses the encoded image to just get the image content
        postToLambda(JSON.stringify({
            'operation':'imageUpload',
            'userID': checkCookie(),
            'tableName':'HydroPotPlantTypes',
            'payload':{
                'Item':{
                    'encodedImage':encodedImage,
                    'fileExtension':fileExtension
                }
            }
        }),
        function(data){
            //data is the url of the image in the S3 Bucket
            if(action === "add"){
                //Add a plant
                addPlant(data, keyValueStore);
            }else if(action === "edit"){
                //Edit an existing plant
                editPlant(id,data, savedOldURL, keyValueStore);
            }
        });
    
    };

    reader.readAsDataURL(image.files[0]);
}

/**
 * Takes what the user has in the search bar and hides or shows elements based on substrings
 */
function runSearchQuery(){
    var searchQuerry = document.getElementById("search-bar-input").value.toLowerCase();

    for(var key in plantTypesLocal){
        var obj = plantTypesLocal[key];
        if(obj.plantType.toLowerCase().includes(searchQuerry)){
            obj.display = "flex";   //Flex shows the display
        }else{
            obj.display = "none";   //None hides the display
        }
    }

    buildTable(plantTypesLocal);
}

/**
 * Logs out of the account
 */
function logout(){
    setCached("userID","");     //Clear the cache of the userID
    location.reload();          //Reload the page
}

/**
 * Checks the user input fields for validation
 * @param {object} keyValueStore    plant data from inputs to check
 * @returns                         true if the fields are validated, if not false
 */
function validateFieldInput(keyValueStore){

    //Check to make sure fields have values
    for(var key in keyValueStore){
        if(keyValueStore[key] === ""){
            warningModal("All fields must have values!");
            return false
        }
    }

    //Checks to make sure all ideal numbers are numerical
    for(var key in keyValueStore){
        if(!(key == "plantType"||key == "description")){
            if(isNaN(keyValueStore[key])){
                warningModal("All ideals must be numerical");
                return false
            }
        }
    }

    //Converts ideals to numerical for comparison
    for(var key in keyValueStore){
        if(!(key == "plantType"||key == "description")){
            keyValueStore[key] = Number(keyValueStore[key]);
        }
    }

    //Check to make sure high temperature is higher than the low
    if(keyValueStore["idealTempHigh"] <= keyValueStore["idealTempLow"]){
        warningModal("Ideal Temperature High must be greater than Ideal Temperature Low");
        return false
    }

    //Checks that high moisture is between 0 and 100 percent
    if(keyValueStore["idealMoistureHigh"] < 0 || keyValueStore["idealMoistureHigh"] > 100){
        warningModal("Ideal Moisture High must be within a 0-100 range");
        return false
    }

    //Checks that low moisture is between 0 and 100 percent
    if(keyValueStore["idealMoistureLow"] < 0 || keyValueStore["idealMoistureLow"] > 100){
        warningModal("Ideal Moisture Low must be within a 0-100 range");
        return false
    }

    //Checks to make sure ideal high moisture is higher than ideal low moisture
    if(keyValueStore["idealMoistureHigh"] <= keyValueStore["idealMoistureLow"]){
        warningModal("Ideal Moisture High must be greater than Ideal Moisture Low");
        return false
    }

    //Checks high light is non-negative
    if(keyValueStore["idealLightHigh"] < 0){
        warningModal("Ideal Light High must not be below 0");
        return false
    }

    //Checks low light is non-negative
    if(keyValueStore["idealLightLow"] < 0){
        warningModal("Ideal Light Low must not be below 0");
        return false
    }

    //Checks that high light is greater than low light
    if(keyValueStore["idealLightHigh"] <= keyValueStore["idealLightLow"]){
        warningModal("Ideal Light High must be greater than Ideal Light Low");
        return false
    }
    
    return true;
}

/**
 * Gathers data from inputs, checks its validation, cleans it, and then sends it to the functions to add to the database
 * @param {string} id               id of the plant to be edited
 * @param {string} action           action to be taken, either "add" or "edit"
 * @param {string} fileDialogueId   id of the file dialogue the image is stored in
 */
function prepForDB(id,action,fileDialogueId){
    var keyArray = ["plantType","idealTempHigh","idealTempLow","idealMoistureHigh","idealMoistureLow","idealLightHigh","idealLightLow","description"];  //Array of the keys
    var keyValueStore = {};
    //Gathers from all of the input fields
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

    //Validates, cleans, and sends data to the image function
    if(validateFieldInput(keyValueStore)){
        for(var key in keyValueStore){
            if(!(key == "plantType"||key == "description")){
                keyValueStore[key] = Number(keyValueStore[key]);
            }
        }
        imageUpload(id,action,fileDialogueId,keyValueStore);
    }
}

/**
 * Checks the cookie for a stored user id
 * @returns the userID that is stored in the cookie
 */
function checkCookie(){
    var cachedResult = retrieveCached("userID", 86400); //86400 number seconds in a day
    return cachedResult;
}

/**
 * Sets a key value pair to the cache
 * @param {string} key  the key for the cached value
 * @param {string} val       the value of the cached value
 */
function setCached(key, val){
    var now = (new Date()).getTime();
    var stringVal = JSON.stringify({time: now, value: val } );
    sessionStorage.setItem(key,stringVal);
    
}

/**
 * Gets the value of the cached element
 * @param {string} key  The key of the element
 * @param {number} ttl  Time in seconds to check
 * @returns             The value of the cached element if it exists
 */
function retrieveCached(key, ttl){
    if (key in sessionStorage) {
        var x = JSON.parse(sessionStorage.getItem(key));
        var now = (new Date()).getTime();
        var cachedTime = x.time;
        if(cachedTime && (now - cachedTime < (ttl*1000))){
            return x.value;
        }
    }
    return null;
}

/**
 * Checks to see if the user is already logged in
 */
function checkLoggedIn(){
    postToLambda(JSON.stringify({
        'operation':'savedLogin',
        'userID':checkCookie()
    }),
    function(data){
        //Checks to see if the user has already been logged in in the past day
        if(data){
            $("#login").remove();
            loadPage();
        }
    });
}