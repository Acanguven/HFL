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

class 'init'
	function init:__init()
		self.sprite = false
		if FileExist(LIB_PATH .. "/HfLib.lua") then
			self:load()
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
					debugger()
				end
				TASKMANAGER = tasks()
				MINIONS = minions()
				ESP = esp()
			end
		end
		self:loadSprite()

		AddDrawCallback(function()
			self:drawSprite()
		end)
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
	end

	function debugger:nodeManagerDraw()
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

		if debugger then
			AddDrawCallback(function ()
				self:drawManager()
			end)
		end

		AddTickCallback(function()
			if GetTickCount() > self.lastTick + self.updateRate then
				self:updateNodes()
				self.lastTick = GetTickCount()
				self:getMinimumDangerRelativetoTaskWalking()
			end
		end)

		return self
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
			end
		end
	end

	function  esp:calculateMinions(node)
		node.danger.free = 0
		node.danger.action = 0
		for i, minion in pairs(MINIONS.enemies.objects) do
			local minionRange 	
			if string.find(minion.charName, "Ranged") then
				minionRange = 600
			else
				minionRange = 100
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

		myHero:MoveTo(minimumNode.x, minimumNode.z) -- use this method for just going to target.
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
			print(nodeDanger.danger.action)
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

		myHero:MoveTo(minimumNode.x, minimumNode.z) -- use this method for just going to target.
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




-- 
-- Manuals
--
----------------------------------------------
-- Pickle
----------------------------------------------

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

----------------------------------------------
-- Unpickle
----------------------------------------------

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







init()