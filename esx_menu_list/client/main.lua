ESX = nil

Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(200)
	end

	local MenuType    = 'list'
	local OpenedMenus = {}
	local OpenedMenuCount = 0

	local openMenu = function(namespace, name, data)
		local menuKey = namespace .. '_' .. name

		if not OpenedMenus[menuKey] then
			OpenedMenus[menuKey] = true
			OpenedMenuCount = OpenedMenuCount + 1
		end

		SendNUIMessage({
			action    = 'openMenu',
			namespace = namespace,
			name      = name,
			data      = data
		})

		ESX.SetTimeout(200, function()
			SetNuiFocus(true, true)
		end)

	end

	local closeMenu = function(namespace, name)
		local menuKey = namespace .. '_' .. name

		if OpenedMenus[menuKey] then
			OpenedMenus[menuKey] = nil
			OpenedMenuCount = math.max(OpenedMenuCount - 1, 0)
		end

		SendNUIMessage({
			action    = 'closeMenu',
			namespace = namespace,
			name      = name
		})

		if OpenedMenuCount == 0 then
			SetNuiFocus(false)
		end

	end

	ESX.UI.Menu.RegisterType(MenuType, openMenu, closeMenu)

	RegisterNUICallback('menu_submit', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

		if menu.submit ~= nil then
			menu.submit(data, menu)
		end

		cb('OK')
	end)

	RegisterNUICallback('menu_cancel', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

		if menu.cancel ~= nil then
			menu.cancel(data, menu)
		end

		cb('OK')
	end)


	Citizen.CreateThread(function()
		while true do
			local sleep = 1000

			if OpenedMenuCount > 0 then
				sleep = 0
				DisableAllControlActions(0)
				DisableAllControlActions(1)
				DisableAllControlActions(2)
				DisableControlAction(0, 200, true) -- Pause menu
				DisableControlAction(0, 322, true) -- ESC
			end

			Citizen.Wait(sleep)
		end
	end)

end)
