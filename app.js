const express   = require('express');
const app       = express();
const port      = 8081;

const AWS = require('aws-sdk');
AWS.config.region = process.env.REGION

app.use(express.static(`${__dirname}/client`)); 		// statics
require(`./server/routes.js`)(app);						// routes

app.listen(port);										// let the games begin!
console.log(`Web server listening on port ${port}`);
