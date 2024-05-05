require('Utilities')

function Server_StartGame (game,standing)

    Pub = Mod.PublicGameData
    Pub.Terrain = {}
    Game = game
    local LandTable =  Mod.Settings.Landdata
    local firstTile = {}

--Init Values
    for i, v in pairs (LandTable) do
        firstTile[i] = {}
        firstTile[i].First = false
        firstTile[i].TileID = 0
    end
        for Tid,ts in pairs(standing.Territories) do
            Pub.Terrain[Tid] = {}
            Pub.Terrain[Tid].values = {}
            local found = false
            for i,v in pairs (LandTable) do
                
                if (ts.NumArmies.NumArmies == v.C_Autofind or ts.NumArmies.NumArmies == v.C_AutoP) and (v.C_Inverse == 1 or v.C_Inverse == 2)  then -- standard template settings.
                    if Pub.Terrain[Tid].values.name == nil or Pub.Terrain[Tid].values.BaseSettings == 4 or v.C_Inverse == 3 then -- deciding how ownership value works

                        firstTile[i] = ID_decider(Tid,v,ts,firstTile[i])
                    end

                    Pub.Terrain[Tid].values.name = v.C_Name
                    Pub.Terrain[Tid].values.turnstart = v.C_Turnstart
                    Pub.Terrain[Tid].values.turnend = v.C_Turnend
                    Pub.Terrain[Tid].values.armyValueChange = v.C_Value
                    Pub.Terrain[Tid].values.ModControl = Modloader(v.C_Modsetting)
                    Pub.Terrain[Tid].values.UnitControl = v.C_Unittype
                    Pub.Terrain[Tid].values.BaseSettings = v.C_Inverse

                    Pub.Terrain[Tid].values.Removebuild = v.C_RemoveBuild
                    found = true
                elseif found == false and (v.C_Inverse == 4 or v.C_Inverse == 3) and (ts.NumArmies.NumArmies ~= v.C_Autofind and ts.NumArmies.NumArmies ~= v.C_AutoP) then -- for every other tile not included in a template and that setting has been turned on with the setting C_Inverse = 4
                    if Pub.Terrain[Tid].values.name == nil then -- deciding how ownership value works
                        firstTile[i] = ID_decider(Tid,v,ts,firstTile[i])
                    end

                    Pub.Terrain[Tid].values.name = v.C_Name
                    Pub.Terrain[Tid].values.turnstart = v.C_Turnstart
                    Pub.Terrain[Tid].values.turnend = v.C_Turnend
                    Pub.Terrain[Tid].values.armyValueChange = v.C_Value
                    Pub.Terrain[Tid].values.ModControl = v.C_Modsetting
                    Pub.Terrain[Tid].values.UnitControl = v.C_Unittype
                    Pub.Terrain[Tid].values.BaseSettings = v.C_Inverse

                    Pub.Terrain[Tid].values.Removebuild = v.C_RemoveBuild
                end

            end
            if Pub.Terrain[Tid].values.name == nil then
                Pub.Terrain[Tid].values.name = "No Terrain Type" end

        end

        Mod.PublicGameData = Pub
end
function ID_decider(Tid,v,ts,first)

    if  v.C_TerrainTypeID == -3 then -- changes to first tile ID it comes across

        if first.First == false then
            Pub.Terrain[Tid].values.OwnerID = ts.OwnerPlayerID 
            first.TileID = ts.OwnerPlayerID
            first.First = true 
        else
            Pub.Terrain[Tid].values.OwnerID = first.TileID
        end

    elseif v.C_TerrainTypeID == -2 then -- does not change
        Pub.Terrain[Tid].values.OwnerID = nil
    elseif  v.C_TerrainTypeID == -1 then -- keep ownership of all current tiles
        Pub.Terrain[Tid].values.OwnerID = ts.OwnerPlayerID 
    elseif  v.C_TerrainTypeID == 0 then -- changes it to 0
        Pub.Terrain[Tid].values.OwnerID = 0
    elseif  v.C_TerrainTypeID > 0 then -- Manual ID input (changes to neutral if ID was not found)

        local Idinput = Findmatch(Game.Game.PlayingPlayers,v.C_TerrainTypeID,"ID")
        Pub.Terrain[Tid].values.OwnerID = Idinput
    end
    return first
end