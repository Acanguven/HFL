editMode = false
debugMode = true


-- Encryption Below
-- Globals
MAPNAME = GetGame().map.shortName
TEAMNUMBER = myHero.team
--
--
-- Class Instances
MINIONS = nil
ESP = nil
TASKMANAGER = nil
PACKETS = nil
DEBUGGER = nil
CHAMPION = nil
AI = nil

--Overloads
local min, max, cos, sin, pi, huge, ceil, floor, round, random, abs, deg, asin, acos = math.min, math.max, math.cos, math.sin, math.pi, math.huge, math.ceil, math.floor, math.round, math.random, math.abs, math.deg, math.asin, math.acos

class 'init'
	function init:__init()
		self.sprite = false
		if FileExist(LIB_PATH .. "/HfLib.lua") then
			self:load()
		end
		if (not _G.hflTasks or not _G.hflTasks[MAPNAME] or not _G.hflTasks[MAPNAME][TEAMNUMBER]) and not editMode then
			print("This map is not supported, please report the map name to law to make him update for this map")
		else
			if editMode then
				debugMode = false
			end
			if not _G.hflTasks then
				_G.hflTasks = {}
			end
			if not _G.hflTasks[MAPNAME] then
				_G.hflTasks[MAPNAME] = {}
			end
			if not _G.hflTasks[MAPNAME][TEAMNUMBER] then
				_G.hflTasks[MAPNAME][TEAMNUMBER]  = {}
			end
			if self:checkAccess() then
				if editMode then
					editor()
				else
					if debugMode then
						DEBUGGER = debugger()
					end
					PACKETS = packet()
					TASKMANAGER = tasks()
					MINIONS = minions()
					ESP = esp()

					if _G[myHero.charName] then
						CHAMPION = _G[myHero.charName]()
					else
						CHAMPION = _G["Default"]()
					end
					myHeroSpellData = spellData[myHero.charName]
					StartBones()

					AI = ai()
				end
			end
			self:loadSprite()

			AddDrawCallback(function()
				self:drawSprite()
			end)
		end
	end

	function init:load()
		local file = io.open(LIB_PATH .. "/HfLib.lua", "rb")
		local content = file:read("*all")
		file:close()
		_G.hflTasks = unpickle(content)
	end

	function init:checkAccess()
		local LuaSocket = require("socket")
		local user = GetUser()
		SocketScript = LuaSocket.connect("handsfreeleveler.com", 80)
		local Link = "/api/acc/".. user .."/"
		SocketScript:send("GET "..Link:gsub(" ", "%%20").." HTTP/1.0\r\n\r\n")
		ScriptReceive, ScriptStatus = SocketScript:receive('*a')
		if string.match(ScriptReceive, "valid") then
			return true
		else
			return false
		end
	end

	function init:drawSprite()
		if self.sprite ~= false then
			self.sprite:Draw(0,(GetGame().WINDOW_H)-120,500)
		end
	end

	function init:loadSprite()
		if FileExist(SPRITE_PATH .. "/hfl.png") then
			self.sprite = createSprite(SPRITE_PATH .. "/hfl.png")
			self.sprite:SetScale(0.5,0.5)
		end
	end
class 'tasks'
	function tasks:__init()	
		self.taskLane = nil
		self.towers = {}
		self.hqs = {}
		self.baracks = {}
		self:collectTowers()
		self:collectHqs()
		self:collectBaracks()
		self:buildTaskObjects()

		self:pickLane()
		self:getCurrentTask()

		return self
	end

	function tasks:collectTowers()
		for i = 1, objManager.maxObjects do
	        local tow = objManager:getObject(i)
	        if tow and tow.type == "obj_AI_Turret" then
	        	table.insert(self.towers, tow)
	        end
	    end
	end
	function tasks:collectHqs()
		for i = 1, objManager.maxObjects do
	        local tow = objManager:getObject(i)
	        if tow and tow.type == "obj_HQ" then
	        	table.insert(self.towers, tow)
	        end
	    end
	end
	function tasks:collectBaracks()
		for i = 1, objManager.maxObjects do
	        local tow = objManager:getObject(i)
	        if tow and tow.type == "obj_BarracksDampener" then
	        	table.insert(self.towers, tow)
	        end
	    end
	end

	function tasks:buildTaskObjects()
		for i,task in pairs(_G.hflTasks[MAPNAME][TEAMNUMBER]) do
			if task.type == "Object" then
				local towerDetected = nil
				for c,tow in pairs(self.towers) do
					if GetDistance(tow,mousePos) < 300 then
						towerDetected = tow
					end
				end
				if towerDetected ~= nil then
					task.object = towerDetected
				else
					local baracksDetected = nil
					for c,barack in pairs(self.baracks) do
						if GetDistance(barack,mousePos) < 300 then
							baracksDetected = barack
						end
					end
					if baracksDetected ~= nil then
						task.object = baracksDetected
					else
						local hqDetected = nil
						for c,hq in pairs(self.hqs) do
							if GetDistance(hq,mousePos) < 300 then
								hqDetected = hq
							end
						end
						if hqDetected ~= nil then
							task.object = hqDetected
						else
							task.type = "Node"
						end
					end
					
				end
			end
		end
	end

	function tasks:pickLane()
		if #_G.hflTasks[MAPNAME][TEAMNUMBER][1].lanes > 1 then
			--Decide best lane
			self.taskLane = _G.hflTasks[MAPNAME][TEAMNUMBER][1].lanes[1]
			--simdilik sadece bot
		else
			self.taskLane = _G.hflTasks[MAPNAME][TEAMNUMBER][1].lanes[1]
		end
	end

	function tasks:getCurrentTask()
		if self.taskLane ~= nil then
			local nearestTask = nil
			local looper = _G.hflTasks[MAPNAME][TEAMNUMBER][self.taskLane]
			while looper.next ~= nil do
				local task = looper
				if nearestTask == nil then
					nearestTask = task
					if GetDistance2D(task.point,_G.hflTasks[MAPNAME][TEAMNUMBER][1].point) > GetDistance2D(myHero,_G.hflTasks[MAPNAME][TEAMNUMBER][1].point) then
						break
					end
				else
					if GetDistance2D(task.point,_G.hflTasks[MAPNAME][TEAMNUMBER][1].point) > GetDistance2D(myHero,_G.hflTasks[MAPNAME][TEAMNUMBER][1].point) + 200 then
						nearestTask = task
						break
					end
				end
				looper = _G.hflTasks[MAPNAME][TEAMNUMBER][looper.next]
			end
			return nearestTask
		else
			print("Lane not selected")
			--Fix here
		end
		return _G.hflTasks[MAPNAME][TEAMNUMBER][1]
	end
class 'debugger'
	function debugger:__init()
		AddDrawCallback(function()
			self:nodeManagerDraw()
		end)
		AddMsgCallback(function(e,t)
			if e == 257 and t == 77 then --m key up add minion ranged debug
				self:addRangedEnemyMinion(mousePos)
			end
			if e == 257 and t == 78 then --n key up add minion melee debug
				self:addMeleeEnemyMinion(mousePos)
			end
			if e == 257 and t == 67 then --c key up add minion clear all debug
				self.debugMinions = {}
				self.towers = {}
			end
			if e == 257 and t == 84 then --t key up add enemy tower debug
				self:addTower(mousePos)
			end
		end)

		self.debugMinions = {}
		self.towers = {}
	end

	function debugger:addTower(pos)
		table.insert(self.towers, {x=pos.x,z=pos.z,y=pos.y,charName="Enemy Tower",range=1000})
	end

	function debugger:addMeleeEnemyMinion(pos)
		table.insert(self.debugMinions, {x=pos.x,z=pos.z,y=pos.y,charName="Debug Minion Melee",range=300})
	end

	function debugger:addRangedEnemyMinion(pos)
		table.insert(self.debugMinions, {x=pos.x,z=pos.z,y=pos.y,charName="Debug Minion Ranged",range=600})
	end

	function debugger:nodeManagerDraw()
		if not _G.hflTasks[MAPNAME][TEAMNUMBER] then
			return
		end
		for i,minion in pairs(self.debugMinions) do
			DrawCircle(minion.x, minion.y, minion.z, 50, ARGB(255, 255, 0, 0))
			DrawCircle(minion.x, minion.y, minion.z, minion.range, ARGB(255, 255, 0, 0))
			local po = WorldToScreen(D3DXVECTOR3(minion.x,minion.y,minion.z))
			DrawText(minion.charName, 20, po.x, po.y, ARGB(255, 255, 255, 0))
		end
		for i,tower in pairs(self.towers) do
			DrawCircle(tower.x, tower.y, tower.z, 50, ARGB(255, 255, 0, 0))
			DrawCircle(tower.x, tower.y, tower.z, tower.range, ARGB(255, 255, 0, 0))
			local po = WorldToScreen(D3DXVECTOR3(tower.x,tower.y,tower.z))
			DrawText(tower.charName, 20, po.x, po.y, ARGB(255, 255, 255, 0))
		end
		for i,task in pairs(_G.hflTasks[MAPNAME][TEAMNUMBER]) do
			if task.type == "Object" then
				DrawCircle(task.point.x, task.point.y, task.point.z, 500, ARGB(255, 255, 255, 0))
				local po = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
				DrawText("" .. i, 35, po.x, po.y, ARGB(255, 255, 255, 0))
			end
			if task.type == "Node" then
				DrawCircle(task.point.x, task.point.y, task.point.z, 150, ARGB(255, 255, 255, 0))
				local po = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
				DrawText("" .. i, 25, po.x, po.y, ARGB(255, 255, 255, 0))
			end
			if task.type == "Base" then
				DrawCircle(task.point.x, task.point.y, task.point.z, 150, ARGB(255, 255, 255, 0))
				local po = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
				DrawText("Spawn", 25, po.x-30, po.y, ARGB(255, 0, 0, 255))
			end
			if task.type ~= "Base" then
				if task.next ~= nil then
					if not _G.hflTasks[MAPNAME][TEAMNUMBER][task.next] then
						task.next = nil
					else
						local ne,curr
						ne = WorldToScreen(D3DXVECTOR3(_G.hflTasks[MAPNAME][TEAMNUMBER][task.next].point.x,_G.hflTasks[MAPNAME][TEAMNUMBER][task.next].point.y,_G.hflTasks[MAPNAME][TEAMNUMBER][task.next].point.z))
						curr = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
					    DrawLine(curr.x, curr.y, ne.x, ne.y, 3, ARGB(0xFF,0xFF,0xFF,0xFF))
					end
				end
			else
				for i,lane in pairs(task.lanes) do
					local ne,curr
					ne = WorldToScreen(D3DXVECTOR3(_G.hflTasks[MAPNAME][TEAMNUMBER][lane].point.x,_G.hflTasks[MAPNAME][TEAMNUMBER][lane].point.y,_G.hflTasks[MAPNAME][TEAMNUMBER][lane].point.z))
					curr = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
				    DrawLine(curr.x, curr.y, ne.x, ne.y, 3, ARGB(0xFF,0xFF,0xFF,0xFF))
				end
			end
			if self.leftNodeSelected ~= nil then
				local po = WorldToScreen(D3DXVECTOR3(self.leftNodeSelected.point.x,self.leftNodeSelected.point.y,self.leftNodeSelected.point.z))
				local ms = WorldToScreen(D3DXVECTOR3(mousePos))
			    DrawLine(po.x, po.y, ms.x, ms.y, 3, ARGB(0xFF,0xFF,0xFF,0xFF))
			end
		end

		for i = 1, objManager.maxObjects do
	        local object = objManager:getObject(i)
	        if object ~= nil and object.name ~= nil and #object.name > 1 and GetDistance2D(mousePos,object.pos) < 150 and not string.find(object.name,".troy") then
	          	local po = WorldToScreen(D3DXVECTOR3(object.pos.x,object.pos.y,object.pos.z))
				DrawText(object.name, 15, po.x, po.y, ARGB(255, 0, 255, 0))
				DrawText(object.type, 15, po.x, po.y+25, ARGB(255, 255, 255, 0))
	        end
      	end
	end
class 'minions'
	function minions:__init()
		self.enemies = minionManager(MINION_ENEMY, 150*9, myHero, MINION_SORT_MAXHEALTH_DEC) --ESP.predictivity burda
		self.allies = minionManager(MINION_ALLY, 150*9, myHero, MINION_SORT_MAXHEALTH_DEC)
		self.attackTable = {}

		AddProcessAttackCallback(function(unit, attackProc) 
			self.attackTable[unit.name]=attackProc.target
		end)

		AddTickCallback(function ()
			self.enemies:update()
			self.allies:update()
			--self:minionLine()
		end)
		if debugger then
			AddDrawCallback(function ()
				--self.drawManager()
			end)
		end

		return self
	end

	function minions:minionLine()

	end

	function minions:drawManager()

	end
