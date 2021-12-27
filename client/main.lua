--
--- This edit has been made by AlexBanPer#4245
--- Adapted from @negbook original edition https://forum.cfx.re/t/release-esx-menu-scaleform-by-negbook/1799474
--

ShutdownLoadingScreen()
ShutdownLoadingScreenNui()
DoScreenFadeIn(10)

local editorMode = false
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["NBACKSPACE"] = 202, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
ESX_MENU       = {};
ESX_MENU.opened       = {};
ESX_MENU.focus        = {};
ESX_MENU.pos          = {};
ESX_MENU.options 	  = {
	position = vector3(0,0,0),
	rotation = vector3(1.0, 1.0, 1.0),
	scale = vector3(1.0, 1.0, 1.0),
	heading = 1,
	canClose = false
}

--------------------
--- Testing & Example Zone

function openEntranceMenuCasino()
    ESX.UI.Menu.Open('scaleform', GetCurrentResourceName(), 'casino_menu_example', {
        title    =  "Casino",
        description = "Select your next destination",
        options  = {
            position = vector3(940.158, 44.79, 79.79), -- Position is a headache, I hope with the editor you can understand it faster.
            rotation = vector3(-2.99, 2.59, 75.38), -- Rotation is a headache, I hope with the editor you can understand it faster.
            scale = vector3(12.0, 5.0, 8.0), -- Scale: X = Horizontal; Y = Vertical; Z = ?
            values = vector3(1.0, 1.0, 1.0), --(Some values are not yet understood, always must be 1.0)
            heading = 1, -- WIP (Some values are not yet understood)
            canClose = false -- WIP
        },
        elements = {
            { label = "Go to CASINO", value = "teleport_to_casino" },
            { label = "Go to ROOF", value = "teleport_to_roof"}
        }
    }, function(data, menu)

        local action = data.current.value
        if action == "teleport_to_casino" then
            print("TELEPORT TO CASINO")
        elseif action == "teleport_to_roof" then
            print("TELEPORT TO ROOF")
        end
       
    end, function(data, menu)end)
end

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(10)
	end

	Citizen.Wait(1000)

	-- You can check distance and open the menu
	-- I recommend to use PolyZone to trigger when leave/enter to zone

	openEntranceMenuCasino()
end)
---------------------

ESX_MENU.open = function(namespace, name, data) 
	if ESX_MENU.opened[namespace] == nil then 
		ESX_MENU.opened[namespace] = {}
	end 

	if ESX_MENU.opened[namespace][name] ~= nil then 
		ESX_MENU.close(namespace, name);
	end 

	if ESX_MENU.pos[namespace]  == nil then 
		ESX_MENU.pos[namespace] = {};
	end 

		for i=1,#data.elements,1 do 
			if data.elements[i].type == nil then 
				data.elements[i].type = 'scaleform';
			end 
		end 
		data._index     = #ESX_MENU.focus;
		data._namespace = namespace;
		data._name      = name;

		for i=1,#data.elements,1 do 
			data.elements[i]._namespace = namespace;
			data.elements[i]._name      = name;
		end 

		ESX_MENU.opened[namespace][name] = data;
		ESX_MENU.pos   [namespace][name] = 1;

		for i=1,#data.elements,1 do 
			if data.elements[i].selected  then 
				ESX_MENU.pos[namespace][name] = i;
			else
				data.elements[i].selected = false
			end 
		end 

		table.insert(ESX_MENU.focus,{namespace=namespace,name=name});
		
		FadeShow();
		ESX_MENU.render();

end 
ESX_MENU.close = function(namespace, name)
	for  i=1,#ESX_MENU.focus, 1 do 
		if ESX_MENU.focus[i].namespace == namespace and  ESX_MENU.focus[i].name == name then 
			Splice(ESX_MENU.focus,i, 1);
			if ESX_MENU.opened[namespace][name] then 
				ESX_MENU.opened[namespace][name] = nil 
			end
			break;
		end 
	end 
	ESX_MENU.render();
end 

