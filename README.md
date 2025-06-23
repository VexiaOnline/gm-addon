# TurtleWoW GM Addon

An addon for GMs to use to help manage Player Tickets for Turtle WoW servers.

# Changelog

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