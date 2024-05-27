require('Utilities')
require('Utilities2')
require('WLUtilities')

-- Things to add to GameCreation settings
-- Max turns

function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, game, close)
	Game = game;
	Close = close;
	publicdate = Mod.PublicGameData
	
	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	if (game.Us == nil or game.Us.State ~= WL.GamePlayerState.Playing) then
		UI.CreateLabel(vert).SetText("You cannot gift gold since you're not in the game")
		return
	end
	if (game.Settings.CommerceGame == false) then
		UI.CreateLabel(vert).SetText("This mod only works in commerce games.  This isn't a commerce game.");
		return;
	end
	-- Payment Varibles
	 temphidden = Mod.Settings.Hidden -- if game has already started. set values
	 tempGoldtax = Mod.Settings.GoldTax
	 Temppercent = Mod.Settings.Percent
	 Contbool = false
	 GoldSetbtn = nil
	 TargetPlayerBtn = nil
	 Reveal = nil
	 AdvanceBtn = nil
	 Cont = nil
	 GoldInput = nil
	 TurnSetbtn = nil
	 Searchbtn = nil
	if(temphidden == nil)then temphidden = false end
	if(tempGoldtax == nil)then tempGoldtax = 0 end
	if(Temppercent == nil)then Temppercent = 0 end
	playerpicked = false
	GoldHave = game.LatestStanding.NumResources(game.Us.ID, WL.ResourceType.Gold)
	Entities = Entitygroup(game.Game.PlayingPlayers,game)
	

-- updated features here
	setMaxSize(450, 320)

	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	local row0 = UI.CreateHorizontalLayoutGroup(vert)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row3 = UI.CreateHorizontalLayoutGroup(vert)
	
--Payment options
	UI.CreateButton(row0).SetText("Single payment").SetOnClick(function () Dialogwindow(1,close,nil) end )
	UI.CreateButton(row0).SetText("Set payments").SetOnClick(function () Dialogwindow(4,close,nil) end )
-- Payment history
	UI.CreateButton(row0).SetText("Payment History").SetOnClick(function () Dialogwindow(3,close,nil) end ).SetInteractable(not temphidden)
	UI.CreateButton(row0).SetText("Payment Plans").SetOnClick(function () Dialogwindow(2,close,nil) end )

--Account Info
	UI.CreateButton(row1).SetText("Create Account").SetOnClick(function () Dialogwindow(5,close,nil) end )
	UI.CreateButton(row1).SetText("Your Account").SetOnClick(function () Dialogwindow(6,close,nil) end )
	UI.CreateButton(row1).SetText("All Accounts").SetOnClick(function () Dialogwindow(7,close,nil) end )

	TaxText(row3)

end

--Ui info for your account
function CreateAccount(rootParent, setMaxSize, setScrollable, game, close)
	--Create the entity then preform a single payment
	setMaxSize(450, 320)
	local player = game.Game.PlayingPlayers[game.Us.ID]
	local income = player.Income(0, game.LatestStanding, false, false) 
	Memberlist = {}
	Ownerlist = {}

	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)
	local row3 = UI.CreateHorizontalLayoutGroup(vert)
	local row4 = UI.CreateHorizontalLayoutGroup(vert)
	local row5 = UI.CreateHorizontalLayoutGroup(vert)
	local row6 = UI.CreateHorizontalLayoutGroup(vert)
	local row7 = UI.CreateHorizontalLayoutGroup(vert)
	local row8 = UI.CreateHorizontalLayoutGroup(vert)



	-- Name of account
	UI.CreateLabel(vert).SetText("Name your account ")
	Acountname = UI.CreateTextInputField(vert).SetPlaceholderText(" Name of account               ").SetFlexibleWidth(1).SetCharacterLimit(25)
	
	--Inial Deposit
	UI.CreateLabel(row2).SetText('Inial Deposit ')
	Deposit = UI.CreateNumberInputField(row2)
	.SetSliderMinValue(1)
	.SetSliderMaxValue(income.Total)
	.SetValue(1)

	--Add Owners
	UI.CreateLabel(row3).SetText("Add Owner to account ") -- selecting player
	TargetOwnerBtn = UI.CreateButton(row3).SetText("Select player...").SetOnClick(function () TargetPlayerClicked(0) end)
	--Add memeber
	UI.CreateLabel(row4).SetText("Add member to account ") -- selecting player
	TargetMemberBtn = UI.CreateButton(row4).SetText("Select player...").SetOnClick(function () TargetPlayerClicked(1) end)

	--Showing Owners/Members list
	UI.CreateLabel(row5).SetText("Owners ------")
	Ownernames = UI.CreateLabel(row6).SetText("")
	UI.CreateLabel(row7).SetText("memebers ------")
	membernames = UI.CreateLabel(row8).SetText("")
