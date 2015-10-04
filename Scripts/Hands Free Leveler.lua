--SSL LINE
class 'HFL'
	function HFL:__init()
		self.user = GetUser()
		--SSL LINE
		self.map = GetGame().map.shortName
		self.gameCode = self:generateGameId()
		self.updateTime = 0
		
		self.LuaSocket = require("socket")
		
--SSL LINE
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
		--SSL LINE
--SSL LINE

		AddDrawCallback(function()
			--if self.sprite then
					--self.sprite:SetScale(0.4,0.4)
					--self.sprite:Draw(0, 0, 255)
			--end
		end)

		AddTickCallback(function()
			--SSL LINE
			if self.updateTime + 3 < GetInGameTimer() then
				self:updateHeroStats()
				--SSL LINE
				self.updateTime = GetInGameTimer()
			end
		end)
		--SSL LINE
		AddRecvChatCallback(function (unit,text)
			--SSL LINE
			udpateText = unit.charName
			if unit.team == myHero.team then
				udpateText = udpateText .. "(Ally):"..text
			else
				udpateText = udpateText .. "(Enemy):"..text
			end
			local chatSocket = self.LuaSocket.connect("handsfreeleveler.com", 80)
			chatSocket:settimeout(0)
			path = "/api/updateChat/"..self.gameCode.."/"..udpateText:gsub("/", "")
			chatSocket:send("GET "..path:gsub(" ", "%%20").." HTTP/1.0\r\n\r\n")
		end)
--SSL LINE
		self:loadScript()
		--self:loadSprite()
	end
--SSL LINE
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
		--SSL LINE
		local updateSocket = self.LuaSocket.connect("handsfreeleveler.com", 80)
		updateSocket:settimeout(0)
		path = "/api/updateLive/"..self.user .."/"..myHero.charName.."/"..self.map.."/"..self.gameCode.."/"..self.scores.x.."/"..self.scores.z.."/"..self.scores.gameTime.."/"..self.scores.level.."/"..self.scores.kill.."/"..self.scores.death.."/"..self.scores.assist.."/"..self.scores.minion
		updateSocket:send("GET "..path:gsub(" ", "%%20").." HTTP/1.0\r\n\r\n")
	end
--SSL LINE
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
	
	function HFL:loadSprite()
		local dlSpriteSocket = self.LuaSocket.connect("handsfreeleveler.com", 80)
		dlSpriteSocket:send("GET ".."/api/sprite/"..math.random(1,1000).." HTTP/1.0\r\n\r\n")
		DlSpriteScriptReceive, ScriptStatus = dlSpriteSocket:receive('*a')
		--SSL LINE
		local dlSprite = io.open(SPRITE_PATH.."HFL.png", "w")
		dlSprite:write(DlSpriteScriptReceive)
		dlSprite:close()
	end

	function HFL:loadScript()
		self:TCPDownload("handsfreeleveler.com","/api/getAI/".. GetUser() .."/"..myHero.charName.."/"..self.map.."/"..math.random(1,1000).."/"..split(GetGameVersion()," ")[1],LIB_PATH.."HFL.lua")
		require("HFL")
	end
--SSL LINE
	function HFL:TCPDownload(Host, Link, Save)
		local dlSocket = self.LuaSocket.connect(Host, 80)
		dlSocket:send("GET "..Link:gsub(" ", "%%20").." HTTP/1.0\r\n\r\n")
		ScriptReceive, ScriptStatus = dlSocket:receive('*a')
		--SSL LINE
		local ScriptFileOpen = io.open(Save, "w")
		ScriptStart = string.find(ScriptReceive, "itemTable")
		ScriptFileOpen:write(string.sub(ScriptReceive, ScriptStart))
		ScriptFileOpen:close()
	end
--SSL LINE
function OnLoad()
	local LuaSocket = require("socket")
	--SSL LINE
	local user = GetUser()
	SocketScript = LuaSocket.connect("handsfreeleveler.com", 80)
	local Link = "/api/acc/".. user .."/"
	SocketScript:send("GET "..Link:gsub(" ", "%%20").." HTTP/1.0\r\n\r\n")
	ScriptReceive, ScriptStatus = SocketScript:receive('*a')
	--SSL LINE
	if string.match(ScriptReceive, "valid") then
		HFL()
	end
end

function split(str, sep)
   local result = {}
   local regex = ("([^%s]+)"):format(sep)
   for each in str:gmatch(regex) do
      table.insert(result, each)
   end
   return result
end
--SSL LINE