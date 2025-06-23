# TurtleWoW GM Addon

An addon for GMs to use to help manage Player Tickets for Turtle WoW servers.

# Installation

## Upgrading from old GM Addon

1. Delete your old addon folder.
2. If you want to save your old templates:
    - Go into your `WTF/Account/<gm account name>/SavedVariables/` folder
    - Rename `TGM.lua` to `gm-addon.lua`
3. Continue with either Launcher Installation or Manual Installation

## Launcher Installation

Click on the addons tab in your launcher, click the "Add new addon" button, then paste `https://github.com/VexiaOnline/gm-addon` in and click install.

## Manual Installation

1. Click the green "Code" button on github and click "Download ZIP."
2. Save the file `gm-addon-main.zip`.
3. Extract the zip file. This will give you a folder named `gm-addon-main`. 
4. Rename the extracted folder from `gm-addon-main` to `gm-addon`.
5. Copy or Move the `gm-addon` folder into the `Interface/AddOns/` folder inside your game client folder.


### Post Install

The addon is disabled by default, so make sure to enable "Turtle GM Addon" in your addons, either with the addons button at character select, or an addon manager in game.


# Configuration

The TurtleWoW GM Addon by default will play a sound when a Ticket is created or abandoned in game. You can configure what sound will be made depending on which realm you are logged into as well as what sound will play when a ticket is abandoned by a player. You can also optionally configure the addon to play a sound when another GM claims a ticket.

## Adding custom sounds

To use your own sounds, simply copy `.mp3`, `.wav`, or `.ogg` files into your `Interface/AddOns/gm-addon/sounds/` folder and then view the next section.

## Changing sounds

To change sounds or list the ones currently being used you can use the `/tgm` command in game.

Using `/tgm` with no arguments will list the current configuration options.

Example Output:

```
[GM Addon] Current Configuration Options and Values:
Option: tasound Value: ta-ticket.ogg
Option: nordsound Value: nord-ticket.ogg
Option: abandonsound Value: abandon.ogg
Option: claimsound Value: Disabled
[GM Addon] Use /tgm <option> <value> to set a specific configuration value.
```

### Nordanaar Tickets

To change the sound played when a ticket is created on Nordanaar use `/tgm nordsound <soundfile>`

Example: `/tgm nordsound nord-ticket.ogg` will play `nord-ticket.ogg` from your sounds folder every time a ticket is created on Nordanaar.

You should see confirmation when changing:

`Updated nordsound to nord-ticket.ogg`

### Tel'Abim Tickets

To change the sound played when a ticket is created on Tel'Abim use `/tgm tasound <soundfile>`

Example: `/tgm tasound ta-ticket.ogg` will play `ta-ticket.ogg` from your sounds folder every time a ticket is created on Tel'Abim.

You should see confirmation when changing:

`Updated tasound to ta-ticket.ogg`

### Abandon Sound

To change the sound played when a ticket is abandoned by a player use `/tgm abandonsound <soundfile>`

Example: `/tgm abandonsound abandon.ogg` will play `abandon.ogg` from your sounds folder every time a ticket is abandoned on either server.

You should see confirmation when changing:

`Updated abandonsound to abandon.ogg`

### Claim Sound (Optional) (Disabled by Default)

To enable or change the sound played when a GM claims a ticket use `/tgm claimsound <soundfile>`

Example: `/tgm claimsound assistance.ogg` will play `assistance.ogg` from your sounds folder every time a ticket is claimed by a GM on either server.

You should see confirmation when changing:

`Updated claimsound to assistance.ogg`

You can also disable playing a sound when tickets are claimed by a GM by using `/tgm claimsound clear`









# Changelog

## 1.0.13 - 6/23/2025

### Fixed

- Fixed how pagination is calculated so that template list will display properly for every page

## 1.0.12 - 6/23/2025

### Added

- Added a `/tgm` command to allow for some configuration of the addon.
    - Usage: `/tgm` will list all current configuration values.
    - Usage: `/tgm <option> <value>`
    - Available Options: `tasound` `nordsound` `abandonsound` `claimsound`
    - Values should be a valid sound file (mp3, ogg, wav, etc.) in the `sounds` folder, and CANNOT CONTAIN SPACES.
    - `nordsound` is the sound that plays when a ticket is created on Nord, etc. `abandonsound` is when a ticket is abandoned, and `claimsound` (Disabled by default) plays when a GM claims a ticket.
    - You can disable claimsound by using `/tgm claimsound clear`

## 1.0.11 - 6/23/2025

### Added

- Added a sound when a Ticket is abandoned.

## 1.0.10 - 6/22/2025

### Fixed

- Closing a ticket now clears the ticket created X ago text in the main window.

## 1.0.9 - 6/22/205

### Added

- Added placeholder sounds and updated TA and Nord default Ticket sounds.

### Changed

- Version number display in the main panel is no longer hardcoded in the XML but pulls from the Version metadata in the addon .toc file.


## 1.0.8 - 6/22/2025

### Added
- Added ability to page through response Templates
- Limited Template Pages to 15 entries per page to prevent clipping and overflow. (Only tested on default window scaling.)
- Added a Recall Last button which will populate the reply window with the last message that was sent to Whisper or Mail.