--[[]

		for i, v in pairs (Ownerlist) do
		Ownernames = UI.CreateLabel(row6).SetText(Ownernames.GetText() .. " \n" .. game.Game.Players[v].DisplayName(nil, false) )
		end

		for i, v in pairs (Memberlist) do
		membernames = UI.CreateLabel(row8).SetText(membernames.GetText() .. " \n" .. game.Game.Players[v].DisplayName(nil, false) )
		end ]]--

		Subbtn = UI.CreateButton(vert).SetText("Create Account").SetOnClick(function () SubmitClicked(close,0,Ownerlist,Memberlist)end).SetInteractable(true).SetColor('#0021FF')

end
-- UI for The current accounts your currently in
function YourAccount(rootParent, setMaxSize, setScrollable, game, close)
end
-- UI for All accounts that exist
function AllAccounts(rootParent, setMaxSize, setScrollable, game, close)
end
--UI for Basic gifting gold
function Giftgold(rootParent, setMaxSize, setScrollable, game, close)
	setMaxSize(450, 320)
	local vert = UI.CreateVerticalLayoutGroup(rootParent)


 -- creating rows
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)

	local row4 = UI.CreateHorizontalLayoutGroup(vert)

	UI.CreateLabel(row1).SetText("Gift gold to this player: ") -- selecting player
	TargetPlayerBtn = UI.CreateButton(row1).SetText("Select player...").SetOnClick(TargetPlayerClicked)

	UI.CreateLabel(row2).SetText('Amount of gold to give away: ') -- selecting gold amount
    GoldInput = UI.CreateNumberInputField(row2)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(GoldHave)
		.SetValue(1)

-- enacting the gift gold logic	
	Giftbtn = UI.CreateButton(vert).SetText("Gift").SetOnClick(function () SubmitClicked(close,0)end).SetInteractable(playerpicked).SetColor('#0021FF')

	--Tax logic


	Reveal = UI.CreateCheckBox(row4).SetText("Reveal Gold amount").SetIsChecked(true)

end
-- UI for Set turns 
function SetTurns(rootParent, setMaxSize, setScrollable, game, close)
	setMaxSize(500, 320)
	MaxTurns = 20
	if Mod.Settings.Plan ~= nil then
		MaxTurns = Mod.Settings.Plan
	end
	local player = game.Game.PlayingPlayers[Game.Us.ID]
	local income = player.Income(0, game.LatestStanding, false, false) 
	Max75 = math.floor(income.Total * 0.75)

	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)
	local row3 = UI.CreateHorizontalLayoutGroup(vert)
	local row4 = UI.CreateHorizontalLayoutGroup(vert)

	UI.CreateLabel(row1).SetText("Gift gold to this player: ") -- selecting player
	TargetPlayerBtn = UI.CreateButton(row1).SetText("Select player...").SetOnClick(TargetPlayerClicked)

	UI.CreateLabel(row2).SetText("The amount of gold to send per turn")
    GoldSetbtn = UI.CreateNumberInputField(row2)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(Max75)
		.SetValue(1)

	UI.CreateLabel(row3).SetText("The amount of turns this process will last")
    TurnSetbtn = UI.CreateNumberInputField(row3)
		.SetSliderMinValue(2)
		.SetSliderMaxValue(MaxTurns)
		.SetValue(2).SetInteractable(false)

		Cont = UI.CreateCheckBox(row4).SetText("Locked ").SetIsChecked(Contbool).SetOnValueChanged(Numberson)
		Reveal = UI.CreateCheckBox(row4).SetText("Reveal Gold amount").SetIsChecked(true).SetInteractable(false)
		AdvanceBtn = UI.CreateButton(row4).SetText("Gift").SetOnClick(function () SubmitClicked(close,0)end).SetInteractable(false).SetColor('#0021FF')

		UI.CreateLabel(vert).SetText("You cannot cancel this payment early if the 'Locked' button is selected").SetColor('#E5FF00')

