# SkyrimNet - Tats

Requirements:
SkyrimNet 29
MageLight
SlaveTats
SlaveTatsNG

An integration of slave tats into SkyrimNet with 2 main features

## Apply
NPCs can apply tattoos. This needs brainstorming on how to do this without overwhelming the LLM with many hundreds of options. Maybe location/category instead of a specific tat.
This will apply the specified tattoo to the target via the SlaveTats function, and narrate it as "X writes *TattooName* on Y’s *Area*"

## Display in Prompt
Visible tattoos should get a section in the prompt sent to LLMs
By default, only "Face" tattoos should be visible 
It should be configurable in the SkyrimNet settings which areas are visible by default.
Areas are not exactly 1-to-1 SlaveTats areas, instead we likely want
> Face, Neck, Back, Ass, Pubic Area, All Over, and left/right options for Arm, Lower Leg, Upper Leg, Hand, Foot
### UI
Because of the complexity of detecting what’s covered by clothing, I want a small MageLight UI that shows all current tats, and allows checking which are visible (checked) or hidden (unchecked). The default from the settings applies on application or first detection, so a new face tattoo automatically gets the check.
There should be a configurable hotkey to popup this screen.

## Considerations
* Other mechanisms can and will apply tats, and these need to be recognized, not just our own.
* Tattoos may be removed in multiple ways, we also need to consider that.
* Performance is very important, some delay in new/removed tattoos is very much acceptable.

## Extra Work
The Tattoo names are not always clear, so similar to the magic tattoo content packs, we will need to make similar packs that map the existing tattoo to our enriched version.

Resources:
1. https://github.com/levchimik/magic-tattoos-framework/tree/main
	1. If you take code from there, list that somewhere for excerpts, include a copyright header for full files.
	2. If used only for inspiration (e.g. the decorator used, caching etc.), mention it in the readme
	3. Both tools use a compatible license, GPL3