class 'esp'
	function esp:__init()
		self.lastTick = GetTickCount()
		self.predictivity = 125
		self.updateRate = 5
		self.emptySpace = 150
		self.nodes = {}
		self:createNodes()
		self.bestNode = nil
		self.lastPos = {x = 0, z = 0}
		self.towers = {}

		self:collectTowers()

		if debugger then
			AddDrawCallback(function ()
				self:drawManager()
			end)
		end

		AddTickCallback(function()
			if GetTickCount() > self.lastTick + self.updateRate then
				self:updateNodes()
				self.lastTick = GetTickCount()


				self:getMinimumDangerRelativetoTaskFarming()
			end
		end)

		return self
	end

	function esp:collectTowers()
		for i = 1, objManager.maxObjects do
	        local tow = objManager:getObject(i)
	        if tow and tow.type == "obj_AI_Turret" then
	        	table.insert(self.towers, tow)
	        end
	    end
	end

	function esp:createNodes()
		for x = -7, 7 do
		  	for z = -7, 7 do
		  		local node = {
			  		x=myHero.x+(x*(self.predictivity+self.emptySpace)),
			  		z=myHero.z+(z*(self.predictivity+self.emptySpace)),
			  		initx=myHero.x,
			  		initz=myHero.z,
			  		danger = {free = 0, action = 0},
			  		reachable = true,
			  		best = false
		  		}
		  		if GetDistance2D(myHero,node) < self.predictivity*8 then
				 	table.insert(self.nodes,node)
				 end
			end
		end
	end

	function esp:updateNodes()
		for i, node in pairs(self.nodes) do
			node.danger.free = 0
			node.danger.action = 0
			local nodeXDiff = myHero.x-node.initx
			if nodeXDiff > 3 or nodeXDiff < -3 then
				node.x = node.x + nodeXDiff
				node.initx = myHero.x
			end

			local nodeZDiff = myHero.z-node.initz
			if nodeZDiff > 3 or nodeZDiff < -3 then
				node.z = node.z + nodeZDiff
				node.initz = myHero.z
			end
			node.danger.free = 0
			node.danger.action = 0

			self:calculateReachable(node)
			if node.reachable then
				self:calculateMinions(node)
				self:calculateTowers(node)
			end
		end
	end

	function  esp:calculateTowers(node)
		for i, tower in pairs(self.towers) do
			if GetDistance2D(node, tower) < 950 and tower.team ~= myHero.team then
				local towerAllies = 0
	        	for i,minion in pairs(MINIONS.allies.objects) do
					if not minion.dead then
						if GetDistance2D(tower,minion) < 950 then
							towerAllies = towerAllies + 1
						end
					end
				end
				if towerAllies < 2 then
					node.danger.free = node.danger.free + 80
					node.danger.action = node.danger.action + 80
				end
			end
		end
		if debugMode then
			for i, tower in pairs(DEBUGGER.towers) do
				if GetDistance2D(node, tower) < 950 then
					local towerAllies = 0
		        	for i,minion in pairs(MINIONS.allies.objects) do
						if not minion.dead then
							if GetDistance2D(tower,minion) < 950 then
								towerAllies = towerAllies + 1
							end
						end
					end
					if towerAllies < 2 then
						node.danger.free = node.danger.free + 80
						node.danger.action = node.danger.action + 80
					end
				end
			end
		end
	end

	function  esp:calculateMinions(node)
		for i, minion in pairs(MINIONS.enemies.objects) do
			local minionRange 	
			if string.find(minion.charName, "Ranged") then
				minionRange = 600
			else
				minionRange = 200
			end
			if GetDistance2D(node, minion) < minionRange and minion.visible and not minion.dead then
				if MINIONS.attackTable[minion.name] and not MINIONS.attackTable[minion.name].dead and MINIONS.attackTable[minion.name] ~= myHero then
					node.danger.action = node.danger.action + 35
				else
					MINIONS.attackTable[minion.name] = nil
					node.danger.free = node.danger.free + 35
					node.danger.action = node.danger.action + 35
				end
			end
		end
		if debugMode then
			for i, minion in pairs(DEBUGGER.debugMinions) do
				local minionRange 	
				if string.find(minion.charName, "Ranged") then
					minionRange = 600
				else
					minionRange = 200
				end
				if GetDistance2D(node, minion) < minionRange then
					node.danger.free = node.danger.free + 35
					node.danger.action = node.danger.action + 35
				end
			end
		end
	end

	function esp:calculateReachable(node)
		node.reachable = not IsWall(D3DXVECTOR3(node.x, myHero.y, node.z))
	end

	function esp:getMinimumDangerRelativetoTaskWalking() --dont forget melees
		local minimumNode = nil
		local currentTask = TASKMANAGER:getCurrentTask()
		for i, node in pairs(self.nodes) do
			node.best = false
			if node.reachable then
				if minimumNode == nil then
					minimumNode = node
				else
					if GetDistance2D(node,currentTask.point) < GetDistance2D(minimumNode,currentTask.point) and GetDistance2D(node,myHero) > 200 and node.danger.free == 0 then
						minimumNode = node
					end
				end
			end
		end
		minimumNode.best = true

		--myHero:MoveTo(minimumNode.x, minimumNode.z) -- use this method for just going to target.
	end

	function esp:getMinimumDangerRelativetoTaskAction() --dont forget melees
		local minimumNode = nil
		local currentTask = TASKMANAGER:getCurrentTask()
		for i, node in pairs(self.nodes) do
			node.best = false
			if node.reachable then
				if minimumNode == nil then
					minimumNode = node
				else
					if GetDistance2D(node,currentTask.point) < GetDistance2D(minimumNode,currentTask.point) and GetDistance2D(node,myHero) > 200 and node.danger.free == 0 then
						minimumNode = node
					end
				end
			end
		end
		minimumNode.best = true

		myHero:MoveTo(minimumNode.x, minimumNode.z) -- use this method for just going to target.
	end

	function esp:getMinimumDangerRelativetoTaskFarming() --dont forget melees and add ally minion existence?
		local minimumNode = nil
		local dangerNodes = {}
		local currentTask = TASKMANAGER:getCurrentTask()
		table.sort(self.nodes, sortByDistanceNodes)

		for i, node in pairs(self.nodes) do
			if node.danger.action > 0 then
				table.insert(dangerNodes, node)
			end
		end
		for x, nodeDanger in pairs(dangerNodes) do
			for i, node in pairs(self.nodes) do
				if GetDistance2D(nodeDanger, _G.hflTasks[MAPNAME][TEAMNUMBER][1].point) < GetDistance2D(node, _G.hflTasks[MAPNAME][TEAMNUMBER][1].point) then
					node.reachable = false
				end		
			end
		end
		for i, node in pairs(self.nodes) do
			node.best = false
			if node.reachable then
				if minimumNode == nil then
					minimumNode = node
				else
					if node.danger.free == 0 then
						if GetDistance2D(node,currentTask.point) < GetDistance2D(minimumNode,currentTask.point) then
							minimumNode = node
						end
					end
				end
			end
		end
		minimumNode.best = true
		if minimumNode ~= self.bestNode then
			self.bestNode = minimumNode
			--myHero:MoveTo(minimumNode.x, minimumNode.z) -- use this method for just going to target.
			self.lastPos = {x=minimumNode.x, z=minimumNode.z}
		else
			if GetDistance2D(self.lastPos,minimumNode) > self.emptySpace then
				--myHero:MoveTo(minimumNode.x, minimumNode.z) -- use this method for just going to target.
				self.lastPos = {x=minimumNode.x, z=minimumNode.z}
			end
		end
	end

	function esp:drawManager()
		for i, node in pairs(self.nodes) do
			if node.reachable then
				if node.best then
					DrawCircle(node.x, myHero.y, node.z, self.predictivity, ARGB(255, 255, 255, 255))
				else
					DrawCircle(node.x, myHero.y, node.z, self.predictivity, ARGB(255, node.danger.free, 255-node.danger.free, 0))
				end
				
				local po = WorldToScreen(D3DXVECTOR3(node.x,myHero.y,node.z))
				DrawText("".. node.danger.free, 25, po.x-30, po.y, ARGB(255, 0, 0, 255))
			else
				DrawCircle(node.x, myHero.y, node.z, self.predictivity, ARGB(255, 255, 0, 0))
				local po = WorldToScreen(D3DXVECTOR3(node.x,myHero.y,node.z))
				DrawText("".. node.danger.action, 25, po.x-30, po.y, ARGB(255, 0, 0, 255))
			end
		end
	end
