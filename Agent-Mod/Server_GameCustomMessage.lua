require('Utilities')



function Server_GameCustomMessage(game, playerID, payload, setReturnTable)
  local type = Nonill(payload.entrytype)
  local typename = Nonill(payload.typename)
  local typecost = Nonill(payload.cost)
  local typetext = Nonill(payload.text)
  local goldhave = game.ServerGame.LatestTurnStanding.NumResources(playerID, WL.ResourceType.Gold)
   publicdata = Mod.PublicGameData
       if publicdata[playerID] == nil then publicdata[playerID] = {} end
       if publicdata.Ranklist == nil then publicdata.Ranklist = {} end
       if publicdata.AgentRank == nil then publicdata.AgentRank = {} end
       if publicdata.id == nil then publicdata.id = 0 end

  
    if publicdata[playerID].Agency ~= nil and false then -- things being cheaper if your agency is ranked higher 
      local hold = 1 / publicdata[playerID].Agency.agencyRank
      if hold == 1 then hold = 0.75 end -- making sure agents aren't free if there number one
      local costhold = typecost * hold
  
      typecost = typecost - costhold
    end
  
    if (goldhave < typecost) then  -- don't have enough money
      setReturnTable({ Message = "You need " .. typecost .. " gold to purchase a " .. typename .. ". you need ".. typecost - goldhave ..  " more gold to purchase this unit", Pass = false})
        return
      end
  
      game.ServerGame.SetPlayerResource(playerID, WL.ResourceType.Gold, goldhave - typecost);
  
    if type == 0 then -- when your buying a new agency    
      --Initing  
        print("agency created")
  
      if publicdata[playerID].Agency == nil then publicdata[playerID].Agency = {} end
      if publicdata[playerID].Agency.agencyname == nil then publicdata[playerID].Agency.agencyname = typetext end
      if publicdata[playerID].Agency.agencyrating == nil then  publicdata[playerID].Agency.agencyrating = 0 end
       if publicdata[playerID].Agency.agencyRank == nil then publicdata[playerID].Agency.agencyRank = 0 end
       if publicdata[playerID].Agency.AgencyKills == nil then publicdata[playerID].Agency.AgencyKills = 0 end
       if publicdata[playerID].Agency.Missions == nil then publicdata[playerID].Agency.Missions = 0 end
       if publicdata[playerID].Agency.successfulmissions == nil then publicdata[playerID].Agency.successfulmissions = 0 end
        if publicdata[playerID].Agency.Protectionrate == nil then  publicdata[playerID].Agency.Protectionrate = 0 end
  
        table.insert(publicdata.Ranklist,publicdata[playerID].Agency)
        print (publicdata[playerID].Agency.agencyrating)
        setReturnTable({ Message = nil, Pass = true})

      
    elseif type == 1 then -- when you buy a decoy
      if publicdata[playerID].Agency.Decoylist == nil then publicdata[playerID].Agency.Decoylist = {}end
      if publicdata[playerID].Agency.Decoylist[#publicdata[playerID].Agency.Decoylist] == nil then 
        publicdata[playerID].Agency.Decoylist[#publicdata[playerID].Agency.Decoylist]  = 0 end

        publicdata[playerID].Agency.agencyrating = publicdata[playerID].Agency.agencyrating + 1 -- adding for agency rating
        setReturnTable({ Message = "Decoy successfully Set up ", Pass = true})
        publicdata[playerID].Agency.Missions = 10

  
  elseif type == 2 then -- when your buying a new agent
    if publicdata[playerID].Agency.Agentlist == nil then publicdata[playerID].Agency.Agentlist = {} end
    if publicdata[playerID].Agency.Agentlist[#publicdata[playerID].Agency.Agentlist + 1] == nil then 
      publicdata[playerID].Agency.Agentlist[#publicdata[playerID].Agency.Agentlist + 1 ]  = {} end 
      local short = publicdata[playerID].Agency.Agentlist[#publicdata[playerID].Agency.Agentlist]

      if short.PlayerofAgentID == nil then short.PlayerofAgentID = playerID end
      if short.codename == nil then short.codename = typetext end
      if short.level == nil then short.level = 1 end
      if short.kills == nil then short.kills = 0 end
      if short.missions == nil then short.missions = 0 end
      if short.cooldownTill == nil then short.cooldownTill = Mod.Settings.Cooldown end
      if short.agentID == nil then short.agentID = publicdata.id end
      if short.missuccessfulmissionssions == nil then short.successfulmissions = 0 end -- our XP
      if short.agentHomeAgency == nil then short.agentHomeAgency = publicdata[playerID].Agency.agencyname end
      table.insert(publicdata.AgentRank,short)


      publicdata.id = publicdata.id + 1
      publicdata.AgentRank[publicdata.id].codename = short.codename



print(publicdata.AgentRank[publicdata.id] , short) -- prints table addresses of current cycle (the same)
print(publicdata.AgentRank[publicdata.id].codename , short.codename) -- prints names (the same)
print(publicdata.AgentRank[1].codename , publicdata[playerID].Agency.Agentlist[1].codename) -- prints name of cyle one, if on cycle one, line 1 and 2 are the same
publicdata[playerID].Agency.Agentlist[1].codename = "Tim" -- i comment this out on cycle one, then on cycle two i remove the comment to update the table of cycle one
short.codename = "True bobo" -- update current cycle name
print(publicdata.AgentRank[publicdata.id].codename , short.codename) -- current cycle, they always update no matter what.
print(publicdata.AgentRank[1].codename , publicdata[playerID].Agency.Agentlist[1].codename) -- heres the problem, when i uncomment from above. it does not update both tables with the new name " Tim"
      publicdata[playerID].Agency.agencyrating = publicdata[playerID].Agency.agencyrating + 1 -- 1 for agent level. agency rating

      setReturnTable({ Message = "Agent Code Name '".. short.codename .. "' successfully Trained. ", Pass = true})
    elseif type == 3 then -- updating cooldown
      
      publicdata[playerID].Agency.Agentlist[typetext].cooldownTill = game.Game.TurnNumber + Mod.Settings.Cooldown

    end
  
    Mod.PublicGameData = publicdata

end