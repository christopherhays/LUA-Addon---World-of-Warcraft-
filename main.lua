-- message('Realm Detector addon loaded.')





print('Realm Detector addon loaded.')

local myNew_EventFrame = CreateFrame("Frame")
myNew_EventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
myNew_EventFrame:SetScript("OnEvent",
	function(self, event)
    
        
        function Set (list)
            local set = {}
            for _, l in ipairs(list) do set[l] = true end
            return set
        end
        
        local badRealmList = Set { "Azralon", "Ragnaros", "Gallywix"            -- list of realms to be avoided
        
        local memberCount = GetNumGroupMembers()
        local realmCount = 0
        if UnitInRaid('player') ~= nil then  -- if we are in a raid
            for var=1,memberCount do
                name, realm = UnitName('raid' ..var)
                if realm == nil or realm == '' then
                    realm = GetRealmName()
                end
                if badRealmList[realm] then
                    realmCount = realmCount + 1
                    print(name.. '-' ..realm)   -- print the name to chat
                end
            end
        else    -- if we are not in a raid
            memberCount = memberCount - 1       -- to account for self
            if memberCount ~= 0 then            -- if we are not alone
                for var=1,memberCount do
                    name, realm = UnitName('party' ..var)
                    if realm == nil or realm == '' then
                        realm = GetRealmName()
                    end
                    if badRealmList[realm] then
                        realmCount = realmCount + 1
                        print(name.. '-' ..realm)   -- print the name to chat
                    end
                end
            end
        end
        if realmCount > 0 then  -- print a personal raid warning
            RaidNotice_AddMessage(RaidWarningFrame, realmCount.. ' from flagged servers.', ChatTypeInfo["RAID_WARNING"])
            PlaySound("RaidWarning", "master")
            print('There are ' ..realmCount.. ' people from flagged servers in your group.')
        end
	end)