end
-- UI display for current plans
function Plans(rootParent, setMaxSize, setScrollable, game, close)
	setMaxSize(560, 320)
	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	if publicdate.PayP ~= nil and #publicdate.PayP.Plan > 0 then

		local row0 = UI.CreateHorizontalLayoutGroup(vert)
		local sortedPlans = SortTable(publicdata.PayP.Plan,"Turntill")
		for i = 1, #sortedPlans do
			local rowT = UI.CreateHorizontalLayoutGroup(vert)
	
			local playername = Game.Game.Players[sortedPlans[i].ID].DisplayName(nil, false)
			if temphidden == true then playername = "???" end
			UI.CreateLabel(rowT).SetText(playername ).SetColor('#FFE5B4')
			UI.CreateLabel(rowT).SetText( " sends " .. sortedPlans[i].aftertax .. " gold per turn to ").SetColor('#FF697A')
			UI.CreateLabel(rowT).SetText(Game.Game.Players[sortedPlans[i].targetplayer].DisplayName(nil, false) .. "  ").SetColor('#FFE5B4')

			print(sortedPlans[i].cont,"cont")
			if sortedPlans[i].cont == 2 then -- Set amount

				UI.CreateLabel(rowT).SetText("  Turns left: " .. sortedPlans[i].Turntill - game.Game.TurnNumber).SetColor('#00B5FF')

			elseif sortedPlans[i].cont == 1 then -- only continues
				local mind = true
				if sortedPlans[i].ID ~= Game.Us.ID then mind = false end
				UI.CreateButton(rowT).SetText("Cancel Plan").SetColor('#1274A4').SetOnClick(function () SubmitClicked(close,i)end).SetInteractable(mind)
			end
		end
	else 
		UI.CreateLabel(vert).SetText("No payment plans have been created")
	end
end
-- Main UI display for all history functions
function History(rootParent, setMaxSize, setScrollable, game, close)
	setMaxSize(500, 320)
	Destroygroup = {}

	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	local row0 = UI.CreateHorizontalLayoutGroup(vert)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	if publicdate.PayP ~= nil and #publicdate.PayP.History > 0 then
	OptionA = UI.CreateButton(row0).SetText("Total payments").SetInteractable(true).SetColor('#0021FF').SetOnClick(function () OptionAfunc(vert)end)
	OptionB = UI.CreateButton(row0).SetText("Payments by players").SetInteractable(true).SetColor('#0021FF').SetOnClick(function () OptionBfunc(vert)end)

	else 
		UI.CreateLabel(vert).SetText("No one has gifted gold yet")
	end


