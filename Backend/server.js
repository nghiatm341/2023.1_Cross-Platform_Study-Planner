const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const app = express();

//middleware
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cors());

// test simple route
app.get("/", (req, res) => {
  res.send("suprise mother f#cker");
});

app.listen(3000, () => {
  console.log("Node server in running at port 3000");
});

const username = "hypeboy";
const password = "hypeboy103";

//connect DB
mongoose
  .connect(
    `mongodb+srv://${username}:${password}@cluster0.xkosywm.mongodb.net/Node-API?retryWrites=true&w=majority&appName=AtlasApp`
  )
  .then(() => console.log("Connected to MongoDB"))
  .catch((error) => console.log(error));

//use routes
const domain = "hypeboy";
app.use(`/${domain}/player`, require("./routes/player"));
app.use(`/${domain}/course`, require("./routes/Course"));
app.use(`/${domain}/lesson`, require("./routes/Lesson"));
app.use(`/${domain}`, require("./routes/auth"));
app.use(`/${domain}/user`, require("./routes/user"));
app.use(`/${domain}/studyRoute`, require("./routes/studyRoute"))
app.use(`/${domain}/lessonNote`, require("./routes/lessonNote"))
app.use(`/${domain}/post`, require("./routes/Post"));