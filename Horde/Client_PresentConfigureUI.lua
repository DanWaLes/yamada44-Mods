
function Client_PresentConfigureUI(rootParent)

	--Troop converted to horde
	local slot = Mod.Settings.Slot
	if slot == nil then
		slot = 1
	else 
		slot = slot + 1
	end

	local troopscon = Mod.Settings.TConv
	if troopscon == nil then
		troopscon = 80
	end

	--structure type
	local struc = Mod.Settings.StructureType
	if struc == nil then
		struc = 0
	end

	--gold cost of hive
	local hivecost = Mod.Settings.HiveCost
	if hivecost == nil then
		hivecost = 500
	end

	-- max hivies
	local maxH = Mod.Settings.Maxhives
	if maxH == nil then
		maxH = 0
	end

	--auto place hibes
	local auto = Mod.Settings.Auto
	if auto == nil then
		auto = 0
	end

	--can play diplos cards
	local playD = Mod.Settings.PlayDip
	if playD == nil then
		playD = false
	end

	-- can play airlift cards
	local playA = Mod.Settings.PlayAir
	if playA == nil then
		playA = false
	end

	-- can play sanctions
	local playS = Mod.Settings.PlaySan
	if playS == nil then
		playS = false
	end

	--can/cannot deploy troops
	local trdeploy = Mod.Settings.TDep
	if trdeploy == nil then
		trdeploy = true
	end	

	-- can play Reinforcement
	local ref = Mod.Settings.PlayRef
	if ref == nil then
		ref = false
	end	

	-- cities are removed if owned by this slot
	local cityremoved = Mod.Settings.CityG
	if cityremoved == nil then
		cityremoved = 1
	end

	--This slot cannot build cities
	local city9 = Mod.Settings.Nocities
	if city9 == nil then
		city9 = false
	end	

	local vert = UI.CreateVerticalLayoutGroup(rootParent)

	local row0 = UI.CreateHorizontalLayoutGroup(vert); -- Slot
	UI.CreateButton(row0).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Only this slot in game will have these affects applied to it") end)
	UI.CreateLabel(row0).SetText('Which Slot is the Horde')
    Slotfield = UI.CreateNumberInputField(row0)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(40)
		.SetValue(slot)

    local row1 = UI.CreateHorizontalLayoutGroup(vert) -- troops converted
	UI.CreateButton(row1).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("After each kill what percentage of troops are transfered to your side. this works while defending and attacking\nSet to 0 to disable") end)
	UI.CreateLabel(row1).SetText('Percentage of troops converted after each kill')
    Convfield = UI.CreateNumberInputField(row1)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(100)
		.SetValue(troopscon)

	local row2 = UI.CreateHorizontalLayoutGroup(vert) -- structure type
	UI.CreateButton(row2).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("What Structure type can this slot build\n0 - Feature disabled\n1 - Cities\n2 - Army Camp\n3 - Mine\n4 - Smelter\n5 - Crafter\n6 - Market\n7 - Army Cache\n8 - Money Cache\n9 - Money Cache\n10 - Resource Cache\n11 - Mercenary Camp\n12 - Man and gun\n13 - Arena\n14 - Hospital\n15 - Dig Site\n16 - Artillery\n17 - Mortar\n18 - Book\nSet to 0 to disable") end)
	UI.CreateLabel(row2).SetText('Building type')
	Buildfield = UI.CreateNumberInputField(row2)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(18)
		.SetValue(struc)

	local row3 = UI.CreateHorizontalLayoutGroup(vert); -- Hive Cost
	UI.CreateButton(row3).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("The cost of each Structure type") end)
	UI.CreateLabel(row3).SetText('Cost of each Hive')
	Costfield = UI.CreateNumberInputField(row3)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(1000)
		.SetValue(hivecost)

	local row4 = UI.CreateHorizontalLayoutGroup(vert) -- Max Hives
	UI.CreateButton(row4).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("How many Structures of this type can you have\nSet to 0 to disable while still having the auto placer work") end)
	UI.CreateLabel(row4).SetText('Max Hive amount')
	Maxfield = UI.CreateNumberInputField(row4)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(20)
		.SetValue(maxH)

		local row5 = UI.CreateHorizontalLayoutGroup(vert) -- Autoplacer for Hives
		UI.CreateButton(row5).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Go into custom scenrio, change the army value of a tile to this value. when the game starts it will have this territory") end)
	UI.CreateLabel(row5).SetText('Auto place Hives')
	Autofield = UI.CreateNumberInputField(row5)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(1234)
		.SetValue(auto)

	local row55 = UI.CreateHorizontalLayoutGroup(vert) -- City removed for Hives
	UI.CreateButton(row55).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("") end)
	UI.CreateLabel(row55).SetText('Cities removed if Owned')
	CityGone = UI.CreateNumberInputField(row55)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(10)
		.SetValue(cityremoved)

	local row6 = UI.CreateHorizontalLayoutGroup(vert) -- Can Deploy troops
	UI.CreateButton(row6).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("") end)
	UI.CreateLabel(row6).SetText('Can this slot Deploy Troops')
	Deployfield = UI.CreateCheckBox(row6).SetText("").SetIsChecked(trdeploy)

	local row7 = UI.CreateHorizontalLayoutGroup(vert) -- can play airlift cards
	UI.CreateButton(row7).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("") end)
	UI.CreateLabel(row7).SetText('Can this slot play Airlift cards')
	Airfield = UI.CreateCheckBox(row7).SetText("").SetIsChecked(playA)

	local row8 = UI.CreateHorizontalLayoutGroup(vert) -- can play sanction cards
	UI.CreateButton(row8).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("") end)
	UI.CreateLabel(row8).SetText('Can this slot play Sanction cards')
	Sanfield = UI.CreateCheckBox(row8).SetText("").SetIsChecked(playS)

	local row9 = UI.CreateHorizontalLayoutGroup(vert) -- can play Diplo cards
	UI.CreateButton(row9).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("") end)
	UI.CreateLabel(row9).SetText('Can this slot play Diplomacy cards')
	Dipfield = UI.CreateCheckBox(row9).SetText("").SetIsChecked(playD)

	local row11 = UI.CreateHorizontalLayoutGroup(vert) -- can play Refin cards
	UI.CreateButton(row11).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("") end)
	UI.CreateLabel(row11).SetText('Can this slot play Reinforcement cards')
	Reffield = UI.CreateCheckBox(row11).SetText("").SetIsChecked(ref)

	local row10 = UI.CreateHorizontalLayoutGroup(vert) -- cannot build cities if true
	UI.CreateButton(row10).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("") end)
	UI.CreateLabel(row10).SetText('Can this Slot build cities')
	Nocities = UI.CreateCheckBox(row10).SetText("").SetIsChecked(city9)

	
end