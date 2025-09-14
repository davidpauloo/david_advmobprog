require("dotenv").config();
const express = require("express");
const cors = require("cors");
const path = require("path");
const bodyParser = require("body-parser");
const jsonParser = bodyParser.json();
const connectDB = require("./config/db");
const userRoutes = require("./routes/userRoutes");
const articleRoutes = require("./routes/articleRoutes");

const app = express();

//db connection
connectDB();

app.use(express.json());

//Middlewares
app.use(jsonParser);
app.use(bodyParser.urlencoded({extended: true}));
app.use(cors());

const corsOptions = {
    origin: "*", 
    credentials: true,
    allowedHeaders: ["Content-Type", "Authorization", "X-Requested-With"],
    method: ["GET", "HEAD", "PUT", "PATCH", "POST", "DELETE"],
    preflightContinue: false,
    optionSuccessStatus: 204,
};

app.options("", cors(corsOptions));
app.use(cors(corsOptions));

app.use((req, res, next) => {
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader(
        "Access-Control-Allow-Headers",
        "Origin, X-Requested-With, Content, Accept, Content-Type, Authorization" 
    );
    res.setHeader(
        "Access-Control-Allow-Methods",
        "Get, POST, PUT, DELETE, PATCH, OPTIONS"
    );
    next();
});

//routes
app.use("/api/users", userRoutes);
app.use("/api/articles", articleRoutes);

//error handling
app.use((err,req,res,next) => {
    console.error(err.stack);
    res.status(500).json({message: "Server Error"});
});

const PORT = process.env.PORT || 8000;
app.listen(PORT, '0.0.0.0', () => console.log(`Server is running on port ${PORT}`));
