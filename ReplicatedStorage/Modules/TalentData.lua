-- TalentData.lua
-- Single source of truth for all six Talents in Whisperwood
-- Used by both client UI and server validation

local TalentData = {}

TalentData.Talents = {
	{
		id = "bloom",
		name = "Bloom Fairy",
		token = "Seed",
		color = Color3.fromHex("F2A65A"),
		starterAbility = "Grows a flower platform to reach higher ground",
		flavorText = "You feel the pull of things that grow.",
	},
	{
		id = "dew",
		name = "Dew Fairy",
		token = "Dewdrop",
		color = Color3.fromHex("85B7EB"),
		starterAbility = "Purifies a small patch of corrupted water",
		flavorText = "You feel the pull of quiet water.",
	},
	{
		id = "spark",
		name = "Spark Fairy",
		token = "Spark",
		color = Color3.fromHex("FAC775"),
		starterAbility = "Lights a short-range glowing trail",
		flavorText = "You feel the pull of light in the dark.",
	},
	{
		id = "mushroom",
		name = "Mushroom Fairy",
		token = "Spore",
		color = Color3.fromHex("97C459"),
		starterAbility = "Grows a small mushroom bridge",
		flavorText = "You feel the pull of things that shelter.",
	},
	{
		id = "breeze",
		name = "Breeze Fairy",
		token = "Feather",
		color = Color3.fromHex("F0997B"),
		starterAbility = "Short glide boost",
		flavorText = "You feel the pull of open air.",
	},
	{
		id = "honey",
		name = "Honey Fairy",
		token = "Honeycomb",
		color = Color3.fromHex("ED93B1"),
		starterAbility = "Summons a scout bee that marks nearby items",
		flavorText = "You feel the pull of the hive.",
	},
}

-- Helper function: get talent by ID
function TalentData:GetTalentById(id)
	for _, talent in ipairs(self.Talents) do
		if talent.id == id then
			return talent
		end
	end
	return nil
end

-- Helper function: validate if a talent ID is valid
function TalentData:IsValidTalent(id)
	return self:GetTalentById(id) ~= nil
end

-- Helper function: get all talent IDs (for validation)
function TalentData:GetValidTalentIds()
	local ids = {}
	for _, talent in ipairs(self.Talents) do
		table.insert(ids, talent.id)
	end
	return ids
end

return TalentData
