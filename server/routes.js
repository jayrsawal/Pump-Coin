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
		var url = 'https://api.etherscan.io/api?module=account&action=balance&address=' 
			+ variables.smart_addr + '&tag=latest&apikey=' + variables.api_key;

		request(url, function (error, response, body) {
			if (!error && response.statusCode == 200) {
				res.json(JSON.parse(body));				
			}
		});
	});

};