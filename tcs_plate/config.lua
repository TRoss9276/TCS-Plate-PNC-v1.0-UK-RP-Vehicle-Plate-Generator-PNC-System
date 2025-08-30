Config = {}


-- Cooldown (seconds) between /genplate uses per player
Config.GenerateCooldown = 5


-- Auto-register ownership to the player who generated it (if in a vehicle)
Config.AutoRegisterOwnerOnGenerate = true


-- Letters allowed in UK format (2001+ format). Exclude characters commonly avoided in UK plates (I, Q).
Config.AllowedLetters = {
'A','B','C','D','E','F','G','H','J','K','L','M','N','O','P','R','S','T','U','V','W','X','Y','Z'
}


-- Area code seeds to make plates *feel* UK (first two letters)
Config.AreaCodes = {
'AB','BD','CN','DV','EA','FX','GM','HY','KR','LD','MN','NP','OX','PL','RM','SN','TY','WA','YK'
}


-- Banned 3-letter endings to avoid rude/offensive results
Config.BlacklistSuffixes = {
'ASS','FUC','COK','CNT','DIK','GAY','JEW','KKK','NIG','PIG','RAC','SEX','TIT','WTF','XTC'
}


-- If true, generator retries until a non-blacklisted, unique plate is produced
Config.EnforceUniqueness = true
Config.MaxGenerationAttempts = 25


-- Chat message prefix
Config.Tag = '^4[^5TCS Plate^4]^7 '