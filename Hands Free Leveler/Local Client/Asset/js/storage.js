var upSettings = JSON.parse(localStorage.getItem('settings'));

function saveLocalSetting(name,value){
	upSettings[name] = value;
	localStorage.setItem("settings",JSON.stringify(upSettings));
}