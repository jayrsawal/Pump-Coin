var request = require('request');
var bodyParser = require('body-parser');
var variables = require('./config.js');

module.exports = app => {
	app.use( bodyParser.json() );       // to support JSON-encoded bodies

	app.use(bodyParser.urlencoded({     // to support URL-encoded bodies
	  extended: true
	}));

	app.get('/', (req, res) => {
		res.sendfile('./client/index.html');
	});

	app.get('/smart-contract', (req, res) => {
		var url = 'https://api.etherscan.io/api?module=account&action=balance&address=0xDF6cdF88A9c16c02c80B6b735EDa68207c833e55&tag=latest&apikey=TBMP972T2C6J3JT55A36786U79KUQQQ813'; 

		request(url, function (error, response, body) {
			if (!error && response.statusCode == 200) {
				res.json(JSON.parse(body));				
			}
		});
	});

};