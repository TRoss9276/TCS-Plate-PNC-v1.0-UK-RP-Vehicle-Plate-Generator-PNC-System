TCS Plate & PNC v1.0

Author: TRoss9276
Version: 1.0.0
Resource Type: FiveM (Server/Client)
Focus: UK Roleplay Vehicle Plates & PNC System

Overview

TCS Plate & PNC is a UK-focused vehicle plate generator and PNC lookup system for FiveM servers.
Designed specifically for British roleplay communities, it allows players to generate realistic UK plates, look up plate records, and manage flags for vehicles.

Features

Generate UK-style plates (/genplate)

PNC lookup for plates (/pnc [plate])

Admin flagging of plates (/flagplate [plate] [reason])

Admin unflagging (/unflagplate [plate])

Cooldown between plate generations

Unique plate enforcement

Blacklisted suffixes support

Installation

Place the tcs_plate folder in your server resources.

Ensure your server.cfg has:

ensure tcs_plate


Adjust config.lua if necessary (cooldown, area codes, allowed letters, etc.).

Start your server and test the commands in-game.

Commands
Player Commands

/genplate — Generate and apply a UK-style plate to your current vehicle.

/pnc [plate] — Look up a plate record (owner, model, flags).

Admin Commands

/flagplate [plate] [reason] — Add a flag to a plate.

/unflagplate [plate] — Clear all flags on a plate.

Configurable Options

Edit config.lua to customize:

Allowed letters and area codes

Cooldown time for /genplate

Maximum generation attempts

Whether to enforce plate uniqueness

Blacklisted suffixes

Chat tag for TCS messages

Notes

data/plates.json is used to store generated plates and flags.

Designed specifically for UK roleplay servers — ideal for British GTA V RP communities.

No additional dependencies are required.

Support / Contact

For support or feature requests, contact TRoss9276 (t.ross.) via Discord.

Any bugs, please contact me as soon as possible and they will be fixed. If you have any suggestions on what to add for this, please do let me know!

TCS Plate & PNC — Your UK Roleplay Plate Solution!
