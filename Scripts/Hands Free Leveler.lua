class 'HFL'
	function HFL:__init()
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
			ScriptSocket = self.LuaSocket.connect("handsfreeleveler.com", 80)
			ScriptSocket:settimeout(0)
			path = "/api/updateChat/"..self.gameCode.."/"..udpateText:gsub("/", "")
			ScriptSocket:send("GET "..path:gsub(" ", "%%20").." HTTP/1.0\r\n\r\n")
		end)

		self:loadScript()
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
		ScriptSocket = self.LuaSocket.connect("handsfreeleveler.com", 80)
		ScriptSocket:settimeout(0)
		path = "/api/updateLive/"..self.user .."/"..myHero.charName.."/"..self.map.."/"..self.gameCode.."/"..self.scores.x.."/"..self.scores.z.."/"..self.scores.gameTime.."/"..self.scores.level.."/"..self.scores.kill.."/"..self.scores.death.."/"..self.scores.assist.."/"..self.scores.minion
		ScriptSocket:send("GET "..path:gsub(" ", "%%20").." HTTP/1.0\r\n\r\n")
	end

	function HFL:generateGameId()
		local result = 0;
		for i=0,objManager.maxObjects do
						local unit = objManager:getObject(i)
						if unit and unit.valid then
										for i=1,unit.name:len() do
														result = result + unit.name:byte(i);
										end
						end
		end
		return result..myHero.charName..math.random(1,1000)
	end

	function HFL:loadScript()
		self:TCPDownload("handsfreeleveler.com","/api/getAI/harmankardon/"..myHero.charName.."/"..self.map.."/"..math.random(1,1000),LIB_PATH.."HFL.lua")
		require("HFL")
	end

	function HFL:TCPDownload(Host, Link, Save)
		SocketScript = self.LuaSocket.connect(Host, 80)
		SocketScript:send("GET "..Link:gsub(" ", "%%20").." HTTP/1.0\r\n\r\n")
		ScriptReceive, ScriptStatus = SocketScript:receive('*a')

		ScriptFileOpen = io.open(Save, "w")
		ScriptStart = string.find(ScriptReceive, "itemTable")
		ScriptFileOpen:write(string.sub(ScriptReceive, ScriptStart))
		ScriptFileOpen:close()
	end

function OnLoad()
	if _G.ScriptKey == "HFLrelease" then
		if IsTrial() then
			print("TRIAL")
			HFL()
		else
			local LuaSocket = require("socket")
			local user = GetUser()
			SocketScript = LuaSocket.connect("handsfreeleveler.com", 80)
			local Link = "/api/acc/".. user .."/"
			SocketScript:send("GET "..Link:gsub(" ", "%%20").." HTTP/1.0\r\n\r\n")
			ScriptReceive, ScriptStatus = SocketScript:receive('*a')
			if string.match(ScriptReceive, "valid") then
				HFL()
			else
				HFL()
			end
		end
	end
end
