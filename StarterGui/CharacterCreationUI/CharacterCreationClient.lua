-- CharacterCreationClient.lua
-- Client-side character creation flow handler
-- Manages 4-step flow: Name -> Appearance -> The Calling -> Reveal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local TalentData = require(ReplicatedStorage.Modules.TalentData)

-- Wait for RemoteEvent to be available
local SubmitCharacterCreation = ReplicatedStorage.Remotes:WaitForChild("SubmitCharacterCreation")

-- =======================
-- State Management
-- =======================

local currentStep = 1
local maxSteps = 4

local characterData = {
	name = "",
	appearance = {
		skinTone = 1,
		hairStyle = 1,
		wingShape = 1,
		colorPalette = 1,
	},
	talent = nil,
}

-- =======================
-- Utility Functions
-- =======================

local function tweenProperty(instance, property, endValue, duration)
	-- Tween a property with a consistent easing style
	local tweenInfo = TweenInfo.new(
		duration,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.InOut
	)

	local tween = TweenService:Create(instance, tweenInfo, { [property] = endValue })
	tween:Play()
	return tween
end

local function advanceStep()
	if currentStep < maxSteps then
		currentStep = currentStep + 1
		-- TODO: Update UI to show current step
		print("Advanced to step " .. currentStep)
	end
end

local function goBackStep()
	if currentStep > 1 then
		currentStep = currentStep - 1
		-- TODO: Update UI to show current step
		print("Went back to step " .. currentStep)
	end
end

-- =======================
-- Name Validation
-- =======================

local function isValidName(name)
	-- At least 1 non-whitespace character
	local trimmed = name:match("^%s*(.-)%s*$")
	return trimmed and #trimmed > 0
end

-- =======================
-- Step 1: Name
-- =======================

local function initializeNameStep()
	print("[Step 1] Name initialization")
	-- TODO: Set up UI for name input
	-- - TextBox with placeholder "Name your fairy"
	-- - "Surprise me" button for random names
	-- - "Next" button (disabled until valid name entered)
end

local function handleNameSubmit(name)
	if isValidName(name) then
		characterData.name = name
		advanceStep()
		print("[Step 1] Name set to: " .. name)
	else
		print("[Step 1] Invalid name")
	end
end

-- =======================
-- Step 2: Appearance
-- =======================

local function initializeAppearanceStep()
	print("[Step 2] Appearance initialization")
	-- TODO: Set up UI for appearance customization
	-- - Skin tone swatch picker (horizontal row of circles)
	-- - Hair style selector (left/right arrows)
	-- - Wing shape selector (left/right arrows)
	-- - Color palette swatch picker (horizontal row of circles)
	-- - "Back" and "Next" buttons
end

local function handleAppearanceUpdate(appearanceType, value)
	if characterData.appearance[appearanceType] ~= nil then
		characterData.appearance[appearanceType] = value
		print("[Step 2] Appearance updated: " .. appearanceType .. " = " .. tostring(value))
	end
end

local function handleAppearanceSubmit()
	advanceStep()
	print("[Step 2] Appearance confirmed")
end

-- =======================
-- Step 3: The Calling (Talent Selection)
-- =======================

local function initializeCallingStep()
	print("[Step 3] The Calling initialization")
	-- TODO: Set up UI for talent selection
	-- - 6 circular buttons arranged in a circle
	-- - Dark backdrop frame
	-- - Caption: "You'll know it when you feel it."
	-- - Hover tween: scale + glow (~0.15s)
	-- - Click tween: confirmation (~0.4s), then auto-advance after ~0.8s
end

local function handleTalentHover(talentId, isHovering)
	if isHovering then
		-- Scale up and glow
		print("[Step 3] Hovering over talent: " .. talentId)
		-- TODO: Apply hover tween to token button
	else
		-- Scale back down
		print("[Step 3] Left talent hover: " .. talentId)
		-- TODO: Reverse hover tween
	end
end

local function handleTalentSelect(talentId)
	-- Validate talent
	if not TalentData:IsValidTalent(talentId) then
		print("[Step 3] Invalid talent selected: " .. talentId)
		return
	end

	characterData.talent = talentId
	print("[Step 3] Talent selected: " .. talentId)

	-- TODO: Apply confirmation tween (~0.4s)
	-- TODO: After ~0.8s pause, auto-advance to next step
	task.wait(0.8)
	advanceStep()
end

-- =======================
-- Step 4: Reveal
-- =======================

local function initializeRevealStep()
	print("[Step 4] Reveal initialization")
	-- TODO: Set up UI for reveal
	-- - Title: "You are a [Talent Name]"
	-- - Flavor text line
	-- - Starter ability preview
	-- - "Begin" button
end

local function handleBeginWorld()
	print("[Step 4] Submitting character creation")
	print("Character data: ", characterData)

	-- Validate all data before sending
	if not isValidName(characterData.name) then
		print("[Step 4] Invalid name at submission")
		return
	end

	if not TalentData:IsValidTalent(characterData.talent) then
		print("[Step 4] Invalid talent at submission")
		return
	end

	-- Send to server
	SubmitCharacterCreation:FireServer(characterData)
	print("[Step 4] Character creation submitted to server")
end

-- =======================
-- Flow Controller
-- =======================

local function initializeStep(stepNumber)
	if stepNumber == 1 then
		initializeNameStep()
	elseif stepNumber == 2 then
		initializeAppearanceStep()
	elseif stepNumber == 3 then
		initializeCallingStep()
	elseif stepNumber == 4 then
		initializeRevealStep()
	end
end

local function startCharacterCreation()
	print("[CharacterCreationClient] Starting character creation flow")
	currentStep = 1
	initializeStep(currentStep)
end

-- =======================
-- Initialization
-- =======================

local script = script.Parent
print("[CharacterCreationClient] Client loaded")

-- TODO: Listen for when character creation UI should start
-- For now, start immediately
startCharacterCreation()

-- Expose functions for UI buttons to call
_G.CharacterCreation = {
	advanceStep = advanceStep,
	goBackStep = goBackStep,
	handleNameSubmit = handleNameSubmit,
	handleAppearanceUpdate = handleAppearanceUpdate,
	handleAppearanceSubmit = handleAppearanceSubmit,
	handleTalentSelect = handleTalentSelect,
	handleBeginWorld = handleBeginWorld,
}

print("[CharacterCreationClient] Ready. Call _G.CharacterCreation.* functions from UI buttons.")
