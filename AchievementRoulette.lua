SLASH_ACHIEVE1 = "/ar"

local function AchieveR()
    local wow = ""
    --Removes world events and feats of strength from pool
    -- 160 Lunar Festival
    -- 187 Love is in the Air
    -- 159 Noblegarden
    -- 163 Children's Week
    -- 161 Midsummer
    -- 15274 Events
    -- 162 Brewfest
    -- 15268 Promotions
    -- 158 Hallow's End
    -- 14981 Pilgrim's Bounty
    -- 15416 & 155 World Events
    -- 156 Winter Veil
    -- 81 Feats of Strength
    -- 15234 Legacy
    
    local cancelList = {161,160,187,159,163,15274,162,15268,158,155,156,81,15234,14981,15416} -- Id Labels above.
    local check = 0
    local cateCheck = 0
    local idTable = GetCategoryList()
    while check == 0 do
        cateCheck = 0
        local category = math.random(1,#idTable)
        local __, __, incomplete = GetCategoryNumAchievements(idTable[category])
        if incomplete ~= 0 then
            local categoryID = idTable[category]
            local index = math.random(1,incomplete)
            local id, ach, __, comp, __, __, __, desc, __, __, __, __, __, __, __ = GetAchievementInfo(categoryID, index)
            if not comp then
                --check that category is not in cancelled list
                for i=1,#cancelList do
                    if categoryID == cancelList[i] then
                        cateCheck = 1
                    end
                end
                --if everything is clear, use this achievement
                if cateCheck == 0 then
                    wow = wow .. ach .. "\n" .. desc .. "\n\nhttps://www.wowhead.com/achievement=" .. id .. "\n ^ Copy this into your browser, and look in comments for additional information."
                    AddTrackedAchievement(id)
                    check = 1
                end
            end
        end
    end
    EditBox_Show(wow)
end

-- Editbox frame from https://www.wowinterface.com/forums/showpost.php?p=323901&postcount=2
-- Used instead of default message box since so much cleaner

function EditBox_Show(text)
    if not EditBox then
        local f = CreateFrame("Frame", "EditBox", UIParent, "DialogBoxFrame")
        f:SetPoint("CENTER")
        f:SetSize(600, 500)
        
        f:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
            edgeSize = 16,
            insets = { left = 8, right = 6, top = 8, bottom = 8 },
        })
        f:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
        
        -- Movable
        f:SetMovable(true)
        f:SetClampedToScreen(true)
        f:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                self:StartMoving()
            end
        end)
        f:SetScript("OnMouseUp", f.StopMovingOrSizing)
        
        -- ScrollFrame
        local sf = CreateFrame("ScrollFrame", "EditBoxScrollFrame", EditBox, "UIPanelScrollFrameTemplate")
        sf:SetPoint("LEFT", 16, 0)
        sf:SetPoint("RIGHT", -32, 0)
        sf:SetPoint("TOP", 0, -16)
        sf:SetPoint("BOTTOM", EditBoxButton, "TOP", 0, 0)
        
        -- EditBox
        local eb = CreateFrame("EditBox", "EditBoxEditBox", EditBoxScrollFrame)
        eb:SetSize(sf:GetSize())
        eb:SetMultiLine(true)
        eb:SetAutoFocus(false) -- dont automatically focus
        eb:SetFontObject("ChatFontNormal")
        eb:SetScript("OnEscapePressed", function() f:Hide() end)
        sf:SetScrollChild(eb)
        
        -- Resizable
        f:SetResizable(true)
        f:SetMinResize(150, 100)
        
        local rb = CreateFrame("Button", "EditBoxResizeButton", EditBox)
        rb:SetPoint("BOTTOMRIGHT", -6, 7)
        rb:SetSize(16, 16)
        
        rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
        rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
        rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
        
        rb:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                f:StartSizing("BOTTOMRIGHT")
                self:GetHighlightTexture():Hide() -- more noticeable
            end
        end)
        rb:SetScript("OnMouseUp", function(self, button)
            f:StopMovingOrSizing()
            self:GetHighlightTexture():Show()
            eb:SetWidth(sf:GetWidth())
        end)
        f:Show()
    end
    if text then
        EditBoxEditBox:SetText(text)
    end
    EditBox:Show()
end

SlashCmdList["ACHIEVE"] = AchieveR