function Splice(t, index, howMany, ...)
	local removed = {}
	local tableSize = #(t) -- Table size
	-- Lua 5.0 handling of vararg...
	local argNb = ... == nil and 0 or #(...) -- Number of elements to insert
	-- Check parameter validity
	if index < 1 then index = 1 end
	if howMany < 0 then howMany = 0 end
	if index > tableSize then
		index = tableSize + 1 -- At end
		howMany = 0 -- Nothing to delete
	end
	if index + howMany - 1 > tableSize then
		howMany = tableSize - index + 1 -- Adjust to number of elements at index
	end

	local argIdx = 1 -- Index in arg
	-- Replace min(howMany, argNb) entries
	for pos = index, index + math.min(howMany, argNb) - 1 do
		-- Copy removed entry
		table.insert(removed, t[pos])
		-- Overwrite entry
		t[pos] = arg[argIdx]
		argIdx = argIdx + 1
	end
	argIdx = argIdx - 1
	-- If howMany > argNb, remove extra entries
	for i = 1, howMany - argNb do
		table.insert(removed, table.remove(t, index + argIdx))
	end
	-- If howMany < argNb, insert remaining new entries
	for i = argNb - howMany, 1, -1 do
		table.insert(t, index + howMany, arg[argIdx + i])
	end
	return removed
