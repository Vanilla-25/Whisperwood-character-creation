-- CharacterCreationServer.lua
-- Server-side handler for character creation
-- Validates, filters, and persists player character data via DataStore

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local TextService = game:GetService("TextService")

local TalentData = require(ReplicatedStorage.Modules.TalentData)
local SubmitCharacterCreation = ReplicatedStorage.Remotes.SubmitCharacterCreation

-- Create or get the character data store
local characterStore = DataStoreService:GetDataStore("CharacterData")

-- Constants
local SPAWN_LOCATION = Vector3.new(0, 10, 0) -- TODO: adjust to your spawn point

-- =======================
-- Player Join Handler
-- =======================
local Players = game:GetService("Players")

local function checkExistingCharacter(player)
	-- Check if player already has saved character data
	local success, characterData = pcall(function()
		return characterStore:GetAsync(player.UserId)
	end)

	if success and characterData then
		-- Player has existing character; load them into the world
		-- TODO: Apply talent abilities, appearance, etc.
		teleportPlayerToWorld(player, characterData.talent)
		return true
	else
		-- Player is new; they'll go through character creation
		return false
	end
end

local function teleportPlayerToWorld(player, talentId)
	-- Spawn player into the world with their chosen Talent
	if player.Character then
		player.Character:MoveTo(SPAWN_LOCATION)
	else
		-- Character doesn't exist yet; create it
		-- TODO: implement proper character spawning based on talent
		local newCharacter = Instance.new("Model")
		newCharacter.Name = player.Name
		newCharacter.Parent = workspace
		newCharacter:MoveTo(SPAWN_LOCATION)
	end
end

Players.PlayerAdded:Connect(function(player)
	-- Check if player has existing character
	if not checkExistingCharacter(player) then
		-- New player will see character creation UI (handled by client)
		print(player.Name .. " is new; awaiting character creation submission.")
	end
end)

-- =======================
-- Character Creation Handler
-- =======================

local function filterName(name)
	-- Use TextService to filter the name
	local success, filtered

	success, filtered = pcall(function()
		return TextService:FilterStringAsync(name, Enum.TextFilterContext.PublicChat, player)
	end)

	if success then
		return filtered
	else
		print("Name filtering failed for: " .. name)
		return nil
	end
end

local function validateCharacterPayload(player, payload)
	-- Validate structure
	if not payload or type(payload) ~= "table" then
		return false, "Invalid payload structure"
	end

	if type(payload.name) ~= "string" or #payload.name:match("^%s*(.-)%s*$") == 0 then
		return false, "Name is empty or invalid"
	end

	if not payload.appearance or type(payload.appearance) ~= "table" then
		return false, "Appearance data missing"
	end

	if type(payload.talent) ~= "string" or not TalentData:IsValidTalent(payload.talent) then
		return false, "Invalid talent: " .. tostring(payload.talent)
	end

	return true, "Valid"
end

local function saveCharacterData(player, payload)
	-- Filter the name through TextService
	local filteredName = filterName(payload.name, player)
	if not filteredName then
		return false, "Name filtering failed"
	end

	-- Build the character data object
	local characterData = {
		name = filteredName,
		appearance = payload.appearance,
		talent = payload.talent,
		createdAt = os.time(),
	}

	-- Save to DataStore
	local success, err = pcall(function()
		characterStore:SetAsync(player.UserId, characterData)
	end)

	if success then
		print(player.Name .. " created character: " .. filteredName .. " (" .. payload.talent .. ")")
		return true
	else
		print("Failed to save character for " .. player.Name .. ": " .. tostring(err))
		return false
	end
end

SubmitCharacterCreation.OnServerEvent:Connect(function(player, payload)
	print("[CharacterCreation] Received submission from " .. player.Name)

	-- Validate payload
	local isValid, validationMessage = validateCharacterPayload(player, payload)
	if not isValid then
		print("[CharacterCreation] Validation failed: " .. validationMessage)
		return
	end

	-- Save character data
	local saveSuccess = saveCharacterData(player, payload)
	if not saveSuccess then
		print("[CharacterCreation] Save failed for " .. player.Name)
		return
	end

	-- Teleport player into the world
	teleportPlayerToWorld(player, payload.talent)

	print("[CharacterCreation] Character creation complete for " .. player.Name)
end)