end
-- UI display for all gold payments
function OptionAfunc(vert)
	OptionA.SetInteractable(false).SetColor("#FF0000")
	OptionB.SetInteractable(true).SetColor("#0021FF")
	Destroylogic()
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	table.insert(Destroygroup,row1)
	local sortedpayments = SortTable(publicdate.PayP.History,"turn")
	local color = '#FF697A'
	local turn = 1
	for i, v in pairs (sortedpayments) do
		if turn ~= v.turn then -- colors
			turn = v.turn
			if color == "#BABABC" then color = '#FF697A'
			else 
			color = "#BABABC"
			end end -- end of colors

		local row1 = UI.CreateHorizontalLayoutGroup(vert)
		local spacer = v.goldamount
		table.insert(Destroygroup,row1)
		local playername = Game.Game.Players[v.from].DisplayName(nil, false)
		if v.noshow ~= nil then spacer = v.noshow end

		
		Destroygroup[#Destroygroup+1] = UI.CreateLabel(row1).SetText(playername ).SetColor('#FFE5B4')
		Destroygroup[#Destroygroup+1] = UI.CreateLabel(row1).SetText( " sent " .. spacer .. " gold to ").SetColor(color)
		Destroygroup[#Destroygroup+1] = UI.CreateLabel(row1).SetText( " " .. Game.Game.Players[v.to].DisplayName(nil, false) .. "  ").SetColor('#FFE5B4')
		Destroygroup[#Destroygroup+1] = UI.CreateLabel(row1).SetText( " On turn ".. v.turn).SetColor(color)

	end


end
-- UI display for payment by player
function OptionBfunc(vert)
	OptionB.SetInteractable(false).SetColor("#FF0000")
	OptionA.SetInteractable(true).SetColor("#0021FF")
	Destroylogic()


	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	TargetPlayerBtn = UI.CreateButton(row1).SetText("from player...").SetOnClick(TargetPlayerClicked)
	Searchbtn = UI.CreateButton(row1).SetText("search").SetOnClick(function()Byplayer(vert)end).SetInteractable(false)
	table.insert(Destroygroup,TargetPlayerBtn)
	table.insert(Destroygroup,row1)
	table.insert(Destroygroup,Searchbtn)




end
-- UI functionally and logic for viewing payment histroy by players
function Byplayer(vert)
	local searchtable = {}
	for i, v in pairs (publicdate.PayP.History) do
		if TargetPlayerID == publicdate.PayP.History[i].from then
			if searchtable[v.to] == nil then
				searchtable[v.to] = {}
				if v.noshow ~= nil then searchtable[v.to].hide = v.noshow
					searchtable[v.to].gold = 0
				else 
					searchtable[v.to].gold = v.goldamount 
				end

				
			else
				if v.noshow ~= nil then searchtable[v.to].hide = v.noshow 
				else 
				searchtable[v.to].gold = searchtable[v.to].gold + v.goldamount end
			end
		end
	end
	local row0 = UI.CreateHorizontalLayoutGroup(vert)
	table.insert(Destroygroup,row0)
	local playername = Game.Game.Players[TargetPlayerID].DisplayName(nil, false)

	Destroygroup[#Destroygroup+1] = UI.CreateLabel(row0).SetText("Total gold sent by " ).SetColor('#00FF05')
	Destroygroup[#Destroygroup+1] = UI.CreateLabel(row0).SetText(" " ..playername ).SetColor('#FFE5B4')
	for i, v in pairs (searchtable) do
		local row1 = UI.CreateHorizontalLayoutGroup(vert)
		local spacer = ""
		if v.hide ~= nil then spacer = v.hide .. " + "end
		table.insert(Destroygroup,row1)
		Destroygroup[#Destroygroup+1] = UI.CreateLabel(row1).SetText(spacer .. v.gold .. " gold to ").SetColor('#FF697A')
		Destroygroup[#Destroygroup+1] = UI.CreateLabel(row1).SetText( " " .. Game.Game.Players[i].DisplayName(nil, false) .. "  ").SetColor('#FFE5B4')
	end
end

-- Submit orders
function SubmitClicked(close,plan,data,data2)
close()
	--Check for negative gold. We don't need to check to ensure we have this much since the server does that check in Server_GameCustomMessage
	local gold = 0
	if GoldInput ~= nil then gold = GoldInput.GetValue() end
	local setturns = 0
	local setgold = 0
	local setup = 0
	local con = false
	local rev = false
	if Reveal ~= nil then rev = Reveal.GetIsChecked() end
	if Cont ~= nil then con = Cont.GetIsChecked() end
	if (gold <= 0 and GoldInput ~= nil) then
		UI.Alert("Gold to gift must be a positive number")
		return
	end
	
	if GoldSetbtn ~= nil and plan == 0 and gold == 0 then
		if GoldSetbtn.GetValue() < 1 or TurnSetbtn.GetValue() < 2  or TurnSetbtn.GetValue() > MaxTurns or GoldSetbtn.GetValue() > Max75 then
			 UI.Alert("Your Turns cannot go below 2\nYour Gold cannot exceed 75% (" .. Max75 .." gold) of your income and cannot go below 1\nYour Turns cannot exceed " .. MaxTurns .. " turns")
				 return end
		setturns = TurnSetbtn.GetValue()
		setgold = GoldSetbtn.GetValue()
		setup = 2
	end
	if plan > 0 then setup = 5 end 

	
	local payload = {};
	payload.TargetPlayerID = TargetPlayerID
	payload.Gold = gold;
	payload.multiplier = tempGoldtax
	payload.sendername = Game.Us.DisplayName(nil,false)
	payload.ourID = Game.Us.ID
	payload.reveal = rev
	payload.hidden = temphidden
	payload.percent = Temppercent
	payload.setgold = setgold
	payload.setturn = setturns
	payload.Cont = con
	payload.setup = setup
	payload.planid = plan
	payload.owners = Ownerlist
	payload.members = Memberlist
	payload.Accountname = ""

	----------------------- new shit

--print(Game.Us.ID .. ' '.. payload.sendername .. ' ' .. payload.TargetPlayerID)
	print("made it",plan)
	Game.SendGameCustomMessage("Gifting gold...", payload, function(returnValue) 
		UI.Alert(returnValue.Message)

		if (returnValue.realGold ~= nil)then
		local msg = '(Local info) \n' .. returnValue.realGold  .. ' Gold sent from ' .. Game.Us.DisplayName(nil,false) .. ' to ' .. Game.Game.Players[TargetPlayerID].DisplayName(nil, false);
		local payload = 'GiftGold2' .. gold .. ',' .. returnValue.realGold  .. ',' .. TargetPlayerID
		

		local orders = Game.Orders
		table.insert(orders, WL.GameOrderCustom.Create(Game.Us.ID, msg, payload))
		Game.Orders = orders

		

		end

		Close(); --Close the dialog since we're done with it
	end);
end
-- Prompt list functionally for players Entities
function TargetEntitiesClicked()

	local Entitygroup = filter(Entities, function (p) return p.ID ~= Game.Us.ID end)
	if Searchbtn ~= nil then Entitygroup = Game.Game.Players end 
	local players = Entitygroup
	local options = map(players, PlayerButton)
	UI.PromptFromList("Select the Location you'd like to send money to", options)
end

--promptlist functionally for player only 
function TargetPlayerClicked(acton)
	Action = acton
	local playergroup = filter(Entities, function (p) return (p.ID ~= Game.Us.ID) or (p.ID >= 1) end)
	local players = playergroup
	local options = map(players, PlayerButton)
	UI.PromptFromList("Select the player you would like to add to you'd like to send money to", options)
end
function PlayerButton(entity)
	local name = entity.Name
	local ret = {};
	ret["text"] = name;
	ret["selected"] = function() 
		TargetPlayerBtn.SetText(name)
		TargetPlayerID = entity.ID
		if Giftbtn ~= nil then
			Giftbtn.SetInteractable(true) end
		if Searchbtn ~= nil then Searchbtn.SetInteractable(true) end
		if AdvanceBtn ~= nil then AdvanceBtn.SetInteractable(true) end
		--Create Account logic
		if Action == 0 then table.insert(Ownerlist,TargetPlayerID)
			Ownernames.SetText(Ownernames.GetText() .. " \n" ..Game.Game.Players[TargetPlayerID].DisplayName(nil, false))
			TargetOwnerBtn.SetText(name)
		elseif Action == 1 then table.insert(Memberlist,TargetPlayerID) 
			membernames.SetText(membernames.GetText() .. " \n" ..Game.Game.Players[TargetPlayerID].DisplayName(nil, false))
			TargetMemberBtn.SetText(name) end

	end
	return ret
end
-- Text storage Function
function TaxText(row3)
	if (tempGoldtax > 0 )then
		UI.CreateLabel(row3).SetText("Gifting Gold to someone applies a Tax. First tax applies after " .. tempGoldtax .. " gold has been sent. each gold piece after that cost 1 gold for every " .. tempGoldtax .. " you send").SetColor('#00F4FF')
		elseif (Temppercent > 0)then
			UI.CreateLabel(row3).SetText("Gifting Gold to someone applies a Tax. Tax is equal to " .. Temppercent .. "%").SetColor('#00F4FF')
		else 
			UI.CreateLabel(row3).SetText("No Tax Applied").SetColor('#00F4FF')
		end
end

-- Display window for creating new popup windows

function Dialogwindow(window, close, data) -- middle function to open up new windows
	publicdata = Mod.PublicGameData


	if window == 1 then --Advanced options
		Game.CreateDialog(Giftgold)
		close()
    elseif window == 2 then -- Payment plans
		Game.CreateDialog(Plans)
		close()
	elseif window == 3 then -- Payment history
		Game.CreateDialog(History)
		close()
	elseif window == 4 then -- Set Turns
		Game.CreateDialog(SetTurns)
		close()
	elseif window == 5 then --  Create an account
		Game.CreateDialog(CreateAccount)
	elseif window == 6 then -- your account
		Game.CreateDialog(YourAccount)
		close()
	elseif window == 7 then -- All Accounts
		Game.CreateDialog(AllAccounts)
		close()
	end
end

-- wrapper function
function Numberson()
	TurnSetbtn.SetInteractable(Cont.GetIsChecked())
end
	--Logic to destroy elements in view money history
function Destroylogic()
	for i=1 ,#Destroygroup do 
		UI.Destroy(Destroygroup[i])
	end
	Destroygroup = {}
end