end
ESX_MENU.getFocused = function()
		return ESX_MENU.focus[#ESX_MENU.focus];
end 
function extract_Price(s)
    local t = nil
    for v in s:gmatch("<price>(.-)</price>") do
        t = v
    end

    if t then
        return t
    end

    return nil
end
function extract_forceName(s)
    local t = nil
    for v in s:gmatch("<forceName>(.-)</forceName>") do
        t = v
    end

    if t then
        return t
    end

    return nil
end
ESX_MENU.render = function() -- DRAW FUNCTIONS

		local focused             = ESX_MENU.getFocused();
		display = false 
		SetDataSlotEmpty() -- gfx function 

		
		if focused and #(focused) then
			display = true 
			-- if GetFollowPedCamViewMode()==4 then 
			-- 	PlaySoundFrontend(-1, "Pull_Out", "Phone_SoundSet_Michael", 1)
			-- end 
			if focused and #(focused) then

				local menuData    = ESX_MENU.opened[focused.namespace][focused.name];
				local pos     = ESX_MENU.pos[focused.namespace][focused.name];
			

				if(#menuData.elements > 0) then 
					SetTitle(menuData.title or "Example Title") -- gfx function 
					
					SetHeader(menuData.header or "") -- gfx function 
					
					SetDescription(menuData.description or "",45000)

					SetOptions(menuData.options)
					
					for i=1,#menuData.elements,1 do 
						
						local element = menuData.elements[i];
						if element.type == 'scaleform' then 
							SetDataSlot(i,element.label,"")
						elseif element.type == "slider" then 
							element.isSlider    = true
							element.sliderLabel = element.options == nil and element.value or element.options[element.value+1];
							
							
							local sTxt = element.sliderLabel
							local haveForceName = extract_forceName(sTxt)
							local forceName = (sTxt ~=nil and haveForceName) and extract_forceName(sTxt) or ""
							local havePrice = sTxt == nil and nil or sTxt:match("(.+)<price>")
							local RightTxt = #element.options>0 and (element.value == 0 and "&gt;" or "&lt;") .. (element.value + 1 == #element.options and "&lt;" or "&gt;") or ""
							SetDataSlot(i,sTxt ~=nil and (element.label .. (" | " .. (string.len(forceName) > 0 and forceName or (havePrice == nil and sTxt or havePrice)))) or "", havePrice and extract_Price(sTxt) ..RightTxt or RightTxt)
							-- gfx function to do (左右选择)
						else 
							
						end 
						
						if i == pos then 
							element.selected = true;
						end 
					end 
					
				end 
				
				DrawMenuList()
				SelectItemIndex(pos) -- gfx function 
		
			end 
		end 
		
end 

	ESX_MENU.submit = function(namespace, name, data)
		TriggerEvent('menu_submit',{
			_namespace= namespace,
			_name     = name,
			current   = data,
			elements  = ESX_MENU.opened[namespace][name].elements
		},function(cb) end)
	end 

	ESX_MENU.cancel = function(namespace, name)

		TriggerEvent('menu_cancel',{_namespace= namespace,
			_name     = name},function(cb) end)
	end 

	ESX_MENU.change = function(namespace, name, data)
		TriggerEvent('menu_change',{
			_namespace= namespace,
			_name     = name,
			current   = data,
			elements  = ESX_MENU.opened[namespace][name].elements
		},function(cb) end)
	end 

	
SendScaleformMessage = function(json)
	TriggerEvent("esx_menu_scaleform:"..json.action,json)
end 
RegisterNetEvent('esx_menu_scaleform:openMenu')
AddEventHandler('esx_menu_scaleform:openMenu', function(json)
	--TriggerEvent('localmessage','openMenu',json.namespace, json.name)
	ESX_MENU.open(json.namespace, json.name, json.data);

	
	
end)
RegisterNetEvent('esx_menu_scaleform:closeMenu')
AddEventHandler('esx_menu_scaleform:closeMenu', function(json)
	--TriggerEvent('localmessage','closeMenu',json.namespace, json.name)
	ESX_MENU.close(json.namespace, json.name)

end)

RegisterNetEvent('esx_menu_scaleform:controlPressed')
AddEventHandler('esx_menu_scaleform:controlPressed', function(json)
	--TriggerEvent('localmessage',json.control )
	if json.control == 'ENTER' then 
		local focused = ESX_MENU.getFocused();

		if focused and #(focused) then

			local menu    = ESX_MENU.opened[focused.namespace][focused.name];
			local pos     = ESX_MENU.pos[focused.namespace][focused.name];
			local elem    = menu.elements[pos];

			if(#menu.elements > 0) then 
				ESX_MENU.submit(focused.namespace, focused.name, elem);
			end 

		end 
	end 
	if json.control == 'BACKSPACE' then 
		local focused = ESX_MENU.getFocused();
		--TriggerEvent('localmessage',focused)
		if focused and #(focused) then 

			ESX_MENU.cancel(focused.namespace, focused.name);
		end 
	end 
	if json.control == 'TOP' then 
		local focused = ESX_MENU.getFocused();
		
		if focused and #focused then  

			local menu    = ESX_MENU.opened[focused.namespace][focused.name];
			local pos     = ESX_MENU.pos[focused.namespace][focused.name];
				
			if pos > 1 then 
				ESX_MENU.pos[focused.namespace][focused.name] = ESX_MENU.pos[focused.namespace][focused.name] - 1;
			else
				ESX_MENU.pos[focused.namespace][focused.name] = #menu.elements ;
			end 
			
			local elem = menu.elements[ESX_MENU.pos[focused.namespace][focused.name]];
			
			for i=1,#menu.elements,1 do
				if(i == ESX_MENU.pos[focused.namespace][focused.name]) then 
					menu.elements[i].selected = true
				else
					menu.elements[i].selected = false
				end 
			end 

			ESX_MENU.change(focused.namespace, focused.name, elem)
			ESX_MENU.render();
		end 
	end 
		
	if json.control == 'DOWN' then 
		local focused = ESX_MENU.getFocused();

		if focused and #(focused) then 
			
			local menu    = ESX_MENU.opened[focused.namespace][focused.name];
			local pos     = ESX_MENU.pos[focused.namespace][focused.name];
			local length  = #menu.elements;

			if (pos < length ) then 
				ESX_MENU.pos[focused.namespace][focused.name] = ESX_MENU.pos[focused.namespace][focused.name] + 1 ;
			else
				ESX_MENU.pos[focused.namespace][focused.name] = 1;
			end 
			
			local elem = menu.elements[ESX_MENU.pos[focused.namespace][focused.name]]

			for i=1,#menu.elements,1 do 
				if(i == ESX_MENU.pos[focused.namespace][focused.name]) then
					menu.elements[i].selected = true
				else
					menu.elements[i].selected = false
				end
			end

			ESX_MENU.change(focused.namespace, focused.name, elem)
			ESX_MENU.render();
			
		end 
		
	end 
	if json.control == 'LEFT' then 
		local focused = ESX_MENU.getFocused();

		if focused and #(focused) then

			local menu    = ESX_MENU.opened[focused.namespace][focused.name];
			local pos     = ESX_MENU.pos[focused.namespace][focused.name];
			local elem    = menu.elements[pos];

			if elem.type == 'slider' then 
				
				local min = elem.min == nil and 1 or elem.min;
				if(elem.value + 1 > min) then 
					elem.value = elem.value -1;
					ESX_MENU.change(focused.namespace, focused.name, elem)
				end 
				ESX_MENU.render();

			end 

		end 
	end 
	if json.control == 'RIGHT' then 
		local focused = ESX_MENU.getFocused();

		if focused and #(focused) then

			local menu    = ESX_MENU.opened[focused.namespace][focused.name];
			local pos     = ESX_MENU.pos[focused.namespace][focused.name];
			local elem    = menu.elements[pos];

			if elem.type == 'slider' then 

				if  elem.options ~=nil and elem.value + 1 < #elem.options then 
					elem.value = elem.value + 1;
					ESX_MENU.change(focused.namespace, focused.name, elem)
				end 

				if elem.max ~=nil and elem.value + 1 < elem.max then
					elem.value = elem.value + 1;
					ESX_MENU.change(focused.namespace, focused.name, elem)
				end 

				ESX_MENU.render();

			end 
		end 
	end 
		
end)
Citizen.CreateThread(function()
	
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	local GUI      = {}
	GUI.Time       = 0
	local MenuType = 'scaleform'
	GMenuType = MenuType
	local openMenu = function(namespace, name, data)
		 SendScaleformMessage({
			action = 'openMenu',
			namespace = namespace,
			name      = name,
			data      = data
		 })
	end

	local closeMenu = function(namespace, name)
		SendScaleformMessage({
		action    = 'closeMenu',
		namespace = namespace,
		name      = name,
		data      = data
		})
		
		
	end

	ESX.UI.Menu.RegisterType(MenuType, openMenu, closeMenu)

	RegisterNetEvent('menu_submit')
	AddEventHandler('menu_submit', function(data, cb)
		--TriggerEvent('localmessage','menu_submit')
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)
		
		if menu.submit ~= nil then
			menu.submit(data, menu)
		end

		cb('OK')
	end)
	
	RegisterNetEvent('menu_cancel')
	AddEventHandler('menu_cancel', function(data, cb)
		--TriggerEvent('localmessage','menu_cancel')
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)
		
		if menu.cancel ~= nil then
			menu.cancel(data, menu)
		end

		cb('OK')
	end)


	RegisterNetEvent('menu_change')
	AddEventHandler('menu_change', function(data, cb)
		--TriggerEvent('localmessage','menu_change')
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)
		
		for i=1, #data.elements, 1 do
			
			menu.setElement(i, 'value', data.elements[i].value)

			if data.elements[i].selected then
				menu.setElement(i, 'selected', true)
			else
				menu.setElement(i, 'selected', false)
			end

		end

		if menu.change ~= nil then
			menu.change(data, menu)
		end

		cb('OK')
	end)

	
	 
	Citizen.CreateThread(function()
		while true do

	  		Wait(10)

			if display == true and scaleform then

				if IsControlPressed(0, Keys['NENTER']) and (GetGameTimer() - GUI.Time) > 150 then
					
					SendScaleformMessage({
						action  = 'controlPressed',
						control = 'ENTER'
					})

					GUI.Time = GetGameTimer()

				end

				if (IsControlPressed(0, Keys['ESC']) or IsControlPressed(0, Keys['NBACKSPACE'])) and (GetGameTimer() - GUI.Time) > 150 then
					
					SendScaleformMessage({
						action  = 'controlPressed',
						control = 'BACKSPACE'
					})
					GUI.Time = GetGameTimer()
				
				end

				if IsDisabledControlPressed(0, Keys['TOP']) and (GetGameTimer() - GUI.Time) > 150 then
					
					SendScaleformMessage({
						action  = 'controlPressed',
						control = 'TOP'
					})

					GUI.Time = GetGameTimer()

				end

				if IsDisabledControlPressed(0, Keys['DOWN']) and (GetGameTimer() - GUI.Time) > 150 then
					
					SendScaleformMessage({
						action  = 'controlPressed',
						control = 'DOWN'
					})

					GUI.Time = GetGameTimer()

				end

				if IsDisabledControlPressed(0, Keys['LEFT']) and (GetGameTimer() - GUI.Time) > 150 then

					SendScaleformMessage({
						action  = 'controlPressed',
						control = 'LEFT'
					})

					GUI.Time = GetGameTimer()

				end

				if IsDisabledControlPressed(0, Keys['RIGHT']) and (GetGameTimer() - GUI.Time) > 150 then

					SendScaleformMessage({
						action  = 'controlPressed',
						control = 'RIGHT'
					})

					GUI.Time = GetGameTimer()

				end
				if IsControlPressed(0, Keys['DELETE'])  then

					ESX.UI.Menu.CloseAll()
				end
			end
	  	end
	end)

end)


