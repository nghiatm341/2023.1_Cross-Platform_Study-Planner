const express = require("express")
const app = express()
const mongoose = require('mongoose');

app.get('/', (req, res) =>{
    res.send("Hello node api");
})

app.get('/routes', (req, res) =>{
    res.send("Get routes");
})

app.listen(3000, () =>{
    console.log("Node server in running at port 3000")
})

const username = "hypeboy";
const password = "hypeboy103"

mongoose.connect(`mongodb+srv://${username}:${password}@cluster0.xkosywm.mongodb.net/Node-API?retryWrites=true&w=majority&appName=AtlasApp`)
  .then(() => console.log('Connected to MongoDB'))
  .catch((error) => console.log(error))
  ;