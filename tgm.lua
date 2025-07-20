local _G, _ = _G or getfenv()

local TGM = CreateFrame("Frame")

TGM.prefix = 'GM_ADDON'
TGM.version = GetAddOnMetadata("gm-addon", "Version")
-- .shop log accountname

TGM.tickets = {}
TGM.ticket = nil
TGM.ticketFrames = {}
TGM.lastmessage = nil

TGM.races = {
    [1] = 'Human',
    [2] = 'Orc',
    [3] = 'Dwarf',
    [4] = 'Nightelf',
    [5] = 'Undead',
    [6] = 'Tauren',
    [7] = 'Gnome',
    [8] = 'Troll',
    [9] = 'Goblin',
    [10] = 'High Elf'
}

TGM.classes = {
    [1] = 'Warrior',
    [2] = 'Paladin',
    [3] = 'Hunter',
    [4] = 'Rogue',
    [5] = 'Priest',
    [7] = 'Shaman',
    [8] = 'Mage',
    [9] = 'Warlock',
    [11] = 'Druid'
}

TGM.classColors = {
    ["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45, colorStr = "ffabd473" },
    ["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79, colorStr = "ff9482c9" },
    ["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0, colorStr = "ffffffff" },
    ["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73, colorStr = "fff58cba" },
    ["MAGE"] = { r = 0.41, g = 0.8, b = 0.94, colorStr = "ff69ccf0" },
    ["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41, colorStr = "fffff569" },
    ["DRUID"] = { r = 1.0, g = 0.49, b = 0.04, colorStr = "ffff7d0a" },
    ["SHAMAN"] = { r = 0.0, g = 0.44, b = 0.87, colorStr = "ff0070de" },
    ["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43, colorStr = "ffc79c6e" }
};

TGM:RegisterEvent("ADDON_LOADED")
TGM:RegisterEvent("CHAT_MSG_ADDON")
TGM:RegisterEvent("CHAT_MSG_SYSTEM")

TGM:SetScript("OnEvent", function()
    if event then
        if event == "ADDON_LOADED" and string.lower(arg1) == 'gm-addon' then
            TGM.init()
            local delay = tonumber(TGM_CONFIG.susdelay) or 5
            if delay > 0 then
            setTimer(delay, TGM.loginCommands)
            end
        end
        if event == 'CHAT_MSG_SYSTEM' then
            TGM.handleSystemMessage(arg1)
        end
        if event == 'CHAT_MSG_ADDON' and arg1 == TGM.prefix then
            TGM.handleAddonMessage(arg2)
        end

    end

end)

local timer = CreateFrame("FRAME");
--'duration' is in seconds and 'func' is the function that will be executed in the end
function setTimer(duration, func)
	local endTime = GetTime() + duration;
	
	timer:SetScript("OnUpdate", function()
		if(endTime < GetTime()) then
			--time is up
			func();
			timer:SetScript("OnUpdate", nil);
		end
	end);
end

function TGM.init()

    if not TGM_CONFIG then
        TGM_CONFIG = {
            tasound = "ta-ticket.ogg",
            nordsound = "nord-ticket.ogg",
            abandonsound = "abandon.ogg",
            claimsound = nil,
        }
    end

    if not TGM_DATA then
        TGM_DATA = {
            scale = 1,
            templates = {
                {
                    title = 'Example Template',
                    text = 'Hello! Feel free to expand this and write your own templates!'
                },
            },
            alpha = 1
        }
    end

    _G['TGM']:SetScale(TGM_DATA.scale)
    _G['TGM']:SetAlpha(TGM_DATA.alpha)
    TGMTitle:SetText("Turtle WoW GM Addon ("..TGM.version..")")
    TGM.disableButtonsAndText()
end

function TGM.loginCommands()
    -- Send commands on login
        SendChatMessage(".gm ingame", "SAY")
        SendChatMessage(".sus enable on", "SAY")
        SendChatMessage(".sus notify on", "SAY")
        SendChatMessage(".sus movementenable on", "SAY")
        SendChatMessage(".sus fishingenable on", "SAY")
        SendChatMessage(".sus killednpcenabled off", "SAY")

end

function TGM.clearScrollbarTexture(frame)
    _G[frame:GetName() .. 'ScrollUpButton']:SetNormalTexture(nil)
    _G[frame:GetName() .. 'ScrollUpButton']:SetDisabledTexture(nil)
    _G[frame:GetName() .. 'ScrollUpButton']:SetPushedTexture(nil)
    _G[frame:GetName() .. 'ScrollUpButton']:SetHighlightTexture(nil)

    _G[frame:GetName() .. 'ScrollDownButton']:SetNormalTexture(nil)
    _G[frame:GetName() .. 'ScrollDownButton']:SetDisabledTexture(nil)
    _G[frame:GetName() .. 'ScrollDownButton']:SetPushedTexture(nil)
    _G[frame:GetName() .. 'ScrollDownButton']:SetHighlightTexture(nil)

    _G[frame:GetName() .. 'ThumbTexture']:SetTexture(nil)
end

function TGM.disableButtonsAndText()
    TGMLeftPanelResponsePlayerName:SetText()
    TGMLeftPanelResponseAccount:SetText()
    TGMLeftPanelResponseIP:SetText()
    TGMLeftPanelResponseLevel:SetText()
    TGMLeftPanelResponseEmail:SetText()
    TGMLeftPanelResponseForum:SetText()
    TGMLeftPanelResponseOnlineStatus:SetText()
    TGMLeftPanelResponseRaceClass:SetText()

    TGMLeftPanelResponseRespondToMailbox:Disable()
    TGMLeftPanelResponseRespondToChat:Disable()
    TGMLeftPanelResponseCloseTicket:Disable()

    TGMLeftPanelResponseGoTo:Disable()
    TGMLeftPanelResponseSummon:Disable()
    TGMLeftPanelResponseInfo:Disable()
    TGMLeftPanelResponseRecall:Disable()
    TGMLeftPanelResponseBaninfo:Disable()
    TGMLeftPanelResponseTarget:Disable()
    TGMLeftPanelResponseShopLog:Disable()

    TGMLeftPanelResponsePlayerNameCopyButton:Disable()
    TGMLeftPanelResponseAccountCopyButton:Disable()
    TGMLeftPanelResponseIPCopyButton:Disable()
end

function TGM.enableButtons()
    TGMLeftPanelResponseRespondToMailbox:Enable()
    TGMLeftPanelResponseRespondToChat:Enable()
    TGMLeftPanelResponseCloseTicket:Enable()

    TGMLeftPanelResponseGoTo:Enable()
    TGMLeftPanelResponseSummon:Enable()
    TGMLeftPanelResponseInfo:Enable()
    TGMLeftPanelResponseRecall:Enable()
    TGMLeftPanelResponseBaninfo:Enable()
    TGMLeftPanelResponseTarget:Enable()
    TGMLeftPanelResponseShopLog:Enable()

    TGMLeftPanelResponsePlayerNameCopyButton:Enable()
    TGMLeftPanelResponseAccountCopyButton:Enable()
    TGMLeftPanelResponseIPCopyButton:Enable()
end

function TGM.handleSystemMessage(text)

    -- refresh tickets on new ticket
    if string.find(text, "New ticket", 1, true) then
		local soundfile = TGM_CONFIG.nordsound
		if GetRealmName() == "Tel'Abim" then soundfile = TGM_CONFIG.tasound end
		PlaySoundFile("Interface\\AddOns\\gm-addon\\sounds\\"..soundfile)
        TGM_refreshTickets()
        return
    end

    -- refresh tickets on ticket assign
    if string.find(text, "Ticket", 1, true) and
            string.find(text, "abandoned", 1, true) then
            local soundfile = TGM_CONFIG.abandonsound
            PlaySoundFile("Interface\\AddOns\\gm-addon\\sounds\\"..soundfile)
            TGM_refreshTickets()
        return
    end

    if string.find(text, "Ticket", 1, true) and
                string.find(text, "Assigned to", 1, true) then
        
        if TGM_CONFIG.claimsound then
            local soundfile = TGM_CONFIG.claimsound
            PlaySoundFile("Interface\\AddOns\\gm-addon\\sounds\\"..soundfile)
        end
        TGM_refreshTickets()
        return
    end

    -- stop if no ticket is active
    if not TGM.ticket then
        return
    end

end

function TGM.handleAddonMessage(m)

    if string.find(m, 'tickets;;start', 1, true) then
        TGM.tickets = {}
    elseif string.find(m, 'tickets;;end', 1, true) then
        TGM.processTickets()
    elseif string.find(m, 'tickets;;', 1, true) then

        --tickets;;id;;name;;playeronlinestatus;;ticketassignedstatus;;tickettimestamp;;ticket_text

        local t = __explode(m, ';;')

        local stamp = string.format(SecondsToTime(time() - tonumber(t[6])))

        TGM.tickets[__length(TGM.tickets) + 1] = {
            id = tonumber(t[2]),
            name = t[3],
            onlineStatus = t[4] == 'online' and '|cff00ff00online' or '|cffff0000offline',
            assigned = t[5],
            stamp = stamp,
            message = t[7],
            message_replaced = __replace(t[7], "\n", ""),
        }

    elseif string.find(m, 'playerinfo;;', 1, true) then

        --playerinfo;;guid;;account;;ip;;level;;email;;forumusername;;race;;class

        local pi = __explode(m, ";;")
        local guid = pi[2]
        local account = pi[3]
        local ip = pi[4]
        local level = tonumber(pi[5])
        local email = pi[6]
        local forum = pi[7]
        local race = pi[8]
        local class = pi[9]

        if TGM.ticket then
            TGM.ticket.guid = guid
            TGM.ticket.account = account
            TGM.ticket.ip = ip
            TGM.ticket.level = level
            TGM.ticket.email = email
            TGM.ticket.forum = forum
            TGM.ticket.raceClass = TGM.races[tonumber(race)] ..
                    " |c" ..
                    TGM.classColors[string.upper(TGM.classes[tonumber(class)])].colorStr ..
                    TGM.classes[tonumber(class)]

            TGMLeftPanelResponseTitle:SetText("Ticket |cffffffff" .. TGM.ticket.id .. " |rcreated |cffffffff" ..
                    TGM.ticket.stamp .. "|rago by |c" .. TGM.classColors[string.upper(TGM.classes[tonumber(class)])].colorStr .. TGM.ticket.name)

            TGMLeftPanelResponsePlayerName:SetText("Name: |cffffffff" .. TGM.ticket.name)
            TGMLeftPanelResponsePlayerNameCopyEditbox:SetText(TGM.ticket.name)
            TGMLeftPanelResponseAccount:SetText("Account: |cffffffff" .. TGM.ticket.account)
            TGMLeftPanelResponseAccountCopyEditbox:SetText(TGM.ticket.account)
            TGMLeftPanelResponseIP:SetText("IP: |cffffffff" .. TGM.ticket.ip)
            TGMLeftPanelResponseLevel:SetText("Level: |cffffffff" .. TGM.ticket.level)
            TGMLeftPanelResponseEmail:SetText("E-mail: |cffffffff" .. TGM.ticket.email)
            TGMLeftPanelResponseForum:SetText("Forum: |cffffffff" .. TGM.ticket.forum)
            TGMLeftPanelResponseOnlineStatus:SetText("Online Status: |cffffffff" .. TGM.ticket.onlineStatus)
            TGMLeftPanelResponseRaceClass:SetText("Race/Class: |cffffffff" .. TGM.ticket.raceClass)

            TGMLeftPanelResponseTicketScrollFrameTicketBox:SetText(TGM.ticket.message)

            TGMLeftPanelResponseCloseTicket:SetID(TGM.ticket.id)

            TGM.enableButtons()

            TGMLeftPanelResponseReplyScrollFrameReplyBox:SetText('')
            TGMLeftPanelResponseReplyScrollFrameReplyBox:ClearFocus()

        end
    end
end

function TGM.processTickets()

    for i, frame in next, TGM.ticketFrames do
        frame:Hide()
    end

    for i, data in next, TGM.tickets do

        if not TGM.ticketFrames[i] then
            TGM.ticketFrames[i] = CreateFrame("Frame", "TGM_Ticket_" .. i, TGMRightPanelScrollFrameChild, "TGMTicketTemplate")
        end

        local frame = "TGM_Ticket_" .. i

        _G[frame]:SetPoint("TOPLEFT", TGMRightPanelScrollFrameChild, "TOPLEFT", 11, 26 - 26 * i)

        _G[frame .. 'TicketIndex']:SetText('|cffffffff' .. i)
        _G[frame .. 'PlayerName']:SetText(data.name)
        _G[frame .. 'TicketTextShort']:SetText(string.sub(data.message_replaced, 1, 35) .. '...')
        _G[frame .. 'AssignButton']:SetID(data.id)
        _G[frame .. 'ManageTicket']:SetID(data.id)

        _G[frame .. 'Selected']:Hide()

        if TGM.ticket and data.id == TGM.ticket.id then
            _G[frame .. 'Selected']:Show()
        end

        if data.assigned == '0' then
            _G[frame .. 'AssignButton']:SetText('-Assign-')
        else
            _G[frame .. 'AssignButton']:SetText('|cffffffff' .. data.assigned)
        end

        _G[frame]:Show()
    end

    TGMRightPanelTicketCount:SetText('Tickets (' .. __length(TGM.tickets) .. ')')

    TGMRightPanelScrollFrame:UpdateScrollChildRect();
    TGMRightPanelScrollFrame:SetVerticalScroll(0)

    TGM.clearScrollbarTexture(TGMRightPanelScrollFrameScrollBar)


end

function TGM_AssignTicket(id)

    for _, data in next, TGM.tickets do
        if data.id == id then
            if data.assigned == '0' then
                SendChatMessage('.ticket assign ' .. id .. ' ' .. UnitName('player'))
            else
                SendChatMessage('.ticket unassign ' .. id)
            end
        end
    end
    --TGM_refreshTickets()
end

function TGM_ManageTicket(id)
    TGM.ticket = {}
    for i, data in next, TGM.tickets do
        if data.id == id then
            TGM.ticket = data
            _G["TGM_Ticket_" .. i .. 'Selected']:Show()
            _G["TGM_Ticket_" .. i .. 'Selected']:SetVertexColor(1, 1, 1, 0.2)
        else
            _G["TGM_Ticket_" .. i .. 'Selected']:Hide()
        end
    end

    if not TGM.ticket.name then
        return
    end

    TGM.send("PLAYER_INFO:" .. TGM.ticket.name)
    -- rest is in addon_message handler
end

function TGM_refreshTickets()
    TGM.send("GET_TICKETS")
end

function TGM_CloseTicket(id)
    SendChatMessage('.ticket close ' .. id)

    TGMLeftPanelResponseTicketScrollFrameTicketBox:SetText('')
    TGMLeftPanelResponseTicketScrollFrameTicketBox:ClearFocus()
    TGMLeftPanelResponseReplyScrollFrameReplyBox:SetText('')
    TGMLeftPanelResponseReplyScrollFrameReplyBox:ClearFocus()
    TGMLeftPanelResponseTitle:SetText('')
    TGM.disableButtonsAndText()
    TGM_refreshTickets()

    TGM.ticket = nil
end

function TGM_MailPlayer()

    local text = TGMLeftPanelResponseReplyScrollFrameReplyBox:GetText()
    if text == '' then
        return
    end

    SendChatMessage('.send mail ' .. TGM.ticket.name .. ' "Ticket" "' .. text .. '"')
    TGM.lastmessage = text
    TGMLeftPanelResponseReplyScrollFrameReplyBox:SetText('')
    TGMLeftPanelResponseReplyScrollFrameReplyBox:ClearFocus()
end

function TGM_WhisperPlayer()
    local text = TGMLeftPanelResponseReplyScrollFrameReplyBox:GetText()
    if text == '' then
        return
    end

    SendChatMessage(text, "WHISPER", DEFAULT_CHAT_FRAME.editBox.languageID, TGM.ticket.name);
    TGM.lastmessage = text
    TGMLeftPanelResponseReplyScrollFrameReplyBox:SetText('')
    TGMLeftPanelResponseReplyScrollFrameReplyBox:ClearFocus()
end

function TGM_GoToPlayer()
    SendChatMessage('.goname ' .. TGM.ticket.name)
end

function TGM_SummonPlayer()
    SendChatMessage('.summon ' .. TGM.ticket.name)
end

function TGM_PlayerInfo()
    SendChatMessage('.pinfo ' .. TGM.ticket.name)
end

function TGM_Target()
    TargetByName(TGM.ticket.name)
end

function TGM_BanInfo()
    SendChatMessage('.baninfo account ' .. TGM.ticket.account)
end

function TGM_Recall()
    SendChatMessage('.recall ' .. TGM.ticket.name)
end

function TGM_ShopLog()
    SendChatMessage('.shop log ' .. TGM.ticket.account)
end

function TGM_Toggle()
    if _G['TGM']:IsVisible() then
        _G['TGM']:Hide()
    else
        _G['TGM']:Show()
    end
end

function TGM_CopyButtonOnClick(field)

    if IsShiftKeyDown() then


        if ChatFrameEditBox:IsVisible() then
            if field == 'PlayerName' then
                ChatFrameEditBox:Insert(TGM.ticket.name);
            end
            if field == 'Account' then
                ChatFrameEditBox:Insert(TGM.ticket.account);
            end
            if field == 'IP' then
                ChatFrameEditBox:Insert(TGM.ticket.ip);
            end
            return
        end

        --DEFAULT_CHAT_FRAME:AddMessage("|Hplayer:Sausage|h" .. "[Sausage]" .. "|h");
        return
    end

    --_G['TGMLeftPanelResponse' .. field .. 'CopyButton']:Hide()
    --_G['TGMLeftPanelResponse' .. field .. 'CopyEditbox']:Show()
    --_G['TGMLeftPanelResponse' .. field .. 'CopyEditbox']:SetFocus()
    --_G['TGMLeftPanelResponse' .. field .. 'CopyEditbox']:HighlightText()
end

function TGM_CopyEditboxOnEscape(field)
    --_G['TGMLeftPanelResponse' .. field .. 'CopyButton']:Show()
    --_G['TGMLeftPanelResponse' .. field .. 'CopyEditbox']:Hide()
    --_G['TGMLeftPanelResponse' .. field .. 'CopyEditbox']:ClearFocus()
end

function TGM_OnMouseWheel()

    if IsControlKeyDown() then
        TGM_DATA.alpha = TGM_DATA.alpha + arg1 * 0.05
        if TGM_DATA.alpha > 1 then
            TGM_DATA.alpha = 1
        end
        if TGM_DATA.alpha < 0.1 then
            TGM_DATA.alpha = 0.1
        end
        _G['TGM']:SetAlpha(TGM_DATA.alpha)
        return
    end

    if IsShiftKeyDown() then
        TGM_DATA.scale = 1
        _G['TGM']:SetScale(TGM_DATA.scale)
        return
    end
    TGM_DATA.scale = TGM_DATA.scale + arg1 * 0.05
    _G['TGM']:SetScale(TGM_DATA.scale)
end

TGM.templatesFrames = {}
TGM.templatePage = 1
TGM.search = nil

function TGM_TemplatePage(page)
    local col, row = 1, 1
    local start = 1
    local current = 1

    if page > 1 and __length(TGM_DATA.templates) > 30 then
        start = ((page-1) * 30)
    end

    if TGM.search then
        for i, data in next, TGM_DATA.templates do
            local frame = "TGM_ResponseTemplate_" .. i
            _G[frame]:Hide()
        end
    end
 
    for i, data in next, TGM_DATA.templates do repeat
        
        if start > 1 then
            if current < start then
                current = current + 1
                do break end 
            end
        end
        
        if not TGM.search or string.find(data.title, TGM.search, 1, true) or string.find(data.text, TGM.search, 1, true) then

            local frame = "TGM_ResponseTemplate_" .. i

            _G[frame]:SetPoint("TOPLEFT", TGMTemplatesPanel, "TOPLEFT", 18 - 260 + 260 * col, -30 * row)
            _G[frame .. 'Button']:SetText(data.title)
            _G[frame .. 'Button']:SetID(i)
            _G[frame .. 'EditButton']:SetID(i)
            _G[frame .. 'DeleteButton']:SetID(i)

            _G[frame]:Show()

            col = col + 1
            if row == 15 and col > 2 then return end
            if col > 2 then
                col = 1
                row = row + 1
            end
        end

    until true end
    TGM.search = nil
end

function __length(arr)
    if not arr then
        return 0
    end
    local rd = 0
    for a in next, arr do
        rd = rd + 1
    end
    return rd
end


function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
  end

function TGM_TemplatePageUp()
    local max = round(round((__length(TGM_DATA.templates)/30)+.5,2))
    TGM.templatePage = TGM.templatePage + 1
    if TGM.templatePage > max then TGM.templatePage = max end
    TGM_CloseTemplates()
    TGM_ToggleTemplates()
end

function TGM_TemplatePageDown()
    TGM.templatePage = TGM.templatePage - 1
    if TGM.templatePage < 1 then TGM.templatePage = 1 end
    TGM_CloseTemplates()
    TGM_ToggleTemplates()
end

function TGM_ToggleTemplates()
    
    TGMRightPanel:Hide()
    TGMTemplatesPanel:Show()

    for _, frame in next, TGM.templatesFrames do
        frame:Hide()
    end

    for i, data in next, TGM_DATA.templates do
        
        if not TGM.templatesFrames[i] then
            TGM.templatesFrames[i] = CreateFrame("Frame", "TGM_ResponseTemplate_" .. i, TGMTemplatesPanel, "TGM_ResponseTemplate")
        end
    end

    TGM_TemplatePage(TGM.templatePage)

end

function TGM_UseTemplate()

    TGMLeftPanelResponseReplyScrollFrameReplyBox:SetText(TGM_DATA.templates[this:GetID()].text)

    TGMTemplatesPanel:Hide()
    TGMRightPanel:Show()
end

function TGM_SaveTemplate()
    TGMLeftPanelResponseReplyScrollFrameReplyBox:ClearFocus()
    StaticPopup_Show('TGM_NEW_TEMPLATE')
end

function TGM_RecallLast()
    if TGM.lastmessage then
        TGMLeftPanelResponseReplyScrollFrameReplyBox:SetText(TGM.lastmessage)
    end
end

TGM.templateToDelete = 0
function TGM_DeleteTemplate()
    TGM.templateToDelete = this:GetID()
    StaticPopup_Show('CONFIRM_DELETE_TEMPLATE')
end

function TGM.send(m)
    --DEFAULT_CHAT_FRAME:AddMessage("Send:" .. m)
    SendAddonMessage(TGM.prefix, m, "GUILD")
end

TGM.templateToEdit = 0
function TGM_EditTemplate()
    TGM.templateToEdit = this:GetID()
    StaticPopup_Show('TGM_EDIT_TEMPLATE_TITLE')
end

function TGM_SearchTemplates()
    StaticPopup_Show('TGM_SEARCH_TEMPLATES')
end

function TGM_CloseTemplates()
    TGMTemplatesPanel:Hide()
    TGMRightPanel:Show()
end

function __length(arr)
    if not arr then
        return 0
    end
    local rd = 0
    for a in next, arr do
        rd = rd + 1
    end
    return rd
end

function __explode(str, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from, 1, true)
    while delim_from do
        tinsert(result, string.sub(str, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from, true)
    end
    tinsert(result, string.sub(str, from))
    return result
end

function __replace(s, c, cc)
    return (string.gsub(s, c, cc))
end

StaticPopupDialogs["TGM_NEW_TEMPLATE"] = {
    text = "Enter Template Title:",
    button1 = "Save",
    button2 = "Cancel",
    hasEditBox = 1,
    autoFocus = 1,
    OnAccept = function()
        local templateTitle = getglobal(this:GetParent():GetName() .. "EditBox"):GetText()
        if templateTitle == '' then
            StaticPopup_Show('TGM_TEMPLATES_EMPTY_TITLE')
            return
        end

        TGM_DATA.templates[table.getn(TGM_DATA.templates) + 1] = {
            title = templateTitle,
            text = TGMLeftPanelResponseReplyScrollFrameReplyBox:GetText(),
        }

        getglobal(this:GetParent():GetName() .. "EditBox"):SetText('')
        DEFAULT_CHAT_FRAME:AddMessage('Template ' .. templateTitle .. ' added.')

    end,
    timeout = 0,
    whileDead = 0,
    hideOnEscape = 1,
};

StaticPopupDialogs["TGM_TEMPLATES_EMPTY_TITLE"] = {
    text = "Template Title cannot be empty.",
    button1 = "Okay",
    timeout = 0,
    exclusive = 1,
    whileDead = 1,
    hideOnEscape = 1
};

StaticPopupDialogs["TGM_TEMPLATES_EMPTY_TEXT"] = {
    text = "Template Text cannot be empty.",
    button1 = "Okay",
    timeout = 0,
    exclusive = 1,
    whileDead = 1,
    hideOnEscape = 1
};

StaticPopupDialogs["CONFIRM_DELETE_TEMPLATE"] = {
    text = "Delete Template ?",
    button1 = TEXT(YES),
    button2 = TEXT(NO),
    OnAccept = function()
        DEFAULT_CHAT_FRAME:AddMessage("Template " .. TGM_DATA.templates[TGM.templateToDelete].title .. " deleted.")
        TGM_DATA.templates[TGM.templateToDelete] = nil
        TGM_ToggleTemplates()
        TGM.templateToDelete = 0
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
};

StaticPopupDialogs["TGM_EDIT_TEMPLATE_TITLE"] = {
    text = "Edit Template Title:",
    button1 = "Save",
    button2 = "Cancel",
    hasEditBox = 1,
    autoFocus = 1,
    OnShow = function()
        getglobal(this:GetName() .. "EditBox"):SetText(TGM_DATA.templates[TGM.templateToEdit].title)
    end,
    OnAccept = function()
        local templateTitle = getglobal(this:GetParent():GetName() .. "EditBox"):GetText()
        if templateTitle == '' then
            StaticPopup_Show('TGM_TEMPLATES_EMPTY_TITLE')
            return
        end

        TGM_DATA.templates[TGM.templateToEdit].title = templateTitle
        StaticPopup_Show('TGM_EDIT_TEMPLATE_TEXT')
    end,
    timeout = 0,
    whileDead = 0,
    hideOnEscape = 1,
};

StaticPopupDialogs["TGM_EDIT_TEMPLATE_TEXT"] = {
    text = "Edit Template Text:",
    button1 = "Save",
    button2 = "Cancel",
    hasEditBox = 1,
    autoFocus = 1,
    OnShow = function()
        getglobal(this:GetName() .. "EditBox"):SetText(TGM_DATA.templates[TGM.templateToEdit].text)
    end,
    OnAccept = function()
        local templateText = getglobal(this:GetParent():GetName() .. "EditBox"):GetText()
        if templateTitle == '' then
            StaticPopup_Show('TGM_TEMPLATES_EMPTY_TEXT')
            return
        end

        TGM_DATA.templates[TGM.templateToEdit].text = templateText
        DEFAULT_CHAT_FRAME:AddMessage("Template " .. TGM_DATA.templates[TGM.templateToEdit].title .. " updated.")
        TGM_ToggleTemplates()
        TGM.templateToEdit = 0

    end,
    timeout = 0,
    whileDead = 0,
    hideOnEscape = 1,
};

StaticPopupDialogs["TGM_SEARCH_TEMPLATES"] = {
    text = "Search Templates for Text:",
    button1 = "Search",
    button2 = "Cancel",
    hasEditBox = 1,
    autoFocus = 1,
    hideOnEscape = true,
    OnShow = function()
        getglobal(this:GetName() .. "EditBox"):SetText('')
    end,
    OnAccept = function()
        local searchtext = getglobal(this:GetParent():GetName() .. "EditBox"):GetText()
        if templateTitle == '' then
            return
        end

        TGM.search = searchtext
        TGM_TemplatePage(1)
    end,
    timeout = 0,
    whileDead = 0,
    hideOnEscape = 1,
    enterClicksFirstButton = 1,
};

function TGMConfig(parameter) 
	if parameter == '' then
        DEFAULT_CHAT_FRAME:AddMessage("[GM Addon] Current Configuration Options and Values:")
        DEFAULT_CHAT_FRAME:AddMessage("Option: tasound Value: "..TGM_CONFIG.tasound)
        DEFAULT_CHAT_FRAME:AddMessage("Option: nordsound Value: "..TGM_CONFIG.nordsound)
        DEFAULT_CHAT_FRAME:AddMessage("Option: abandonsound Value: "..TGM_CONFIG.abandonsound)
      
        local claim = "Disabled"
        if TGM_CONFIG.claimsound then claim = TGM_CONFIG.claimsound end

        DEFAULT_CHAT_FRAME:AddMessage("Option: claimsound Value: "..claim)
        local delay_display = TGM_CONFIG.susdelay or 5
        DEFAULT_CHAT_FRAME:AddMessage("Option: susdelay Value: ".. delay_display)

		DEFAULT_CHAT_FRAME:AddMessage("[GM Addon] Use /tgm <option> <value> to set a specific configuration value.");
    else

    if parameter == 'minimap' then
        TGM_Minimap:SetPoint("TOPLEFT", UIParent, "TOPLEFT" ,960,-540)
        return
    end

    args = __explode(parameter, " ")

    if __length(args) < 2 then
        DEFAULT_CHAT_FRAME:AddMessage("[GM Addon] Usage: /tgm <option> <value>")
        return
    end

    option = args[1]
    value = args[2]

    -- DEFAULT_CHAT_FRAME:AddMessage("Setting "..option.." to "..value)

	if option == "tasound" then
        TGM_CONFIG.tasound = value
		DEFAULT_CHAT_FRAME:AddMessage("Updated tasound to "..value);
	end

    if option == "nordsound" then
        TGM_CONFIG.nordsound = value
		DEFAULT_CHAT_FRAME:AddMessage("Updated nordsound to "..value);
	end

    if option == "abandonsound" then
        TGM_CONFIG.abandonsound = value
		DEFAULT_CHAT_FRAME:AddMessage("Updated abandonsound to "..value);
	end

    if option == "susdelay" then
        if type(tonumber(value)) == "number" then
            -- If value is a number
            TGM_CONFIG.susdelay = math.abs(value)
            DEFAULT_CHAT_FRAME:AddMessage("Updated susdelay to "..value);
        else
            DEFAULT_CHAT_FRAME:AddMessage("Please use a valid number for susdelay.");
        end
    end

    if option == "claimsound" then
        if value == "clear" then
            TGM_CONFIG.claimsound = nil
            DEFAULT_CHAT_FRAME:AddMessage("Disabled claimsound");
            return
        else
            TGM_CONFIG.claimsound = value
            DEFAULT_CHAT_FRAME:AddMessage("Updated claimsound to "..value);
        end
	end


    end

end

SLASH_TGM1 = '/tgm'
SlashCmdList["TGM"] = TGMConfig