Citizen.CreateThread(function()

    scaleform = RequestScaleformMovie("shop_menu")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

	while true do
        if display == true and scaleform then 			
			DrawScaleformMovie_3dSolid(scaleform, 
				ESX_MENU.options.position.x, ESX_MENU.options.position.y, ESX_MENU.options.position.z,
				ESX_MENU.options.rotation.x, ESX_MENU.options.rotation.y, ESX_MENU.options.rotation.z,
				1.0, 1.0, 1.0,
				ESX_MENU.options.scale.x, ESX_MENU.options.scale.y, ESX_MENU.options.scale.z,
				ESX_MENU.options.heading
			)
			Citizen.Wait(0)
		else
			Citizen.Wait(500)
        end 
	end 
end)

function GetCurrentSelection()
    local a = scaleform
        BeginScaleformMovieMethod(a,"GET_CURRENT_SELECTION") --call function
        local b = EndScaleformMovieMethodReturnValue()
        while not IsScaleformMovieMethodReturnValueReady(b) do 
            Citizen.Wait(0)
        end 
        local c = GetScaleformMovieMethodReturnValueInt(b)  --output
        
	return c
end 	

function SetDataSlot(index,item,price)
	local _index = index - 1
	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(_index) -- DATA SLOT ID, the number of the objective in the list
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0) -- 1+ = Star After Item Name
    PushScaleformMovieFunctionParameterInt(0) -- 1+ = shirt icon
    PushScaleformMovieFunctionParameterString(price)
    if type(price) == "number" then price = "$" .. price  end 
    PushScaleformMovieFunctionParameterString(item) -- Name Of Item
    PopScaleformMovieFunctionVoid()
