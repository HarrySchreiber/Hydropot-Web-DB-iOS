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
    console.log(data);
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