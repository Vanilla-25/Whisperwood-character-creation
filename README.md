# Whisperwood Character Creation System

A gentle, ceremony-like character creation flow for the Whisperwood fairy exploration game. Built in Roblox Studio with Luau.

## Structure

- **ReplicatedStorage/Modules/TalentData.lua** — Single source of truth for all six Talents
- **ReplicatedStorage/Remotes/SubmitCharacterCreation** — RemoteEvent for client→server character submission
- **ServerScriptService/CharacterCreationServer.lua** — Server validation, name filtering, DataStore persistence, player spawn
- **StarterGui/CharacterCreationUI/CharacterCreationClient.lua** — Client-side 4-step flow management and state

## Setup Instructions

1. Place the scripts in their designated locations in Roblox Studio
2. Create a `RemoteEvent` instance at `ReplicatedStorage/Remotes/SubmitCharacterCreation`
3. Build the UI (Frames, TextBoxes, Buttons) in StarterGui/CharacterCreationUI — the scripts are ready to hook into them
4. Replace the TODO sections with actual UI references and mechanics as needed

## Flow

1. **Name** — Player enters a fairy name (validated for non-empty)
2. **Appearance** — Player customizes skin tone, hair, wings, and color palette
3. **The Calling** — Player selects one of six talent tokens arranged in a circle
4. **Reveal** — Confirmation screen showing chosen Talent, flavor text, and ability preview
5. Player is teleported into the world with their chosen Talent applied

## Key Features

- ✅ All transitions tweened (no instant cuts)
- ✅ Step-back support (data preserved in local state)
- ✅ Server-side validation of Talent enum
- ✅ TextService name filtering before DataStore save
- ✅ Existing character detection on join (skips creation if player has data)
- ✅ Single source of truth for Talent definitions
- ✅ Gentle tone: no stat numbers, no "best choice" framing

## TODO Sections

UI and interactivity TODOs are marked with `-- TODO:` comments in the scripts. Fill these in with your UI implementation.