end 

function LoadDict(dict)
    RequestStreamedTextureDict(dict)
    while not HasStreamedTextureDictLoaded(dict) do Wait(0) end
end

function SetOptions(options)
	ESX_MENU.options = options
end

function SetDataSlotEmpty()
	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT_EMPTY")
	PushScaleformMovieFunctionParameterInt(0)
    PopScaleformMovieFunctionVoid()

    SetDescription(" ",45000)
end 	

function SetTitle(title)
	if title then 
		PushScaleformMovieFunction(scaleform, "SET_TITLE")
		PushScaleformMovieFunctionParameterString(title)
		PopScaleformMovieFunctionVoid()
    end 
end 	

function SetHeader(header)
	if header then 
		PushScaleformMovieFunction(scaleform, "SET_HEADER")
		PushScaleformMovieFunctionParameterString(header)
		PopScaleformMovieFunctionVoid()
	end 
end 	

function SetDescription(desc,delay)
	PushScaleformMovieFunction(scaleform, "SET_POPUP")
	PushScaleformMovieFunctionParameterString(desc)
	PushScaleformMovieFunctionParameterInt(delay//1000)
    PopScaleformMovieFunctionVoid()
end 	

function SetImage(txDict,txName)
   if txDict and txName then 
    PushScaleformMovieFunction(scaleform, "SET_IMAGE")
    PushScaleformMovieFunctionParameterString(txDict)
    PushScaleformMovieFunctionParameterString(txName)
    PopScaleformMovieFunctionVoid()
	end 
end 	

function DrawMenuList()
	PushScaleformMovieFunction(scaleform, "DRAW_MENU_LIST")
    PopScaleformMovieFunctionVoid()
end 

function FadeShow()
	PushScaleformMovieFunction(scaleform, "FADE_SHOW")
    PopScaleformMovieFunctionVoid()
end 
	

function DownInputSelection()
	PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
	PushScaleformMovieFunctionParameterInt(9)
    PopScaleformMovieFunctionVoid()
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end 

function UpInputSelection()
	PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
	PushScaleformMovieFunctionParameterInt(8)
    PopScaleformMovieFunctionVoid()
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end 

function SelectItemIndex(index)
	local _index = index - 1
	PushScaleformMovieFunction(scaleform, "SET_ITEMS_NOW")
	PushScaleformMovieFunctionParameterInt(_index)
    PopScaleformMovieFunctionVoid()
end 

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
                if type(k) ~= 'number' then k = '"'..k..'"' end
                s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function EditorModeThread()
    while editorMode do
        Citizen.Wait(5)

		--TODO key helper scaleform?

		-- Al pulsar enter
		if IsControlPressed(0, 201) then
			print(dump(ESX_MENU.options))
			Wait(100)
		end


		if IsDisabledControlPressed(0, Keys['TOP']) then
			
		local _V = vector3(ESX_MENU.options.position.x+0.1, ESX_MENU.options.position.y, ESX_MENU.options.position.z)
			
			ESX_MENU.options.position =	_V

			Wait(100)
		end

		if IsDisabledControlPressed(0, Keys['DOWN']) then
			
			local _V = vector3(ESX_MENU.options.position.x-0.1, ESX_MENU.options.position.y, ESX_MENU.options.position.z)
			
			ESX_MENU.options.position =	_V
			Wait(100)
		end

		if IsDisabledControlPressed(0, Keys['LEFT']) then

			local _V = vector3(ESX_MENU.options.position.x, ESX_MENU.options.position.y-0.1, ESX_MENU.options.position.z)
			
			ESX_MENU.options.position =	_V
			Wait(100)
		end

		if IsDisabledControlPressed(0, Keys['RIGHT']) then

			local _V = vector3(ESX_MENU.options.position.x, ESX_MENU.options.position.y+0.1, ESX_MENU.options.position.z)
			
			ESX_MENU.options.position =	_V
			Wait(100)
		end


		-- Q & E
		if IsDisabledControlPressed(0, 44) then

			local _V = vector3(ESX_MENU.options.position.x, ESX_MENU.options.position.y, ESX_MENU.options.position.z+0.1)
			
			ESX_MENU.options.position =	_V
			Wait(100)
		end

		if IsDisabledControlPressed(0, 38) then

			local _V = vector3(ESX_MENU.options.position.x, ESX_MENU.options.position.y, ESX_MENU.options.position.z-0.1)
			
			ESX_MENU.options.position =	_V
			Wait(100)
		end


		-- K
		if IsDisabledControlPressed(0, 311) then

			local _V = vector3(ESX_MENU.options.rotation.x+0.1, ESX_MENU.options.rotation.y, ESX_MENU.options.rotation.z)
			
			ESX_MENU.options.rotation =	_V
			Wait(100)
		end

		-- L
		if IsDisabledControlPressed(0, 182) then

			local _V = vector3(ESX_MENU.options.rotation.x-0.1, ESX_MENU.options.rotation.y, ESX_MENU.options.rotation.z)
			
			ESX_MENU.options.rotation =	_V
			Wait(100)
		end

		-- G
		if IsDisabledControlPressed(0, 47) then

			local _V = vector3(ESX_MENU.options.rotation.x, ESX_MENU.options.rotation.y+0.1, ESX_MENU.options.rotation.z)
			
			ESX_MENU.options.rotation =	_V
			Wait(100)
		end

		-- F
		if IsDisabledControlPressed(0, 23) then

			local _V = vector3(ESX_MENU.options.rotation.x, ESX_MENU.options.rotation.y-0.1, ESX_MENU.options.rotation.z)
			
			ESX_MENU.options.rotation =	_V
			Wait(100)
		end


		--Y
		if IsControlPressed(0, 246) then

			local _V = vector3(ESX_MENU.options.rotation.x, ESX_MENU.options.rotation.y, ESX_MENU.options.rotation.z+0.1)
			
			ESX_MENU.options.rotation =	_V
			Wait(100)
		end

		--U
		if IsControlPressed(0, 303) then

			local _V = vector3(ESX_MENU.options.rotation.x, ESX_MENU.options.rotation.y, ESX_MENU.options.rotation.z-0.1)
			
			ESX_MENU.options.rotation =	_V
			Wait(100)
		end
    end
end

RegisterCommand('scaleditor', function()
	editorMode = not editorMode

	if editorMode then
		Citizen.CreateThread(function()
			EditorModeThread()
		end)
	end
end)