class 'editor'
	function editor:__init()
		AddMsgCallback(function(e,t)
			if e == 257 and t == 17 then
				self:deleteHover()
			end
			if e == 257 and t == 16 then
				self:connectHover()
			end
			if e == 514 and t == 0 then
				self:mouseUp()
			end
			if e == 513 and t == 1 then
				self:mouseDown()
			end
			if self.selectedTask ~= nil then
				if self.selectedTask.type == "Node" or self.selectedTask.type == "Base" then
					self.selectedTask.point = {x=mousePos.x,y=mousePos.y,z=mousePos.z}
				end
			end
		end)

		AddDrawCallback(function()
			self:drawManager()
		end)

		--Editor Locals
		self.selectedTask = nil
		self.deletePressed = false
		self.leftNodeSelected = nil
		if _G.hflTasks[MAPNAME][TEAMNUMBER][1] and _G.hflTasks[MAPNAME][TEAMNUMBER][1].type == "Base" then
			self.spawnAdded = true
		else
			self.spawnAdded = false
		end
		
		self.towers = {}
		self.hqs = {}
		self.baracks = {}
		self:collectTowers()
		self:collectHqs()
		self:collectBaracks()
	end

	function editor:collectTowers()
		for i = 1, objManager.maxObjects do
	        local tow = objManager:getObject(i)
	        if tow and tow.type == "obj_AI_Turret" then
	        	table.insert(self.towers, tow)
	        end
	    end
	end
	function editor:collectHqs()
		for i = 1, objManager.maxObjects do
	        local tow = objManager:getObject(i)
	        if tow and tow.type == "obj_HQ" then
	        	table.insert(self.towers, tow)
	        end
	    end
	end
	function editor:collectBaracks()
		for i = 1, objManager.maxObjects do
	        local tow = objManager:getObject(i)
	        if tow and tow.type == "obj_BarracksDampener" then
	        	table.insert(self.towers, tow)
	        end
	    end
	end

	function editor:connectHover(  )
		if self.leftNodeSelected == nil then
			for i,task in pairs(_G.hflTasks[MAPNAME][TEAMNUMBER]) do
				if task.type == "Object" then
					if GetDistance(mousePos, task.point) < 500 then
						self.leftNodeSelected = task
					end
				end
				if task.type == "Node" or task.type == "Base" then
					if GetDistance(mousePos, task.point)  < 150  then
						self.leftNodeSelected = task
					end
				end
			end
		else
			for i,task in pairs(_G.hflTasks[MAPNAME][TEAMNUMBER]) do
				if task.type == "Object" then
					if GetDistance(mousePos, task.point) < 300 then
						if self.leftNodeSelected.type == "Base" then
							table.insert(self.leftNodeSelected.lanes,i)
						else
							self.leftNodeSelected.next = i
						end
					end
				end
				if task.type == "Node" then
					if GetDistance(mousePos, task.point)  < 300  then
						if self.leftNodeSelected.type == "Base" then
							table.insert(self.leftNodeSelected.lanes,i)
						else
							self.leftNodeSelected.next = i
						end
					end
				end
			end
			if self.leftNodeSelected.type ~= "Base" then
				if self.leftNodeSelected.next == nil then
					local towerDetected = nil
					local buildingDetected = nil
					for c,tow in pairs(self.towers) do
						if GetDistance(tow,mousePos) < 300 then
							towerDetected = tow
						end
					end

					if towerDetected ~= nil then
						table.insert(_G.hflTasks[MAPNAME][TEAMNUMBER],{point={x=towerDetected.x,y=towerDetected.y,z=towerDetected.z},type="Object",next=nil})
					else
						if buildingDetected == nil then
							table.insert(_G.hflTasks[MAPNAME][TEAMNUMBER],{point={x=mousePos.x,y=mousePos.y,z=mousePos.z},type="Node",next=nil})
						end
					end
					self.leftNodeSelected.next = #_G.hflTasks[MAPNAME][TEAMNUMBER]
					self.leftNodeSelected = _G.hflTasks[MAPNAME][TEAMNUMBER][#_G.hflTasks[MAPNAME][TEAMNUMBER]]
				else
					self.leftNodeSelected = _G.hflTasks[MAPNAME][TEAMNUMBER][self.leftNodeSelected.next]
				end
				self:save()
			end
		end
	end

	function editor:deleteHover(  )
		for i,task in pairs(_G.hflTasks[MAPNAME][TEAMNUMBER]) do
			if task.type == "Object" then
				if GetDistance(mousePos, task.point) < 500 then
					table.remove(_G.hflTasks[MAPNAME][TEAMNUMBER], i)
				end
			end
			if task.type == "Node" then
				if GetDistance(mousePos, task.point)  < 150  then
					table.remove(_G.hflTasks[MAPNAME][TEAMNUMBER], i)
				end
			end
			if task.type == "Base" then
				if GetDistance(mousePos, task.point)  < 150  then
					_G.hflTasks[MAPNAME][TEAMNUMBER] = {}
					self.spawnAdded = false
				end
			end
		end
		self:save()
	end

	function editor:mouseDown()
		if self.leftNodeSelected == nil then
			for i,task in pairs(_G.hflTasks[MAPNAME][TEAMNUMBER]) do
				if task.type == "Object" then
					if GetDistance(mousePos, task.point) < 500 then
						self.selectedTask = task
					end
				end
				if task.type == "Node" then
					if GetDistance(mousePos, task.point)  < 150  then
						self.selectedTask = task
					end
				end
				if task.type == "Base" then
					if GetDistance(mousePos, task.point)  < 150  then
						self.selectedTask = task
					end
				end
			end
		end
	end

	function editor:mouseUp()
		if self.leftNodeSelected == nil then
			if self.selectedTask == nil then
				if self.spawnAdded then
					local towerDetected = nil
					for c,tow in pairs(self.towers) do
						if GetDistance(tow,mousePos) < 300 then
							towerDetected = tow
						end
					end
					if towerDetected ~= nil then
						table.insert(_G.hflTasks[MAPNAME][TEAMNUMBER],{point={x=towerDetected.x,y=towerDetected.y,z=towerDetected.z},type="Object",next=nil})
					else
						local baracksDetected = nil
						for c,barack in pairs(self.baracks) do
							if GetDistance(barack,mousePos) < 300 then
								baracksDetected = barack
							end
						end
						if baracksDetected ~= nil then
							table.insert(_G.hflTasks[MAPNAME][TEAMNUMBER],{point={x=towerDetected.x,y=towerDetected.y,z=towerDetected.z},type="Object",next=nil})
						else
							local hqDetected = nil
							for c,hq in pairs(self.hqs) do
								if GetDistance(hq,mousePos) < 300 then
									hqDetected = hq
								end
							end
							if hqDetected ~= nil then
								table.insert(_G.hflTasks[MAPNAME][TEAMNUMBER],{point={x=towerDetected.x,y=towerDetected.y,z=towerDetected.z},type="Object",next=nil})
							else
								table.insert(_G.hflTasks[MAPNAME][TEAMNUMBER],{point={x=mousePos.x,y=mousePos.y,z=mousePos.z},type="Node",next=nil})
							end
						end
						
					end
				else
					table.insert(_G.hflTasks[MAPNAME][TEAMNUMBER],{point={x=mousePos.x,y=mousePos.y,z=mousePos.z},type="Base",lanes={}})
					self.spawnAdded = true
				end
			end
		else
			for i,task in pairs(_G.hflTasks[MAPNAME][TEAMNUMBER]) do
				if task.type == "Object" then
					if GetDistance(mousePos, task.point) < 200 then
						if self.leftNodeSelected.type == "Base" then
							if GetDistance(mousePos, task.point)  < 200  then
								table.insert(self.leftNodeSelected.lanes,i)
							end
						else
							self.leftNodeSelected.next = i
						end
					end
				end
				if task.type == "Node" then
					if GetDistance(mousePos, task.point)  < 200  then
						if self.leftNodeSelected.type == "Base" then
							if GetDistance(mousePos, task.point)  < 200  then
								table.insert(self.leftNodeSelected.lanes,i)
							end
						else
							self.leftNodeSelected.next = i
						end
					end
				end
			end
			self.leftNodeSelected = nil
		end
		self.selectedTask = nil
		self:save()
	end

	function editor:drawManager()
		for i,task in pairs(_G.hflTasks[MAPNAME][TEAMNUMBER]) do

			if task.type == "Object" then
				DrawCircle(task.point.x, task.point.y, task.point.z, 500, ARGB(255, 255, 255, 0))
				local po = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
				DrawText("" .. i, 35, po.x, po.y, ARGB(255, 255, 255, 0))
			end
			if task.type == "Node" then
				DrawCircle(task.point.x, task.point.y, task.point.z, 150, ARGB(255, 255, 255, 0))
				local po = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
				DrawText("" .. i, 25, po.x, po.y, ARGB(255, 255, 255, 0))
			end
			if task.type == "Base" then
				DrawCircle(task.point.x, task.point.y, task.point.z, 150, ARGB(255, 255, 255, 0))
				local po = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
				DrawText("Spawn", 25, po.x-30, po.y, ARGB(255, 0, 0, 255))
			end
			if task.type ~= "Base" then
				if task.next ~= nil then
					if not _G.hflTasks[MAPNAME][TEAMNUMBER][task.next] then
						task.next = nil
					else
						local ne,curr
						ne = WorldToScreen(D3DXVECTOR3(_G.hflTasks[MAPNAME][TEAMNUMBER][task.next].point.x,_G.hflTasks[MAPNAME][TEAMNUMBER][task.next].point.y,_G.hflTasks[MAPNAME][TEAMNUMBER][task.next].point.z))
						curr = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
					    DrawLine(curr.x, curr.y, ne.x, ne.y, 3, ARGB(0xFF,0xFF,0xFF,0xFF))
					end
				end
			else
				for i,lane in pairs(task.lanes) do
					local ne,curr
					ne = WorldToScreen(D3DXVECTOR3(_G.hflTasks[MAPNAME][TEAMNUMBER][lane].point.x,_G.hflTasks[MAPNAME][TEAMNUMBER][lane].point.y,_G.hflTasks[MAPNAME][TEAMNUMBER][lane].point.z))
					curr = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
				    DrawLine(curr.x, curr.y, ne.x, ne.y, 3, ARGB(0xFF,0xFF,0xFF,0xFF))
				end
			end
			if self.leftNodeSelected ~= nil then
				local po = WorldToScreen(D3DXVECTOR3(self.leftNodeSelected.point.x,self.leftNodeSelected.point.y,self.leftNodeSelected.point.z))
				local ms = WorldToScreen(D3DXVECTOR3(mousePos))
			    DrawLine(po.x, po.y, ms.x, ms.y, 3, ARGB(0xFF,0xFF,0xFF,0xFF))
			end
		end

		for i = 1, objManager.maxObjects do
	        local object = objManager:getObject(i)
	        if object ~= nil and object.name ~= nil and #object.name > 1 and GetDistance2D(mousePos,object.pos) < 150 and not string.find(object.name,".troy") then
	          	local po = WorldToScreen(D3DXVECTOR3(object.pos.x,object.pos.y,object.pos.z))
				DrawText(object.name, 15, po.x, po.y, ARGB(255, 0, 255, 0))
				DrawText(object.type, 15, po.x, po.y+25, ARGB(255, 255, 255, 0))
	        end
      	end
	end

	function editor:save()
		local pickledString = pickle(_G.hflTasks)
		local file = io.open(LIB_PATH .. "/HfLib.lua", "w")
		file:write(pickledString)
		file:close()
	end

	function editor:load()
		local file = io.open(LIB_PATH .. "/HfLib.lua", "rb")
		local content = file:read("*all")
		file:close()
		_G.hflTasks = unpickle(content)
	end
class 'packet'
	function packet:__init()
		self.disabledPacket = false
		self.version = split(GetGameVersion()," ")[1]
		self.idBytes = {}
		self.spellLevel = {}
		self.buyItem = {}

		self:initBytes()
		if not self.idBytes[self.version] then
			print("Packets are not supported, disabling packets. please report Law to update " .. self.version)
			self.disabledPacket = true
		end
	end

	function packet:buyItemId(id)
		self.buyItem[self.version](id)
	end

	function spellUp(id)
		self.spellLevel[self.version](id)
	end

	function packet:initBytes()
		self.idBytes["5.22.0.289"] = {
		    [0x01] = 0xD6,[0x02] = 0xBD,[0x03] = 0x87,[0x04] = 0x3D,[0x05] = 0xBC,[0x06] = 0x4D,[0x07] = 0xE8,[0x08] = 0x10,
		    [0x09] = 0x9C,[0x0A] = 0xF8,[0x0B] = 0xF2,[0x0C] = 0xE2,[0x0D] = 0xC5,[0x0E] = 0xB5,[0x0F] = 0x42,[0x10] = 0x2F,
		    [0x11] = 0x55,[0x12] = 0xAA,[0x13] = 0xF6,[0x14] = 0x1C,[0x15] = 0x5F,[0x16] = 0x4A,[0x17] = 0xDB,[0x18] = 0x7E,
		    [0x19] = 0x3A,[0x1A] = 0xC2,[0x1B] = 0x90,[0x1C] = 0x26,[0x1D] = 0x5E,[0x1E] = 0x5C,[0x1F] = 0x62,[0x20] = 0xA6,
		    [0x21] = 0xD5,[0x22] = 0x61,[0x23] = 0xE1,[0x24] = 0x88,[0x25] = 0xE5,[0x26] = 0xC6,[0x27] = 0xCA,[0x28] = 0xF7,
		    [0x29] = 0x12,[0x2A] = 0xFE,[0x2B] = 0xFA,[0x2C] = 0x98,[0x2D] = 0x46,[0x2E] = 0xAE,[0x2F] = 0xA9,[0x30] = 0x2E,
		    [0x31] = 0x4F,[0x32] = 0xCC,[0x33] = 0x97,[0x34] = 0xDD,[0x35] = 0x06,[0x36] = 0xA1,[0x37] = 0x04,[0x38] = 0x40,
		    [0x39] = 0x28,[0x3A] = 0x47,[0x3B] = 0xBA,[0x3C] = 0x73,[0x3D] = 0x30,[0x3E] = 0x7C,[0x3F] = 0x16,[0x40] = 0xAF,
		    [0x41] = 0x83,[0x42] = 0xE4,[0x43] = 0x89,[0x44] = 0x33,[0x45] = 0xDA,[0x46] = 0x38,[0x47] = 0xEA,[0x48] = 0x81,
		    [0x49] = 0x2B,[0x4A] = 0xDE,[0x4B] = 0x63,[0x4C] = 0x85,[0x4D] = 0x76,[0x4E] = 0x5D,[0x4F] = 0x0E,[0x50] = 0x0A,
		    [0x51] = 0x74,[0x52] = 0xCD,[0x53] = 0x6D,[0x54] = 0xC1,[0x55] = 0x24,[0x56] = 0x11,[0x57] = 0xA7,[0x58] = 0xCE,
		    [0x59] = 0xA4,[0x5A] = 0x34,[0x5B] = 0x8F,[0x5C] = 0xB8,[0x5D] = 0xEC,[0x5E] = 0x09,[0x5F] = 0x99,[0x60] = 0x05,
		    [0x61] = 0x70,[0x62] = 0xD9,[0x63] = 0x1B,[0x64] = 0x02,[0x65] = 0xA3,[0x66] = 0xEF,[0x67] = 0x54,[0x68] = 0xB4,
		    [0x69] = 0xBF,[0x6A] = 0x03,[0x6B] = 0xFB,[0x6C] = 0x21,[0x6D] = 0x5B,[0x6E] = 0x2C,[0x6F] = 0x65,[0x70] = 0x41,
		    [0x71] = 0x01,[0x72] = 0xF4,[0x73] = 0x50,[0x74] = 0x7F,[0x75] = 0x82,[0x76] = 0x53,[0x77] = 0x15,[0x78] = 0xD1,
		    [0x79] = 0x07,[0x7A] = 0xEE,[0x7B] = 0x93,[0x7C] = 0xFD,[0x7D] = 0xA8,[0x7E] = 0x45,[0x7F] = 0x84,[0x80] = 0x23,
		    [0x81] = 0x0D,[0x82] = 0xA5,[0x83] = 0xB2,[0x84] = 0x22,[0x85] = 0x56,[0x86] = 0xA2,[0x87] = 0x3E,[0x88] = 0x31,
		    [0x89] = 0xE9,[0x8A] = 0x36,[0x8B] = 0x9B,[0x8C] = 0xE6,[0x8D] = 0x78,[0x8E] = 0x48,[0x8F] = 0x69,[0x90] = 0xD3,
		    [0x91] = 0x92,[0x92] = 0xD0,[0x93] = 0x79,[0x94] = 0x1D,[0x95] = 0xF3,[0x96] = 0x59,[0x97] = 0x94,[0x98] = 0x72,
		    [0x99] = 0xF0,[0x9A] = 0x9D,[0x9B] = 0x8C,[0x9C] = 0xB1,[0x9D] = 0x19,[0x9E] = 0x27,[0x9F] = 0x6B,[0xA0] = 0xD4,
		    [0xA1] = 0xC9,[0xA2] = 0x00,[0xA3] = 0x18,[0xA4] = 0xF1,[0xA5] = 0x0F,[0xA6] = 0x25,[0xA7] = 0x3C,[0xA8] = 0x5A,
		    [0xA9] = 0x14,[0xAA] = 0x86,[0xAB] = 0xAB,[0xAC] = 0x44,[0xAD] = 0xE0,[0xAE] = 0xF9,[0xAF] = 0x9E,[0xB0] = 0xAC,
		    [0xB1] = 0x2D,[0xB2] = 0xD2,[0xB3] = 0xC7,[0xB4] = 0x7A,[0xB5] = 0x1A,[0xB6] = 0x35,[0xB7] = 0xB3,[0xB8] = 0x9A,
		    [0xB9] = 0x17,[0xBA] = 0xFF,[0xBB] = 0x6F,[0xBC] = 0x8E,[0xBD] = 0xDC,[0xBE] = 0x4E,[0xBF] = 0x51,[0xC0] = 0x0B,
		    [0xC1] = 0xC3,[0xC2] = 0x7B,[0xC3] = 0xE3,[0xC4] = 0xB9,[0xC5] = 0x64,[0xC6] = 0x6E,[0xC7] = 0xF5,[0xC8] = 0xCF,
		    [0xC9] = 0xC4,[0xCA] = 0x80,[0xCB] = 0x91,[0xCC] = 0x8A,[0xCD] = 0xBE,[0xCE] = 0x96,[0xCF] = 0x95,[0xD0] = 0x3B,
		    [0xD1] = 0x68,[0xD2] = 0xEB,[0xD3] = 0xFC,[0xD4] = 0x58,[0xD5] = 0x8B,[0xD6] = 0x0C,[0xD7] = 0x1E,[0xD8] = 0x43,
		    [0xD9] = 0xD8,[0xDA] = 0x4B,[0xDB] = 0xBB,[0xDC] = 0xAD,[0xDD] = 0x29,[0xDE] = 0xE7,[0xDF] = 0x13,[0xE0] = 0x6C,
		    [0xE1] = 0x9F,[0xE2] = 0x49,[0xE3] = 0xB0,[0xE4] = 0x1F,[0xE5] = 0x2A,[0xE6] = 0x7D,[0xE7] = 0xDF,[0xE8] = 0x3F,
		    [0xE9] = 0x66,[0xEA] = 0xCB,[0xEB] = 0x39,[0xEC] = 0xC0,[0xED] = 0x08,[0xEE] = 0x4C,[0xEF] = 0xED,[0xF0] = 0xA0,
		    [0xF1] = 0x71,[0xF2] = 0xB7,[0xF3] = 0x37,[0xF4] = 0x60,[0xF5] = 0x32,[0xF6] = 0x67,[0xF7] = 0x77,[0xF8] = 0x8D,
		    [0xF9] = 0x52,[0xFA] = 0x75,[0xFB] = 0xB6,[0xFC] = 0x20,[0xFD] = 0xD7,[0xFE] = 0xC8,[0xFF] = 0x6A,[0x00] = 0x57,
		}
	end

	function initFunctions()
		--
		--SPELL LEVELUPS
		--
		self.spellLevel["5.22.0.289"] = (function (id)
		  	local offsets = {
		  	  	[_Q] = 0xB8,
		  	  	[_W] = 0xBA,
		  	  	[_E] = 0x79,
		  	  	[_R] = 0x7B,
		  	}
		  	local p = CLoLPacket(0x0050)
		  	p.vTable = 0xF38DAC
		  	p:EncodeF(myHero.networkID)
		  	p:Encode1(offsets[id])
		  	p:Encode1(0x3C)
		  	for i = 1, 4 do p:Encode1(0xF6) end
		  	for i = 1, 4 do p:Encode1(0x5E) end
		  	for i = 1, 4 do p:Encode1(0xE0) end
		  	p:Encode1(0x24)
		  	p:Encode1(0xF1)
		  	p:Encode1(0x27)
		  	p:Encode1(0x00)
		  	SendPacket(p)
		end)

		self.spellLevel["5.21"] = (function (id)
		  	local offsets = {
		   [_Q] = 0x85,
		   [_W] = 0x45,
		   [_E] = 0x15,
		   [_R] = 0xC5,
		   }
		   local p
		   p = CLoLPacket(0x130)
		   p.vTable = 0xEDB360
		   p:EncodeF(myHero.networkID)
		   for i = 1, 4 do p:Encode1(0x55) end
		   for i = 1, 4 do p:Encode1(0x74) end
		   p:Encode1(offsets[id])
		   p:Encode1(0xB3)
		   for i = 1, 4 do p:Encode1(0x4F) end
		   p:Encode1(0x01)
		   for i = 1, 3 do p:Encode1(0x00) end
		   SendPacket(p)
		end)
	    --
		--BUY ITEMS
		--
		self.buyItem["5.22.0.289"] = (function (id)
   			local rB = {}
			for i=0, 255 do rB[self:getTableByte(i)] = i end
			local p = CLoLPacket(0x11F)
			p.vTable = 0xDD25B4
			p:EncodeF(myHero.networkID)
			local b1 = bit32.lshift(bit32.band(rB[bit32.band(bit32.rshift(bit32.band(id,0xFFFF),24),0xFF)],0xFF),24)
			local b2 = bit32.lshift(bit32.band(rB[bit32.band(bit32.rshift(bit32.band(id,0xFFFFFF),16),0xFF)],0xFF),16)
			local b3 = bit32.lshift(bit32.band(rB[bit32.band(bit32.rshift(bit32.band(id,0xFFFFFFFF),8),0xFF)],0xFF),8)
			local b4 = bit32.band(rB[bit32.band(id ,0xFF)],0xFF)
			p:Encode4(bit32.bxor(b1,b2,b3,b4))
			p:Encode4(0x2B8D2CCF)
			SendPacket(p)
		end)
	end

	function packet:getTableByte(i)
		return self.idBytes[self.version][i]
	end
class 'ai'
	function ai:__init()
		self.state = {}

		return self
	end
class 'chat'
	function chat:__init()
		self.working = true

		if self.working then
			AddTickCallback(function()
				self:traceChats()
			end)
		end
		return self
	end

	function chat:traceChats()

	end



------------- 
--Champions--
-------------
class 'Default'
class 'Vayne'
  	function Vayne:__init()
  	end

  	function Vayne:Load()
	    --self:Menu()
	    self.roll = false
	    require("VPrediction") 
      	VP = VPrediction()
  	end

	  function Vayne:Menu()
	    Config.Combo:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
	    Config.Combo:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
	    Config.Combo:addParam("R", "Use R -> Stun", SCRIPT_PARAM_ONOFF, true)
	    Config.Combo:addParam("Rtf", "Use Rtf", SCRIPT_PARAM_ONOFF, true)
	    Config.Combo:addParam("Re", "-> X Enemies Around", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
	    Config.Combo:addParam("Ra", "-> X Allies Around", SCRIPT_PARAM_SLICE, 1, 0, 5, 0)
	    Config.Harass:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
	    Config.Harass:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
	    Config.LaneClear:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
	    Config.LaneClear:addParam("E", "Use E (jungle)", SCRIPT_PARAM_ONOFF, true)
	    Config.Killsteal:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
	    Config.Killsteal:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
	    if Ignite ~= nil then Config.Killsteal:addParam("I", "Ignite", SCRIPT_PARAM_ONOFF, true) end
	    Config.Harass:addParam("manaQ", "Mana Q", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
	    Config.Harass:addParam("manaE", "Mana E", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
	    Config.LaneClear:addParam("manaQ", "Mana Q", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
	    Config.LaneClear:addParam("manaE", "Mana E", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
	    --AI.state:addDynamicParam("Combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	    --AI.state:addDynamicParam("Harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	    --AI.state:addDynamicParam("LastHit", "Last hit", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	    --AI.state:addDynamicParam("LaneClear", "Lane Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
	    Config.Misc:addParam("offsetE", "Max E range %", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)
	    AddGapcloseCallback(_E, 500, true, Config.Misc)
	  end

	  function Vayne:Draw()
	    if not sReady[_E] then return end
	    for k,enemy in pairs(GetEnemyHeroes()) do
	      if enemy and enemy.visible and not enemy.dead and enemy.bTargetable then
	        local pos1 = enemy
	        local pos2 = enemy - (Vector(myHero) - enemy):normalized()*(450*Config.Misc.offsetE/100)
	        local a = WorldToScreen(D3DXVECTOR3(pos1.x, pos1.y, pos1.z))
	        local b = WorldToScreen(D3DXVECTOR3(pos2.x, pos2.y, pos2.z))
	        if OnScreen(a.x, a.y, a.z) and OnScreen(b.x, b.y, b.z) then
	          DrawLine(a.x, a.y, b.x, b.y, 1, 0xFFFFFFFF)
	          DrawCircle(pos2.x, pos2.y, pos2.z, 50, 0xFFFFFFFF)
	        end
	      end
	    end
  	end

	  function Vayne:Tick()
	    self.roll = (AI.state.Combo and Config.Combo.Q) or (AI.state.Harass and Config.Harass.Q and Config.Harass.manaQ/100 < myHero.mana/myHero.maxMana) or (AI.state.LastHit and Config.LastHit.Q and Config.LastHit.manaQ/100 < myHero.mana/myHero.maxMana) or (AI.state.LaneClear and Config.LaneClear.Q and Config.LaneClear.manaQ/100 < myHero.mana/myHero.maxMana)
	    if not sReady[_E] then return end
	    for k,enemy in pairs(GetEnemyHeroes()) do
	      if ValidTarget(enemy, 650) then
	        self:MakeUnitHugTheWall(enemy)
	      end
	    end
	  end

	  function Vayne:ProcessAttack(unit, spell)
	    if unit and spell and unit.isMe and spell.name then
	      if spell.name:lower():find("attack") then
	        if self.roll and sReady[_Q] then
	          CastSpell(_Q, mousePos.x, mousePos.z)
	        end
	        if spell.target and spell.target.type == myHero.type and Config.Killsteal.E and sReady[_E] and EnemiesAround(spell.target, 750) == 1 and GetRealHealth(spell.target) < GetDmg(_E, myHero, spell.target)+GetDmg("AD", myHero, spell.target)+(GetStacks(spell.target) >= 1 and GetDmg(_W, myHero, spell.target) or 0) and GetDistance(spell.target) < 650 then
	          local t = spell.target
	          CastSpell(_E, spell.target)
	        end
	      end
	    end
	  end

	  function Vayne:MakeUnitHugTheWall(unit)
	    if not unit or unit.dead or not unit.visible or GetDistanceSqr(unit) > 650*650 or not sReady[_E] then return end
	    local x, y = VP:CalculateTargetPosition(unit, myHeroSpellData[2].delay, myHeroSpellData[2].width, myHeroSpellData[2].speed, myHero)
	    for _=0,(450)*Config.Misc.offsetE/100,(450/25)*Config.Misc.offsetE/100 do
	      local dir = x+(Vector(x)-myHero):normalized()*_
	      if IsWall(D3DXVECTOR3(dir.x,dir.y,dir.z)) then
	        CastSpell(_E, unit)
	        return true
	      end
	    end
	    return false
	  end

	  function Vayne:LaneClear()
	    target = GetJMinion(myHeroSpellData[2].range)
	    if sReady[_E] and target and target.team > 200 and Config.LaneClear.E and Config.LaneClear.manaQ/100 < myHero.mana/myHero.maxMana then
	      self:MakeUnitHugTheWall(target)
	    end
	  end

	  function Vayne:Combo()
	    if Config.Combo.E and sReady[_E] then
	      if self:MakeUnitHugTheWall(Target) and Config.Combo.R then
	        Cast(_R)
	      end
	    else
	      if Config.Combo.R and GetDistance(Target) < 450 then
	        Cast(_R)
	      end
	    end
	    if Config.Combo.Rtf and EnemiesAround(myHero, 750) >= Config.Combo.Re and AlliesAround(myHero, 750) >= Config.Combo.Ra then
	      Cast(_R)
	    end
	  end

	  function Vayne:Harass()
	    if sReady[_E] and Config.Harass.E and Config.Harass.manaE <= 100*myHero.mana/myHero.maxMana then
	      self:MakeUnitHugTheWall(Target)
	    end
	  end

  	function Vayne:Killsteal()
	    for k,enemy in pairs(GetEnemyHeroes()) do
	      if enemy and not enemy.dead and enemy.visible and enemy.bTargetable then
	        local health = GetRealHealth(enemy)
	        if sReady[_Q] and health < GetDmg(_Q, myHero, enemy)+GetDmg("AD", myHero, enemy)+(GetStacks(enemy) == 2 and GetDmg(_W, myHero, enemy) or 0) and Config.Killsteal.Q and ValidTarget(enemy, myHeroSpellData[0].range + myHero.range) then
	          Cast(_Q, enemy.pos)
	          DelayAction(function() myHero:Attack(enemy) end, 0.25)
	        elseif sReady[_E] and self.HP and self.HP:PredictHealth(enemy, (min(myHeroSpellData[2].range, GetDistance(myHero, enemy)) / (2000) + 0.25)) < GetDmg(_E, myHero, enemy)+(GetStacks(enemy) == 2 and GetDmg(_W, myHero, enemy) or 0) and Config.Killsteal.E and ValidTarget(enemy, myHeroSpellData[2].range) then
	          CastSpell(_E, enemy)
	        elseif sReady[_E] and health < GetDmg(_E, myHero, enemy)+(GetStacks(enemy) == 2 and GetDmg(_W, myHero, enemy) or 0) and Config.Killsteal.E and ValidTarget(enemy, myHeroSpellData[2].range) then
	          CastSpell(_E, enemy)
	        elseif sReady[_E] and health < GetDmg(_E, myHero, enemy)*2+(GetStacks(enemy) == 2 and GetDmg(_W, myHero, enemy) or 0) and Config.Killsteal.E and ValidTarget(enemy, myHeroSpellData[2].range) then
	          self:MakeUnitHugTheWall(enemy)
	        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and health < (50 + 20 * myHero.level) and Config.Killsteal.I and ValidTarget(enemy, 600) then
	          CastSpell(Ignite, enemy)
	        end
	      end
	    end
  	end --BUNU BITIR ORNEK BIRSEYIN OLSUN


------------------
--Scriptlog Bones-
------------------
function StartBones()
	SetupTargetSelector()
	InitVars()
	AddPluginTicks()
end


function SetupTargetSelector()
    targetSel = TargetSelector(TARGET_LESS_CAST, 1250, DAMAGE_MAGIC, false, true)
    ArrangeTSPriorities()
end

function InitVars()
	sReady = {}
	stackTable = {}
	for _=0, 3 do
		sReady[_] = myHero:CanUseSpell(_) == 0
	end
	buffStackTrackList = { ["Darius"] = "dariushemo", ["Kalista"] = "kalistaexpungemarker", ["TahmKench"] = "tahmpassive", ["Tristana"] = "tristanaecharge", ["Vayne"] = "vaynesilvereddebuff" }
	if buffStackTrackList[myHero.charName] then
		buffToTrackForStacks = buffStackTrackList[myHero.charName]
	end
	killTable = {}
	for i, enemy in pairs(GetEnemyHeroes()) do
		killTable[enemy.networkID] = {0, 0, 0, 0, 0, 0}
	end
	killDrawTable = {}
	for i, enemy in pairs(GetEnemyHeroes()) do
		killDrawTable[enemy.networkID] = {}
	end
	colors = { 0xDFFFE258, 0xDF8866F4, 0xDF55F855, 0xDFFF5858 }
	gapcloserTable = {
		["Aatrox"] = _Q, ["Akali"] = _R, ["Alistar"] = _W, ["Ahri"] = _R, ["Amumu"] = _Q, ["Corki"] = _W,
		["Diana"] = _R, ["Elise"] = _Q, ["Elise"] = _E, ["Fiddlesticks"] = _R, ["Fiora"] = _Q,
		["Fizz"] = _Q, ["Gnar"] = _E, ["Grags"] = _E, ["Graves"] = _E, ["Hecarim"] = _R,
		["Irelia"] = _Q, ["JarvanIV"] = _Q, ["Jax"] = _Q, ["Jayce"] = "JayceToTheSkies", ["Katarina"] = _E, 
		["Kassadin"] = _R, ["Kennen"] = _E, ["KhaZix"] = _E, ["Lissandra"] = _E, ["LeBlanc"] = _W, 
		["LeeSin"] = "blindmonkqtwo", ["Leona"] = _E, ["Lucian"] = _E, ["Malphite"] = _R, ["MasterYi"] = _Q, 
		["MonkeyKing"] = _E, ["Nautilus"] = _Q, ["Nocturne"] = _R, ["Olaf"] = _R, ["Pantheon"] = _W, 
		["Poppy"] = _E, ["RekSai"] = _E, ["Renekton"] = _E, ["Riven"] = _Q, ["Sejuani"] = _Q, 
		["Sion"] = _R, ["Shen"] = _E, ["Shyvana"] = _R, ["Talon"] = _E, ["Thresh"] = _Q, 
		["Tristana"] = _W, ["Tryndamere"] = "Slash", ["Udyr"] = _E, ["Volibear"] = _Q, ["Vi"] = _Q, 
		["XinZhao"] = _E, ["Yasuo"] = _E, ["Zac"] = _E, ["Ziggs"] = _W
	}
end

function AddPluginTicks()
		tickTable = {
      function() 
        targetSel:update()
        if ValidTarget(Forcetarget) then
          Target = Forcetarget
        elseif _G.MMA_Loaded and _G.MMA_Target() and _G.MMA_Target().type == myHero.type then 
          Target = _G.MMA_Target()
        elseif _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then 
          Target = _G.AutoCarry.Attack_Crosshair.target
        elseif _G.NebelwolfisOrbWalkerLoaded and _G.NebelwolfisOrbWalker:GetTarget() and _G.NebelwolfisOrbWalker:GetTarget().type == myHero.type then 
          Target = _G.NebelwolfisOrbWalker:GetTarget()
        else
          Target = targetSel.target
        end
      end,
      function()
        if CHAMPION.CalculateDamage then
          CHAMPION:CalculateDamage()
        else
          CalculateDamage()
        end
      end
      }
      if CHAMPION.Combo then
        table.insert(tickTable,
          function()
            if AI.state.Combo and (ValidTarget(Target) or myHero.charName == "Ryze") then
              CHAMPION:Combo()
            end
          end
        )
      end
      if CHAMPION.Harass then
        table.insert(tickTable,
          function()
            if AI.state.Harass and ValidTarget(Target) then
              CHAMPION:Harass()
            end
          end
        )
      end
      if CHAMPION.LaneClear then
        table.insert(tickTable,
          function()
            if AI.state.LaneClear then
              CHAMPION:LaneClear()
            end
          end
        )
      end
      if CHAMPION.LastHit then
        table.insert(tickTable,
        function()
          if AI.state.LastHit or AI.state.LaneClear then
            CHAMPION:LastHit()
          end
        end
        )
      end
      if CHAMPION.Tick and CHAMPION.Killsteal then
        table.insert(tickTable,
        function()
          if CHAMPION.Tick then 
            CHAMPION:Tick() 
          end
          if CHAMPION.Killsteal then 
            CHAMPION:Killsteal() 
          end
        end
        )
      elseif CHAMPION.Killsteal then
        table.insert(tickTable,
        function()
          if CHAMPION.Killsteal then 
            CHAMPION:Killsteal() 
          end
        end
        )
      elseif CHAMPION.Tick then
        table.insert(tickTable,
        function()
          if CHAMPION.Tick then 
            CHAMPION:Tick() 
          end
        end
        )
      end
      gTick=0;cTick=0;AddTickCallback(function() 
        local time = os.clock()
        if gTick < time then
          gTick = time + 0.025
          cTick = cTick + 1
          if cTick > #tickTable then cTick = 1 end
          tickTable[cTick]()
        end
        CalculateDamageOffsets()
      end)
		AddTickCallback(function();for _=0,3 do;sReady[_]=(myHero:CanUseSpell(_)==READY);end;end)
      	if buffToTrackForStacks then
        AddApplyBuffCallback(function(unit, source, buff)
          if unit and buff and unit.team ~= myHero.team and buff.name:lower() == buffToTrackForStacks then
            stackTable[unit.networkID] = 1
          end
        end)
        AddUpdateBuffCallback(function(unit, buff, stacks)
          if unit and buff and stacks and unit.team ~= myHero.team and buff.name:lower() == buffToTrackForStacks then
            stackTable[unit.networkID] = stacks
          end
        end)
        AddRemoveBuffCallback(function(unit, buff)
          if unit and buff and unit.team ~= myHero.team and buff.name:lower() == buffToTrackForStacks then
            stackTable[unit.networkID] = 0
          end
        end)
      end
      if CHAMPION.ApplyBuff ~= nil then
        AddApplyBuffCallback(function(unit, source, buff)
          CHAMPION:ApplyBuff(unit, source, buff)
        end)
      end
      if CHAMPION.UpdateBuff ~= nil then
        AddUpdateBuffCallback(function(unit, buff, stacks)
          CHAMPION:UpdateBuff(unit, buff, stacks)
        end)
      end
      if CHAMPION.RemoveBuff ~= nil then
        AddRemoveBuffCallback(function(unit, buff)
          CHAMPION:RemoveBuff(unit, buff)
        end)
      end
      if CHAMPION.ProcessAttack ~= nil then
        AddProcessAttackCallback(function(unit, spell)
          CHAMPION:ProcessAttack(unit, spell)
        end)
      end
      if CHAMPION.ProcessSpell ~= nil then
        AddProcessSpellCallback(function(unit, spell)
          CHAMPION:ProcessSpell(unit, spell)
        end)
      end
      if CHAMPION.Animation ~= nil then
        AddAnimationCallback(function(unit, ani)
          CHAMPION:Animation(unit, ani)
        end)
      end
      if CHAMPION.CreateObj ~= nil then
        AddCreateObjCallback(function(obj)
          CHAMPION:CreateObj(obj)
        end)
      end
      if CHAMPION.DeleteObj ~= nil then
        AddDeleteObjCallback(function(obj)
          CHAMPION:DeleteObj(obj)
        end)
      end
      if CHAMPION.IssueOrder ~= nil then
        AddIssueOrderCallback(function(source, order, position, target) 
          CHAMPION:IssueOrder(source, order, position, target) 
        end)
      end
      if CHAMPION.WndMsg ~= nil then
        AddMsgCallback(function(msg, key)
          CHAMPION:WndMsg(msg, key)
        end)
      end
      if CHAMPION.Msg ~= nil then
        AddMsgCallback(function(msg, key)
          CHAMPION:Msg(msg, key)
        end)
      end
      if CHAMPION.Draw ~= nil and debugMode then
        AddDrawCallback(function()
          CHAMPION:Draw()
        end)
      end
      if CHAMPION.Load ~= nil then
        CHAMPION:Load()
      end
    end


function ArrangeTSPriorities()
    local priorityTable2 = {
      p5 = {"Alistar", "Amumu", "Blitzcrank", "Braum", "ChoGath", "DrMundo", "Garen", "Gnar", "Hecarim", "JarvanIV", "Leona", "Lulu", "Malphite", "Nasus", "Nautilus", "Nunu", "Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Taric", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac"},
      p4 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gangplank", "Gragas", "Irelia", "Jax","LeeSin", "Maokai", "Morgana", "Nocturne", "Pantheon", "Poppy", "Rengar", "Rumble", "Ryze", "Swain","Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai"},
      p3 = {"Akali", "Diana", "Fiddlesticks", "Fiora", "Fizz", "Heimerdinger", "Janna", "Jayce", "Kassadin","Kayle", "KhaZix", "Lissandra", "Mordekaiser", "Nami", "Nidalee", "Riven", "Shaco", "Sona", "Soraka", "TahmKench", "Vladimir", "Yasuo", "Zilean", "Zyra"},
      p2 = {"Ahri", "Anivia", "Annie",  "Brand",  "Cassiopeia", "Ekko", "Karma", "Karthus", "Katarina", "Kennen", "LeBlanc",  "Lux", "Malzahar", "MasterYi", "Orianna", "Syndra", "Talon", "TwistedFate", "Veigar", "VelKoz", "Viktor", "Xerath", "Zed", "Ziggs" },
      p1 = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "KogMaw", "Lucian", "MissFortune", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Varus", "Vayne"},
    }
    local mixed = Set {"Akali","Corki","Evelynn","Ezreal","Kayle","KogMaw","Mordekaiser","Poppy","Skarner","Teemo","Tristana","Yorick"}
    local ad = Set {"Aatrox","Darius","Draven","Ezreal","Fiora","Gangplank","Garen","Gnar","Graves","Hecarim","Irelia","JarvanIV","Jax","Jayce","Jinx","Kalista","KhaZix","LeeSin","Lucian","MasterYi","MissFortune","Nasus","Nocturne","Olaf","Pantheon","Quinn","RekSai","Renekton","Rengar","Riven","Shaco","Shyvana","Sion","Sivir","Talon","Trundle","Tryndamere","Twitch","Udyr","Urgot","Varus","Vayne","Vi","Warwick","Wukong","XinZhao","Yasuo","Zed"}
    local ap = Set {"Ahri","Alistar","Amumu","Anivia","Annie","Azir","Bard","Blitzcrank","Brand","Braum","Cassiopeia","ChoGath","Diana","DrMundo","Ekko","Elise","Fiddlesticks","Fizz","Galio","Gragas","Heimerdinger","Janna","Karma","Karthus","Kassadin","Katarina","Kennen","LeBlanc","Leona","Lissandra","Lulu","Lux","Malphite","Malzahar","Maokai","Morgana","Nami","Nautilus","Nidalee","Nunu","Orianna","Rammus","Rumble","Ryze","Sejuani","Shen","Singed","Sona","Soraka","Swain","Syndra","TahmKench","Taric","Thresh","TwistedFate","Veigar","VelKoz","Viktor","Vladimir","Volibear","Xerath","Zac","Ziggz","Zilean","Zyra"}
    targetSel:SetDamages((ad[myHero.charName] or mixed[myHero.charName]) and 100 or 0, (ap[myHero.charName] or mixed[myHero.charName]) and 100 or 0, 0)
    do
      local r = 0
      for i=0, 3 do
        if myHeroSpellData[i] and (myHeroSpellData[i].dmgAP or myHeroSpellData[i].dmgAD or myHeroSpellData[i].dmgTRUE) then
          if myHeroSpellData[i].range and myHeroSpellData[i].range > 0 then
            if myHeroSpellData[i].range > r and myHeroSpellData[i].range < 2000 then
              r = myHeroSpellData[i].range
            end
          elseif myHeroSpellData[i].width and myHeroSpellData[i].width > 0 then
            if myHeroSpellData[i].width > r then
              r = myHeroSpellData[i].width
            end
          end
        end
      end
      targetSel.range = max(r, myHero.range+myHero.boundingRadius)
      print("System is loaded with settings of " .. myHero.charName .. ", calculated range:" .. targetSel.range)
    end
    local priorityOrder = {
      [1] = {1,1,1,1,1},
      [2] = {1,1,2,2,2},
      [3] = {1,1,2,3,3},
      [4] = {1,2,3,4,4},
      [5] = {1,2,3,4,5},
    }
    local function _SetPriority(table, hero, priority)
      if table ~= nil and hero ~= nil and priority ~= nil and type(table) == "table" then
        for i=1, #table, 1 do
          if hero.charName:find(table[i]) ~= nil and type(priority) == "number" then
            TS_SetHeroPriority(priority, hero.charName)
          end
        end
      end
    end
    local enemies = #GetEnemyHeroes()
    if priorityTable2~=nil and type(priorityTable2) == "table" and enemies > 0 then
      for i, enemy in ipairs(GetEnemyHeroes()) do
        _SetPriority(priorityTable2.p1, enemy, min(1, #GetEnemyHeroes()))
        _SetPriority(priorityTable2.p2, enemy, min(2, #GetEnemyHeroes()))
        _SetPriority(priorityTable2.p3,  enemy, min(3, #GetEnemyHeroes()))
        _SetPriority(priorityTable2.p4,  enemy, min(4, #GetEnemyHeroes()))
        _SetPriority(priorityTable2.p5,  enemy, min(5, #GetEnemyHeroes()))
      end
    end
end

function CalculateDamageOffsets()
    for i, enemy in pairs(GetEnemyHeroes()) do
      local nextOffset = 0
      local barPos = GetUnitHPBarPos(enemy)
      local barOffset = GetUnitHPBarOffset(enemy)
      pos = {x = barPos.x - 67 + barOffset.x * 150, y = barPos.y + barOffset.y * 50 - 4}
      local totalDmg = 0
      killDrawTable[enemy.networkID] = {}
      for _, dmg in pairs(killTable[enemy.networkID]) do
        if dmg > 0 then
          local perc1 = dmg / enemy.maxHealth
          local perc2 = totalDmg / enemy.maxHealth
          totalDmg = totalDmg + dmg
          local offs = 1-(enemy.maxHealth - enemy.health) / enemy.maxHealth
          killDrawTable[enemy.networkID][_] = {
          offs*105+pos.x-perc2*105, pos.y, -perc1*105, 9, colors[_],
          str[_-1], 15, offs*105+pos.x-perc1*105-perc2*105, pos.y-20, colors[_]
          }
        else
          killDrawTable[enemy.networkID][_] = {}
        end
      end
    end
end

function CalculateDamage()
    for i, enemy in pairs(GetEnemyHeroes()) do
      if enemy and not enemy.dead and enemy.visible and enemy.bTargetable then
        local damageQ = myHero:CanUseSpell(_Q) ~= READY and 0 or myHero.charName == "Kalista" and 0 or GetDmg(_Q, myHero, enemy) or 0
        local damageW = myHero:CanUseSpell(_W) ~= READY and 0 or GetDmg(_W, myHero, enemy) or 0
        local damageE = myHero:CanUseSpell(_E) ~= READY and 0 or GetDmg(_E, myHero, enemy) or 0
        local damageR = myHero:CanUseSpell(_R) ~= READY and 0 or GetDmg(_R, myHero, enemy) or 0
        killTable[enemy.networkID] = {damageQ, damageW, damageE, damageR}
      end
    end
end


---------------
--Spell Data---
---------------
spellData = {
	["Aatrox"] = {
		[_Q] = { name = "AatroxQ", speed = 450, delay = 0.25, range = 650, width = 150, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "AatroxE", speed = 1200, delay = 0.25, range = 1000, width = 150, collision = false, aoe = false, type = "linear"}
	},
	["Ahri"] = {
		[_Q] = { name = "AhriOrbofDeception", speed = 2500, delay = 0.25, range = 975, width = 100, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 15+25*source:GetSpellData(_Q).level+0.35*source.ap end},
		[_W] = { name = "AhriFoxFire", range = 700, dmgAP = function(source, target) return 15+25*source:GetSpellData(_W).level+0.4*source.ap end},
		[_E] = { name = "AhriSeduce", speed = 1550, delay = 0.25, range = 1075, width = 65, collision = true, aoe = false, type = "linear", dmgAP = function(source, target) return 25+35*source:GetSpellData(_E).level+0.5*source.ap end},
		[_R] = { name = "AhriTumble", range = 450, dmgAP = function(source, target) return 40*source:GetSpellData(_R).level+30+0.3*source.ap end}
	},
	["Akali"] = {
		[_E] = { name = "", speed = math.huge, delay = 0.125, range = 0, width = 325, collision = false, aoe = true, type = "circular"}
	},
	["Alistar"] = {
		[_Q] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 365, collision = false, aoe = true, type = "circular"}
	},
	["Amumu"] = {
		[_Q] = { name = "BandageToss", speed = 725, delay = 0.25, range = 1000, width = 100, collision = true, aoe = false, type = "linear"}
	},
	["Anivia"] = {
		[_Q] = { name = "FlashFrostSpell", speed = 850, delay = 0.250, range = 1200, width = 110, collision = false, aoe = false, type = "linear"},
		[_R] = { name = "", speed = math.huge, delay = 0.100, range = 615, width = 350, collision = false, aoe = true, type = "circular"}
	},
	["Annie"] = {
		[_Q] = { name = "Disintegrate" },
		[_W] = { name = "Incinerate", speed = math.huge, delay = 0.25, range = 625, width = 250, collision = false, aoe = true, type = "cone"},
		[_E] = { name = "MoltenShield" },
		[_R] = { name = "InfernalGuardian", speed = math.huge, delay = 0.25, range = 600, width = 300, collision = false, aoe = true, type = "circular"}
	},
	["Ashe"] = {
		[_Q] = { range = 700, dmgAD = function(source, target) return (0.05*source:GetSpellData(_Q).level+1.1)*source.totalDamage end},
		[_W] = { name = "Volley", speed = 902, delay = 0.25, range = 1200, width = 100, collision = true, aoe = false, type = "cone", dmgAD = function(source, target) return 10*source:GetSpellData(_W).level+30+source.totalDamage end},
		[_E] = { speed = 1500, delay = 0.5, range = 25000, width = 1400, collision = false, aoe = false, type = "linear"},
		[_R] = { name = "EnchantedCrystalArrow", speed = 1600, delay = 0.5, range = 25000, width = 100, collision = true, aoe = false, type = "linear", dmgAP = function(source, target) return 175*source:GetSpellData(_R).level+75+source.ap end}
	},
	["Azir"] = {
		[_Q] = { name = "AzirQ", speed = 2500, delay = 0.250, range = 880, width = 100, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 15+25*source:GetSpellData(_Q).level+0.35*source.ap end},
		[_W] = { name = "AzirW", range = 520, dmgAP = function(source, target) return 15+25*source:GetSpellData(_W).level+0.4*source.ap end},
		[_E] = { name = "AzirE", range = 1100, delay = 0.25, speed = 1200, width = 60, collision = true, aoe = false, type = "linear", dmgAP = function(source, target) return 25+35*source:GetSpellData(_E).level+0.5*source.ap end},
		[_R] = { name = "AzirR", speed = 1300, delay = 0.2, range = 520, width = 600, collision = false, aoe = true, type = "linear", dmgAP = function(source, target) return 40*source:GetSpellData(_R).level+30+0.3*source.ap end}
	},
	["Bard"] = {
		[_Q] = { name = "", speed = 1100, delay = 0.25, range = 850, width = 108, collision = true, aoe = false, type = "linear"}
	},
	["Blitzcrank"] = {
		[_Q] = { name = "RocketGrabMissile", speed = 1800, delay = 0.250, range = 900, width = 70, collision = true, type = "linear", dmgAP = function(source, target) return 55*source:GetSpellData(_Q).level+25+source.ap end},
		[_W] = { name = "", range = 2500},
		[_E] = { name = "", range = 225, dmgAD = function(source, target) return 2*source.totalDamage end},
		[_R] = { name = "StaticField", speed = math.huge, delay = 0.25, range = 0, width = 500, collision = false, aoe = false, type = "circular", dmgAP = function(source, target) return 125*source:GetSpellData(_R).level+125+source.ap end}
	},
	["Brand"] = {
		[_Q] = { name = "BrandBlaze", speed = 1200, delay = 0.25, range = 1050, width = 80, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 40*source:GetSpellData(_Q).level+40+0.65*source.ap end},
		[_W] = { name = "BrandFissure", speed = math.huge, delay = 0.625, range = 1050, width = 275, collision = false, aoe = false, type = "circular", dmgAP = function(source, target) return 45*source:GetSpellData(_W).level+30+0.6*source.ap end},
		[_E] = { name = "", range = 625, dmgAP = function(source, target) return 25*source:GetSpellData(_E).level+30+0.55*source.ap end},
		[_R] = { name = "BrandWildfire", range = 750, dmgAP = function(source, target) return 100*source:GetSpellData(_R).level+50+0.5*source.ap end}
	},
	["Braum"] = {
		[_Q] = { name = "BraumQ", speed = 1600, delay = 0.25, range = 1000, width = 100, collision = false, aoe = false, type = "linear"},
		[_R] = { name = "BraumR", speed = 1250, delay = 0.5, range = 1250, width = 0, collision = false, aoe = false, type = "linear"}
	},
	["Caitlyn"] = {
		[_Q] = { name = "CaitlynPiltoverPeacemaker", speed = 2200, delay = 0.625, range = 1300, width = 0, collision = false, aoe = false, type = "linear"},
		[_E] = { name = "CaitlynEntrapment", speed = 2000, delay = 0.400, range = 1000, width = 80, collision = false, aoe = false, type = "linear"},
		[_R] = { name = "CaitlynAceintheHole" }
	},
	["Cassiopeia"] = {
		[_Q] = { name = "CassiopeiaNoxiousBlast", speed = math.huge, delay = 0.75, range = 850, width = 100, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 45+30*source:GetSpellData(_Q).level+0.45*source.ap end},
		[_W] = { name = "CassiopeiaMiasma", speed = 2500, delay = 0.5, range = 925, width = 90, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 5+5*source:GetSpellData(_W).level+0.1*source.ap end},
		[_E] = { name = "CassiopeiaTwinFang", range = 700, dmgAP = function(source, target) return 30+25*source:GetSpellData(_E).level+0.55*source.ap end },
		[_R] = { name = "CassiopeiaPetrifyingGaze", speed = math.huge, delay = 0.5, range = 825, width = 410, collision = false, aoe = true, type = "cone", dmgAP = function(source, target) return 50+10*source:GetSpellData(_R).level+0.5*source.ap end}
	},
	["Chogath"] = {
		[_Q] = { name = "Rupture", speed = math.huge, delay = 0.25, range = 950, width = 300, collision = false, aoe = true, type = "circular"},
		[_W] = { name = "", speed = math.huge, delay = 0.5, range = 650, width = 275, collision = false, aoe = false, type = "linear"},
	},
	["Corki"] = {
		[_Q] = { name = "", speed = 700, delay = 0.4, range = 825, width = 250, collision = false, aoe = false, type = "circular"},
		[_R] = { name = "MissileBarrage", speed = 2000, delay = 0.200, range = 1225, width = 60, collision = false, aoe = false, type = "linear"},
	},
	["Darius"] = {
		[_Q] = { name = "", speed = math.huge, delay = 0.75, range = 450, width = 450, type = "circular", dmgAD = function(source, target) return 20*source:GetSpellData(_Q).level+(0.9 + 0.1 * source:GetSpellData(_Q).level)*source.totalDamage end},
		[_W] = { name = "", range = 275, dmgAD = function(source, target) return source.totalDamage*1.4 end},
		[_E] = { name = "", speed = math.huge, delay = 0.32, range = 570, width = 125, collision = false, aoe = true, type = "cone"},
		[_R] = { name = "", range = 460, dmgTRUE = function(source, target, stacks) return math.floor(99*source:GetSpellData(_R).level+0.749*source.addDamage+stacks*(19*source:GetSpellData(_R).level+0.149*source.addDamage)) end}
	},
	["Diana"] = {
		[_Q] = { name = "DianaArc", speed = 1500, delay = 0.250, range = 835, width = 130, collision = false, aoe = false, type = "circular", dmgAP = function(source, target) return 35*source:GetSpellData(_Q).level+45+0.2*source.ap end},
		[_W] = { name = "", range = 250, dmgAP = function(source, target) return 12*source:GetSpellData(_W).level+10+0.2*source.ap end },
		[_E] = { name = "DianaVortex", speed = math.huge, delay = 0.33, range = 0, width = 395, collision = false, aoe = false, type = "circular" },
		[_R] = { name = "", range = 825, dmgAP = function(source, target) return 60*source:GetSpellData(_R).level+40+0.6*source.ap end }
	},
	["DrMundo"] = {
		[_Q] = { name = "InfectedCleaverMissile", speed = 2000, delay = 0.250, range = 1050, width = 75, collision = true, aoe = false, type = "linear"}
	},
	["Draven"] = {
		[_E] = { name = "DravenDoubleShot", speed = 1400, delay = 0.250, range = 1100, width = 130, collision = false, aoe = false, type = "linear"},
		[_R] = { name = "DravenRCast", speed = 2000, delay = 0.5, range = 25000, width = 160, collision = false, aoe = false, type = "linear"}
	},
	["Ekko"] = {
		[_Q] = { name = "", speed = 1050, delay = 0.25, range = 925, width = 140, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 15*source:GetSpellData(_Q).level+45+0.1*source.ap end},
		[_W] = { name = "", speed = math.huge, delay = 2.5, range = 1600, width = 450, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "", delay = 0.50, range = 350, dmgAP = function(source, target) return 30*source:GetSpellData(_E).level+20+0.2*source.ap+source.totalDamage end},
		[_R] = { name = "", speed = math.huge, delay = 0.5, range = 0, width = 400, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 150*source:GetSpellData(_R).level+50+1.3*source.ap end}
	},
	["Elise"] = {
		[_E] = { name = "EliseHumanE", speed = 1450, delay = 0.250, range = 975, width = 70, collision = true, aoe = false, type = "linear"}
	},
	["Evelynn"] = {
		[_Q] = { name = "", speed = 1300, delay = 0.250, range = 650, width = 350, collision = false, aoe = true, type = "circular" }
	},
	["Ezreal"] = {
		[_Q] = { name = "EzrealMysticShot", speed = 2000, delay = 0.25, range = 1200, width = 65, collision = true, aoe = false, type = "linear", dmgAD = function(source, target) return 20*source:GetSpellData(_Q).level+15+source.totalDamage+0.4*source.ap end},
		[_W] = { name = "EzrealEssenceFlux", speed = 1200, delay = 0.25, range = 900, width = 90, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 45*source:GetSpellData(_W).level+25+0.8*source.ap end},
		[_E] = { name = "", range = 450, dmgAP = function(source, target) return 50*source:GetSpellData(_R).level+25+0.5*source.addDamage+0.75*source.ap end},
		[_R] = { name = "EzrealTrueshotBarrage", speed = 2000, delay = 1, range = 25000, width = 180, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 150*source:GetSpellData(_R).level+200+source.addDamage+0.9*source.ap end}
	},
	["Fiddlesticks"] = {
	},
	["Fiora"] = {
	},
	["Fizz"] = {
		[_R] = { name = "FizzMarinerDoom", speed = 1350, delay = 0.250, range = 1150, width = 100, collision = false, aoe = false, type = "linear"}
	},
	["Galio"] = {
		[_Q] = { name = "GalioResoluteSmite", speed = 1300, delay = 0.25, range = 900, width = 250, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "", speed = 1200, delay = 0.25, range = 1000, width = 200, collision = false, aoe = false, type = "linear"}
	},
	["Gangplank"] = {
		[_Q] = { name = "GangplankQWrapper", range = 900},
		[_E] = { name = "", speed = math.huge, delay = 0.25, range = 900, width = 250, collision = false, aoe = true, type = "circular"},
		[_R] = { name = "", speed = math.huge, delay = 0.25, range = 25000, width = 575, collision = false, aoe = true, type = "circular"}
	},
	["Garen"] = {
	},
	["Gnar"] = {
		[_Q] = { name = "", speed = 1225, delay = 0.125, range = 1200, width = 80, collision = true, aoe = false, type = "linear"}
	},
	["Gragas"] = {
		[_Q] = { name = "GragasQ", speed = 1000, delay = 0.250, range = 1000, width = 300, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "GragasE", speed = math.huge, delay = 0.250, range = 600, width = 50, collision = true, aoe = true, type = "circular"},
		[_R] = { name = "GragasR", speed = 1000, delay = 0.250, range = 1050, width = 400, collision = false, aoe = true, type = "circular"}
	},
	["Graves"] = {
		[_Q] = { name = "", speed = 1950, delay = 0.265, range = 750, width = 85, collision = false, aoe = false, type = "cone"},
		[_W] = { name = "", speed = 1650, delay = 0.300, range = 700, width = 250, collision = false, aoe = true, type = "circular"},
		[_R] = { name = "", speed = 2100, delay = 0.219, range = 1000, width = 100, collision = false, aoe = false, type = "linear"}
	},
	["Hecarim"] = {
		[_Q] = { name = "", speed = math.huge, delay = 0.250, range = 0, width = 350, collision = false, aoe = true, type = "circular"},
		[_R] = { name = "", speed = 1900, delay = 0.219, range = 1000, width = 200, collision = false, aoe = false, type = "linear"}
	},
	["Heimerdinger"] = {
		[_W] = { name = "", speed = 900, delay = 0.500, range = 1325, width = 100, collision = true, aoe = false, type = "linear"},
		[_E] = { name = "", speed = 2500, delay = 0.250, range = 970, width = 180, collision = false, aoe = true, type = "circular"}
	},
	["Irelia"] = {
		[_R] = { name = "", speed = 1700, delay = 0.250, range = 1200, width = 25, collision = false, aoe = false, type = "linear"}
	},
	["Janna"] = {
		[_Q] = { name = "HowlingGale", speed = 1500, delay = 0.250, range = 1700, width = 150, collision = false, aoe = false, type = "linear"}
	},
	["JarvanIV"] = {
		[_Q] = { name = "", speed = 1400, delay = 0.25, range = 770, width = 70, collision = false, aoe = false, type = "linear"},
		[_E] = { name = "", speed = 1450, delay = 0.25, range = 850, width = 175, collision = false, aoe = false, type = "linear"}
	},
	["Jax"] = {
		[_E] = { name = "", speed = math.huge, delay = 0.250, range = 0, width = 375, collision = false, aoe = true, type = "circular"}
	},
	["Jayce"] = {
		[_Q] = { name = "jayceshockblast", speed = 2350, delay = 0.15, range = 1750, width = 70, collision = true, aoe = false, type = "linear"}
	},
	["Jinx"] = {
		[_W] = { name = "JinxWMissile", speed = 3000, delay = 0.600, range = 1400, width = 60, collision = true, aoe = false, type = "linear"},
		[_E] = { name = "JinxE", speed = 887, delay = 0.500, range = 830, width = 0, collision = false, aoe = true, type = "circular"},
		[_R] = { name = "JinxR", speed = 1700, delay = 0.600, range = 20000, width = 120, collision = false, aoe = true, type = "circular"}
	},
	["Kalista"] = {
		[_Q] = { name = "KalistaMysticShot", speed = 1700, delay = 0.25, range = 1150, width = 40, collision = true, aoe = false, type = "linear", dmgAD = function(source, target) return 0-50+60*source:GetSpellData(_Q).level+source.totalDamage end},
		[_W] = { name = "", delay = 1.5, range = 5000},
		[_E] = { name = "", range = 1000, dmgAD = function(source, target, stacks) return stacks > 0 and (10 + (10 * source:GetSpellData(_E).level) + (source.totalDamage * 0.6)) + (stacks-1) * (({10, 14, 19, 25, 32})[source:GetSpellData(_E).level] + (0.175 + 0.025 * source:GetSpellData(_E).level)*source.totalDamage) or 0 end},
		[_R] = { name = "", range = 2000}
	},
	["Karma"] = {
		[_Q] = { name = "KarmaQ", speed = 1700, delay = 0.250, range = 950, width = 90, collision = true, aoe = false, type = "linear"}
	},
	["Karthus"] = {
		[_Q] = { name = "KarthusLayWaste", speed = math.huge, delay = 0.775, range = 875, width = 160, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) local m=minionManager(MINION_JUNGLE, 160, target, MINION_SORT_HEALTH_ASC); return (#m.objects == 0 and 2 or 1) * (20+20*source:GetSpellData(_Q).level+0.3*source.ap) end},
		[_W] = { name = "KarthusWallOfPain", speed = math.huge, delay = 0.25, range = 1000, width = 160, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "KarthusDefile", speed = math.huge, delay = 0.25, range = 550, width = 550, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 10+20*source:GetSpellData(_Q).level+0.2*source.ap end},
		[_R] = { name = "KarthusFallenOne", range = math.huge, dmgAP = function(source, target) return 100+150*source:GetSpellData(_Q).level+0.60*source.ap end}
	},
	["Kassadin"] = {
		[_Q] = { name = "", range = 650, dmgAP = function(source, target) return 35+25*source:GetSpellData(_Q).level+0.7*source.ap end},
		[_W] = { name = "", range = 150+myHero.boundingRadius, dmgAP = function(source, target) return 15+25*source:GetSpellData(_W).level+0.6*source.ap end},
		[_E] = { name = "", speed = 2200, delay = 0.25, range = 650, width = 80, collision = false, aoe = false, type = "cone", dmgAP = function(source, target) return 45+25*source:GetSpellData(_E).level+0.7*source.ap end},
		[_R] = { name = "", speed = math.huge, delay = 0.5, range = 500, width = 150, collision = false, aoe = true, type = "circular", dmgAP = function(source, target, stacks) return (1+stacks/2)*(60+20*source:GetSpellData(_E).level+0.02*source.maxMana) end}
	},
	["Katarina"] = {
		[_Q] = { name = "", range = 675, dmgAP = function(source, target) return 35+25*source:GetSpellData(_Q).level+0.45*source.ap end},
		[_W] = { name = "", range = 375, dmgAP = function(source, target) return 5+35*source:GetSpellData(_W).level+0.25*source.ap+0.6*source.addDamage end},
		[_E] = { name = "", range = 700, dmgAP = function(source, target) return 10+30*source:GetSpellData(_E).level+0.25*source.ap end},
		[_R] = { name = "", range = 550, dmgAP = function(source, target) return 15+20*source:GetSpellData(_R).level+0.25*source.ap+0.375*source.addDamage end}
	},
	["Kayle"] = {
        [_Q] = { name = "JudicatorReckoning" },
        [_W] = { name = "JudicatorDivineBlessing" },
        [_E] = { name = "JudicatorRighteosFury" },
        [_R] = { name = "JudicatorIntervention" }
	},
	["Kennen"] = {
		[_Q] = { name = "KennenShurikenHurlMissile1", speed = 1700, delay = 0.180, range = 1050, width = 70, collision = true, aoe = false, type = "linear"}
	},
	["KhaZix"] = {
		[_W] = { name = "KhazixW", speed = 1700, delay = 0.25, range = 1025, width = 70, collision = true, aoe = false, type = "linear"},
		[_E] = { name = "", speed = 400, delay = 0.25, range = 600, width = 325, collision = false, aoe = true, type = "circular"}
	},
	["KogMaw"] = {
		[_Q] = { range = 975, delay = 0.25, speed = 1600, width = 80, type = "linear", dmgAP = function(source, target) return 30+50*source:GetSpellData(_Q).level+0.5*source.ap end},
        [_W] = { range = function() return myHero.range + myHero.boundingRadius*2 + 110+20*myHero:GetSpellData(_W).level end, dmgAP = function(source, target) return target.maxHealth*0.01*(source:GetSpellData(_W).level+1)+0.01*source.ap+source.totalDamage end},
		[_E] = { name = "", speed = 1200, delay = 0.25, range = 1200, width = 120, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 10+50*source:GetSpellData(_E).level+0.7*source.ap end},
		[_R] = { name = "KogMawLivingArtillery", speed = math.huge, delay = 1.1, range = 2200, width = 250, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 40+40*source:GetSpellData(_R).level+0.3*source.ap+0.5*source.totalDamage end}
	},
	["LeBlanc"] = {
		[_Q] = { range = 700, dmgAP = function(source, target) return 30+25*source:GetSpellData(_Q).level+0.4*source.ap end},
		[_W] = { name = "LeblancDistortion", speed = 1300, delay = 0.250, range = 600, width = 250, collision = false, aoe = false, type = "circular", dmgAP = function(source, target) return 45+40*source:GetSpellData(_W).level+0.6*source.ap end},
		[_E] = { name = "LeblancSoulShackle", speed = 1300, delay = 0.250, range = 950, width = 55, collision = true, aoe = false, type = "linear", dmgAP = function(source, target) return 15+25*source:GetSpellData(_E).level+0.5*source.ap end},
        [_R] = { range = 0}
	},
	["LeeSin"] = {
		[_Q] = { name = "BlindMonkQOne", speed = 1750, delay = 0.25, range = 1000, width = 70, collision = true, aoe = false, type = "linear", dmgAD = function(source, target) return 20+30*source:GetSpellData(_Q).level+0.9*source.addDamage end},
        [_W] = { name = "", range = 600},
		[_E] = { name = "BlindMonkEOne", speed = math.huge, delay = 0.25, range = 0, width = 450, collision = false, aoe = false, type = "circular", dmgAD = function(source, target) return 25+35*source:GetSpellData(_E).level+source.addDamage end},
		[_R] = { name = "BlindMonkR", speed = 2000, delay = 0.25, range = 2000, width = 150, collision = false, aoe = false, type = "linear", dmgAD = function(source, target) return 200*source:GetSpellData(_R).level+2*source.addDamage end}
	},
	["Leona"] = {
		[_E] = { name = "LeonaZenithBlade", speed = 2000, delay = 0.250, range = 875, width = 80, collision = false, aoe = false, type = "linear"},
		[_R] = { name = "LeonaSolarFlare", speed = 2000, delay = 0.250, range = 1200, width = 300, collision = false, aoe = true, type = "circular"}
	},
	["Lissandra"] = {
		[_Q] = { name = "", speed = 1800, delay = 0.250, range = 725, width = 20, collision = true, aoe = false, type = "linear"}
	},
	["Lucian"] = {
		[_Q] = { name = "LucianQ" },
		[_W] = { name = "LucianW", speed = 800, delay = 0.300, range = 1000, width = 80, collision = true, aoe = false, type = "linear"},
		[_R] = { name = "LucianR" }
	},
	["Lulu"] = {
		[_Q] = { name = "LuluQ", speed = 1400, delay = 0.250, range = 925, width = 80, collision = false, aoe = false, type = "linear"}
	},
	["Lux"] = {
		[_Q] = { name = "LuxLightBinding", speed = 1200, delay = 0.25, range = 1300, width = 130, collision = true, type = "linear", dmgAP = function(source, target) return 10+50*source:GetSpellData(_Q).level+0.7*source.ap end},
		[_W] = { name = "LuxPrismaticWave", speed = 1630, delay = 0.25, range = 1250, width = 210, collision = false, type = "linear"},
		[_E] = { name = "LuxLightStrikeKugel", speed = 1300, delay = 0.25, range = 1100, width = 325, collision = false, type = "circular", dmgAP = function(source, target) return 15+45*source:GetSpellData(_E).level+0.6*source.ap end},
		[_R] = { name = "LuxMaliceCannon", speed = math.huge, delay = 1, range = 3340, width = 250, collision = false, type = "linear", dmgAP = function(source, target) return 200+100*source:GetSpellData(_R).level+0.75*source.ap end}
	},
	["Malphite"] = {
		[_R] = { name = "", speed = 1600, delay = 0.5, range = 900, width = 500, collision = false, aoe = true, type = "circular"}
	},
	["Malzahar"] = {
		[_Q] = { name = "AlZaharCalloftheVoid1", speed = math.huge, delay = 1, range = 900, width = 100, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 25+55*source:GetSpellData(_Q).level+0.8*source.ap end},
		[_W] = { name = "", speed = math.huge, delay = 0.5, range = 800, width = 250, collision = false, aoe = false, type = "circular", dmgAP = function(source, target) return (3+source:GetSpellData(_W).level+source.ap*0.01)*target.maxHealth*0.01 end},
		[_E] = { name = "", range = 650, dmgAP = function(source, target) return (20+60*source:GetSpellData(_E).level)/8+0.1*source.ap end},
		[_R] = { name = "", range = 700, dmgAP = function(source, target) return 20+30*source:GetSpellData(_R).level+0.26*source.ap end}
	},
	["Maokai"] = {
		[_Q] = { name = "", speed = math.huge, delay = 0.25, range = 600, width = 100, collision = false, aoe = false, type = "linear"},
		[_E] = { name = "", speed = 1500, delay = 0.25, range = 1100, width = 175, collision = false, aoe = false, type = "circular"}
	},
	["MasterYi"] = {
	},
	["MissFortune"] = {
		[_E] = { name = "", speed = math.huge, delay = 0.25, range = 800, width = 200, collision = false, aoe = true, type = "circular"},
		[_R] = { name = "", speed = math.huge, delay = 0.25, range = 1400, width = 700, collision = false, aoe = true, type = "cone"}
	},
	["Mordekaiser"] = {
		[_E] = { name = "", speed = math.huge, delay = 0.25, range = 700, width = 0, collision = false, aoe = true, type = "cone"}
	},
	["Morgana"] = {
		[_Q] = { name = "DarkBindingMissile", speed = 1200, delay = 0.250, range = 1300, width = 80, collision = true, aoe = false, type = "linear"}
	},
	["Nami"] = {
		[_Q] = { name = "NamiQ", speed = math.huge, delay = 0.8, range = 850, width = 0, collision = false, aoe = true, type = "circular"}
	},
	["Nasus"] = {
		[_E] = { name = "", speed = math.huge, delay = 0.25, range = 450, width = 250, collision = false, aoe = true, type = "circular"}
	},
	["Nautilus"] = {
		[_Q] = { name = "NautilusAnchorDrag", speed = 2000, delay = 0.250, range = 1080, width = 80, collision = true, aoe = false, type = "linear"}
	},
	["Nidalee"] = {
		[_Q] = { name = "JavelinToss", speed = 1350, delay = 0.25, range = 1625, width = 37.5, collision = true, type = "linear", dmgAP = function(source, target) return (30+20*source:GetSpellData(_Q).level+0.4*source.ap)*math.max(1,math.min(3,GetDistance(source,target)/1250*3)) end}
	},
	["Nocturne"] = {
		[_Q] = { name = "NocturneDuskbringer", speed = 1400, delay = 0.250, range = 1125, width = 60, collision = false, aoe = false, type = "linear"}
	},
	["Nunu"] = {
	},
	["Olaf"] = {
		[_Q] = { name = "OlafAxeThrow", speed = 1600, delay = 0.25, range = 1000, width = 90, collision = false, aoe = false, type = "linear"}
	},
	["Orianna"] = {
		[_Q] = { name = "OrianaIzunaCommand", speed = 1200, delay = 0.250, range = 825, width = 175, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 30+30*source:GetSpellData(_Q).level+0.5*source.ap end},
		[_W] = { name = "OrianaDissonanceCommand", speed = math.huge, delay = 0.250, range = 0, width = 225, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 25+45*source:GetSpellData(_W).level+0.7*source.ap end},
		[_E] = { name = "OrianaRedactCommand", speed = 1800, delay = 0.250, range = 825, width = 80, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 30+30*source:GetSpellData(_E).level+0.3*source.ap end},
		[_R] = { name = "OrianaDetonateCommand", speed = math.huge, delay = 0.250, range = 0, width = 410, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 75+75*source:GetSpellData(_R).level+0.7*source.ap end}
	},
	["Pantheon"] = {
		[_E] = { name = "", speed = math.huge, delay = 0.250, range = 400, width = 100, collision = false, aoe = true, type = "cone"},
		[_R] = { name = "", speed = 3000, delay = 1, range = 5500, width = 1000, collision = false, aoe = true, type = "circular"}
	},
	["Poppy"] = {
	},
	["Quinn"] = {
		[_Q] = { name = "QuinnQ", speed = 1550, delay = 0.25, range = 1050, width = 80, collision = true, aoe = false, type = "linear", dmgAD = function(source, target) return 30+40*source:GetSpellData(_Q).level+0.65*source.addDamage+0.5*source.ap end},
		[_W] = { },
		[_E] = { range = 0, dmgAD = function(source, target) return 10+30*source:GetSpellData(_E).level+0.2*source.addDamage end},
		[_R] = { range = 0, dmgAD = function(source, target) return (70+50*source:GetSpellData(_R).level+0.5*source.addDamage)*(1+((target.maxHealth-target.health)/target.maxHealth)) end}
	},
	["Rammus"] = {
	},
	["RekSai"] = {
		[_Q] = { name = "", speed = 1550, delay = 0.25, range = 1050, width = 180, collision = true, aoe = false, type = "linear"}
	},
	["Renekton"] = {
		[_Q] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 450, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "", speed = 1225, delay = 0.25, range = 450, width = 150, collision = false, aoe = false, type = "linear"}
	},
	["Rengar"] = {
		[_Q] = { range = 450+myHero.boundingRadius*2, dmgAD = function(source, target) return 30*source:GetSpellData(_Q).level+(0.95+0.05*source:GetSpellData(_Q).level)*source.totalDamage end},
		[_W] = { name = "RengarW", speed = math.huge, delay = 0.25, range = 0, width = 490, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "RengarE", speed = 1225, delay = 0.25, range = 1000, width = 80, collision = true, aoe = false, type = "linear"},
		[_R] = { range = 4000}
	},
	["Riven"] = {
		[_Q] = { name = "RivenTriCleave", speed = math.huge, delay = 0.250, range = 310, width = 225, collision = false, aoe = true, type = "circular", dmgAD = function(source, target) return 0-10+20*myHero:GetSpellData(_Q).level+(0.35+0.05*myHero:GetSpellData(_Q).level)*source.totalDamage end},
		[_W] = { name = "RivenMartyr", speed = math.huge, delay = 0.250, range = 0, width = 265, collision = false, aoe = true, type = "circular", dmgAD = function(source, target) return 20+30*myHero:GetSpellData(_W).level+source.totalDamage end},
        [_E] = { range = 390},
		[_R] = { name = "rivenizunablade", speed = 2200, delay = 0.5, range = 1100, width = 200, collision = false, aoe = false, type = "cone", dmgAD = function(source, target) return (40+40*myHero:GetSpellData(_R).level+0.6*source.addDamage)*(math.min(3,math.max(1,4*(target.maxHealth-target.health)/target.maxHealth))) end}
	},
	["Rumble"] = {
		[_Q] = { name = "RumbleFlameThrower", speed = math.huge, delay = 0.250, range = 600, width = 500, collision = false, aoe = false, type = "cone", dmgAP = function(source, target) return 5+20*source:GetSpellData(_Q).level+0.33*source.ap end},
		[_W] = { range = myHero.boundingRadius},
		[_E] = { name = "RumbleGrenadeMissile", speed = 1200, delay = 0.250, range = 850, width = 90, collision = true, aoe = false, type = "linear", dmgAP = function(source, target) return 20+25*source:GetSpellData(_E).level+0.4*source.ap end},
		[_R] = { name = "RumbleCarpetBomb", speed = 1200, delay = 0.250, range = 1700, width = 90, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 75+55*source:GetSpellData(_R).level+0.3*source.ap end}
	},
	["Ryze"] = {
		[_Q] = { name = "RyzeQ", speed = 1700, delay = 0.25, range = 900, width = 50, collision = true, aoe = false, type = "linear", dmgAP = function(source, target) return 35+25*source:GetSpellData(_Q).level+0.55*source.ap+(0.015+0.005*source:GetSpellData(_Q).level)*source.maxMana end},
		[_W] = { name = "RyzeW", range = 600, dmgAP = function(source, target) return 60+20*source:GetSpellData(_W).level+0.4*source.ap+0.025*source.maxMana end},
		[_E] = { name = "RyzeE", range = 600, dmgAP = function(source, target) return 34+16*source:GetSpellData(_E).level+0.3*source.ap+0.02*source.maxMana end},
		[_R] = { name = "RyzeR", range = 900}
	},
	["Sejuani"] = {
		[_Q] = { range = 0, dmgAP = function(source, target) return 35+45*source:GetSpellData(_Q).level+0.4*source.ap end},
		[_W] = { range = 0, dmgAP = function(source, target) return end},
		[_E] = { range = 0, dmgAP = function(source, target) return 30+30*source:GetSpellData(_E).level*0.5*source.ap end},
		[_R] = { name = "SejuaniGlacialPrisonCast", speed = 1600, delay = 0.250, range = 1200, width = 110, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 50+100*source:GetSpellData(_R).level*0.8*source.ap end}
	},
	["Shaco"] = {
	},
	["Shen"] = {
		[_E] = { name = "ShenShadowDash", speed = 1200, delay = 0.25, range = 600, width = 40, collision = false, aoe = false, type = "linear"}
	},
	["Shyvana"] = {
		[_Q] = { range = 0, dmgAD = function(source, target) return (0.75+0.05*source:GetSpellData(_Q).level)*source.totalDamage end},
		[_W] = { range = 0, dmgAP = function(source, target) return 5+15*source:GetSpellData(_W).level+0.2*source.totalDamage end},
		[_E] = { name = "", speed = 1500, delay = 0.250, range = 925, width = 60, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 20+40*source:GetSpellData(_E).level+0.6*source.totalDamage end},
		[_R] = { range = 0, dmgAP = function(source, target) return 50+125*source:GetSpellData(_R).level+0.7*source.ap end}
	},
	["Singed"] = {
	},
	["Sion"] = {
		[_Q] = { name = "", speed = math.huge, delay = 0.125, range = 925, width = 250, collision = false, aoe = false, type = "cone"}
	},
	["Sivir"] = {
		[_Q] = { name = "SivirQ", speed = 1330, delay = 0.250, range = 1075, width = 0, collision = false, aoe = false, type = "linear"}
	},
	["Skarner"] = {
		[_E] = { name = "", speed = 1200, delay = 0.600, range = 350, width = 60, collision = false, aoe = false, type = "linear"}
	},
	["Sona"] = {
		[_R] = { name = "SonaCrescendo", speed = 2400, delay = 0.5, range = 900, width = 160, collision = false, aoe = false, type = "linear"}
	},
	["Soraka"] = {
		[_Q] = { name = "SorakaQ", speed = 2400, delay = 0.25, range = 900, width = 160, collision = false, aoe = true, type = "circular"}
	},
	["Swain"] = {
		[_W] = { name = "SwainShadowGrasp", speed = math.huge, delay = 0.850, range = 900, width = 125, collision = false, aoe = true, type = "circular"}
	},
	["Syndra"] = {
		[_Q] = { name = "SyndraQ", speed = math.huge, delay = 0.67, range = 790, width = 125, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return ((source:GetSpellData(_Q).level == 5 and target.type == myHero.type) and 1.15 or 1)*(5+45*source:GetSpellData(_Q).level+0.6*source.ap) end},
		[_W] = { name = "syndrawcast", speed = math.huge, delay = 0.8, range = 925, width = 190, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 40+40*source:GetSpellData(_W).level+0.7*source.ap end},
		[_E] = { name = "", speed = 2500, delay = 0.25, range = 730, width = 45, collision = false, aoe = true, type = "cone", dmgAP = function(source, target) return 25+45*source:GetSpellData(_E).level+0.4*source.ap end},
		[_R] = { name = "", range = 725, dmgAP = function(source, target, stacks) return math.max((stacks or 1) + 3, 7)*(45+45*source:GetSpellData(_R).level+0.2*source.ap) end}
	},
	["Talon"] = {
		[_Q] = { name = "", range = myHero.range+myHero.boundingRadius*2, dmgAD = function(source, target) return source.totalDamage+30*source:GetSpellData(_Q).level+0.3*(source.addDamage) end},
		[_W] = { name = "", speed = 900, delay = 0.25, range = 600, width = 200, collision = false, aoe = false, type = "cone", dmgAD = function(source, target) return 2*(5+25*source:GetSpellData(_W).level+0.6*(source.addDamage)) end},
		[_E] = { name = "", range = 700},
		[_R] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 650, collision = false, aoe = false, type = "circular", dmgAD = function(source, target) return 2*(70+50*source:GetSpellData(_R).level+0.75*(source.addDamage)) end}
	},
	["Taric"] = {
		[_R] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 175, collision = false, aoe = false, type = "circular"}
	},
	["Teemo"] = {
		[_Q] = { name = "", range = myHero.range+myHero.boundingRadius*3, dmgAP = function(source, target) return 35+45*source:GetSpellData(_Q).level+0.8*source.ap end},
		[_W] = { name = "", range = 25000},
		[_E] = { name = "", range = myHero.range+myHero.boundingRadius, dmgAP = function(source, target) return 10*source:GetSpellData(_E).level+0.3*source.ap end},
		[_R] = { name = "", speed = 1200, delay = 1.25, range = 900, width = 250, type = "circular", dmgAP = function(source, target) return 75+125*source:GetSpellData(_E).level+0.5*source.ap end}
	},
	["Thresh"] = {
		[_Q] = { name = "ThreshQ", speed = 1825, delay = 0.25, range = 1050, width = 70, collision = true, aoe = false, type = "linear", dmgAP = function(source, target) return 35+45*source:GetSpellData(_Q).level+0.8*source.ap end},
		[_W] = { range = 25000},
		[_E] = { name = "ThreshE", speed = 2000, delay = 0.25, range = 450, width = 110, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 9*source:GetSpellData(_E).level+0.3*source.ap end},
		[_R] = { range = 450, width = 250}
	},
	["Tristana"] = {
		[_Q] = { name = "", range = 543 },
		[_W] = { name = "", speed = 2100, delay = 0.25, range = 900, width = 125, collision = false, aoe = false, type = "circular", dmgAP = function(source, target, stacks) return (1+(stacks or 0)*0.25)*(45+35*source:GetSpellData(_W).level+0.5*source.ap) end},
		[_E] = { name = "", range = 543, dmgAD = function(source, target, stacks) return (1+(stacks or 0)*0.3)*(50+10*source:GetSpellData(_E).level+0.5*source.ap+(0.35+0.15*source:GetSpellData(_E).level)*source.addDamage) end },
		[_R] = { name = "", range = 543, dmgAP = function(source, target) return 200+100*source:GetSpellData(_R).level+source.ap end }
	},
	["Trundle"] = {
		[_Q] = { name = "", speed = math.huge, delay = 0.25, range = 1000, width = 125, collision = false, aoe = false, type = "circular"}
	},
	["Tryndamere"] = {
		[_E] = { name = "", speed = 700, delay = 0.250, range = 650, width = 160, collision = false, aoe = false, type = "linear"}
	},
	["TwistedFate"] = {
		[_Q] = { name = "WildCards", speed = 1500, delay = 0.250, range = 1200, width = 80, collision = false, aoe = false, type = "cone"}
	},
	["Twitch"] = {
		[_W] = { name = "", speed = 1750, delay = 0.250, range = 950, width = 275, collision = false, aoe = true, type = "circular"}
	},
	["Udyr"] = {
	},
	["Urgot"] = {
		[_Q] = { name = "UrgotHeatseekingLineMissile", speed = 1575, delay = 0.175, range = 1000, width = 80, collision = true, aoe = false, type = "linear"},
		[_E] = { name = "UrgotPlasmaGrenade", speed = 1750, delay = 0.25, range = 890, width = 200, collision = false, aoe = true, type = "circular"}
	},
	["Varus"] = {
		[_Q] = { name = "VarusQ", speed = 1500, delay = 0.5, range = 1475, width = 100, collision = false, aoe = false, type = "linear"},
		[_E] = { name = "VarusEMissile", speed = 1750, delay = 0.25, range = 925, width = 235, collision = false, aoe = true, type = "circular"},
		[_R] = { name = "VarusR", speed = 1200, delay = 0.5, range = 800, width = 100, collision = false, aoe = false, type = "linear"}
	},
	["Vayne"] = {
		[_Q] = { name = "", range = 450, dmgAD = function(source, target) return (1.25+0.05*source:GetSpellData(_Q).level)*source.totalDamage end},
		[_W] = { name = "", range = myHero.range+myHero.boundingRadius*2, dmgTRUE = function(source, target) return 10+10*source:GetSpellData(_W).level+((0.03+0.01*source:GetSpellData(_W).level)*target.maxHealth) end},
		[_E] = { name = "", speed = 2000, delay = 0.25, range = 650, width = 0, collision = false, aoe = false, type = "linear", dmgAD = function(source, target) return 10+35*source:GetSpellData(_E).level+0.5*source.addDamage end},
		[_R] = { name = "", range = 1000}
	},
	["Veigar"] = {
		[_Q] = { name = "VeigarBalefulStrike", speed = 1200, delay = 0.25, range = 900, width = 70, collision = true, aoe = false, type = "linear", dmgAP = function(source, target) return 30+40*source:GetSpellData(_Q).level+0.6*source.ap end},
		[_W] = { name = "VeigarDarkMatter", speed = math.huge, delay = 1.2, range = 900, width = 225, collision = false, aoe = false, type = "circular", dmgAP = function(source, target) return 50+50*source:GetSpellData(_W).level+source.ap end},
		[_E] = { name = "", speed = math.huge, delay = 0.75, range = 725, width = 275, collision = false, aoe = false, type = "circular"},
		[_R] = { name = "", range = 650, dmgAP = function(source, target) return 125+125*source:GetSpellData(_R).level+source.ap+target.ap end}
	},
	["VelKoz"] = {
		[_Q] = { name = "VelKozQ", speed = 1300, delay = 0.066, range = 1050, width = 50, collision = true, aoe = false, type = "linear"},
		[_W] = { name = "VelKozW", speed = 1700, delay = 0.064, range = 1050, width = 80, collision = false, aoe = false, type = "linear"},
		[_E] = { name = "VelKozE", speed = 1500, delay = 0.333, range = 850, width = 225, collision = false, aoe = true, type = "circular"},
		[_R] = { name = "VelKozR", speed = math.huge, delay = 0.333, range = 1550, width = 50, collision = false, aoe = false, type = "linear"}
	},
	["Vi"] = {
		[_Q] = { name = "", speed = 1500, delay = 0.25, range = 715, width = 55, collision = false, aoe = false, type = "linear"}
	},
	["Viktor"] = {
		[_Q] = { range = 0, dmgAP = function(source, target) return 20+20*source:GetSpellData(_Q).level+0.2*source.ap end},
		[_W] = { name = "", speed = 750, delay = 0.6, range = 700, width = 125, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "ViktorDeathRay", speed = 1200, delay = 0.25, range = 1200, width = 0, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 25+45*source:GetSpellData(_E).level+0.7*source.ap end},
		[_R] = { name = "", speed = 1000, delay = 0.25, range = 700, width = 0, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 50+100*source:GetSpellData(_R).level+0.55*source.ap end}
	},
	["Vladimir"] = {
	},
	["Volibear"] = {
		[_Q] = { range = myHero.range+myHero.boundingRadius*2, dmgAD = function(source, target) return 30*source:GetSpellData(_Q).level+source.totalDamage end},
		[_W] = { range = myHero.range*2+myHero.boundingRadius+25, dmgAD = function(source, target) return ((1+(target.maxHealth-target.health)/target.maxHealth))*(45*source:GetSpellData(_W).level+35+0.15*(source.maxHealth-(440+86*source.level))) end},
		[_E] = { range = myHero.range*2+myHero.boundingRadius*2+10, dmgAP = function(source, target) return 45*source:GetSpellData(_E).level+15+0.6*source.ap end},
		[_R] = { range = myHero.range+myHero.boundingRadius, dmgAP = function(source, target) return 40*source:GetSpellData(_R).level+35+0.3*source.ap end}
	},
	["Warwick"] = {
	},
	["Wukong"] = {
	},
	["Xerath"] = {
		[_Q] = { name = "", speed = math.huge, delay = 1.75, range = 750, width = 100, collision = false, aoe = false, type = "linear"},
		[_W] = { name = "", speed = math.huge, delay = 0.25, range = 1100, width = 100, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "", speed = 1600, delay = 0.25, range = 1050, width = 70, collision = true, aoe = false, type = "linear"},
		[_R] = { name = "", speed = math.huge, delay = 0.75, range = 3200, width = 245, collision = false, aoe = true, type = "circular"}
	},
	["XinZhao"] = {
		[_R] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 375, collision = false, aoe = true, type = "circular"}
	},
	["Yasuo"] = {
		[_Q] = { name = "YasuoQ", speed = math.huge, delay = 0.25, range = 475, width = 40, collision = false, aoe = false, type = "linear", dmgAD = function(source, target) return 20*source:GetSpellData(_Q).level+source.totalDamage-10 end},
		[_W] = { name = "", range = 350},
		[_E] = { name = "", range = 475, dmgAP = function(source, target) return 50+20*source:GetSpellData(_E).level+source.ap end},
		[_R] = { name = "", range = 1200, dmgAD = function(source, target) return 100+100*source:GetSpellData(_R).level+1.5*source.totalDamage end},
		[-2] = { name = "", range = 1200, speed = 1200, delay = 0.125, width = 65, collision = false, aoe = false, type = "linear" }
	},
	["Yorick"] = {
		[_Q] = { range = 0, dmgAD = function(source, target) return 30*source:GetSpellData(_Q).level+1.2*source.totalDamage+source.totalDamage end},
		[_W] = { name = "", speed = math.huge, delay = 0.25, range = 600, width = 175, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 50+20*source:GetSpellData(_W).level+source.ap end},
		[_E] = { range = 0, dmgAD = function(source, target) return 100+100*source:GetSpellData(_E).level+source.addDamage*1.5 end},
	},
	["Zac"] = {
		[_Q] = { name = "", speed = 2500, delay = 0.110, range = 500, width = 110, collision = false, aoe = false, type = "linear"}
	},
	["Zed"] = {
		[_Q] = { name = "ZedShuriken", speed = 1700, delay = 0.25, range = 900, width = 48, collision = false, aoe = false, type = "linear"},
		[_E] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 300, collision = false, aoe = true, type = "circular"}
	},
	["Ziggs"] = {
		[_Q] = { name = "ZiggsQ", speed = 1750, delay = 0.25, range = 1400, width = 155, collision = true, aoe = false, type = "linear"},
		[_W] = { name = "ZiggsW", speed = 1800, delay = 0.25, range = 970, width = 275, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "ZiggsE", speed = 1750, delay = 0.12, range = 900, width = 350, collision = false, aoe = true, type = "circular"},
		[_R] = { name = "ZiggsR", speed = 1750, delay = 0.14, range = 5300, width = 525, collision = false, aoe = true, type = "circular"}
	},
	["Zilean"] = {
		[_Q] = { name = "", speed = math.huge, delay = 0.5, range = 900, width = 150, collision = false, aoe = true, type = "circular"}
	},
	["Zyra"] = {
		[-1] = { name = "zyrapassivedeathmanager" },
		[_Q] = { name = "ZyraQFissure", speed = math.huge, delay = 0.7, range = 800, width = 85, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "ZyraGraspingRoots", speed = 1150, delay = 0.25, range = 1100, width = 70, collision = false, aoe = false, type = "linear"},
		[_R] = { name = "ZyraBrambleZone", speed = math.huge, delay = 1, range = 1100, width = 500, collision=false, aoe = true, type = "circular"}
	}
}


----------- 
--Manuals--
-----------
function pickle(t)
  	return Pickle:clone():pickle_(t)
end

Pickle = {
  	clone = function (t) local nt={}; for i, v in pairs(t) do nt[i]=v end return nt end 
}

function Pickle:pickle_(root)
  if type(root) ~= "table" then 
    error("can only pickle tables, not ".. type(root).."s")
  end
  self._tableToRef = {}
  self._refToTable = {}
  local savecount = 0
  self:ref_(root)
  local s = ""

  while #self._refToTable > savecount do
    savecount = savecount + 1
    local t = self._refToTable[savecount]
    s = s.."{\n"
    for i, v in pairs(t) do
        s = string.format("%s[%s]=%s,\n", s, self:value_(i), self:value_(v))
    end
    s = s.."},\n"
  end

  return string.format("{%s}", s)
end

function Pickle:value_(v)
  local vtype = type(v)
  if     vtype == "string" then return string.format("%q", v)
  elseif vtype == "number" then return v
  elseif vtype == "boolean" then return tostring(v)
  elseif vtype == "table" then return "{"..self:ref_(v).."}"
  else --error("pickle a "..type(v).." is not supported")
  end  
end

function Pickle:ref_(t)
  local ref = self._tableToRef[t]
  if not ref then 
    if t == self then error("can't pickle the pickle class") end
    table.insert(self._refToTable, t)
    ref = #self._refToTable
    self._tableToRef[t] = ref
  end
  return ref
end

function unpickle(s)
  if type(s) ~= "string" then
    error("can't unpickle a "..type(s)..", only strings")
  end
  local gentables = load("return "..s)
  local tables = gentables()
  
  for tnum = 1, #tables do
    local t = tables[tnum]
    local tcopy = {}; for i, v in pairs(t) do tcopy[i] = v end
    for i, v in pairs(tcopy) do
      local ni, nv
      if type(i) == "table" then ni = tables[i[1]] else ni = i end
      if type(v) == "table" then nv = tables[v[1]] else nv = v end
      t[i] = nil
      t[ni] = nv
    end
  end
  return tables[1]
end

function GetDistance2D( o1, o2 )
    local c = "z"
    if o1.z == nil or o2.z == nil then c = "y" end
    return math.sqrt(math.pow(o1.x - o2.x, 2) + math.pow(o1[c] - o2[c], 2))
end

function GVD(startPos, distance, endPos)
	return Vector(startPos) + distance * (Vector(endPos)-Vector(startPos)):normalized()
end

function IsPassWall(startPos, endPos)
	count = GetDistance(startPos, endPos)
	i=1
	while i < count do
		i = i+10
		local pos = GVD(startPos, i, endPos)
		if IsWall(D3DXVECTOR3(pos.x, pos.y, pos.z)) then return true end
	end
	return false
end


function DrawCircleNew(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
		DrawCircleNextLvl(x, y, z, radius, 1, color, 300) 
	end
end
_G.DrawCircle = DrawCircleNew

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8, Round(180 / math.deg((math.asin((chordlength / (2 * radius)))))))
	quality = 2 * math.pi / quality
	radius = radius * .92
	local points = {}
	
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end

function Round(number)
	if number >= 0 then 
		return math.floor(number+.5) 
	else 
		return math.ceil(number-.5) 
	end
end

function sortByDistanceNodes(a,b)
  return GetDistance2D(a,_G.hflTasks[MAPNAME][TEAMNUMBER][1].point) < GetDistance2D(b,_G.hflTasks[MAPNAME][TEAMNUMBER][1].point)
end

function split(str, sep)
   local result = {}
   local regex = ("([^%s]+)"):format(sep)
   for each in str:gmatch(regex) do
      table.insert(result, each)
   end
   return result
end

function Set(list)
    local set = {}
    for _, l in ipairs(list) do 
      set[l] = true 
    end
    return set
end



init()