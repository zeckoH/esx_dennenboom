Config = {}
Config.Locale = 'en'

Config.Marker = {
	r = 150, g = 100, b = 255, a = 100,  -- red color
	x = 1.5, y = 1.5, z = 1.0,       -- tiny, cylinder formed circle
	DrawDistance = 15.0, Type = 1    -- default circle type, low draw distance due to indoors area
}

Config.PoliceNumberRequired = 4
Config.TimerBeforeNewRob    = 120000 -- Cooldown timer 

Config.MaxDistance    = 10   -- max distance from the robbary, going any longer away from it will to cancel the robbary
Config.GiveBlackMoney = true -- geef zwartgeld, if false krijgt overvaller witgeld op de bank. 

Stores = {
	["store_one"] = {
		position = { x = -2957.53, y = 481.63, z = 15.7 },
		reward = math.random(30000, 70000), -- Buit van de winkel (tussen 30.000 - 70.000) <- verander naar gewenste aantal. 
		nameOfStore = "Winkel - Mirrorpark", -- Naam van de winkel
		secondsRemaining = 500, -- seconds
		lastRobbed = 0
	},
}
