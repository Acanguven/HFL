/* Settings */

var host = "http://leagueoflegends.wikia.com";
var MAX_OPEN_REQUEST = 5;

/* Dont touch below */

var request = require('request');
var cheerio = require('cheerio');
var itemList = require('./items.json');
var fs = require('fs');

var outList = [];
var currentIndex = 0;
var open_request = 0;

function parser(path){
	request(host + path, function(err, resp, body){
		open_request--;
		$ = cheerio.load(body);
		var item = {
			/* Item Refs */
			ref: host + path,

			/* Item Cores */
			name : $("td[data-name='1']").text().replace(/\n/g, ""),
			code : $("td[data-name='code']").text().replace(/\n/g, ""),
			png : $(".floatleft img").attr("src"),

			/* Item Prices */
			buy : $("td[data-name='buy']").text().replace(/\n/g, ""),
			comb : $("td[data-name='comb']").text().replace(/\n/g, ""),
			sell : $("td[data-name='sell']").text().replace(/\n/g, ""),

			/* Item Stats */
			life : $("td[data-name='life']").text().replace(/\n/g, ""),
			mres : $("td[data-name='mres']").text().replace(/\n/g, ""),
			as : $("td[data-name='as']").text().replace(/\n/g, ""),
			arm : $("td[data-name='arm']").text().replace(/\n/g, ""),
			atk : $("td[data-name='atk']").text().replace(/\n/g, ""),
			ms : $("td[data-name='ms']").text().replace(/\n/g, ""),
			msflat : $("td[data-name='msflat']").text().replace(/\n/g, ""),
			mana : $("td[data-name='mana']").text().replace(/\n/g, ""),
			lref : $("td[data-name='arm_lvl']").text().replace(/\n/g, ""),
			crit : $("td[data-name='crit']").text().replace(/\n/g, ""),
			abil : $("td[data-name='abil']").text().replace(/\n/g, ""),
			cd : $("td[data-name='cd']").text().replace(/\n/g, ""),
			vamp : $("td[data-name='vamp']").text().replace(/\n/g, ""),
			gold : $("td[data-name='gold']").text().replace(/\n/g, ""),
			rpen : $("td[data-name='rpen']").text().replace(/\n/g, ""),
			mpen : $("td[data-name='mpen']").text().replace(/\n/g, ""),
			mreg : $("td[data-name='mreg']").text().replace(/\n/g, ""),
		}
		outList.push(item);

		console.log((currentIndex + 1) +" of " + itemList.length + " done.")
	});
}

function asyncManager(){
	if(currentIndex != itemList.length -1){
		if(open_request < MAX_OPEN_REQUEST){
			open_request++;
			parser(itemList[currentIndex++]);
		}
	}else{
		if(open_request == 0){
			clearInterval(_t);
			fs.writeFile('itemsParsed.json', JSON.stringify(outList), function (err) {
				if (err) return console.log(err);
				console.log("Items saved to itemsParsed.json")
			});
		}
	}
}

var _t = setInterval(asyncManager,100)