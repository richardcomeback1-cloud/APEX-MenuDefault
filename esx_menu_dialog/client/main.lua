Citizen.CreateThread(function()
	-- internal variables
	ESX               = nil
	local focusTimeout = nil
	local MenuType    = 'dialog'
	local OpenedMenus = {}
	local OpenedMenuCount = 0

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(200)
	end

	local openMenu = function(namespace, name, data)
		if focusTimeout ~= nil then
			ESX.ClearTimeout(focusTimeout)
			focusTimeout = nil
		end

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

		focusTimeout = ESX.SetTimeout(200, function()
			SetNuiFocus(true, true)
			focusTimeout = nil
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
		local post = true

		if menu.submit ~= nil then

			-- Is the submitted data a number?
			if tonumber(data.value) ~= nil then

				-- Round float values
				data.value = ESX.Math.Round(tonumber(data.value))

				-- Check for negative value
				if tonumber(data.value) <= 0 then
					post = false
				end
			end

			data.value = ESX.Math.Trim(data.value)

			-- Don't post if the value is negative or if it's 0
			if post then
				menu.submit(data, menu)
			else
				ESX.ShowNotification('That input is invalid!')
			end
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

	RegisterNUICallback('menu_change', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

		if menu.change ~= nil then
			menu.change(data, menu)
		end

		cb('OK')
	end)

	Citizen.CreateThread(function()
		while true do
			local sleep = 1000

			if OpenedMenuCount > 0 then
				sleep = 0
				DisableControlAction(0, 1,   true) -- LookLeftRight
				DisableControlAction(0, 2,   true) -- LookUpDown
				DisableControlAction(0, 142, true) -- MeleeAttackAlternate
				DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
				DisableControlAction(0, 12, true) -- WeaponWheelUpDown
				DisableControlAction(0, 14, true) -- WeaponWheelNext
				DisableControlAction(0, 15, true) -- WeaponWheelPrev
				DisableControlAction(0, 16, true) -- SelectNextWeapon
				DisableControlAction(0, 17, true) -- SelectPrevWeapon
			end

			Citizen.Wait(sleep)
		end
	end)
end)
