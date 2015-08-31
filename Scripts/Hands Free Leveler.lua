_ENV.aiAggr=17
_ENV.aiLane="Bot"
_ENV.aiSpells={3,2,2,1,3,3,4,4,}
_ENV.aiItems={"Amplifying Tome","Abyssal Scepter","Archangel's Staff","Berserker's Greaves","Blasting Wand","Blackfire Torch","Blade of the Ruined King","Bonetooth Necklace","Boots of Swiftness","Boots of Speed","Dagger","Cloak of Agility","Crystalline Bracer","Cloak and Dagger",}
_ENV.chats = {}
_ENV.chats["ac4"] = {{chance=8,text="oabaaaa"},}
_ENV.chats["onkill"] = {{chance=17,text="vay amk"},{chance=45,text="Lol"},}
_ENV.chats["ondead"] = {{chance=9,text="yes be"},{chance=45,text="Well I am dead"},}



class 'HFL'
	function HFL:__init()
		HookPackets()
		self.user = GetUser()
		self.map = GetGame().map.shortName
		self.gameCode = self:generateGameId()
		self.updateTime = 0
		self.LuaSocket = require("socket")
		

		self.scores = {
			killCurrent = 0,
			deathCurrent = 0,
			assistCurrent = 0,
			minionCurrent = 0,
			gameTime = GetInGameTimer(),
			level = 1,
			x = myHero.x,
			z = myHero.z
		}



		AddTickCallback(function()
			if self.updateTime + 3 < GetInGameTimer() then
				self:updateHeroStats()
				self.updateTime = GetInGameTimer()
			end
		end)

		AddRecvChatCallback(function (unit,text)
			udpateText = unit.charName
			if unit.team == myHero.team then
				udpateText = udpateText .. "(Ally):"..text
			else
				udpateText = udpateText .. "(Enemy):"..text
			end
			ScriptSocket = self.LuaSocket.connect("localhost", 80)
			ScriptSocket:settimeout(0)
			path = "/api/updateChat/"..self.gameCode.."/"..udpateText:gsub("/", "")
			ScriptSocket:send("GET "..path:gsub(" ", "%%20").." HTTP/1.0\r\n\r\n")
		end)
	end

	function HFL:updateHeroStats()
		self.scores = {
			kill = myHero:GetInt("CHAMPIONS_KILLED"),
			death = myHero:GetInt("NUM_DEATHS"),
			assist = myHero:GetInt("ASSISTS"),
			minion = myHero:GetInt("MINIONS_KILLED"),
			level = myHero.level,
			gameTime = GetInGameTimer(),
			x = myHero.x,
			z = myHero.z
		}
		ScriptSocket = self.LuaSocket.connect("localhost", 80)
		ScriptSocket:settimeout(0)
		path = "/api/updateLive/"..self.user .."/"..myHero.charName.."/"..self.map.."/"..self.gameCode.."/"..self.scores.x.."/"..self.scores.z.."/"..self.scores.gameTime.."/"..self.scores.level.."/"..self.scores.kill.."/"..self.scores.death.."/"..self.scores.assist.."/"..self.scores.minion
		ScriptSocket:send("GET "..path:gsub(" ", "%%20").." HTTP/1.0\r\n\r\n")
	end

	function HFL:generateGameId()
       	return tostring(math.random(10000,10000000000))
	end

function OnLoad()
	HFL()
end

function OnSendChat(text)
	--print(text)
end
