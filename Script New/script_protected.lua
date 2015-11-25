editMode = false
debugMode = true


-- Encryption Below
-- Globals
MAPNAME = GetGame().map.shortName
TEAMNUMBER = myHero.team
--
--
-- Class Instances
Config = {}
MINIONS = nil
ESP = nil
TASKMANAGER = nil
PACKETS = nil
DEBUGGER = nil
CHAMPION = nil
AI = nil
ORBWALKER = nil

--Settings Loaded




--Overloads
local min, max, cos, sin, pi, huge, ceil, floor, round, random, abs, deg, asin, acos = math.min, math.max, math.cos, math.sin, math.pi, math.huge, math.ceil, math.floor, math.round, math.random, math.abs, math.deg, math.asin, math.acos
local str = {[-3] = "P", [-2] = "Q3", [-1] = "Q2", [_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R", [4] = "I", [5] = "S"}
local clock = os.clock
local itemTable = {["Aegis of the Legion"] = {name = "Aegis of the Legion",code =  3105,buy =  1500,comb =  400,},["Abyssal Scepter"] = {name = "Abyssal Scepter",code =  3001,buy =  2350,comb =  780,},["Aether Wisp"] = {name = "Aether Wisp",code =  3113,buy =  850,comb =  415,},["Alacrity"] = {name = "Alacrity",buy =  475,},["Ancient Coin"] = {name = "Ancient Coin",code =  3301,buy =  350,},["Amplifying Tome"] = {name = "Amplifying Tome",code =  1052,buy =  435,},["Archangel's Staff"] = {name = "Archangel's Staff",code =  3003,buy =  3100,comb =  1100,},["Ardent Censer"] = {name = "Ardent Censer",code =  3504,buy =  2200,comb =  800,},["Archangel's Staff (Crystal Scar)"] = {name = "Archangel's Staff (Crystal Scar)",code =  3007,buy =  3100,comb =  1100,},["Athene's Unholy Grail"] = {name = "Athene's Unholy Grail",code =  3174,buy =  2800,comb =  565,},["Atma's Impaler"] = {name = "Atma's Impaler",code =  3005,buy =  2300,comb =  780,},["Avarice Blade"] = {name = "Avarice Blade",code =  3093,buy =  800,comb =  400,},["B. F. Sword"] = {name = "B. F. Sword",code =  1038,buy =  1300,},["Bami's Cinder"] = {name = "Bami's Cinder",code =  3751,buy =  1100,comb =  700,},["Banner of Command"] = {name = "Banner of Command",code =  3060,buy =  2900,comb =  600,},["Banshee's Veil"] = {name = "Banshee's Veil",code =  3102,buy =  2900,comb =  1150,},["Berserker's Greaves"] = {name = "Berserker's Greaves",code =  3006,buy =  1100,comb =  500,},["Bilgewater Cutlass"] = {name = "Bilgewater Cutlass",code =  3144,buy =  1650,comb =  400,},["Blackfire Torch"] = {name = "Blackfire Torch",code =  3188,buy =  2650,comb =  970,},["Blade of the Ruined King"] = {name = "Blade of the Ruined King",code =  3153,buy =  3400,comb =  750,},["Blasting Wand"] = {name = "Blasting Wand",code =  1026,buy =  850,},["Bonetooth Necklace"] = {name = "Bonetooth Necklace",code =  3166,},["Boots of Mobility"] = {name = "Boots of Mobility",code =  3117,buy =  800,comb =  500,},["Boots of Speed"] = {name = "Boots of Speed",code =  1001,buy =  300,},["Boots of Swiftness"] = {name = "Boots of Swiftness",code =  3009,buy =  800,comb =  500,},["Brawler's Gloves"] = {name = "Brawler's Gloves",code =  1051,buy =  400,},["Captain"] = {name = "Captain",code =  3107,buy =  600,},["Chain Vest"] = {name = "Chain Vest",code =  1031,buy =  800,comb =  500,},["Catalyst the Protector"] = {name = "Catalyst the Protector",code =  3010,buy =  1200,comb =  450,},["Chalice of Harmony"] = {name = "Chalice of Harmony",code =  3028,buy =  1000,comb =  300,},["Cinderhulk"] = {name = "Cinderhulk",buy =  1575,comb =  475,},["Cloak and Dagger"] = {name = "Cloak and Dagger",code =  3172,buy =  1450,comb =  200,},["Cloak of Agility"] = {name = "Cloak of Agility",code =  1018,buy =  800,},["Cloth Armor"] = {name = "Cloth Armor",code =  1029,buy =  300,},["Crystalline Bracer"] = {name = "Crystalline Bracer",code =  3801,buy =  650,comb =  100,},["Crystalline Flask"] = {name = "Crystalline Flask",code =  2041,buy =  345,},["Dagger"] = {name = "Dagger",code =  1042,buy =  300,},["Dead Man's Plate"] = {name = "Dead Man's Plate",code =  3742,buy =  2800,comb =  1000,},["Death's Daughter"] = {name = "Death's Daughter",code =  3902,},["Deathfire Grasp"] = {name = "Deathfire Grasp",code =  3128,buy =  3100,comb =  680,},["Dervish Blade"] = {name = "Dervish Blade",code =  3137,buy =  2700,comb =  200,},["Devourer"] = {name = "Devourer",buy =  1400,comb =  400,},["Distortion"] = {name = "Distortion",buy =  475,},["Doran's Blade"] = {name = "Doran's Blade",code =  1055,buy =  450,},["Doran's Shield"] = {name = "Doran's Shield",code =  1054,buy =  450,},["Doran's Ring"] = {name = "Doran's Ring",code =  1056,buy =  400,},["Eleisa's Miracle"] = {name = "Eleisa's Miracle",code =  3173,buy =  1100,comb =  400,},["Elixir of Agility"] = {name = "Elixir of Agility",code =  2038,buy =  250,},["Elixir of Brilliance"] = {name = "Elixir of Brilliance",code =  2039,buy =  250,},["Elixir of Fortitude"] = {name = "Elixir of Fortitude",code =  2037,buy =  350,},["Elixir of Iron"] = {name = "Elixir of Iron",code =  2138,buy =  500,},["Elixir of Ruin"] = {name = "Elixir of Ruin",code =  2137,buy =  400,},["Elixir of Sorcery"] = {name = "Elixir of Sorcery",code =  2139,buy =  500,},["Elixir of Wrath"] = {name = "Elixir of Wrath",code =  2140,buy =  500,},["Emblem of Valor"] = {name = "Emblem of Valor",code =  3097,buy =  650,comb =  170,},["Entropy"] = {name = "Entropy",code =  3184,buy =  2700,comb =  500,},["Essence Reaver"] = {name = "Essence Reaver",code =  3508,buy =  3600,comb =  400,},["Executioner's Calling"] = {name = "Executioner's Calling",code =  3123,buy =  800,comb =  450,},["Explorer's Ward"] = {name = "Explorer's Ward",code =  2050,},["Face of the Mountain"] = {name = "Face of the Mountain",code =  3401,buy =  2200,comb =  550,},["Faerie Charm"] = {name = "Faerie Charm",code =  1004,buy =  125,},["Farsight Orb"] = {name = "Farsight Orb",code =  3363,buy =  250,},["Fiendish Codex"] = {name = "Fiendish Codex",code =  3108,buy =  800,comb =  365,},["Fire At Will"] = {name = "Fire At Will",code =  3901,},["Flesheater"] = {name = "Flesheater",code =  3924,buy =  1460,comb =  300,},["Forbidden Idol"] = {name = "Forbidden Idol",code =  3114,buy =  550,comb =  300,},["Force of Nature"] = {name = "Force of Nature",code =  3109,buy =  2610,comb =  1000,},["Frostfang"] = {name = "Frostfang",code =  3098,buy =  850,comb =  375,},["Frost Queen's Claim"] = {name = "Frost Queen's Claim",code =  3092,buy =  2200,comb =  550,},["Frozen Heart"] = {name = "Frozen Heart",code =  3110,buy =  2800,comb =  700,},["Frozen Mallet"] = {name = "Frozen Mallet",code =  3022,buy =  3100,comb =  625,},["Furor"] = {name = "Furor",buy =  475,},["Giant's Belt"] = {name = "Giant's Belt",code =  1011,buy =  1000,comb =  600,},["Glacial Shroud"] = {name = "Glacial Shroud",code =  3024,buy =  1000,comb =  350,},["Globe of Trust"] = {name = "Globe of Trust",code =  3840,buy =  2100,comb =  635,},["Greater Stealth Totem"] = {name = "Greater Stealth Totem",code =  3361,buy =  250,},["Greater Vision Totem"] = {name = "Greater Vision Totem",code =  3362,buy =  250,},["Guardian Angel"] = {name = "Guardian Angel",code =  3026,buy =  2900,comb =  1380,},["Guardian's Horn"] = {name = "Guardian's Horn",code =  2051,buy =  1015,comb =  435,},["Haunting Guise"] = {name = "Haunting Guise",code =  3136,buy =  1600,comb =  765,},["Guinsoo's Rageblade"] = {name = "Guinsoo's Rageblade",code =  3124,buy =  2500,comb =  775,},["Head of Kha'Zix"] = {name = "Head of Kha'Zix",code =  2130,},["Health Potion"] = {name = "Health Potion",code =  2003,buy =  50,},["Hexdrinker"] = {name = "Hexdrinker",code =  3155,buy =  1300,comb =  500,},["Hextech Gunblade"] = {name = "Hextech Gunblade",code =  3146,buy =  3400,comb =  550,},["Hextech Revolver"] = {name = "Hextech Revolver",code =  3145,buy =  1200,comb =  330,},["Hextech Sweeper"] = {name = "Hextech Sweeper",code =  3187,buy =  2080,comb =  330,},["Hextech Sweeper (Trinket)"] = {name = "Hextech Sweeper (Trinket)",},["Homeguard"] = {name = "Homeguard",buy =  450,},["Hunter's Machete"] = {name = "Hunter's Machete",code =  1039,buy =  350,},["Ichor of Illumination"] = {name = "Ichor of Illumination",code =  2048,buy =  500,},["Ichor of Rage"] = {name = "Ichor of Rage",code =  2040,buy =  500,},["Iceborn Gauntlet"] = {name = "Iceborn Gauntlet",code =  3025,buy =  2700,comb =  650,},["Infinity Edge"] = {name = "Infinity Edge",code =  3031,buy =  3600,comb =  625,},["Ionian Boots of Lucidity"] = {name = "Ionian Boots of Lucidity",code =  3158,buy =  800,comb =  500,},["Juggernaut"] = {name = "Juggernaut",buy =  1400,comb =  150,},["Kindlegem"] = {name = "Kindlegem",code =  3067,buy =  800,comb =  400,},["Last Whisper"] = {name = "Last Whisper",code =  3035,buy =  1300,comb =  425,},["Liandry's Torment"] = {name = "Liandry's Torment",code =  3151,buy =  3200,comb =  750,},["Lich Bane"] = {name = "Lich Bane",code =  3100,buy =  3200,comb =  450,},["Locket of the Iron Solari"] = {name = "Locket of the Iron Solari",code =  3190,buy =  2500,comb =  200,},["Long Sword"] = {name = "Long Sword",code =  1036,buy =  350,},["Lord Van Damm's Pillager"] = {name = "Lord Van Damm's Pillager",code =  3104,buy =  3800,comb =  995,},["Lost Chapter"] = {name = "Lost Chapter",code =  3433,buy =  1800,comb =  380,},["Luden's Echo"] = {name = "Luden's Echo",code =  3285,buy =  3200,comb =  1100,},["Madred's Razors"] = {name = "Madred's Razors",code =  3106,buy =  750,comb =  300,},["Magus"] = {name = "Magus",buy =  1400,comb =  580,},["Luden's Echo (3286)"] = {name = "Luden's Echo (3286)",code =  3286,buy =  2800,comb =  1090,},["Mana Potion"] = {name = "Mana Potion",code =  2004,buy =  35,},["Manamune"] = {name = "Manamune",code =  3004,buy =  2400,comb =  775,},["Manamune (Crystal_Scar)"] = {name = "Manamune (Crystal_Scar)",code =  3008,buy =  2400,comb =  775,},["Martyr's Gambit"] = {name = "Martyr's Gambit",code =  3911,buy =  1850,comb =  400,},["Mejai's Soulstealer"] = {name = "Mejai's Soulstealer",code =  3041,buy =  1400,comb =  1000,},["Maw of Malmortius"] = {name = "Maw of Malmortius",code =  3156,buy =  3250,comb =  850,},["Mercurial Scimitar"] = {name = "Mercurial Scimitar",code =  3139,buy =  3700,comb =  625,},["Mercury's Treads"] = {name = "Mercury's Treads",code =  3111,buy =  1100,comb =  350,},["Mikael's Crucible"] = {name = "Mikael's Crucible",code =  3222,buy =  2300,comb =  750,},["Mirage Blade"] = {name = "Mirage Blade",code =  3150,buy =  3200,comb =  695,},["Moonflair Spellblade"] = {name = "Moonflair Spellblade",code =  3170,buy =  2570,comb =  570,},["Morellonomicon"] = {name = "Morellonomicon",code =  3165,buy =  2550,comb =  765,},["Muramana"] = {name = "Muramana",code =  3042,},["Murksphere"] = {name = "Murksphere",code =  3844,buy =  365,},["Muramana (Crystal Scar)"] = {name = "Muramana (Crystal Scar)",code =  3043,},["Nashor's Tooth"] = {name = "Nashor's Tooth",code =  3115,buy =  3000,comb =  1000,},["Needlessly Large Rod"] = {name = "Needlessly Large Rod",code =  1058,buy =  1250,},["Negatron Cloak"] = {name = "Negatron Cloak",code =  1057,buy =  720,comb =  270,},["Netherstride Grimoire"] = {name = "Netherstride Grimoire",code =  3431,buy =  3000,comb =  765,},["Ninja Tabi"] = {name = "Ninja Tabi",code =  3047,buy =  1100,comb =  500,},["Nomad's Medallion"] = {name = "Nomad's Medallion",code =  3096,buy =  850,comb =  225,},["Null-Magic Mantle"] = {name = "Null-Magic Mantle",code =  1033,buy =  450,},["Odyn's Veil"] = {name = "Odyn's Veil",code =  3180,buy =  2450,comb =  450,},["Ohmwrecker"] = {name = "Ohmwrecker",code =  3056,buy =  2650,comb =  650,},["Oracle's Elixir"] = {name = "Oracle's Elixir",code =  2042,buy =  400,},["Oracle's Extract"] = {name = "Oracle's Extract",code =  2047,buy =  250,},["Oracle's Lens"] = {name = "Oracle's Lens",code =  3364,buy =  250,comb =  250,},["Orb of Winter"] = {name = "Orb of Winter",code =  3112,buy =  2150,comb =  990,},["Overlord's Bloodmail"] = {name = "Overlord's Bloodmail",code =  3084,buy =  2500,comb =  900,},["Perfect Hex Core"] = {name = "Perfect Hex Core",code =  3198,buy =  3000,comb =  1000,},["Phage"] = {name = "Phage",code =  3044,buy =  1250,comb =  500,},["Phantom Dancer"] = {name = "Phantom Dancer",code =  3046,buy =  2700,comb =  900,},["Pickaxe"] = {name = "Pickaxe",code =  1037,buy =  875,},["Poacher's Knife"] = {name = "Poacher's Knife",code =  3711,buy =  850,comb =  450,},["Poro-Snax"] = {name = "Poro-Snax",code =  2052,},["Pox Arcana"] = {name = "Pox Arcana",code =  3434,buy =  3000,comb =  765,},["Prospector's Blade"] = {name = "Prospector's Blade",code =  1062,buy =  950,},["Prospector's Ring"] = {name = "Prospector's Ring",code =  1063,buy =  950,},["Prototype Hex Core"] = {name = "Prototype Hex Core",code =  3200,buy =  0,},["Puppeteer"] = {name = "Puppeteer",code =  3745,buy =  2200,comb =  250,},["Quicksilver Sash"] = {name = "Quicksilver Sash",code =  3140,buy =  1300,comb =  850,},["Rabadon's Deathcap"] = {name = "Rabadon's Deathcap",code =  3089,buy =  3800,comb =  1265,},["Raise Morale"] = {name = "Raise Morale",code =  3903,},["Randuin's Omen"] = {name = "Randuin's Omen",code =  3143,buy =  3000,comb =  900,},["Raptor Cloak"] = {name = "Raptor Cloak",code =  2053,buy =  1200,comb =  250,},["Ravenous Hydra"] = {name = "Ravenous Hydra",code =  3074,buy =  3600,comb =  1100,},["Ranger's Trailblazer"] = {name = "Ranger's Trailblazer",code =  3713,buy =  850,comb =  450,},["Regrowth Pendant"] = {name = "Regrowth Pendant",code =  1007,buy =  435,},["Recurve Bow"] = {name = "Recurve Bow",code =  1043,buy =  1000,comb =  400,},["Rejuvenation Bead"] = {name = "Rejuvenation Bead",code =  1006,buy =  150,},["Relic Shield"] = {name = "Relic Shield",code =  3302,buy =  350,},["Righteous Glory"] = {name = "Righteous Glory",code =  3800,buy =  2600,comb =  750,},["Rite of Ruin"] = {name = "Rite of Ruin",code =  3430,buy =  3000,comb =  765,},["Rod of Ages"] = {name = "Rod of Ages",code =  3027,buy =  3000,comb =  950,},["Rod of Ages (Crystal Scar)"] = {name = "Rod of Ages (Crystal Scar)",code =  3029,buy =  3000,comb =  950,},["Ruby Crystal"] = {name = "Ruby Crystal",code =  1028,buy =  400,},["Runaan's Hurricane"] = {name = "Runaan's Hurricane",code =  3085,buy =  2500,comb =  300,},["Runeglaive"] = {name = "Runeglaive",buy =  1625,comb =  140,},["Ruby Sightstone"] = {name = "Ruby Sightstone",code =  2045,buy =  1800,comb =  600,},["Rylai's Crystal Scepter"] = {name = "Rylai's Crystal Scepter",code =  3116,buy =  3200,comb =  515,},["Sanguine Blade"] = {name = "Sanguine Blade",code =  3181,buy =  2275,comb =  600,},["Sapphire Crystal"] = {name = "Sapphire Crystal",code =  1027,buy =  350,},["Sated Devourer"] = {name = "Sated Devourer",},["Scrying Orb"] = {name = "Scrying Orb",code =  3342,buy =  0,},["Seeker's Armguard"] = {name = "Seeker's Armguard",code =  3191,buy =  1200,comb =  465,},["Seraph's Embrace"] = {name = "Seraph's Embrace",code =  3040,},["Seraph's Embrace (Crystal Scar)"] = {name = "Seraph's Embrace (Crystal Scar)",code =  3048,},["Sheen"] = {name = "Sheen",code =  3057,buy =  1050,comb =  700,},["Sightstone"] = {name = "Sightstone",code =  2049,buy =  800,comb =  400,},["Skirmisher's Sabre"] = {name = "Skirmisher's Sabre",code =  3715,buy =  850,comb =  450,},["Sorcerer's Shoes"] = {name = "Sorcerer's Shoes",code =  3020,buy =  1100,comb =  800,},["Soul Anchor"] = {name = "Soul Anchor",code =  3345,buy =  0,},["Spectre's Cowl"] = {name = "Spectre's Cowl",code =  3211,buy =  1100,comb =  250,},["Spellthief's Edge"] = {name = "Spellthief's Edge",code =  3303,buy =  350,},["Staff of Flowing Water"] = {name = "Staff of Flowing Water",code =  3744,buy =  1635,comb =  300,},["Stalker's Blade"] = {name = "Stalker's Blade",code =  3706,buy =  850,comb =  450,},["Spirit Visage"] = {name = "Spirit Visage",code =  3065,buy =  2800,comb =  900,},["Statikk Shiv"] = {name = "Statikk Shiv",code =  3087,buy =  2500,comb =  550,},["Stealth Ward"] = {name = "Stealth Ward",code =  2044,buy =  75,},["Sunfire Cape"] = {name = "Sunfire Cape",code =  3068,buy =  2700,comb =  800,},["Sterak's Gage"] = {name = "Sterak's Gage",code =  3748,buy =  2700,comb =  1100,},["Stinger"] = {name = "Stinger",code =  3101,buy =  1200,comb =  600,},["Sweeping Lens"] = {name = "Sweeping Lens",code =  3341,buy =  0,},["Swindler's Orb"] = {name = "Swindler's Orb",code =  3841,buy =  865,comb =  500,},["Sword of the Occult"] = {name = "Sword of the Occult",code =  3141,buy =  1400,comb =  1040,},["Talisman of Ascension"] = {name = "Talisman of Ascension",code =  3069,buy =  2200,comb =  800,},["Targon's Brace"] = {name = "Targon's Brace",code =  3097,buy =  850,comb =  350,},["Tear of the Goddess"] = {name = "Tear of the Goddess",code =  3070,buy =  750,comb =  275,},["Tear of the Goddess (Crystal Scar)"] = {name = "Tear of the Goddess (Crystal Scar)",code =  3073,buy =  750,comb =  275,},["Teleport"] = {name = "Teleport",buy =  600,},["The Black Spear"] = {name = "The Black Spear",code =  3599,},["The Black Cleaver"] = {name = "The Black Cleaver",code =  3071,buy =  3500,comb =  1150,},["The Bloodthirster"] = {name = "The Bloodthirster",code =  3072,buy =  3700,comb =  1150,},["The Brutalizer"] = {name = "The Brutalizer",code =  3134,buy =  1337,comb =  617,},["The Hex Core mk-1"] = {name = "The Hex Core mk-1",code =  3196,buy =  1000,comb =  1000,},["The Hex Core mk-2"] = {name = "The Hex Core mk-2",code =  3197,buy =  2000,comb =  1000,},["The Lightbringer"] = {name = "The Lightbringer",code =  3185,buy =  2280,comb =  350,},["Tiamat"] = {name = "Tiamat",code =  3077,buy =  1250,comb =  225,},["Thornmail"] = {name = "Thornmail",code =  3075,buy =  2350,comb =  1250,},["Titanic Hydra"] = {name = "Titanic Hydra",code =  3053,buy =  3600,comb =  750,},["Total Biscuit of Rejuvenation"] = {name = "Total Biscuit of Rejuvenation",code =  2010,buy =  35,},["Trickster's Glass"] = {name = "Trickster's Glass",code =  3829,buy =  2115,comb =  215,},["Trinity Force"] = {name = "Trinity Force",code =  3078,buy =  3800,comb =  300,},["Twin Shadows"] = {name = "Twin Shadows",code =  3023,buy =  2400,comb =  730,},["Twin Shadows (3290)"] = {name = "Twin Shadows (3290)",code =  3290,buy =  2400,comb =  730,},["Typhoon Claws"] = {name = "Typhoon Claws",code =  3652,buy =  2000,comb =  675,},["Vampiric Scepter"] = {name = "Vampiric Scepter",code =  1053,buy =  900,comb =  550,},["Vision Ward"] = {name = "Vision Ward",code =  2043,buy =  75,},["Void Staff"] = {name = "Void Staff",code =  3135,buy =  2650,comb =  1365,},["Warden's Mail"] = {name = "Warden's Mail",code =  3082,buy =  1100,comb =  500,},["Warding Totem"] = {name = "Warding Totem",code =  3340,buy =  0,},["Warmog's Armor"] = {name = "Warmog's Armor",code =  3083,buy =  2850,comb =  550,},["Warrior"] = {name = "Warrior",buy =  1575,comb =  475,},["Wicked Hatchet"] = {name = "Wicked Hatchet",code =  3122,buy =  1200,comb =  440,},["Will of the Ancients"] = {name = "Will of the Ancients",code =  3152,buy =  2300,comb =  300,},["Wit's End"] = {name = "Wit's End",code =  3091,buy =  2800,comb =  1050,},["Wooglet's Witchcap"] = {name = "Wooglet's Witchcap",code =  3090,buy =  3500,comb =  1050,},["Youmuu's Ghostblade"] = {name = "Youmuu's Ghostblade",code =  3142,buy =  3200,comb =  1000,},["Zeke's Harbinger"] = {name = "Zeke's Harbinger",code =  3050,buy =  2350,comb =  480,},["Zeal"] = {name = "Zeal",code =  3086,buy =  1200,comb =  500,},["Zeke's Herald"] = {name = "Zeke's Herald",code =  3050,buy =  2450,comb =  800,},["Zephyr"] = {name = "Zephyr",code =  3172,buy =  2850,comb =  725,},["Zhonya's Hourglass"] = {name = "Zhonya's Hourglass",code =  3157,buy =  3500,comb =  1050,},}

class 'init'
	function init:__init()
		self.sprite = false
		if FileExist(LIB_PATH .. "/HfLib.lua") then
			self:load()
		end
		if (not _G.hflTasks or not _G.hflTasks[MAPNAME] or not _G.hflTasks[MAPNAME][TEAMNUMBER]) and not editMode then
			print("This map is not supported, please report the map name to law to make him update for this map")
		else
			if editMode then
				debugMode = false
			end
			if not _G.hflTasks then
				_G.hflTasks = {}
			end
			if not _G.hflTasks[MAPNAME] then
				_G.hflTasks[MAPNAME] = {}
			end
			if not _G.hflTasks[MAPNAME][TEAMNUMBER] then
				_G.hflTasks[MAPNAME][TEAMNUMBER]  = {}
			end
			if self:checkAccess() then
				if editMode then
					editor()
				else
					if debugMode then
						DEBUGGER = debugger()
					end
					PACKETS = packet()
					TASKMANAGER = tasks()
					MINIONS = minions()
					ESP = esp()
					AI = ai()
					ORBWALKER = orb()
					if _G[myHero.charName] then
						CHAMPION = _G[myHero.charName]()
					else
						CHAMPION = _G["Default"]()
					end
					myHeroSpellData = spellData[myHero.charName]
					StartBones()
					
				end
			end
			self:loadSprite()

			AddDrawCallback(function()
				self:drawSprite()
			end)
		end
	end

	function init:load()
		local file = io.open(LIB_PATH .. "/HfLib.lua", "rb")
		local content = file:read("*all")
		file:close()
		_G.hflTasks = unpickle(content)
	end

	function init:checkAccess()
		local LuaSocket = require("socket")
		local user = GetUser()
		SocketScript = LuaSocket.connect("handsfreeleveler.com", 80)
		local Link = "/api/acc/".. user .."/"
		SocketScript:send("GET "..Link:gsub(" ", "%%20").." HTTP/1.0\r\n\r\n")
		ScriptReceive, ScriptStatus = SocketScript:receive('*a')
		if string.match(ScriptReceive, "valid") then
			return true
		else
			return false
		end
	end

	function init:drawSprite()
		if self.sprite ~= false then
			self.sprite:Draw(0,(GetGame().WINDOW_H)-120,500)
		end
	end

	function init:loadSprite()
		if FileExist(SPRITE_PATH .. "/hfl.png") then
			self.sprite = createSprite(SPRITE_PATH .. "/hfl.png")
			self.sprite:SetScale(0.5,0.5)
		end
	end
class 'tasks'
	function tasks:__init()	
		self.taskLane = nil
		self.towers = {}
		self.hqs = {}
		self.baracks = {}
		self:collectTowers()
		self:collectHqs()
		self:collectBaracks()
		self:buildTaskObjects()

		self:pickLane()
		self:getCurrentTask()

		return self
	end

	function tasks:collectTowers()
		for i = 1, objManager.maxObjects do
	        local tow = objManager:getObject(i)
	        if tow and tow.type == "obj_AI_Turret" then
	        	table.insert(self.towers, tow)
	        end
	    end
	end
	function tasks:collectHqs()
		for i = 1, objManager.maxObjects do
	        local tow = objManager:getObject(i)
	        if tow and tow.type == "obj_HQ" then
	        	table.insert(self.towers, tow)
	        end
	    end
	end
	function tasks:collectBaracks()
		for i = 1, objManager.maxObjects do
	        local tow = objManager:getObject(i)
	        if tow and tow.type == "obj_BarracksDampener" then
	        	table.insert(self.towers, tow)
	        end
	    end
	end

	function tasks:buildTaskObjects()
		for i,task in pairs(_G.hflTasks[MAPNAME][TEAMNUMBER]) do
			if task.type == "Object" then
				local towerDetected = nil
				for c,tow in pairs(self.towers) do
					if GetDistance(tow,mousePos) < 300 then
						towerDetected = tow
					end
				end
				if towerDetected ~= nil then
					task.object = towerDetected
				else
					local baracksDetected = nil
					for c,barack in pairs(self.baracks) do
						if GetDistance(barack,mousePos) < 300 then
							baracksDetected = barack
						end
					end
					if baracksDetected ~= nil then
						task.object = baracksDetected
					else
						local hqDetected = nil
						for c,hq in pairs(self.hqs) do
							if GetDistance(hq,mousePos) < 300 then
								hqDetected = hq
							end
						end
						if hqDetected ~= nil then
							task.object = hqDetected
						else
							task.type = "Node"
						end
					end
					
				end
			end
		end
	end

	function tasks:pickLane()
		if #_G.hflTasks[MAPNAME][TEAMNUMBER][1].lanes > 1 then
			--Decide best lane
			self.taskLane = _G.hflTasks[MAPNAME][TEAMNUMBER][1].lanes[1]
			--simdilik sadece bot
		else
			self.taskLane = _G.hflTasks[MAPNAME][TEAMNUMBER][1].lanes[1]
		end
	end

	function tasks:getCurrentTask()
		if self.taskLane ~= nil then
			local nearestTask = nil
			local looper = _G.hflTasks[MAPNAME][TEAMNUMBER][self.taskLane]
			while looper.next ~= nil do
				local task = looper
				if nearestTask == nil then
					nearestTask = task
					if GetDistance2D(task.point,_G.hflTasks[MAPNAME][TEAMNUMBER][1].point) > GetDistance2D(myHero,_G.hflTasks[MAPNAME][TEAMNUMBER][1].point) then
						if GetDistance2D(task.point,myHero) < 200 then
							nearestTask =  _G.hflTasks[MAPNAME][TEAMNUMBER][task.next]
						end
						break
					end
				else
					if GetDistance2D(task.point,_G.hflTasks[MAPNAME][TEAMNUMBER][1].point) > GetDistance2D(myHero,_G.hflTasks[MAPNAME][TEAMNUMBER][1].point) then
						nearestTask = task
						if GetDistance2D(task.point,myHero) < 200 then
							nearestTask =  _G.hflTasks[MAPNAME][TEAMNUMBER][task.next]
						end
						break
					end
				end
				looper = _G.hflTasks[MAPNAME][TEAMNUMBER][looper.next]
			end
			return nearestTask
		else
			print("Lane not selected")
			--Fix here
		end
		return _G.hflTasks[MAPNAME][TEAMNUMBER][1]
	end
class 'debugger'
	function debugger:__init()
		AddDrawCallback(function()
			self:nodeManagerDraw()
		end)
		AddMsgCallback(function(e,t)
			if e == 257 and t == 77 then --m key up add minion ranged debug
				self:addRangedEnemyMinion(mousePos)
			end
			if e == 257 and t == 78 then --n key up add minion melee debug
				self:addMeleeEnemyMinion(mousePos)
			end
			if e == 257 and t == 67 then --c key up add minion clear all debug
				self.debugMinions = {}
				self.towers = {}
			end
			if e == 257 and t == 84 then --t key up add enemy tower debug
				self:addTower(mousePos)
			end
		end)

		self.debugMinions = {}
		self.towers = {}
	end

	function debugger:addTower(pos)
		table.insert(self.towers, {x=pos.x,z=pos.z,y=pos.y,charName="Enemy Tower",range=1000})
	end

	function debugger:addMeleeEnemyMinion(pos)
		table.insert(self.debugMinions, {x=pos.x,z=pos.z,y=pos.y,charName="Debug Minion Melee",range=300})
	end

	function debugger:addRangedEnemyMinion(pos)
		table.insert(self.debugMinions, {x=pos.x,z=pos.z,y=pos.y,charName="Debug Minion Ranged",range=600})
	end

	function debugger:nodeManagerDraw()
		if not _G.hflTasks[MAPNAME][TEAMNUMBER] then
			return
		end
		for i,minion in pairs(self.debugMinions) do
			DrawCircle(minion.x, minion.y, minion.z, 50, ARGB(255, 255, 0, 0))
			DrawCircle(minion.x, minion.y, minion.z, minion.range, ARGB(255, 255, 0, 0))
			local po = WorldToScreen(D3DXVECTOR3(minion.x,minion.y,minion.z))
			DrawText(minion.charName, 20, po.x, po.y, ARGB(255, 255, 255, 0))
		end
		for i,tower in pairs(self.towers) do
			DrawCircle(tower.x, tower.y, tower.z, 50, ARGB(255, 255, 0, 0))
			DrawCircle(tower.x, tower.y, tower.z, tower.range, ARGB(255, 255, 0, 0))
			local po = WorldToScreen(D3DXVECTOR3(tower.x,tower.y,tower.z))
			DrawText(tower.charName, 20, po.x, po.y, ARGB(255, 255, 255, 0))
		end
		for i,task in pairs(_G.hflTasks[MAPNAME][TEAMNUMBER]) do
			if task.type == "Object" then
				DrawCircle(task.point.x, task.point.y, task.point.z, 500, ARGB(255, 255, 255, 0))
				local po = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
				DrawText("" .. i, 35, po.x, po.y, ARGB(255, 255, 255, 0))
			end
			if task.type == "Node" then
				DrawCircle(task.point.x, task.point.y, task.point.z, 150, ARGB(255, 255, 255, 0))
				local po = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
				DrawText("" .. i, 25, po.x, po.y, ARGB(255, 255, 255, 0))
			end
			if task.type == "Base" then
				DrawCircle(task.point.x, task.point.y, task.point.z, 150, ARGB(255, 255, 255, 0))
				local po = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
				DrawText("Spawn", 25, po.x-30, po.y, ARGB(255, 0, 0, 255))
			end
			if task.type ~= "Base" then
				if task.next ~= nil then
					if not _G.hflTasks[MAPNAME][TEAMNUMBER][task.next] then
						task.next = nil
					else
						local ne,curr
						ne = WorldToScreen(D3DXVECTOR3(_G.hflTasks[MAPNAME][TEAMNUMBER][task.next].point.x,_G.hflTasks[MAPNAME][TEAMNUMBER][task.next].point.y,_G.hflTasks[MAPNAME][TEAMNUMBER][task.next].point.z))
						curr = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
					    DrawLine(curr.x, curr.y, ne.x, ne.y, 3, ARGB(0xFF,0xFF,0xFF,0xFF))
					end
				end
			else
				for i,lane in pairs(task.lanes) do
					local ne,curr
					ne = WorldToScreen(D3DXVECTOR3(_G.hflTasks[MAPNAME][TEAMNUMBER][lane].point.x,_G.hflTasks[MAPNAME][TEAMNUMBER][lane].point.y,_G.hflTasks[MAPNAME][TEAMNUMBER][lane].point.z))
					curr = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
				    DrawLine(curr.x, curr.y, ne.x, ne.y, 3, ARGB(0xFF,0xFF,0xFF,0xFF))
				end
			end
			if self.leftNodeSelected ~= nil then
				local po = WorldToScreen(D3DXVECTOR3(self.leftNodeSelected.point.x,self.leftNodeSelected.point.y,self.leftNodeSelected.point.z))
				local ms = WorldToScreen(D3DXVECTOR3(mousePos))
			    DrawLine(po.x, po.y, ms.x, ms.y, 3, ARGB(0xFF,0xFF,0xFF,0xFF))
			end
		end

		for i = 1, objManager.maxObjects do
	        local object = objManager:getObject(i)
	        if object ~= nil and object.name ~= nil and #object.name > 1 and GetDistance2D(mousePos,object.pos) < 150 and not string.find(object.name,".troy") then
	          	local po = WorldToScreen(D3DXVECTOR3(object.pos.x,object.pos.y,object.pos.z))
				DrawText(object.name, 15, po.x, po.y, ARGB(255, 0, 255, 0))
				DrawText(object.type, 15, po.x, po.y+25, ARGB(255, 255, 255, 0))
	        end
      	end
	end
class 'minions'
	function minions:__init()
		self.enemies = minionManager(MINION_ENEMY, 1500, myHero, MINION_SORT_HEALTH_ASC) --ESP.predictivity burda
		self.allies = minionManager(MINION_ALLY, 1500, myHero, MINION_SORT_HEALTH_ASC)
		self.attackTable = {}

		AddProcessAttackCallback(function(unit, attackProc) 
			self.attackTable[unit.name]=attackProc.target
		end)

		AddTickCallback(function ()
			self.enemies:update()
			self.allies:update()
			--self:minionLine()
		end)
		if debugger then
			AddDrawCallback(function ()
				--self.drawManager()
			end)
		end

		return self
	end

	function minions:minionLine()

	end

	function minions:drawManager()

	end
class 'esp'
	function esp:__init()
		self.lastTick = GetTickCount()
		self.predictivity = 125
		self.updateRate = 5
		self.emptySpace = 150
		self.nodes = {}
		self:createNodes()
		self.bestNode = nil
		self.lastPos = {x = 0, z = 0}
		self.towers = {}

		self:collectTowers()

		if debugger then
			AddDrawCallback(function ()
				self:drawManager()
			end)
		end

		AddTickCallback(function()
			if GetTickCount() > self.lastTick + self.updateRate then
				self:updateNodes()
				self.lastTick = GetTickCount()


				self:getMinimumDangerRelativetoTaskFarming()
			end
		end)

		return self
	end

	function esp:collectTowers()
		for i = 1, objManager.maxObjects do
	        local tow = objManager:getObject(i)
	        if tow and tow.type == "obj_AI_Turret" then
	        	table.insert(self.towers, tow)
	        end
	    end
	end

	function esp:createNodes()
		for x = -7, 7 do
		  	for z = -7, 7 do
		  		local node = {
			  		x=myHero.x+(x*(self.predictivity+self.emptySpace)),
			  		z=myHero.z+(z*(self.predictivity+self.emptySpace)),
			  		initx=myHero.x,
			  		initz=myHero.z,
			  		danger = {free = 0, action = 0},
			  		reachable = true,
			  		best = false
		  		}
		  		if GetDistance2D(myHero,node) < self.predictivity*8 then
				 	table.insert(self.nodes,node)
				 end
			end
		end
	end

	function esp:updateNodes()
		for i, node in pairs(self.nodes) do
			node.danger.free = 0
			node.danger.action = 0
			local nodeXDiff = myHero.x-node.initx
			if nodeXDiff > 3 or nodeXDiff < -3 then
				node.x = node.x + nodeXDiff
				node.initx = myHero.x
			end

			local nodeZDiff = myHero.z-node.initz
			if nodeZDiff > 3 or nodeZDiff < -3 then
				node.z = node.z + nodeZDiff
				node.initz = myHero.z
			end
			node.danger.free = 0
			node.danger.action = 0

			self:calculateReachable(node)
			if node.reachable then
				self:calculateMinions(node)
				self:calculateTowers(node)
			end
		end
	end

	function  esp:calculateTowers(node)
		for i, tower in pairs(self.towers) do
			if GetDistance2D(node, tower) < 950 and tower.team ~= myHero.team then
				local towerAllies = 0
	        	for i,minion in pairs(MINIONS.allies.objects) do
					if not minion.dead then
						if GetDistance2D(tower,minion) < 950 then
							towerAllies = towerAllies + 1
						end
					end
				end
				if towerAllies < 2 then
					node.danger.free = node.danger.free + 80
					node.danger.action = node.danger.action + 80
				end
			end
		end
		if debugMode then
			for i, tower in pairs(DEBUGGER.towers) do
				if GetDistance2D(node, tower) < 950 then
					local towerAllies = 0
		        	for i,minion in pairs(MINIONS.allies.objects) do
						if not minion.dead then
							if GetDistance2D(tower,minion) < 950 then
								towerAllies = towerAllies + 1
							end
						end
					end
					if towerAllies < 2 then
						node.danger.free = node.danger.free + 80
						node.danger.action = node.danger.action + 80
					end
				end
			end
		end
	end

	function  esp:calculateMinions(node)
		for i, minion in pairs(MINIONS.enemies.objects) do
			local minionRange 	
			if string.find(minion.charName, "Ranged") then
				minionRange = 600
			else
				minionRange = 200
			end
			if GetDistance2D(node, minion) < minionRange and minion.visible and not minion.dead then
				if MINIONS.attackTable[minion.name] and not MINIONS.attackTable[minion.name].dead and MINIONS.attackTable[minion.name] ~= myHero then
					node.danger.action = node.danger.action + 35
				else
					MINIONS.attackTable[minion.name] = nil
					node.danger.free = node.danger.free + 35
					node.danger.action = node.danger.action + 35
				end
			end
		end
		if debugMode then
			for i, minion in pairs(DEBUGGER.debugMinions) do
				local minionRange 	
				if string.find(minion.charName, "Ranged") then
					minionRange = 600
				else
					minionRange = 200
				end
				if GetDistance2D(node, minion) < minionRange then
					node.danger.free = node.danger.free + 35
					node.danger.action = node.danger.action + 35
				end
			end
		end
	end

	function esp:calculateReachable(node)
		node.reachable = not IsWall(D3DXVECTOR3(node.x, myHero.y, node.z))
	end

	function esp:getMinimumDangerRelativetoTaskWalking() --dont forget melees
		local minimumNode = nil
		local currentTask = TASKMANAGER:getCurrentTask()
		for i, node in pairs(self.nodes) do
			node.best = false
			if node.reachable then
				if minimumNode == nil then
					minimumNode = node
				else
					if GetDistance2D(node,currentTask.point) < GetDistance2D(minimumNode,currentTask.point) and GetDistance2D(node,myHero) > 200 and node.danger.free == 0 then
						minimumNode = node
					end
				end
			end
		end
		minimumNode.best = true
		return minimumNode
	end

	function esp:getMinimumDangerRelativetoTaskAction() --dont forget melees
		local minimumNode = nil
		local currentTask = TASKMANAGER:getCurrentTask()
		for i, node in pairs(self.nodes) do
			node.best = false
			if node.reachable then
				if minimumNode == nil then
					minimumNode = node
				else
					if GetDistance2D(node,currentTask.point) < GetDistance2D(minimumNode,currentTask.point) and GetDistance2D(node,myHero) > 200 and node.danger.free == 0 then
						minimumNode = node
					end
				end
			end
		end
		minimumNode.best = true

		myHero:MoveTo(minimumNode.x, minimumNode.z) -- use this method for just going to target.
	end

	function esp:getMinimumDangerRelativetoTaskFarming() --dont forget melees and add ally minion existence?
		local minimumNode = nil
		local dangerNodes = {}
		local currentTask = TASKMANAGER:getCurrentTask()
		table.sort(self.nodes, sortByDistanceNodes)

		for i, node in pairs(self.nodes) do
			if node.danger.action > 0 then
				table.insert(dangerNodes, node)
			end
		end
		for x, nodeDanger in pairs(dangerNodes) do
			for i, node in pairs(self.nodes) do
				if GetDistance2D(nodeDanger, _G.hflTasks[MAPNAME][TEAMNUMBER][1].point) < GetDistance2D(node, _G.hflTasks[MAPNAME][TEAMNUMBER][1].point) then
					node.reachable = false
				end		
			end
		end
		for i, node in pairs(self.nodes) do
			node.best = false
			if node.reachable then
				if minimumNode == nil then
					minimumNode = node
				else
					if node.danger.free == 0 then
						if GetDistance2D(node,currentTask.point) < GetDistance2D(minimumNode,currentTask.point) then
							minimumNode = node
						end
					end
				end
			end
		end
		minimumNode.best = true
		if minimumNode ~= self.bestNode then
			self.bestNode = minimumNode
			--myHero:MoveTo(minimumNode.x, minimumNode.z) -- use this method for just going to target.
			self.lastPos = {x=minimumNode.x, z=minimumNode.z}
		else
			if GetDistance2D(self.lastPos,minimumNode) > self.emptySpace then
				--myHero:MoveTo(minimumNode.x, minimumNode.z) -- use this method for just going to target.
				self.lastPos = {x=minimumNode.x, z=minimumNode.z}
			end
		end
	end

	function esp:drawManager()
		for i, node in pairs(self.nodes) do
			if node.reachable then
				if node.best then
					DrawCircle(node.x, myHero.y, node.z, self.predictivity, ARGB(255, 255, 255, 255))
				else
					DrawCircle(node.x, myHero.y, node.z, self.predictivity, ARGB(255, node.danger.free, 255-node.danger.free, 0))
				end
				
				local po = WorldToScreen(D3DXVECTOR3(node.x,myHero.y,node.z))
				DrawText("".. node.danger.free, 25, po.x-30, po.y, ARGB(255, 0, 0, 255))
			else
				DrawCircle(node.x, myHero.y, node.z, self.predictivity, ARGB(255, 255, 0, 0))
				local po = WorldToScreen(D3DXVECTOR3(node.x,myHero.y,node.z))
				DrawText("".. node.danger.action, 25, po.x-30, po.y, ARGB(255, 0, 0, 255))
			end
		end
	end
class 'editor'
	function editor:__init()
		AddMsgCallback(function(e,t)
			if e == 257 and t == 17 then
				self:deleteHover()
			end
			if e == 257 and t == 16 then
				self:connectHover()
			end
			if e == 514 and t == 0 then
				self:mouseUp()
			end
			if e == 513 and t == 1 then
				self:mouseDown()
			end
			if self.selectedTask ~= nil then
				if self.selectedTask.type == "Node" or self.selectedTask.type == "Base" then
					self.selectedTask.point = {x=mousePos.x,y=mousePos.y,z=mousePos.z}
				end
			end
		end)

		AddDrawCallback(function()
			self:drawManager()
		end)

		--Editor Locals
		self.selectedTask = nil
		self.deletePressed = false
		self.leftNodeSelected = nil
		if _G.hflTasks[MAPNAME][TEAMNUMBER][1] and _G.hflTasks[MAPNAME][TEAMNUMBER][1].type == "Base" then
			self.spawnAdded = true
		else
			self.spawnAdded = false
		end
		
		self.towers = {}
		self.hqs = {}
		self.baracks = {}
		self:collectTowers()
		self:collectHqs()
		self:collectBaracks()
	end

	function editor:collectTowers()
		for i = 1, objManager.maxObjects do
	        local tow = objManager:getObject(i)
	        if tow and tow.type == "obj_AI_Turret" then
	        	table.insert(self.towers, tow)
	        end
	    end
	end
	function editor:collectHqs()
		for i = 1, objManager.maxObjects do
	        local tow = objManager:getObject(i)
	        if tow and tow.type == "obj_HQ" then
	        	table.insert(self.towers, tow)
	        end
	    end
	end
	function editor:collectBaracks()
		for i = 1, objManager.maxObjects do
	        local tow = objManager:getObject(i)
	        if tow and tow.type == "obj_BarracksDampener" then
	        	table.insert(self.towers, tow)
	        end
	    end
	end

	function editor:connectHover(  )
		if self.leftNodeSelected == nil then
			for i,task in pairs(_G.hflTasks[MAPNAME][TEAMNUMBER]) do
				if task.type == "Object" then
					if GetDistance(mousePos, task.point) < 500 then
						self.leftNodeSelected = task
					end
				end
				if task.type == "Node" or task.type == "Base" then
					if GetDistance(mousePos, task.point)  < 150  then
						self.leftNodeSelected = task
					end
				end
			end
		else
			for i,task in pairs(_G.hflTasks[MAPNAME][TEAMNUMBER]) do
				if task.type == "Object" then
					if GetDistance(mousePos, task.point) < 300 then
						if self.leftNodeSelected.type == "Base" then
							table.insert(self.leftNodeSelected.lanes,i)
						else
							self.leftNodeSelected.next = i
						end
					end
				end
				if task.type == "Node" then
					if GetDistance(mousePos, task.point)  < 300  then
						if self.leftNodeSelected.type == "Base" then
							table.insert(self.leftNodeSelected.lanes,i)
						else
							self.leftNodeSelected.next = i
						end
					end
				end
			end
			if self.leftNodeSelected.type ~= "Base" then
				if self.leftNodeSelected.next == nil then
					local towerDetected = nil
					local buildingDetected = nil
					for c,tow in pairs(self.towers) do
						if GetDistance(tow,mousePos) < 300 then
							towerDetected = tow
						end
					end

					if towerDetected ~= nil then
						table.insert(_G.hflTasks[MAPNAME][TEAMNUMBER],{point={x=towerDetected.x,y=towerDetected.y,z=towerDetected.z},type="Object",next=nil})
					else
						if buildingDetected == nil then
							table.insert(_G.hflTasks[MAPNAME][TEAMNUMBER],{point={x=mousePos.x,y=mousePos.y,z=mousePos.z},type="Node",next=nil})
						end
					end
					self.leftNodeSelected.next = #_G.hflTasks[MAPNAME][TEAMNUMBER]
					self.leftNodeSelected = _G.hflTasks[MAPNAME][TEAMNUMBER][#_G.hflTasks[MAPNAME][TEAMNUMBER]]
				else
					self.leftNodeSelected = _G.hflTasks[MAPNAME][TEAMNUMBER][self.leftNodeSelected.next]
				end
				self:save()
			end
		end
	end

	function editor:deleteHover(  )
		for i,task in pairs(_G.hflTasks[MAPNAME][TEAMNUMBER]) do
			if task.type == "Object" then
				if GetDistance(mousePos, task.point) < 500 then
					table.remove(_G.hflTasks[MAPNAME][TEAMNUMBER], i)
				end
			end
			if task.type == "Node" then
				if GetDistance(mousePos, task.point)  < 150  then
					table.remove(_G.hflTasks[MAPNAME][TEAMNUMBER], i)
				end
			end
			if task.type == "Base" then
				if GetDistance(mousePos, task.point)  < 150  then
					_G.hflTasks[MAPNAME][TEAMNUMBER] = {}
					self.spawnAdded = false
				end
			end
		end
		self:save()
	end

	function editor:mouseDown()
		if self.leftNodeSelected == nil then
			for i,task in pairs(_G.hflTasks[MAPNAME][TEAMNUMBER]) do
				if task.type == "Object" then
					if GetDistance(mousePos, task.point) < 500 then
						self.selectedTask = task
					end
				end
				if task.type == "Node" then
					if GetDistance(mousePos, task.point)  < 150  then
						self.selectedTask = task
					end
				end
				if task.type == "Base" then
					if GetDistance(mousePos, task.point)  < 150  then
						self.selectedTask = task
					end
				end
			end
		end
	end

	function editor:mouseUp()
		if self.leftNodeSelected == nil then
			if self.selectedTask == nil then
				if self.spawnAdded then
					local towerDetected = nil
					for c,tow in pairs(self.towers) do
						if GetDistance(tow,mousePos) < 300 then
							towerDetected = tow
						end
					end
					if towerDetected ~= nil then
						table.insert(_G.hflTasks[MAPNAME][TEAMNUMBER],{point={x=towerDetected.x,y=towerDetected.y,z=towerDetected.z},type="Object",next=nil})
					else
						local baracksDetected = nil
						for c,barack in pairs(self.baracks) do
							if GetDistance(barack,mousePos) < 300 then
								baracksDetected = barack
							end
						end
						if baracksDetected ~= nil then
							table.insert(_G.hflTasks[MAPNAME][TEAMNUMBER],{point={x=towerDetected.x,y=towerDetected.y,z=towerDetected.z},type="Object",next=nil})
						else
							local hqDetected = nil
							for c,hq in pairs(self.hqs) do
								if GetDistance(hq,mousePos) < 300 then
									hqDetected = hq
								end
							end
							if hqDetected ~= nil then
								table.insert(_G.hflTasks[MAPNAME][TEAMNUMBER],{point={x=towerDetected.x,y=towerDetected.y,z=towerDetected.z},type="Object",next=nil})
							else
								table.insert(_G.hflTasks[MAPNAME][TEAMNUMBER],{point={x=mousePos.x,y=mousePos.y,z=mousePos.z},type="Node",next=nil})
							end
						end
						
					end
				else
					table.insert(_G.hflTasks[MAPNAME][TEAMNUMBER],{point={x=mousePos.x,y=mousePos.y,z=mousePos.z},type="Base",lanes={}})
					self.spawnAdded = true
				end
			end
		else
			for i,task in pairs(_G.hflTasks[MAPNAME][TEAMNUMBER]) do
				if task.type == "Object" then
					if GetDistance(mousePos, task.point) < 200 then
						if self.leftNodeSelected.type == "Base" then
							if GetDistance(mousePos, task.point)  < 200  then
								table.insert(self.leftNodeSelected.lanes,i)
							end
						else
							self.leftNodeSelected.next = i
						end
					end
				end
				if task.type == "Node" then
					if GetDistance(mousePos, task.point)  < 200  then
						if self.leftNodeSelected.type == "Base" then
							if GetDistance(mousePos, task.point)  < 200  then
								table.insert(self.leftNodeSelected.lanes,i)
							end
						else
							self.leftNodeSelected.next = i
						end
					end
				end
			end
			self.leftNodeSelected = nil
		end
		self.selectedTask = nil
		self:save()
	end

	function editor:drawManager()
		for i,task in pairs(_G.hflTasks[MAPNAME][TEAMNUMBER]) do

			if task.type == "Object" then
				DrawCircle(task.point.x, task.point.y, task.point.z, 500, ARGB(255, 255, 255, 0))
				local po = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
				DrawText("" .. i, 35, po.x, po.y, ARGB(255, 255, 255, 0))
			end
			if task.type == "Node" then
				DrawCircle(task.point.x, task.point.y, task.point.z, 150, ARGB(255, 255, 255, 0))
				local po = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
				DrawText("" .. i, 25, po.x, po.y, ARGB(255, 255, 255, 0))
			end
			if task.type == "Base" then
				DrawCircle(task.point.x, task.point.y, task.point.z, 150, ARGB(255, 255, 255, 0))
				local po = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
				DrawText("Spawn", 25, po.x-30, po.y, ARGB(255, 0, 0, 255))
			end
			if task.type ~= "Base" then
				if task.next ~= nil then
					if not _G.hflTasks[MAPNAME][TEAMNUMBER][task.next] then
						task.next = nil
					else
						local ne,curr
						ne = WorldToScreen(D3DXVECTOR3(_G.hflTasks[MAPNAME][TEAMNUMBER][task.next].point.x,_G.hflTasks[MAPNAME][TEAMNUMBER][task.next].point.y,_G.hflTasks[MAPNAME][TEAMNUMBER][task.next].point.z))
						curr = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
					    DrawLine(curr.x, curr.y, ne.x, ne.y, 3, ARGB(0xFF,0xFF,0xFF,0xFF))
					end
				end
			else
				for i,lane in pairs(task.lanes) do
					local ne,curr
					ne = WorldToScreen(D3DXVECTOR3(_G.hflTasks[MAPNAME][TEAMNUMBER][lane].point.x,_G.hflTasks[MAPNAME][TEAMNUMBER][lane].point.y,_G.hflTasks[MAPNAME][TEAMNUMBER][lane].point.z))
					curr = WorldToScreen(D3DXVECTOR3(task.point.x,task.point.y,task.point.z))
				    DrawLine(curr.x, curr.y, ne.x, ne.y, 3, ARGB(0xFF,0xFF,0xFF,0xFF))
				end
			end
			if self.leftNodeSelected ~= nil then
				local po = WorldToScreen(D3DXVECTOR3(self.leftNodeSelected.point.x,self.leftNodeSelected.point.y,self.leftNodeSelected.point.z))
				local ms = WorldToScreen(D3DXVECTOR3(mousePos))
			    DrawLine(po.x, po.y, ms.x, ms.y, 3, ARGB(0xFF,0xFF,0xFF,0xFF))
			end
		end

		for i = 1, objManager.maxObjects do
	        local object = objManager:getObject(i)
	        if object ~= nil and object.name ~= nil and #object.name > 1 and GetDistance2D(mousePos,object.pos) < 150 and not string.find(object.name,".troy") then
	          	local po = WorldToScreen(D3DXVECTOR3(object.pos.x,object.pos.y,object.pos.z))
				DrawText(object.name, 15, po.x, po.y, ARGB(255, 0, 255, 0))
				DrawText(object.type, 15, po.x, po.y+25, ARGB(255, 255, 255, 0))
	        end
      	end
	end

	function editor:save()
		local pickledString = pickle(_G.hflTasks)
		local file = io.open(LIB_PATH .. "/HfLib.lua", "w")
		file:write(pickledString)
		file:close()
	end

	function editor:load()
		local file = io.open(LIB_PATH .. "/HfLib.lua", "rb")
		local content = file:read("*all")
		file:close()
		_G.hflTasks = unpickle(content)
	end
class 'packet'
	function packet:__init()
		self.disabledPacket = false
		self.version = split(GetGameVersion()," ")[1]
		self.idBytes = {}
		self.spellLevel = {}
		self.buyItem = {}

		self:initBytes()
		self:initFunctions()
		if not self.idBytes[self.version] then
			print("Packets are not supported, disabling packets. please report Law to update " .. self.version)
			self.disabledPacket = true
		end
	end

	function packet:buyItemId(id)
		self.buyItem[self.version](id)
	end

	function packet:spellUp(id)
		self.spellLevel[self.version](id)
	end

	function packet:initBytes()
		self.idBytes["5.22.0.289"] = {
		    [0x01] = 0x39,[0x02] = 0x38,[0x03] = 0x36,[0x04] = 0xB7,[0x05] = 0xB9,[0x06] = 0xB8,[0x07] = 0xB6,[0x08] = 0xF7,
		    [0x09] = 0xF9,[0x0A] = 0xF8,[0x0B] = 0xF6,[0x0C] = 0x77,[0x0D] = 0x79,[0x0E] = 0x78,[0x0F] = 0x76,[0x10] = 0x57,
		    [0x11] = 0x59,[0x12] = 0x58,[0x13] = 0x56,[0x14] = 0xD7,[0x15] = 0xD9,[0x16] = 0xD8,[0x17] = 0xD6,[0x18] = 0x17,
		    [0x19] = 0x19,[0x1A] = 0x18,[0x1B] = 0x16,[0x1C] = 0x97,[0x1D] = 0x99,[0x1E] = 0x98,[0x1F] = 0x96,[0x20] = 0x67,
		    [0x21] = 0x69,[0x22] = 0x68,[0x23] = 0x66,[0x24] = 0xE7,[0x25] = 0xE9,[0x26] = 0xE8,[0x27] = 0xE6,[0x28] = 0x27,
		    [0x29] = 0x29,[0x2A] = 0x28,[0x2B] = 0x26,[0x2C] = 0xA7,[0x2D] = 0xA9,[0x2E] = 0xA8,[0x2F] = 0xA6,[0x30] = 0x4B,
		    [0x31] = 0x4D,[0x32] = 0x4C,[0x33] = 0x4A,[0x34] = 0xCB,[0x35] = 0xCD,[0x36] = 0xCC,[0x37] = 0xCA,[0x38] = 0x0B,
		    [0x39] = 0x0D,[0x3A] = 0x0C,[0x3B] = 0x0A,[0x3C] = 0x8B,[0x3D] = 0x8D,[0x3E] = 0x8C,[0x3F] = 0x8A,[0x40] = 0x30,
		    [0x41] = 0x2E,[0x42] = 0x31,[0x43] = 0x2F,[0x44] = 0xB0,[0x45] = 0xAE,[0x46] = 0xB1,[0x47] = 0xAF,[0x48] = 0xF0,
		    [0x49] = 0xEE,[0x4A] = 0xF1,[0x4B] = 0xEF,[0x4C] = 0x70,[0x4D] = 0x6E,[0x4E] = 0x71,[0x4F] = 0x6F,[0x50] = 0x50,
		    [0x51] = 0x4E,[0x52] = 0x51,[0x53] = 0x4F,[0x54] = 0xD0,[0x55] = 0xCE,[0x56] = 0xD1,[0x57] = 0xCF,[0x58] = 0x10,
		    [0x59] = 0x0E,[0x5A] = 0x11,[0x5B] = 0x0F,[0x5C] = 0x90,[0x5D] = 0x8E,[0x5E] = 0x91,[0x5F] = 0x8F,[0x60] = 0x60,
		    [0x61] = 0x5E,[0x62] = 0x61,[0x63] = 0x5F,[0x64] = 0xE0,[0x65] = 0xDE,[0x66] = 0xE1,[0x67] = 0xDF,[0x68] = 0x20,
		    [0x69] = 0x1E,[0x6A] = 0x21,[0x6B] = 0x1F,[0x6C] = 0xA0,[0x6D] = 0x9E,[0x6E] = 0xA1,[0x6F] = 0x9F,[0x70] = 0x44,
		    [0x71] = 0x42,[0x72] = 0x45,[0x73] = 0x43,[0x74] = 0xC4,[0x75] = 0xC2,[0x76] = 0xC5,[0x77] = 0xC3,[0x78] = 0x04,
		    [0x79] = 0x02,[0x7A] = 0x05,[0x7B] = 0x03,[0x7C] = 0x84,[0x7D] = 0x82,[0x7E] = 0x85,[0x7F] = 0x83,[0x80] = 0x3B,
		    [0x81] = 0x3D,[0x82] = 0x3C,[0x83] = 0x3A,[0x84] = 0xBB,[0x85] = 0xBD,[0x86] = 0xBC,[0x87] = 0xBA,[0x88] = 0xFB,
		    [0x89] = 0xFD,[0x8A] = 0xFC,[0x8B] = 0xFA,[0x8C] = 0x7B,[0x8D] = 0x7D,[0x8E] = 0x7C,[0x8F] = 0x7A,[0x90] = 0x5B,
		    [0x91] = 0x5D,[0x92] = 0x5C,[0x93] = 0x5A,[0x94] = 0xDB,[0x95] = 0xDD,[0x96] = 0xDC,[0x97] = 0xDA,[0x98] = 0x1B,
		    [0x99] = 0x1D,[0x9A] = 0x1C,[0x9B] = 0x1A,[0x9C] = 0x9B,[0x9D] = 0x9D,[0x9E] = 0x9C,[0x9F] = 0x9A,[0xA0] = 0x6B,
		    [0xA1] = 0x6D,[0xA2] = 0x6C,[0xA3] = 0x6A,[0xA4] = 0xEB,[0xA5] = 0xED,[0xA6] = 0xEC,[0xA7] = 0xEA,[0xA8] = 0x2B,
		    [0xA9] = 0x2D,[0xAA] = 0x2C,[0xAB] = 0x2A,[0xAC] = 0xAB,[0xAD] = 0xAD,[0xAE] = 0xAC,[0xAF] = 0xAA,[0xB0] = 0x40,
		    [0xB1] = 0x3E,[0xB2] = 0x41,[0xB3] = 0x3F,[0xB4] = 0xC0,[0xB5] = 0xBE,[0xB6] = 0xC1,[0xB7] = 0xBF,[0xB8] = 0x00,
		    [0xB9] = 0xFE,[0xBA] = 0x01,[0xBB] = 0xFF,[0xBC] = 0x80,[0xBD] = 0x7E,[0xBE] = 0x81,[0xBF] = 0x7F,[0xC0] = 0x34,
		    [0xC1] = 0x32,[0xC2] = 0x35,[0xC3] = 0x33,[0xC4] = 0xB4,[0xC5] = 0xB2,[0xC6] = 0xB5,[0xC7] = 0xB3,[0xC8] = 0xF4,
		    [0xC9] = 0xF2,[0xCA] = 0xF5,[0xCB] = 0xF3,[0xCC] = 0x74,[0xCD] = 0x72,[0xCE] = 0x75,[0xCF] = 0x73,[0xD0] = 0x54,
		    [0xD1] = 0x52,[0xD2] = 0x55,[0xD3] = 0x53,[0xD4] = 0xD4,[0xD5] = 0xD2,[0xD6] = 0xD5,[0xD7] = 0xD3,[0xD8] = 0x14,
		    [0xD9] = 0x12,[0xDA] = 0x15,[0xDB] = 0x13,[0xDC] = 0x94,[0xDD] = 0x92,[0xDE] = 0x95,[0xDF] = 0x93,[0xE0] = 0x64,
		    [0xE1] = 0x62,[0xE2] = 0x65,[0xE3] = 0x63,[0xE4] = 0xE4,[0xE5] = 0xE2,[0xE6] = 0xE5,[0xE7] = 0xE3,[0xE8] = 0x24,
		    [0xE9] = 0x22,[0xEA] = 0x25,[0xEB] = 0x23,[0xEC] = 0xA4,[0xED] = 0xA2,[0xEE] = 0xA5,[0xEF] = 0xA3,[0xF0] = 0x48,
		    [0xF1] = 0x46,[0xF2] = 0x49,[0xF3] = 0x47,[0xF4] = 0xC8,[0xF5] = 0xC6,[0xF6] = 0xC9,[0xF7] = 0xC7,[0xF8] = 0x08,
   			[0xF9] = 0x06,[0xFA] = 0x09,[0xFB] = 0x07,[0xFC] = 0x88,[0xFD] = 0x86,[0xFE] = 0x89,[0xFF] = 0x87,[0x00] = 0x37,
		}
	end

	function packet:initFunctions()
		--
		--SPELL LEVELUPS
		--
		self.spellLevel["5.22.0.289"] = (function (id)
		  	local offsets = {
		  	  	[_Q] = 0xB8,
		  	  	[_W] = 0xBA,
		  	  	[_E] = 0x79,
		  	  	[_R] = 0x7B,
		  	}
		  	local p = CLoLPacket(0x0050)
		  	p.vTable = 0xF38DAC
		  	p:EncodeF(myHero.networkID)
		  	p:Encode1(offsets[id])
		  	p:Encode1(0x3C)
		  	for i = 1, 4 do p:Encode1(0xF6) end
		  	for i = 1, 4 do p:Encode1(0x5E) end
		  	for i = 1, 4 do p:Encode1(0xE0) end
		  	p:Encode1(0x24)
		  	p:Encode1(0xF1)
		  	p:Encode1(0x27)
		  	p:Encode1(0x00)
		  	SendPacket(p)
		end)

		self.spellLevel["5.21"] = (function (id)
		  	local offsets = {
		   [_Q] = 0x85,
		   [_W] = 0x45,
		   [_E] = 0x15,
		   [_R] = 0xC5,
		   }
		   local p
		   p = CLoLPacket(0x130)
		   p.vTable = 0xEDB360
		   p:EncodeF(myHero.networkID)
		   for i = 1, 4 do p:Encode1(0x55) end
		   for i = 1, 4 do p:Encode1(0x74) end
		   p:Encode1(offsets[id])
		   p:Encode1(0xB3)
		   for i = 1, 4 do p:Encode1(0x4F) end
		   p:Encode1(0x01)
		   for i = 1, 3 do p:Encode1(0x00) end
		   SendPacket(p)
		end)
	    --
		--BUY ITEMS
		--
		self.buyItem["5.22.0.289"] = (function (id)
   			local rB = {}
			for i=0, 255 do rB[self:getTableByte(i)] = i end
			local p = CLoLPacket(0x121)
			p.vTable = 0xEE7E24
			p:EncodeF(myHero.networkID)
			local b1 = bit32.lshift(bit32.band(rB[bit32.band(bit32.rshift(bit32.band(id,0xFFFF),24),0xFF)],0xFF),24)
			local b2 = bit32.lshift(bit32.band(rB[bit32.band(bit32.rshift(bit32.band(id,0xFFFFFF),16),0xFF)],0xFF),16)
			local b3 = bit32.lshift(bit32.band(rB[bit32.band(bit32.rshift(bit32.band(id,0xFFFFFFFF),8),0xFF)],0xFF),8)
			local b4 = bit32.band(rB[bit32.band(id ,0xFF)],0xFF)
			p:Encode4(bit32.bxor(b1,b2,b3,b4))
			p:Encode4(0xED2C0000)
			SendPacket(p)
		end)
	end

	function packet:getTableByte(i)
		return self.idBytes[self.version][i]
	end
class 'chat'
	function chat:__init()
		self.working = true

		if self.working then
			AddTickCallback(function()
				self:traceChats()
			end)
		end
		return self
	end

	function chat:traceChats()

	end
class 'orb'
	function orb:__init()
		self.orbwalker = TargetSelector(TARGET_LOW_HP_PRIORITY, 2000, DAMAGE_PHYSICAL, false)
		self.orbwalker:SetBBoxMode(true)
		self.orbwalker:SetDamages(0, myHero.totalDamage, 0)

		-- Orb Vars
		self.projSpeed = 0
		self.startAttackSpeed = 0.665
		self.attackDelayOffset = 600
		self.previousAttackCooldown = 0
		self.lastAttack = 0
		self.projAt = 0
		self.previousWindUp = 0
		self.isMelee = false
		self.lastRange = 0

		AddTickCallback(function()
			self:tick()
		end)

		AddProcessSpellCallback(function(e,t)
			self:OnProcessSpell(e,t)
			self:LastHitProcessSpell(e,t)
		end)

		--Last Hit Vars 
		self.minionInfo = {}
		self.minionInfo[(myHero.team == 100 and "Blue" or "Red").."_Minion_Basic"] =      { aaDelay = 400, projSpeed = 0    }
		self.minionInfo[(myHero.team == 100 and "Blue" or "Red").."_Minion_Caster"] =     { aaDelay = 484, projSpeed = 0.68 }
		self.minionInfo[(myHero.team == 100 and "Blue" or "Red").."_Minion_Wizard"] =     { aaDelay = 484, projSpeed = 0.68 }
		self.minionInfo[(myHero.team == 100 and "Blue" or "Red").."_Minion_MechCannon"] = { aaDelay = 365, projSpeed = 1.18 }
		self.minionInfo.obj_AI_Turret = { aaDelay = 150, projSpeed = 1.14 }
		self.incomingDamage = {}
	end

	function orb:tick()
		if GetTickCount() + GetLatency()/2 > self.lastAttack + self.previousWindUp + 20 and GetTickCount() + GetLatency()/2 < self.lastAttack + self.previousWindUp + 400 then self:attackedSuccessfully() end
		self.isMelee = myHero.range < 300
		if myHero.range ~= lastRange then
			self.orbwalker.range = myHero.range
			self.lastRange = myHero.range
		end
	end

	function orb:attackedSuccessfully()
		self.projAt = GetTickCount()
	end

	function orb:heroCanMove()
		return (GetTickCount() + GetLatency()/2 > lastAttack + previousWindUp + 20)
	end

	function orb:getHitBoxRadius(target)
		return GetDistance2D(target.minBBox, target.maxBBox)/2
	end

	function orb:timeToShoot()
		return (GetTickCount() + GetLatency()/2 > lastAttack + previousAttackCooldown)
	end

	function orb:OnProcessSpell(unit, spell)
		if myHero.dead then return end

		if unit.isMe and (spell.name:lower():find("attack") or self:isSpellAttack(spell.name)) and not self:isNotAttack(spell.name) then
			self.lastAttack = GetTickCount() - GetLatency()/2
			self.previousWindUp = spell.windUpTime*1000
			self.previousAttackCooldown = spell.animationTime*1000
		elseif unit.isMe and self:refreshAttack(spell.name) then
			self.lastAttack = GetTickCount() - GetLatency()/2 - self.previousAttackCooldown
		end
	end

	function orb:isAllyMinionInRange(minion)
		if minion ~= nil and minion.team == myHero.team
			and (minion.type == "obj_AI_Minion" or minion.type == "obj_AI_Turret")
			and GetDistance2D(minion, myHero) <= 2000 then return true
		else return false end
	end

	function orb:isSpellAttack(spellName)
		return (
			--Ashe
			spellName == "frostarrow"
			--Caitlyn
			or spellName == "CaitlynHeadshotMissile"
			--Kennen
			or spellName == "KennenMegaProc"
			--Quinn
			or spellName == "QuinnWEnhanced"
			--Trundle
			or spellName == "TrundleQ"
			--XinZhao
			or spellName == "XenZhaoThrust"
			or spellName == "XenZhaoThrust2"
			or spellName == "XenZhaoThrust3"
			--Garen
			or spellName == "GarenSlash2"
			--Renekton
			or spellName == "RenektonExecute"
			or spellName == "RenektonSuperExecute"
			--Yi
			or spellName == "MasterYiDoubleStrike"
		)
	end

	function orb:isNotAttack(spellName)
		return (

			spellName == "shyvanadoubleattackdragon"
			or spellName == "ShyvanaDoubleAttack"

			or spellName == "MonkeyKingDoubleAttack"

		)
	end

	function orb:moveToCursor(range)
		if not disableMovement and self.CanMove then
			myHero:MoveTo(waypoint.x, waypoint.z)
		end
	end

	function orb:LastHitProcessSpell(object, spell)
		if not self.isMelee and self:isAllyMinionInRange(object) then
			for i,minion in pairs(MINIONS.enemies.objects) do
				if ValidTarget(minion) and minion ~= nil and GetDistance2D(minion, spell.endPos) < 3 then
					if object ~= nil and (minionInfo[object.charName] or object.type == "obj_AI_turret") then
						self.incomingDamage[object.name] = self:getNewAttackDetails(object, minion)
					end
				end
			end
		end
	end

	function orb:getNewAttackDetails(source, target)
		return  {
				sourceName = source.name,
				targetName = target.name,
				damage = source:CalcDamage(target),
				started = GetTickCount(),
				origin = { x = source.x, z = source.z },
				delay = self:getMinionDelay(source),
				speed = self:getMinionProjSpeed(source),
				sourceType = source.type
			}
	end

	function orb:getMinionDelay(minion)
		return ( minion.type == "obj_AI_Turret" and minionInfo.obj_AI_Turret.aaDelay or minionInfo[minion.charName].aaDelay )
	end

	function orb:getMinionProjSpeed(minion)
		return ( minion.type == "obj_AI_Turret" and minionInfo.obj_AI_Turret.projSpeed or minionInfo[minion.charName].projSpeed )
	end

	function orb:getKillableCreep(iteration)
		if isMelee then return meleeLastHit() end
		local minion = MINIONS.enemies.objects[iteration]
		if minion ~= nil then
			local distanceToMinion = GetDistance(minion)
			local predictedDamage = 0
			if distanceToMinion < self:getTrueRange() then

					for l, attack in pairs(self.incomingDamage) do
						predictedDamage = predictedDamage + getPredictedDamage(l, minion, attack)
					end

				local myDamage = myHero:CalcDamage(minion, myHero.totalDamage)
				--if minion.health - predictedDamage <= 0 then
						--return getKillableCreep(iteration + 1)
				if minion.health + 1.2 - predictedDamage < myDamage then
						return minion
				--elseif minion.health + 1.2 - predictedDamage < myDamage + (0.5 * predictedDamage) then
				--		return nil
				end
			end
		else
			for name, turret in pairs(GetTurrets()) do
				if turret.team ~= myHero.team and GetDistance2D(myHero,turret) < self:getTrueRange() then
					return turret
				end
			end
		end
		return nil
	end

	function orb:getTrueRange()
		return myHero.range + GetDistance(myHero.minBBox)
	end

	function orb:getHighestMinion()
		local highestHp = {obj = nil, hp = 0}
		for _, tMinion in pairs(MINIONS.enemies.objects) do
			if GetDistance2D(tMinion, myHero) <= self:getTrueRange() and tMinion.health > highestHp.hp then
				highestHp = {obj = tMinion, hp = tMinion.health}
			end
		end
		return highestHp.obj
	end

	function orb:refreshAttack(spellName)
		return (
			--Blitzcrank
			spellName == "PowerFist"
			--Darius
			or spellName == "DariusNoxianTacticsONH"
			--Nidalee
			or spellName == "Takedown"
			--Sivir
			or spellName == "Ricochet"
			--Teemo
			or spellName == "BlindingDart"
			--Vayne
			or spellName == "VayneTumble"
			--Jax
			or spellName == "JaxEmpowerTwo"
			--Mordekaiser
			or spellName == "MordekaiserMaceOfSpades"
			--Nasus
			or spellName == "SiphoningStrikeNew"
			--Rengar
			or spellName == "RengarQ"
			--Wukong
			or spellName == "MonkeyKingDoubleAttack"
			--Yorick
			or spellName == "YorickSpectral"
			--Vi
			or spellName == "ViE"
			--Garen
			or spellName == "GarenSlash3"
			--Hecarim
			or spellName == "HecarimRamp"
			--XinZhao
			or spellName == "XenZhaoComboTarget"
			--Leona
			or spellName == "LeonaShieldOfDaybreak"
			--Shyvana
			or spellName == "ShyvanaDoubleAttack"
			or spellName == "shyvanadoubleattackdragon"
			--Talon
			or spellName == "TalonNoxianDiplomacy"
			--Trundle
			or spellName == "TrundleTrollSmash"
			--Volibear
			or spellName == "VolibearQ"
			--Poppy
			or spellName == "PoppyDevastatingBlow"
		)
	end



------
--AI--
------	
class 'ai'
	function ai:__init()
		self.state = {
			LaneClear = false,
			Harass = false,
			Combo = false,
			LastHit = false,
		}

		

		--Mount Behaviours
		self.root = Sequence:new{root = true}
		self:mountBehaviours()

		AddTickCallback(function()
			self.root:run()
		end)

		return self
	end

	function ai:mountBehaviours()
		--Bones
		local sq1 = Sequence:new()
		local se1 = Selector:new()
		local se2 = Selector:new()
		local sq2 = Sequence:new()
		local sq3 = Sequence:new()
		local se3 = Selector:new()
		

		--Actions
		local debugPrint = Action:new{action = "debugPrint"}

		local HeroAtSpawn = Action:new{action = "HeroAtSpawn"}
		local levelup = Action:new{action = "levelUp"}
		local BuyItems = Action:new{action = "BuyItems"}
		local baseOutValid = Action:new{action = "baseOutValid"}
		local PickLane = Action:new{action = "PickLane"}
		local IsHeroDead = Action:new{action = "IsHeroDead"}
		local WalkToTask = Action:new{action = "WalkToTask"}
		--Connections
		

		sq1:addChild(HeroAtSpawn)
		sq1:addChild(BuyItems)
		sq1:addChild(baseOutValid)
		sq1:addChild(PickLane)
		sq1:addChild(WalkToTask)

		self.root:addChild(levelup)
		self.root:addChild(se1)
		se1:addChild(se3)
		se1:addChild(se2)
		se2:addChild(sq2)
		se2:addChild(sq3)
		sq2:addChild(IsHeroDead)
		sq3:addChild(debugPrint)
		se3:addChild(sq1)
		se3:addChild(HeroAtSpawn)
	end

-----------------
--Behaviour Tree-
-----------------

---------
--Items--
---------
function getHeroItems()
	assassins = {"Akali","Diana","Evelynn","Fizz","Katarina","Nidalee"}
	adtanks = {"DrMundo","Garen","Hecarim","Jarvan IV","Nasus","Skarner","Volibear","Yorick"}
	adcs = {"Kalista","Jinx","Ashe","Caitlyn","Corki","Draven","Ezreal","Gankplank","Graves","KogMaw","Lucian","MissFortune","Quinn","Sivir","Thresh","Tristana","Tryndamere","Twitch","Urgot","Varus","Vayne"}
	aptanks = {"Alistar","Amumu","Blitzcrank","ChoGath","Leona","Malphite","Maokai","Nautilus","Rammus","Sejuani","Shen","Singed","Zac"}
	mages = {"Ahri","Soraka","Anivia","Annie","Brand","Cassiopeia","Galio","Gragas","Heimerdinger","Janna","Karma","Karthus","LeBlanc","Lissandra","Lulu","Lux","Malzahar","Morgana","Nami","Nunu","Orianna","Ryze","Sona","Soraka","Swain","Syndra","Taric","TwistedFate","Veigar","Viktor","Xerath","Ziggs","Zilian","Zyra"}
	hybrids = {"Kayle","Teemo"}
	bruisers = {"Darius","Irelia","Khazix","LeeSin","Olaf","Pantheon","Renekton","Rengar","Riven","Shyvana","Talon","Trundle","Vi","Wukong","Zed"}
	fighters = {"Aatrox","Fiora","Jax","Jayce","Nocturne","Poppy","Sion","Udyr","Warwick","XinZhao"}
	apcs = {"Elise","FiddleSticks","Kennen","Mordekaiser","Rumble","Vladimir"}
	heroType = nil

	for i,nam in pairs(adcs) do
		if nam == myHero.charName then
			heroType = 1
		end
	end

	for i,nam in pairs(adtanks) do
		if nam == myHero.charName then
			heroType = 2
		end
	end
	for i,nam in pairs(aptanks) do
		if nam == myHero.charName then
			heroType = 3
		end
	end
	for i,nam in pairs(hybrids) do
		if nam == myHero.charName then
			heroType = 4
		end
	end
	for i,nam in pairs(bruisers) do
		if nam == myHero.charName then
			heroType = 5
		end
	end
	for i,nam in pairs(assassins) do
		if nam == myHero.charName then
			heroType = 6
		end
	end
	for i,nam in pairs(mages) do
		if nam == myHero.charName then
			heroType = 7
		end
	end
	for i,nam in pairs(apcs) do
		if nam == myHero.charName then
			heroType = 8
		end
	end
	for i,nam in pairs(fighters) do
		if nam == myHero.charName then
			heroType = 9
		end
	end
	if heroType == nil then
		heroType = 10
	end

	if heroType == 1 then  --Done ADCS
		shopList = {itemTable["Dagger"],itemTable["Dagger"],itemTable["Recurve Bow"],itemTable["Long Sword"],itemTable["Vampiric Scepter"],itemTable["Long Sword"],itemTable["Blade of the Ruined King"],itemTable["Boots of Speed"],itemTable["Dagger"],itemTable["Berserker's Greaves"],itemTable["Brawler's Gloves"],itemTable["Avarice Blade"],itemTable["Long Sword"],itemTable["Long Sword"],itemTable["The Brutalizer"],itemTable["Youmuu's Ghostblade"],itemTable["Dagger"],itemTable["Brawler's Gloves"],itemTable["Zeal"],itemTable["Dagger"],itemTable["Cloak of Agility"],itemTable["Phantom Dancer"],itemTable["B. F. Sword"],itemTable["Pickaxe"],
		itemTable["Infinity Edge"],itemTable["The Bloodthirster"],0}
	end
	if heroType == 2 then --Done AdTanks
		shopList = {itemTable["Pickaxe"],itemTable["Rejuvenation Bead"],itemTable["Rejuvenation Bead"],itemTable["Long Sword"],itemTable["Tiamat"],itemTable["Long Sword"],itemTable["Vampiric Scepter"],itemTable["Boots of Speed"],itemTable["Ruby Crystal"],itemTable["Giant's Belt"],itemTable["Ravenous Hydra"],itemTable["Cloth Armor"],itemTable["Chain Vest"],itemTable["Ruby Crystal"],itemTable["Bami's Cinder"],itemTable["Sunfire Cape"],itemTable["Null-Magic Mantle"],itemTable["Mercury's Treads"],itemTable["Cloth Armor"],itemTable["Cloth Armor"],itemTable["Warden's Mail"],itemTable["Randuin's Omen"],itemTable["Phage"],itemTable["Sheen"],itemTable["Trinity Force"],itemTable["Guardian Angel"],0}
	end
	if heroType == 3 then --Done ApTanks
		shopList = {itemTable["Ruby Crystal"],itemTable["Giant's Belt"],itemTable["Amplifying Tome"],itemTable["Needlessly Large Rod"],itemTable["Rylai's Crystal Scepter"],itemTable["Null-Magic Mantle"],itemTable["Boots of Speed"],itemTable["Mercury's Treads"],itemTable["Ruby Crystal"],itemTable["Amplifying Tome"],itemTable["Haunting Guise"],itemTable["Blasting Wand"],itemTable["Liandry's Torment"],itemTable["Ruby Crystal"],itemTable["Giant's Belt"],itemTable["Cloth Armor"],itemTable["Cloth Armor"],itemTable["Warden's Mail"],itemTable["Randuin's Omen"],itemTable["Cloth Armor"],itemTable["Chain Vest"],itemTable["Cloth Armor"],itemTable["Thornmail"],itemTable["Abyssal Scepter"],0}
	end
	if heroType == 4 then --Done Hybrids
		shopList = {itemTable["Faerie Charm"],itemTable["Faerie Charm"],itemTable["Null-Magic Mantle"],itemTable["Chalice of Harmony"],itemTable["Boots of Speed"],itemTable["Sorcerer's Shoes"],itemTable["Amplifying Tome"],itemTable["Fiendish Codex"],itemTable["Amplifying Tome"],itemTable["Athene's Unholy Grail"],itemTable["Amplifying Tome"],itemTable["Ruby Crystal"],itemTable["Haunting Guise"],itemTable["Blasting Wand"],itemTable["Liandry's Torment"],itemTable["Cloth Armor"],itemTable["Amplifying Tome"],itemTable["Seeker's Armguard"],itemTable["Needlessly Large Rod"],itemTable["Zhonya's Hourglass"],itemTable["Amplifying Tome"],itemTable["Blasting Wand"],itemTable["Needlessly Large Rod"],itemTable["Rabadon's Deathcap"],itemTable["Needlessly Large Rod"],itemTable["Luden's Echo"],0}
	end
	if heroType == 5 then --Done Brusiers
		shopList = {itemTable["Pickaxe"],itemTable["Rejuvenation Bead"],itemTable["Rejuvenation Bead"],itemTable["Long Sword"],itemTable["Tiamat"],itemTable["Long Sword"],itemTable["Vampiric Scepter"],itemTable["Boots of Speed"],itemTable["Ruby Crystal"],itemTable["Giant's Belt"],itemTable["Ravenous Hydra"],itemTable["Cloth Armor"],itemTable["Chain Vest"],itemTable["Ruby Crystal"],itemTable["Bami's Cinder"],itemTable["Sunfire Cape"],itemTable["Null-Magic Mantle"],itemTable["Mercury's Treads"],itemTable["Cloth Armor"],itemTable["Cloth Armor"],itemTable["Warden's Mail"],itemTable["Randuin's Omen"],itemTable["Phage"],itemTable["Sheen"],itemTable["Trinity Force"],itemTable["Guardian Angel"],0}
	end
	if heroType == 6 then --DONE ASSASINS
		shopList = {itemTable["Blasting Wand"],itemTable["Null-Magic Mantle"],itemTable["Negatron Cloak"],itemTable["Abyssal Scepter"],itemTable["Boots of Speed"],itemTable["Sorcerer's Shoes"],itemTable["Amplifying Tome"],itemTable["Athene's Unholy Grail"],itemTable["Amplifying Tome"],itemTable["Ruby Crystal"],itemTable["Haunting Guise"],itemTable["Blasting Wand"],itemTable["Liandry's Torment"],itemTable["Cloth Armor"],itemTable["Amplifying Tome"],itemTable["Seeker's Armguard"],itemTable["Needlessly Large Rod"],itemTable["Zhonya's Hourglass"],itemTable["Amplifying Tome"],itemTable["Blasting Wand"],itemTable["Needlessly Large Rod"],itemTable["Rabadon's Deathcap"],itemTable["Needlessly Large Rod"],itemTable["Luden's Echo"],0}
	end
	if heroType == 7 then --DONE Mages
		shopList = {itemTable["Faerie Charm"],itemTable["Faerie Charm"],itemTable["Null-Magic Mantle"],itemTable["Chalice of Harmony"],itemTable["Boots of Speed"],itemTable["Sorcerer's Shoes"],itemTable["Amplifying Tome"],itemTable["Fiendish Codex"],itemTable["Amplifying Tome"],itemTable["Athene's Unholy Grail"],itemTable["Amplifying Tome"],itemTable["Ruby Crystal"],itemTable["Haunting Guise"],itemTable["Blasting Wand"],itemTable["Liandry's Torment"],itemTable["Cloth Armor"],itemTable["Amplifying Tome"],itemTable["Seeker's Armguard"],itemTable["Needlessly Large Rod"],itemTable["Zhonya's Hourglass"],itemTable["Amplifying Tome"],itemTable["Blasting Wand"],itemTable["Needlessly Large Rod"],itemTable["Rabadon's Deathcap"],itemTable["Needlessly Large Rod"],itemTable["Luden's Echo"],0}
	end
	if heroType == 8 then --Done Apc
		shopList = {itemTable["Faerie Charm"],itemTable["Faerie Charm"],itemTable["Null-Magic Mantle"],itemTable["Chalice of Harmony"],itemTable["Boots of Speed"],itemTable["Sorcerer's Shoes"],itemTable["Amplifying Tome"],itemTable["Fiendish Codex"],itemTable["Amplifying Tome"],itemTable["Athene's Unholy Grail"],itemTable["Amplifying Tome"],itemTable["Ruby Crystal"],itemTable["Haunting Guise"],itemTable["Blasting Wand"],itemTable["Liandry's Torment"],itemTable["Cloth Armor"],itemTable["Amplifying Tome"],itemTable["Seeker's Armguard"],itemTable["Needlessly Large Rod"],itemTable["Zhonya's Hourglass"],itemTable["Amplifying Tome"],itemTable["Blasting Wand"],itemTable["Needlessly Large Rod"],itemTable["Rabadon's Deathcap"],itemTable["Needlessly Large Rod"],itemTable["Luden's Echo"],0}
	end
	if heroType == 9 or heroType == 10 then --Done Fighters
		shopList = {itemTable["Pickaxe"],itemTable["Rejuvenation Bead"],itemTable["Rejuvenation Bead"],itemTable["Long Sword"],itemTable["Tiamat"],itemTable["Long Sword"],itemTable["Vampiric Scepter"],itemTable["Boots of Speed"],itemTable["Ruby Crystal"],itemTable["Giant's Belt"],itemTable["Ravenous Hydra"],itemTable["Cloth Armor"],itemTable["Chain Vest"],itemTable["Ruby Crystal"],itemTable["Bami's Cinder"],itemTable["Sunfire Cape"],itemTable["Null-Magic Mantle"],itemTable["Mercury's Treads"],itemTable["Cloth Armor"],itemTable["Cloth Armor"],itemTable["Warden's Mail"],itemTable["Randuin's Omen"],itemTable["Phage"],itemTable["Sheen"],itemTable["Trinity Force"],itemTable["Guardian Angel"],0}
	end
	return shopList
end

function loadedSettingsItems()
	if _G.aiItems then
		shopList = _G.aiItems
	else
		shopList = getHeroItems()
	end

	return shopList
end
class 'Behaviour'
	function Behaviour:__init()
		self.buyIndex = 1
		self.moneyPre = clock() + 1.5
		self.lastBuy = clock()
		self.shopList = loadedSettingsItems()
		return self
	end
	function Behaviour:HeroAtSpawn()
		self = BEHAVIOURS
		if GetDistance2D(myHero, _G.hflTasks[MAPNAME][TEAMNUMBER][1].point) < 400 then
			return true
		else
			return false
		end
	end
	function Behaviour:debugPrint()
		self = BEHAVIOURS
		print("DEBUG")
		return true
	end
	function Behaviour:levelUp()
		self = BEHAVIOURS
		levelUp()
		return true
	end
	function Behaviour:BuyItems()
		self = BEHAVIOURS
		local clock = os.clock
		if self.lastBuy + 0.5 < clock() then
			if self.shopList[self.buyIndex] ~= 0 then
				if self.shopList[self.buyIndex].comb then
					if myHero.gold >= self.shopList[self.buyIndex].comb then
						PACKETS:buyItemId(self.shopList[self.buyIndex].code)
						self.buyIndex = self.buyIndex + 1
						self.lastBuy = clock()
						return false
					else
						return true
					end
				else
					if myHero.gold >= self.shopList[self.buyIndex].buy then
						PACKETS:buyItemId(self.shopList[self.buyIndex].code)
						self.buyIndex = self.buyIndex + 1
						self.lastBuy = clock()
						return false
					else
						return true
					end
				end
			else
				return true
			end
		end
	end
	function Behaviour:baseOutValid()
		self = BEHAVIOURS
		local ret = true
		if self.shopList[self.buyIndex] ~= 0 then
			if self.shopList[self.buyIndex].comb then
				if myHero.gold < self.shopList[self.buyIndex].comb then
					ret =  true
				else
					ret =  false
				end
			else
				if myHero.gold < self.shopList[self.buyIndex].buy then
					ret =  true
				else
					ret =  false
				end
			end
		else
			ret =  true
		end
		if ret then
			if myHero.health*100/myHero.maxHealth > 80 then
				ret =  true
			else
				ret =  false
			end
		end
		return ret
	end
	function Behaviour:PickLane()
		TASKMANAGER:pickLane()
		return true
	end
	function Behaviour:IsHeroDead()
		return myHero.dead
	end
	function Behaviour:WalkToTask()
		local node = ESP:getMinimumDangerRelativetoTaskWalking()
		myHero:MoveTo(node.x, node.z)
		return true
	end


BEHAVIOURS = Behaviour()

BTask = {}
function BTask:new(o)
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.lastRun = GetTickCount()
	self.__index = self
	return o
end

function BTask:run()
	
end

function BTask:addChild(value)
	table.insert(self,value)
end

function BTask:addAll(value)
	for i = 1, #value, 1 do
		table.insert(self, value[i])
	end
end

function BTask:printAll()
	for i = 1, #self, 1 do
		PrintChat("Value: "..self[i])
	end
end

-- Selector Class
Selector = BTask:new()

function Selector:run()
	for i, v in ipairs(self) do
		if v:run() then 
			return true 
		end
	end
	return false
end

--Sequence Class
Sequence = BTask:new()

function Sequence:run()
	if self.root then
		if self.lastRun + 50 > GetTickCount()  then
			return true
		end
	end

	for i, v in ipairs(self) do
		if not v:run() then 
			return false 
		end
	end
	self.lastRun = GetTickCount()
	return true
end

--Action Class
Action = BTask:new()

function Action:run()
	return BEHAVIOURS[self.action]()
end




------------- 
--Champions--
-------------
class 'Default'
class 'Vayne'
  	function Vayne:__init()
  	end

  	function Vayne:Load()
	    self:Menu()
	    self.roll = false
	    require("VPrediction") 
      	VP = VPrediction()
  	end

	  function Vayne:Menu()
	  	Config = {
	  		Combo = {
	  			Q = true,
	  			E = true,
	  			R = true,
	  			Rtf = true,
	  			Re = true,
	  			Ra = true
	  		},
	  		Harass = {
	  			Q = true,
	  			E = true,
	  			manaQ = 30,
	  			manaE = 30
	  		},
	  		Killsteal = {
	  			Q = true,
	  			E = true,
	  			I = true
	  		},
	  		LaneClear = {
	  			Q = true,
	  			E = true,
	  			manaQ = 30,
	  			manaE = 30
	  		},
	  		Misc = {
	  			offsetE = 100
	  		}
	  	}
	    AddGapcloseCallback(_E, 500, true, Config.Misc)
	  end

	  	function Vayne:Draw()
		    if not sReady[_E] then return end
		    for k,enemy in pairs(GetEnemyHeroes()) do
		      if enemy and enemy.visible and not enemy.dead and enemy.bTargetable then
		        local pos1 = enemy
		        local pos2 = enemy - (Vector(myHero) - enemy):normalized()*(450*Config.Misc.offsetE/100)
		        local a = WorldToScreen(D3DXVECTOR3(pos1.x, pos1.y, pos1.z))
		        local b = WorldToScreen(D3DXVECTOR3(pos2.x, pos2.y, pos2.z))
		        if OnScreen(a.x, a.y, a.z) and OnScreen(b.x, b.y, b.z) then
		          DrawLine(a.x, a.y, b.x, b.y, 1, 0xFFFFFFFF)
		          DrawCircle(pos2.x, pos2.y, pos2.z, 50, 0xFFFFFFFF)
		        end
		      end
		    end
		end

	  function Vayne:Tick()
	    self.roll = (AI.state.Combo and Config.Combo.Q) or (AI.state.Harass and Config.Harass.Q and Config.Harass.manaQ/100 < myHero.mana/myHero.maxMana) or (AI.state.LastHit and Config.LastHit.Q and Config.LastHit.manaQ/100 < myHero.mana/myHero.maxMana) or (AI.state.LaneClear and Config.LaneClear.Q and Config.LaneClear.manaQ/100 < myHero.mana/myHero.maxMana)
	    if not sReady[_E] then return end
	    for k,enemy in pairs(GetEnemyHeroes()) do
	      if ValidTarget(enemy, 650) then
	        self:MakeUnitHugTheWall(enemy)
	      end
	    end
	  end

	  function Vayne:ProcessAttack(unit, spell)
	    if unit and spell and unit.isMe and spell.name then
	      if spell.name:lower():find("attack") then
	        if self.roll and sReady[_Q] then
	          CastSpell(_Q, mousePos.x, mousePos.z)
	        end
	        if spell.target and spell.target.type == myHero.type and Config.Killsteal.E and sReady[_E] and EnemiesAround(spell.target, 750) == 1 and GetRealHealth(spell.target) < GetDmg(_E, myHero, spell.target)+GetDmg("AD", myHero, spell.target)+(GetStacks(spell.target) >= 1 and GetDmg(_W, myHero, spell.target) or 0) and GetDistance(spell.target) < 650 then
	          local t = spell.target
	          CastSpell(_E, spell.target)
	        end
	      end
	    end
	  end

	  function Vayne:MakeUnitHugTheWall(unit)
	    if not unit or unit.dead or not unit.visible or GetDistanceSqr(unit) > 650*650 or not sReady[_E] then return end
	    local x, y = VP:CalculateTargetPosition(unit, myHeroSpellData[2].delay, myHeroSpellData[2].width, myHeroSpellData[2].speed, myHero)
	    for _=0,(450)*Config.Misc.offsetE/100,(450/25)*Config.Misc.offsetE/100 do
	      local dir = x+(Vector(x)-myHero):normalized()*_
	      if IsWall(D3DXVECTOR3(dir.x,dir.y,dir.z)) then
	        CastSpell(_E, unit)
	        return true
	      end
	    end
	    return false
	  end

	  function Vayne:LaneClear()
	    target = GetJMinion(myHeroSpellData[2].range)
	    if sReady[_E] and target and target.team > 200 and Config.LaneClear.E and Config.LaneClear.manaQ/100 < myHero.mana/myHero.maxMana then
	      self:MakeUnitHugTheWall(target)
	    end
	  end

	  function Vayne:Combo()
	    if Config.Combo.E and sReady[_E] then
	      if self:MakeUnitHugTheWall(Target) and Config.Combo.R then
	        Cast(_R)
	      end
	    else
	      if Config.Combo.R and GetDistance(Target) < 450 then
	        Cast(_R)
	      end
	    end
	    if Config.Combo.Rtf and EnemiesAround(myHero, 750) >= Config.Combo.Re and AlliesAround(myHero, 750) >= Config.Combo.Ra then
	      Cast(_R)
	    end
	  end

	  function Vayne:Harass()
	    if sReady[_E] and Config.Harass.E and Config.Harass.manaE <= 100*myHero.mana/myHero.maxMana then
	      self:MakeUnitHugTheWall(Target)
	    end
	  end

  	function Vayne:Killsteal()
	    for k,enemy in pairs(GetEnemyHeroes()) do
	      if enemy and not enemy.dead and enemy.visible and enemy.bTargetable then
	        local health = GetRealHealth(enemy)
	        if sReady[_Q] and health < GetDmg(_Q, myHero, enemy)+GetDmg("AD", myHero, enemy)+(GetStacks(enemy) == 2 and GetDmg(_W, myHero, enemy) or 0) and Config.Killsteal.Q and ValidTarget(enemy, myHeroSpellData[0].range + myHero.range) then
	          Cast(_Q, enemy.pos)
	          DelayAction(function() myHero:Attack(enemy) end, 0.25)
	        elseif sReady[_E] and self.HP and self.HP:PredictHealth(enemy, (min(myHeroSpellData[2].range, GetDistance(myHero, enemy)) / (2000) + 0.25)) < GetDmg(_E, myHero, enemy)+(GetStacks(enemy) == 2 and GetDmg(_W, myHero, enemy) or 0) and Config.Killsteal.E and ValidTarget(enemy, myHeroSpellData[2].range) then
	          CastSpell(_E, enemy)
	        elseif sReady[_E] and health < GetDmg(_E, myHero, enemy)+(GetStacks(enemy) == 2 and GetDmg(_W, myHero, enemy) or 0) and Config.Killsteal.E and ValidTarget(enemy, myHeroSpellData[2].range) then
	          CastSpell(_E, enemy)
	        elseif sReady[_E] and health < GetDmg(_E, myHero, enemy)*2+(GetStacks(enemy) == 2 and GetDmg(_W, myHero, enemy) or 0) and Config.Killsteal.E and ValidTarget(enemy, myHeroSpellData[2].range) then
	          self:MakeUnitHugTheWall(enemy)
	        elseif Ignite and myHero:CanUseSpell(Ignite) == READY and health < (50 + 20 * myHero.level) and Config.Killsteal.I and ValidTarget(enemy, 600) then
	          CastSpell(Ignite, enemy)
	        end
	      end
	    end
  	end --BUNU BITIR ORNEK BIRSEYIN OLSUN


------------------
--Scriptlog Bones-
------------------
function StartBones()
	SetupTargetSelector()
	InitVars()
	AddPluginTicks()
end

function AddGapcloseCallback(spell, range, targeted, config)
    GapcloseSpell = spell
    GapcloseTime = 0
    GapcloseUnit = nil
    GapcloseTargeted = targeted
    GapcloseRange = range
    AddProcessSpellCallback(function(unit, spell)
      if not config.antigap or not unit or not unit.valid or not gapcloserTable[unit.charName] or not config[unit.charName] then return end
      if spell.name == (type(gapcloserTable[unit.charName]) == 'number' and unit:GetSpellData(gapcloserTable[unit.charName]).name or gapcloserTable[unit.charName]) and (spell.target == myHero or GetDistanceSqr(spell.endPos) < GapcloseRange*GapcloseRange*4) then
        GapcloseTime = os.clock() + 2
        GapcloseUnit = unit
      end
    end)
    AddTickCallback(function()
      if sReady[GapcloseSpell] and GapcloseTime and GapcloseUnit and GapcloseTime > os.clock() then
        if GapcloseTargeted then
          if GetDistanceSqr(GapcloseUnit,myHero) < GapcloseRange*GapcloseRange then
            if myHero.charName == "Jayce" and loadedClass:IsRange() then Cast(_R) end
            Cast(GapcloseSpell, GapcloseUnit)
          end
        else 
          if GetDistanceSqr(GapcloseUnit,myHero) < GapcloseRange*GapcloseRange then
            Cast(GapcloseSpell)
          end
        end
      else
        GapcloseTime = 0
        GapcloseUnit = nil
      end
    end)
end

function SetupTargetSelector()
    targetSel = TargetSelector(TARGET_LESS_CAST, 1250, DAMAGE_MAGIC, false, true)
    ArrangeTSPriorities()
end

function GetMaladySlot()
    for slot = ITEM_1, ITEM_7, 1 do
      if myHero:GetSpellData(slot).name and (string.find(string.lower(myHero:GetSpellData(slot).name), "malady")) then
        return slot
      end
    end
    return nil
end

function InitVars()
	sReady = {}
	stackTable = {}
	for _=0, 3 do
		sReady[_] = myHero:CanUseSpell(_) == 0
	end
	buffStackTrackList = { ["Darius"] = "dariushemo", ["Kalista"] = "kalistaexpungemarker", ["TahmKench"] = "tahmpassive", ["Tristana"] = "tristanaecharge", ["Vayne"] = "vaynesilvereddebuff" }
	if buffStackTrackList[myHero.charName] then
		buffToTrackForStacks = buffStackTrackList[myHero.charName]
	end
	killTable = {}
	for i, enemy in pairs(GetEnemyHeroes()) do
		killTable[enemy.networkID] = {0, 0, 0, 0, 0, 0}
	end
	killDrawTable = {}
	for i, enemy in pairs(GetEnemyHeroes()) do
		killDrawTable[enemy.networkID] = {}
	end
	colors = { 0xDFFFE258, 0xDF8866F4, 0xDF55F855, 0xDFFF5858 }
	gapcloserTable = {
		["Aatrox"] = _Q, ["Akali"] = _R, ["Alistar"] = _W, ["Ahri"] = _R, ["Amumu"] = _Q, ["Corki"] = _W,
		["Diana"] = _R, ["Elise"] = _Q, ["Elise"] = _E, ["Fiddlesticks"] = _R, ["Fiora"] = _Q,
		["Fizz"] = _Q, ["Gnar"] = _E, ["Grags"] = _E, ["Graves"] = _E, ["Hecarim"] = _R,
		["Irelia"] = _Q, ["JarvanIV"] = _Q, ["Jax"] = _Q, ["Jayce"] = "JayceToTheSkies", ["Katarina"] = _E, 
		["Kassadin"] = _R, ["Kennen"] = _E, ["KhaZix"] = _E, ["Lissandra"] = _E, ["LeBlanc"] = _W, 
		["LeeSin"] = "blindmonkqtwo", ["Leona"] = _E, ["Lucian"] = _E, ["Malphite"] = _R, ["MasterYi"] = _Q, 
		["MonkeyKing"] = _E, ["Nautilus"] = _Q, ["Nocturne"] = _R, ["Olaf"] = _R, ["Pantheon"] = _W, 
		["Poppy"] = _E, ["RekSai"] = _E, ["Renekton"] = _E, ["Riven"] = _Q, ["Sejuani"] = _Q, 
		["Sion"] = _R, ["Shen"] = _E, ["Shyvana"] = _R, ["Talon"] = _E, ["Thresh"] = _Q, 
		["Tristana"] = _W, ["Tryndamere"] = "Slash", ["Udyr"] = _E, ["Volibear"] = _Q, ["Vi"] = _Q, 
		["XinZhao"] = _E, ["Yasuo"] = _E, ["Zac"] = _E, ["Ziggs"] = _W
	}
end

function AddPluginTicks()
		tickTable = {
      function() 
        targetSel:update()
        if ValidTarget(Forcetarget) then
          Target = Forcetarget
        elseif _G.MMA_Loaded and _G.MMA_Target() and _G.MMA_Target().type == myHero.type then 
          Target = _G.MMA_Target()
        elseif _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then 
          Target = _G.AutoCarry.Attack_Crosshair.target
        elseif _G.NebelwolfisOrbWalkerLoaded and _G.NebelwolfisOrbWalker:GetTarget() and _G.NebelwolfisOrbWalker:GetTarget().type == myHero.type then 
          Target = _G.NebelwolfisOrbWalker:GetTarget()
        else
          Target = targetSel.target
        end
      end,
      function()
        if CHAMPION.CalculateDamage then
          CHAMPION:CalculateDamage()
        else
          CalculateDamage()
        end
      end
      }
      if CHAMPION.Combo then
        table.insert(tickTable,
          function()
            if AI.state.Combo and (ValidTarget(Target) or myHero.charName == "Ryze") then
              CHAMPION:Combo()
            end
          end
        )
      end
      if CHAMPION.Harass then
        table.insert(tickTable,
          function()
            if AI.state.Harass and ValidTarget(Target) then
              CHAMPION:Harass()
            end
          end
        )
      end
      if CHAMPION.LaneClear then
        table.insert(tickTable,
          function()
            if AI.state.LaneClear then
              CHAMPION:LaneClear()
            end
          end
        )
      end
      if CHAMPION.LastHit then
        table.insert(tickTable,
        function()
          if AI.state.LastHit or AI.state.LaneClear then
            CHAMPION:LastHit()
          end
        end
        )
      end
      if CHAMPION.Tick and CHAMPION.Killsteal then
        table.insert(tickTable,
        function()
          if CHAMPION.Tick then 
            CHAMPION:Tick() 
          end
          if CHAMPION.Killsteal then 
            CHAMPION:Killsteal() 
          end
        end
        )
      elseif CHAMPION.Killsteal then
        table.insert(tickTable,
        function()
          if CHAMPION.Killsteal then 
            CHAMPION:Killsteal() 
          end
        end
        )
      elseif CHAMPION.Tick then
        table.insert(tickTable,
        function()
          if CHAMPION.Tick then 
            CHAMPION:Tick() 
          end
        end
        )
      end
      gTick=0;cTick=0;AddTickCallback(function() 
        local time = os.clock()
        if gTick < time then
          gTick = time + 0.025
          cTick = cTick + 1
          if cTick > #tickTable then cTick = 1 end
          tickTable[cTick]()
        end
      end)
		AddTickCallback(function();for _=0,3 do;sReady[_]=(myHero:CanUseSpell(_)==READY);end;end)
      	if buffToTrackForStacks then
        AddApplyBuffCallback(function(unit, source, buff)
          if unit and buff and unit.team ~= myHero.team and buff.name:lower() == buffToTrackForStacks then
            stackTable[unit.networkID] = 1
          end
        end)
        AddUpdateBuffCallback(function(unit, buff, stacks)
          if unit and buff and stacks and unit.team ~= myHero.team and buff.name:lower() == buffToTrackForStacks then
            stackTable[unit.networkID] = stacks
          end
        end)
        AddRemoveBuffCallback(function(unit, buff)
          if unit and buff and unit.team ~= myHero.team and buff.name:lower() == buffToTrackForStacks then
            stackTable[unit.networkID] = 0
          end
        end)
      end
      if CHAMPION.ApplyBuff ~= nil then
        AddApplyBuffCallback(function(unit, source, buff)
          CHAMPION:ApplyBuff(unit, source, buff)
        end)
      end
      if CHAMPION.UpdateBuff ~= nil then
        AddUpdateBuffCallback(function(unit, buff, stacks)
          CHAMPION:UpdateBuff(unit, buff, stacks)
        end)
      end
      if CHAMPION.RemoveBuff ~= nil then
        AddRemoveBuffCallback(function(unit, buff)
          CHAMPION:RemoveBuff(unit, buff)
        end)
      end
      if CHAMPION.ProcessAttack ~= nil then
        AddProcessAttackCallback(function(unit, spell)
          CHAMPION:ProcessAttack(unit, spell)
        end)
      end
      if CHAMPION.ProcessSpell ~= nil then
        AddProcessSpellCallback(function(unit, spell)
          CHAMPION:ProcessSpell(unit, spell)
        end)
      end
      if CHAMPION.Animation ~= nil then
        AddAnimationCallback(function(unit, ani)
          CHAMPION:Animation(unit, ani)
        end)
      end
      if CHAMPION.CreateObj ~= nil then
        AddCreateObjCallback(function(obj)
          CHAMPION:CreateObj(obj)
        end)
      end
      if CHAMPION.DeleteObj ~= nil then
        AddDeleteObjCallback(function(obj)
          CHAMPION:DeleteObj(obj)
        end)
      end
      if CHAMPION.IssueOrder ~= nil then
        AddIssueOrderCallback(function(source, order, position, target) 
          CHAMPION:IssueOrder(source, order, position, target) 
        end)
      end
      if CHAMPION.WndMsg ~= nil then
        AddMsgCallback(function(msg, key)
          CHAMPION:WndMsg(msg, key)
        end)
      end
      if CHAMPION.Msg ~= nil then
        AddMsgCallback(function(msg, key)
          CHAMPION:Msg(msg, key)
        end)
      end
      if CHAMPION.Draw ~= nil and debugMode then
        AddDrawCallback(function()
          CHAMPION:Draw()
        end)
      end
      if CHAMPION.Load ~= nil then
        CHAMPION:Load()
      end
    end

function GetStacks(unit)
    if myHero.charName == "Syndra" or myHero.charName == "Kassadin" then
      return Champerino.stacks
    else
      return (stackTable and stackTable[unit.networkID]) and stackTable[unit.networkID] or 0
    end
end

function UnitHaveBuff(unit, buffName)
    if unit and buffName and unit.buffCount then
      for i = 1, unit.buffCount do
        local buff = unit:getBuff(i)
        if buff and buff.valid and buff.startT <= GetGameTimer() and buff.endT >= GetGameTimer() and buff.name ~= nil and (buff.name:lower():find(buffName:lower()) or buffName:lower():find(buff.name:lower()) or buffName:lower() == buff.name:lower()) then 
          return true
        end
      end
    end
    return false
end

function GetDmg(spell, source, target)
    if target == nil or source == nil then
      return
    end
    local ADDmg  = 0
    local APDmg  = 0
    local TRUEDmg  = 0
    local AP     = source.ap
    local Level  = source.level
    local TotalDmg   = source.totalDamage
    local crit     = source.critChance
    local crdm     = source.critDmg
    local ArmorPen   = floor(source.armorPen)
    local ArmorPenPercent  = floor(source.armorPenPercent*100)/100
    local MagicPen   = floor(source.magicPen)
    local MagicPenPercent  = floor(source.magicPenPercent*100)/100

    local Armor   = target.armor*ArmorPenPercent-ArmorPen
    local ArmorPercent = Armor > 0 and floor(Armor*100/(100+Armor))/100 or 0--ceil(Armor*100/(100-Armor))/100
    local MagicArmor   = target.magicArmor*MagicPenPercent-MagicPen
    local MagicArmorPercent = MagicArmor > 0 and floor(MagicArmor*100/(100+MagicArmor))/100 or ceil(MagicArmor*100/(100-MagicArmor))/100
    if spell == "IGNITE" then
      return 50+20*Level/2
    elseif spell == "Tiamat" then
      ADDmg = (GetHydraSlot() and myHero:CanUseSpell(GetHydraSlot()) == READY) and TotalDmg*0.8 or 0 
    elseif spell == "AD" then
      ADDmg = TotalDmg
      if source.charName == "Ashe" and crit then
        ADDmg = TotalDmg*1.1+(1+crit)*(1+crdm)
      elseif source.charName == "Teemo" then
        APDmg = APDmg + spellData["Teemo"][_E].dmgAP(source, target)
      elseif source.charName == "Orianna" then
        APDmg = APDmg + 2 + 8 * ceil(Level/3) + 0.15*AP
      elseif crit then
        ADDmg = ADDmg * (1 + crit)
      end
      if myHero.charName == "Vayne" and source.isMe and GetStacks(target) == 2 then
        TRUEDmg = TRUEDmg + spellData["Vayne"][_W].dmgTRUE(source, target)
      end
      if GetMaladySlot() then
        APDmg = 15 + 0.15*AP
      end
    elseif type(spell) == "number" and spellData[source.charName] and spellData[source.charName][spell] then
      if spellData[source.charName][spell].dmgAD then ADDmg = spellData[source.charName][spell].dmgAD(source, target, GetStacks(target)) end
      if spellData[source.charName][spell].dmgAP then APDmg = spellData[source.charName][spell].dmgAP(source, target, GetStacks(target)) end
      if spellData[source.charName][spell].dmgTRUE then TRUEDmg = spellData[source.charName][spell].dmgTRUE(source, target, GetStacks(target)) end
    end
    dmg = floor(ADDmg*(1-ArmorPercent))+floor(APDmg*(1-MagicArmorPercent))+TRUEDmg
    dmgMod = (UnitHaveBuff(source, "summonerexhaust") and 0.6 or 1) * (UnitHaveBuff(target, "meditate") and 1-(target:GetSpellData(_W).level * 0.05 + 0.5) or 1)
    return floor(dmg) * dmgMod
end


function ArrangeTSPriorities()
    local priorityTable2 = {
      p5 = {"Alistar", "Amumu", "Blitzcrank", "Braum", "ChoGath", "DrMundo", "Garen", "Gnar", "Hecarim", "JarvanIV", "Leona", "Lulu", "Malphite", "Nasus", "Nautilus", "Nunu", "Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Taric", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac"},
      p4 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gangplank", "Gragas", "Irelia", "Jax","LeeSin", "Maokai", "Morgana", "Nocturne", "Pantheon", "Poppy", "Rengar", "Rumble", "Ryze", "Swain","Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai"},
      p3 = {"Akali", "Diana", "Fiddlesticks", "Fiora", "Fizz", "Heimerdinger", "Janna", "Jayce", "Kassadin","Kayle", "KhaZix", "Lissandra", "Mordekaiser", "Nami", "Nidalee", "Riven", "Shaco", "Sona", "Soraka", "TahmKench", "Vladimir", "Yasuo", "Zilean", "Zyra"},
      p2 = {"Ahri", "Anivia", "Annie",  "Brand",  "Cassiopeia", "Ekko", "Karma", "Karthus", "Katarina", "Kennen", "LeBlanc",  "Lux", "Malzahar", "MasterYi", "Orianna", "Syndra", "Talon", "TwistedFate", "Veigar", "VelKoz", "Viktor", "Xerath", "Zed", "Ziggs" },
      p1 = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "KogMaw", "Lucian", "MissFortune", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Varus", "Vayne"},
    }
    local mixed = Set {"Akali","Corki","Evelynn","Ezreal","Kayle","KogMaw","Mordekaiser","Poppy","Skarner","Teemo","Tristana","Yorick"}
    local ad = Set {"Aatrox","Darius","Draven","Ezreal","Fiora","Gangplank","Garen","Gnar","Graves","Hecarim","Irelia","JarvanIV","Jax","Jayce","Jinx","Kalista","KhaZix","LeeSin","Lucian","MasterYi","MissFortune","Nasus","Nocturne","Olaf","Pantheon","Quinn","RekSai","Renekton","Rengar","Riven","Shaco","Shyvana","Sion","Sivir","Talon","Trundle","Tryndamere","Twitch","Udyr","Urgot","Varus","Vayne","Vi","Warwick","Wukong","XinZhao","Yasuo","Zed"}
    local ap = Set {"Ahri","Alistar","Amumu","Anivia","Annie","Azir","Bard","Blitzcrank","Brand","Braum","Cassiopeia","ChoGath","Diana","DrMundo","Ekko","Elise","Fiddlesticks","Fizz","Galio","Gragas","Heimerdinger","Janna","Karma","Karthus","Kassadin","Katarina","Kennen","LeBlanc","Leona","Lissandra","Lulu","Lux","Malphite","Malzahar","Maokai","Morgana","Nami","Nautilus","Nidalee","Nunu","Orianna","Rammus","Rumble","Ryze","Sejuani","Shen","Singed","Sona","Soraka","Swain","Syndra","TahmKench","Taric","Thresh","TwistedFate","Veigar","VelKoz","Viktor","Vladimir","Volibear","Xerath","Zac","Ziggz","Zilean","Zyra"}
    targetSel:SetDamages((ad[myHero.charName] or mixed[myHero.charName]) and 100 or 0, (ap[myHero.charName] or mixed[myHero.charName]) and 100 or 0, 0)
    do
      local r = 0
      for i=0, 3 do
        if myHeroSpellData[i] and (myHeroSpellData[i].dmgAP or myHeroSpellData[i].dmgAD or myHeroSpellData[i].dmgTRUE) then
          if myHeroSpellData[i].range and myHeroSpellData[i].range > 0 then
            if myHeroSpellData[i].range > r and myHeroSpellData[i].range < 2000 then
              r = myHeroSpellData[i].range
            end
          elseif myHeroSpellData[i].width and myHeroSpellData[i].width > 0 then
            if myHeroSpellData[i].width > r then
              r = myHeroSpellData[i].width
            end
          end
        end
      end
      targetSel.range = max(r, myHero.range+myHero.boundingRadius)
      print("System is loaded with settings of " .. myHero.charName .. ", calculated range:" .. targetSel.range)
    end
    local priorityOrder = {
      [1] = {1,1,1,1,1},
      [2] = {1,1,2,2,2},
      [3] = {1,1,2,3,3},
      [4] = {1,2,3,4,4},
      [5] = {1,2,3,4,5},
    }
    local function _SetPriority(table, hero, priority)
      if table ~= nil and hero ~= nil and priority ~= nil and type(table) == "table" then
        for i=1, #table, 1 do
          if hero.charName:find(table[i]) ~= nil and type(priority) == "number" then
            TS_SetHeroPriority(priority, hero.charName)
          end
        end
      end
    end
    local enemies = #GetEnemyHeroes()
    if priorityTable2~=nil and type(priorityTable2) == "table" and enemies > 0 then
      for i, enemy in ipairs(GetEnemyHeroes()) do
        _SetPriority(priorityTable2.p1, enemy, min(1, #GetEnemyHeroes()))
        _SetPriority(priorityTable2.p2, enemy, min(2, #GetEnemyHeroes()))
        _SetPriority(priorityTable2.p3,  enemy, min(3, #GetEnemyHeroes()))
        _SetPriority(priorityTable2.p4,  enemy, min(4, #GetEnemyHeroes()))
        _SetPriority(priorityTable2.p5,  enemy, min(5, #GetEnemyHeroes()))
      end
    end
end

function CalculateDamage()
    for i, enemy in pairs(GetEnemyHeroes()) do
      if enemy and not enemy.dead and enemy.visible and enemy.bTargetable then
        local damageQ = myHero:CanUseSpell(_Q) ~= READY and 0 or myHero.charName == "Kalista" and 0 or GetDmg(_Q, myHero, enemy) or 0
        local damageW = myHero:CanUseSpell(_W) ~= READY and 0 or GetDmg(_W, myHero, enemy) or 0
        local damageE = myHero:CanUseSpell(_E) ~= READY and 0 or GetDmg(_E, myHero, enemy) or 0
        local damageR = myHero:CanUseSpell(_R) ~= READY and 0 or GetDmg(_R, myHero, enemy) or 0
        killTable[enemy.networkID] = {damageQ, damageW, damageE, damageR}
      end
    end
end

function GetRealHealth(unit)
    return unit.health--+unit.shield <- TODO: Spam bilbao
end


---------------
--Spell Data---
---------------
spellData = {
	["Aatrox"] = {
		[_Q] = { name = "AatroxQ", speed = 450, delay = 0.25, range = 650, width = 150, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "AatroxE", speed = 1200, delay = 0.25, range = 1000, width = 150, collision = false, aoe = false, type = "linear"}
	},
	["Ahri"] = {
		[_Q] = { name = "AhriOrbofDeception", speed = 2500, delay = 0.25, range = 975, width = 100, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 15+25*source:GetSpellData(_Q).level+0.35*source.ap end},
		[_W] = { name = "AhriFoxFire", range = 700, dmgAP = function(source, target) return 15+25*source:GetSpellData(_W).level+0.4*source.ap end},
		[_E] = { name = "AhriSeduce", speed = 1550, delay = 0.25, range = 1075, width = 65, collision = true, aoe = false, type = "linear", dmgAP = function(source, target) return 25+35*source:GetSpellData(_E).level+0.5*source.ap end},
		[_R] = { name = "AhriTumble", range = 450, dmgAP = function(source, target) return 40*source:GetSpellData(_R).level+30+0.3*source.ap end}
	},
	["Akali"] = {
		[_E] = { name = "", speed = math.huge, delay = 0.125, range = 0, width = 325, collision = false, aoe = true, type = "circular"}
	},
	["Alistar"] = {
		[_Q] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 365, collision = false, aoe = true, type = "circular"}
	},
	["Amumu"] = {
		[_Q] = { name = "BandageToss", speed = 725, delay = 0.25, range = 1000, width = 100, collision = true, aoe = false, type = "linear"}
	},
	["Anivia"] = {
		[_Q] = { name = "FlashFrostSpell", speed = 850, delay = 0.250, range = 1200, width = 110, collision = false, aoe = false, type = "linear"},
		[_R] = { name = "", speed = math.huge, delay = 0.100, range = 615, width = 350, collision = false, aoe = true, type = "circular"}
	},
	["Annie"] = {
		[_Q] = { name = "Disintegrate" },
		[_W] = { name = "Incinerate", speed = math.huge, delay = 0.25, range = 625, width = 250, collision = false, aoe = true, type = "cone"},
		[_E] = { name = "MoltenShield" },
		[_R] = { name = "InfernalGuardian", speed = math.huge, delay = 0.25, range = 600, width = 300, collision = false, aoe = true, type = "circular"}
	},
	["Ashe"] = {
		[_Q] = { range = 700, dmgAD = function(source, target) return (0.05*source:GetSpellData(_Q).level+1.1)*source.totalDamage end},
		[_W] = { name = "Volley", speed = 902, delay = 0.25, range = 1200, width = 100, collision = true, aoe = false, type = "cone", dmgAD = function(source, target) return 10*source:GetSpellData(_W).level+30+source.totalDamage end},
		[_E] = { speed = 1500, delay = 0.5, range = 25000, width = 1400, collision = false, aoe = false, type = "linear"},
		[_R] = { name = "EnchantedCrystalArrow", speed = 1600, delay = 0.5, range = 25000, width = 100, collision = true, aoe = false, type = "linear", dmgAP = function(source, target) return 175*source:GetSpellData(_R).level+75+source.ap end}
	},
	["Azir"] = {
		[_Q] = { name = "AzirQ", speed = 2500, delay = 0.250, range = 880, width = 100, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 15+25*source:GetSpellData(_Q).level+0.35*source.ap end},
		[_W] = { name = "AzirW", range = 520, dmgAP = function(source, target) return 15+25*source:GetSpellData(_W).level+0.4*source.ap end},
		[_E] = { name = "AzirE", range = 1100, delay = 0.25, speed = 1200, width = 60, collision = true, aoe = false, type = "linear", dmgAP = function(source, target) return 25+35*source:GetSpellData(_E).level+0.5*source.ap end},
		[_R] = { name = "AzirR", speed = 1300, delay = 0.2, range = 520, width = 600, collision = false, aoe = true, type = "linear", dmgAP = function(source, target) return 40*source:GetSpellData(_R).level+30+0.3*source.ap end}
	},
	["Bard"] = {
		[_Q] = { name = "", speed = 1100, delay = 0.25, range = 850, width = 108, collision = true, aoe = false, type = "linear"}
	},
	["Blitzcrank"] = {
		[_Q] = { name = "RocketGrabMissile", speed = 1800, delay = 0.250, range = 900, width = 70, collision = true, type = "linear", dmgAP = function(source, target) return 55*source:GetSpellData(_Q).level+25+source.ap end},
		[_W] = { name = "", range = 2500},
		[_E] = { name = "", range = 225, dmgAD = function(source, target) return 2*source.totalDamage end},
		[_R] = { name = "StaticField", speed = math.huge, delay = 0.25, range = 0, width = 500, collision = false, aoe = false, type = "circular", dmgAP = function(source, target) return 125*source:GetSpellData(_R).level+125+source.ap end}
	},
	["Brand"] = {
		[_Q] = { name = "BrandBlaze", speed = 1200, delay = 0.25, range = 1050, width = 80, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 40*source:GetSpellData(_Q).level+40+0.65*source.ap end},
		[_W] = { name = "BrandFissure", speed = math.huge, delay = 0.625, range = 1050, width = 275, collision = false, aoe = false, type = "circular", dmgAP = function(source, target) return 45*source:GetSpellData(_W).level+30+0.6*source.ap end},
		[_E] = { name = "", range = 625, dmgAP = function(source, target) return 25*source:GetSpellData(_E).level+30+0.55*source.ap end},
		[_R] = { name = "BrandWildfire", range = 750, dmgAP = function(source, target) return 100*source:GetSpellData(_R).level+50+0.5*source.ap end}
	},
	["Braum"] = {
		[_Q] = { name = "BraumQ", speed = 1600, delay = 0.25, range = 1000, width = 100, collision = false, aoe = false, type = "linear"},
		[_R] = { name = "BraumR", speed = 1250, delay = 0.5, range = 1250, width = 0, collision = false, aoe = false, type = "linear"}
	},
	["Caitlyn"] = {
		[_Q] = { name = "CaitlynPiltoverPeacemaker", speed = 2200, delay = 0.625, range = 1300, width = 0, collision = false, aoe = false, type = "linear"},
		[_E] = { name = "CaitlynEntrapment", speed = 2000, delay = 0.400, range = 1000, width = 80, collision = false, aoe = false, type = "linear"},
		[_R] = { name = "CaitlynAceintheHole" }
	},
	["Cassiopeia"] = {
		[_Q] = { name = "CassiopeiaNoxiousBlast", speed = math.huge, delay = 0.75, range = 850, width = 100, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 45+30*source:GetSpellData(_Q).level+0.45*source.ap end},
		[_W] = { name = "CassiopeiaMiasma", speed = 2500, delay = 0.5, range = 925, width = 90, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 5+5*source:GetSpellData(_W).level+0.1*source.ap end},
		[_E] = { name = "CassiopeiaTwinFang", range = 700, dmgAP = function(source, target) return 30+25*source:GetSpellData(_E).level+0.55*source.ap end },
		[_R] = { name = "CassiopeiaPetrifyingGaze", speed = math.huge, delay = 0.5, range = 825, width = 410, collision = false, aoe = true, type = "cone", dmgAP = function(source, target) return 50+10*source:GetSpellData(_R).level+0.5*source.ap end}
	},
	["Chogath"] = {
		[_Q] = { name = "Rupture", speed = math.huge, delay = 0.25, range = 950, width = 300, collision = false, aoe = true, type = "circular"},
		[_W] = { name = "", speed = math.huge, delay = 0.5, range = 650, width = 275, collision = false, aoe = false, type = "linear"},
	},
	["Corki"] = {
		[_Q] = { name = "", speed = 700, delay = 0.4, range = 825, width = 250, collision = false, aoe = false, type = "circular"},
		[_R] = { name = "MissileBarrage", speed = 2000, delay = 0.200, range = 1225, width = 60, collision = false, aoe = false, type = "linear"},
	},
	["Darius"] = {
		[_Q] = { name = "", speed = math.huge, delay = 0.75, range = 450, width = 450, type = "circular", dmgAD = function(source, target) return 20*source:GetSpellData(_Q).level+(0.9 + 0.1 * source:GetSpellData(_Q).level)*source.totalDamage end},
		[_W] = { name = "", range = 275, dmgAD = function(source, target) return source.totalDamage*1.4 end},
		[_E] = { name = "", speed = math.huge, delay = 0.32, range = 570, width = 125, collision = false, aoe = true, type = "cone"},
		[_R] = { name = "", range = 460, dmgTRUE = function(source, target, stacks) return math.floor(99*source:GetSpellData(_R).level+0.749*source.addDamage+stacks*(19*source:GetSpellData(_R).level+0.149*source.addDamage)) end}
	},
	["Diana"] = {
		[_Q] = { name = "DianaArc", speed = 1500, delay = 0.250, range = 835, width = 130, collision = false, aoe = false, type = "circular", dmgAP = function(source, target) return 35*source:GetSpellData(_Q).level+45+0.2*source.ap end},
		[_W] = { name = "", range = 250, dmgAP = function(source, target) return 12*source:GetSpellData(_W).level+10+0.2*source.ap end },
		[_E] = { name = "DianaVortex", speed = math.huge, delay = 0.33, range = 0, width = 395, collision = false, aoe = false, type = "circular" },
		[_R] = { name = "", range = 825, dmgAP = function(source, target) return 60*source:GetSpellData(_R).level+40+0.6*source.ap end }
	},
	["DrMundo"] = {
		[_Q] = { name = "InfectedCleaverMissile", speed = 2000, delay = 0.250, range = 1050, width = 75, collision = true, aoe = false, type = "linear"}
	},
	["Draven"] = {
		[_E] = { name = "DravenDoubleShot", speed = 1400, delay = 0.250, range = 1100, width = 130, collision = false, aoe = false, type = "linear"},
		[_R] = { name = "DravenRCast", speed = 2000, delay = 0.5, range = 25000, width = 160, collision = false, aoe = false, type = "linear"}
	},
	["Ekko"] = {
		[_Q] = { name = "", speed = 1050, delay = 0.25, range = 925, width = 140, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 15*source:GetSpellData(_Q).level+45+0.1*source.ap end},
		[_W] = { name = "", speed = math.huge, delay = 2.5, range = 1600, width = 450, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "", delay = 0.50, range = 350, dmgAP = function(source, target) return 30*source:GetSpellData(_E).level+20+0.2*source.ap+source.totalDamage end},
		[_R] = { name = "", speed = math.huge, delay = 0.5, range = 0, width = 400, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 150*source:GetSpellData(_R).level+50+1.3*source.ap end}
	},
	["Elise"] = {
		[_E] = { name = "EliseHumanE", speed = 1450, delay = 0.250, range = 975, width = 70, collision = true, aoe = false, type = "linear"}
	},
	["Evelynn"] = {
		[_Q] = { name = "", speed = 1300, delay = 0.250, range = 650, width = 350, collision = false, aoe = true, type = "circular" }
	},
	["Ezreal"] = {
		[_Q] = { name = "EzrealMysticShot", speed = 2000, delay = 0.25, range = 1200, width = 65, collision = true, aoe = false, type = "linear", dmgAD = function(source, target) return 20*source:GetSpellData(_Q).level+15+source.totalDamage+0.4*source.ap end},
		[_W] = { name = "EzrealEssenceFlux", speed = 1200, delay = 0.25, range = 900, width = 90, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 45*source:GetSpellData(_W).level+25+0.8*source.ap end},
		[_E] = { name = "", range = 450, dmgAP = function(source, target) return 50*source:GetSpellData(_R).level+25+0.5*source.addDamage+0.75*source.ap end},
		[_R] = { name = "EzrealTrueshotBarrage", speed = 2000, delay = 1, range = 25000, width = 180, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 150*source:GetSpellData(_R).level+200+source.addDamage+0.9*source.ap end}
	},
	["Fiddlesticks"] = {
	},
	["Fiora"] = {
	},
	["Fizz"] = {
		[_R] = { name = "FizzMarinerDoom", speed = 1350, delay = 0.250, range = 1150, width = 100, collision = false, aoe = false, type = "linear"}
	},
	["Galio"] = {
		[_Q] = { name = "GalioResoluteSmite", speed = 1300, delay = 0.25, range = 900, width = 250, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "", speed = 1200, delay = 0.25, range = 1000, width = 200, collision = false, aoe = false, type = "linear"}
	},
	["Gangplank"] = {
		[_Q] = { name = "GangplankQWrapper", range = 900},
		[_E] = { name = "", speed = math.huge, delay = 0.25, range = 900, width = 250, collision = false, aoe = true, type = "circular"},
		[_R] = { name = "", speed = math.huge, delay = 0.25, range = 25000, width = 575, collision = false, aoe = true, type = "circular"}
	},
	["Garen"] = {
	},
	["Gnar"] = {
		[_Q] = { name = "", speed = 1225, delay = 0.125, range = 1200, width = 80, collision = true, aoe = false, type = "linear"}
	},
	["Gragas"] = {
		[_Q] = { name = "GragasQ", speed = 1000, delay = 0.250, range = 1000, width = 300, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "GragasE", speed = math.huge, delay = 0.250, range = 600, width = 50, collision = true, aoe = true, type = "circular"},
		[_R] = { name = "GragasR", speed = 1000, delay = 0.250, range = 1050, width = 400, collision = false, aoe = true, type = "circular"}
	},
	["Graves"] = {
		[_Q] = { name = "", speed = 1950, delay = 0.265, range = 750, width = 85, collision = false, aoe = false, type = "cone"},
		[_W] = { name = "", speed = 1650, delay = 0.300, range = 700, width = 250, collision = false, aoe = true, type = "circular"},
		[_R] = { name = "", speed = 2100, delay = 0.219, range = 1000, width = 100, collision = false, aoe = false, type = "linear"}
	},
	["Hecarim"] = {
		[_Q] = { name = "", speed = math.huge, delay = 0.250, range = 0, width = 350, collision = false, aoe = true, type = "circular"},
		[_R] = { name = "", speed = 1900, delay = 0.219, range = 1000, width = 200, collision = false, aoe = false, type = "linear"}
	},
	["Heimerdinger"] = {
		[_W] = { name = "", speed = 900, delay = 0.500, range = 1325, width = 100, collision = true, aoe = false, type = "linear"},
		[_E] = { name = "", speed = 2500, delay = 0.250, range = 970, width = 180, collision = false, aoe = true, type = "circular"}
	},
	["Irelia"] = {
		[_R] = { name = "", speed = 1700, delay = 0.250, range = 1200, width = 25, collision = false, aoe = false, type = "linear"}
	},
	["Janna"] = {
		[_Q] = { name = "HowlingGale", speed = 1500, delay = 0.250, range = 1700, width = 150, collision = false, aoe = false, type = "linear"}
	},
	["JarvanIV"] = {
		[_Q] = { name = "", speed = 1400, delay = 0.25, range = 770, width = 70, collision = false, aoe = false, type = "linear"},
		[_E] = { name = "", speed = 1450, delay = 0.25, range = 850, width = 175, collision = false, aoe = false, type = "linear"}
	},
	["Jax"] = {
		[_E] = { name = "", speed = math.huge, delay = 0.250, range = 0, width = 375, collision = false, aoe = true, type = "circular"}
	},
	["Jayce"] = {
		[_Q] = { name = "jayceshockblast", speed = 2350, delay = 0.15, range = 1750, width = 70, collision = true, aoe = false, type = "linear"}
	},
	["Jinx"] = {
		[_W] = { name = "JinxWMissile", speed = 3000, delay = 0.600, range = 1400, width = 60, collision = true, aoe = false, type = "linear"},
		[_E] = { name = "JinxE", speed = 887, delay = 0.500, range = 830, width = 0, collision = false, aoe = true, type = "circular"},
		[_R] = { name = "JinxR", speed = 1700, delay = 0.600, range = 20000, width = 120, collision = false, aoe = true, type = "circular"}
	},
	["Kalista"] = {
		[_Q] = { name = "KalistaMysticShot", speed = 1700, delay = 0.25, range = 1150, width = 40, collision = true, aoe = false, type = "linear", dmgAD = function(source, target) return 0-50+60*source:GetSpellData(_Q).level+source.totalDamage end},
		[_W] = { name = "", delay = 1.5, range = 5000},
		[_E] = { name = "", range = 1000, dmgAD = function(source, target, stacks) return stacks > 0 and (10 + (10 * source:GetSpellData(_E).level) + (source.totalDamage * 0.6)) + (stacks-1) * (({10, 14, 19, 25, 32})[source:GetSpellData(_E).level] + (0.175 + 0.025 * source:GetSpellData(_E).level)*source.totalDamage) or 0 end},
		[_R] = { name = "", range = 2000}
	},
	["Karma"] = {
		[_Q] = { name = "KarmaQ", speed = 1700, delay = 0.250, range = 950, width = 90, collision = true, aoe = false, type = "linear"}
	},
	["Karthus"] = {
		[_Q] = { name = "KarthusLayWaste", speed = math.huge, delay = 0.775, range = 875, width = 160, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) local m=minionManager(MINION_JUNGLE, 160, target, MINION_SORT_HEALTH_ASC); return (#m.objects == 0 and 2 or 1) * (20+20*source:GetSpellData(_Q).level+0.3*source.ap) end},
		[_W] = { name = "KarthusWallOfPain", speed = math.huge, delay = 0.25, range = 1000, width = 160, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "KarthusDefile", speed = math.huge, delay = 0.25, range = 550, width = 550, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 10+20*source:GetSpellData(_Q).level+0.2*source.ap end},
		[_R] = { name = "KarthusFallenOne", range = math.huge, dmgAP = function(source, target) return 100+150*source:GetSpellData(_Q).level+0.60*source.ap end}
	},
	["Kassadin"] = {
		[_Q] = { name = "", range = 650, dmgAP = function(source, target) return 35+25*source:GetSpellData(_Q).level+0.7*source.ap end},
		[_W] = { name = "", range = 150+myHero.boundingRadius, dmgAP = function(source, target) return 15+25*source:GetSpellData(_W).level+0.6*source.ap end},
		[_E] = { name = "", speed = 2200, delay = 0.25, range = 650, width = 80, collision = false, aoe = false, type = "cone", dmgAP = function(source, target) return 45+25*source:GetSpellData(_E).level+0.7*source.ap end},
		[_R] = { name = "", speed = math.huge, delay = 0.5, range = 500, width = 150, collision = false, aoe = true, type = "circular", dmgAP = function(source, target, stacks) return (1+stacks/2)*(60+20*source:GetSpellData(_E).level+0.02*source.maxMana) end}
	},
	["Katarina"] = {
		[_Q] = { name = "", range = 675, dmgAP = function(source, target) return 35+25*source:GetSpellData(_Q).level+0.45*source.ap end},
		[_W] = { name = "", range = 375, dmgAP = function(source, target) return 5+35*source:GetSpellData(_W).level+0.25*source.ap+0.6*source.addDamage end},
		[_E] = { name = "", range = 700, dmgAP = function(source, target) return 10+30*source:GetSpellData(_E).level+0.25*source.ap end},
		[_R] = { name = "", range = 550, dmgAP = function(source, target) return 15+20*source:GetSpellData(_R).level+0.25*source.ap+0.375*source.addDamage end}
	},
	["Kayle"] = {
        [_Q] = { name = "JudicatorReckoning" },
        [_W] = { name = "JudicatorDivineBlessing" },
        [_E] = { name = "JudicatorRighteosFury" },
        [_R] = { name = "JudicatorIntervention" }
	},
	["Kennen"] = {
		[_Q] = { name = "KennenShurikenHurlMissile1", speed = 1700, delay = 0.180, range = 1050, width = 70, collision = true, aoe = false, type = "linear"}
	},
	["KhaZix"] = {
		[_W] = { name = "KhazixW", speed = 1700, delay = 0.25, range = 1025, width = 70, collision = true, aoe = false, type = "linear"},
		[_E] = { name = "", speed = 400, delay = 0.25, range = 600, width = 325, collision = false, aoe = true, type = "circular"}
	},
	["KogMaw"] = {
		[_Q] = { range = 975, delay = 0.25, speed = 1600, width = 80, type = "linear", dmgAP = function(source, target) return 30+50*source:GetSpellData(_Q).level+0.5*source.ap end},
        [_W] = { range = function() return myHero.range + myHero.boundingRadius*2 + 110+20*myHero:GetSpellData(_W).level end, dmgAP = function(source, target) return target.maxHealth*0.01*(source:GetSpellData(_W).level+1)+0.01*source.ap+source.totalDamage end},
		[_E] = { name = "", speed = 1200, delay = 0.25, range = 1200, width = 120, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 10+50*source:GetSpellData(_E).level+0.7*source.ap end},
		[_R] = { name = "KogMawLivingArtillery", speed = math.huge, delay = 1.1, range = 2200, width = 250, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 40+40*source:GetSpellData(_R).level+0.3*source.ap+0.5*source.totalDamage end}
	},
	["LeBlanc"] = {
		[_Q] = { range = 700, dmgAP = function(source, target) return 30+25*source:GetSpellData(_Q).level+0.4*source.ap end},
		[_W] = { name = "LeblancDistortion", speed = 1300, delay = 0.250, range = 600, width = 250, collision = false, aoe = false, type = "circular", dmgAP = function(source, target) return 45+40*source:GetSpellData(_W).level+0.6*source.ap end},
		[_E] = { name = "LeblancSoulShackle", speed = 1300, delay = 0.250, range = 950, width = 55, collision = true, aoe = false, type = "linear", dmgAP = function(source, target) return 15+25*source:GetSpellData(_E).level+0.5*source.ap end},
        [_R] = { range = 0}
	},
	["LeeSin"] = {
		[_Q] = { name = "BlindMonkQOne", speed = 1750, delay = 0.25, range = 1000, width = 70, collision = true, aoe = false, type = "linear", dmgAD = function(source, target) return 20+30*source:GetSpellData(_Q).level+0.9*source.addDamage end},
        [_W] = { name = "", range = 600},
		[_E] = { name = "BlindMonkEOne", speed = math.huge, delay = 0.25, range = 0, width = 450, collision = false, aoe = false, type = "circular", dmgAD = function(source, target) return 25+35*source:GetSpellData(_E).level+source.addDamage end},
		[_R] = { name = "BlindMonkR", speed = 2000, delay = 0.25, range = 2000, width = 150, collision = false, aoe = false, type = "linear", dmgAD = function(source, target) return 200*source:GetSpellData(_R).level+2*source.addDamage end}
	},
	["Leona"] = {
		[_E] = { name = "LeonaZenithBlade", speed = 2000, delay = 0.250, range = 875, width = 80, collision = false, aoe = false, type = "linear"},
		[_R] = { name = "LeonaSolarFlare", speed = 2000, delay = 0.250, range = 1200, width = 300, collision = false, aoe = true, type = "circular"}
	},
	["Lissandra"] = {
		[_Q] = { name = "", speed = 1800, delay = 0.250, range = 725, width = 20, collision = true, aoe = false, type = "linear"}
	},
	["Lucian"] = {
		[_Q] = { name = "LucianQ" },
		[_W] = { name = "LucianW", speed = 800, delay = 0.300, range = 1000, width = 80, collision = true, aoe = false, type = "linear"},
		[_R] = { name = "LucianR" }
	},
	["Lulu"] = {
		[_Q] = { name = "LuluQ", speed = 1400, delay = 0.250, range = 925, width = 80, collision = false, aoe = false, type = "linear"}
	},
	["Lux"] = {
		[_Q] = { name = "LuxLightBinding", speed = 1200, delay = 0.25, range = 1300, width = 130, collision = true, type = "linear", dmgAP = function(source, target) return 10+50*source:GetSpellData(_Q).level+0.7*source.ap end},
		[_W] = { name = "LuxPrismaticWave", speed = 1630, delay = 0.25, range = 1250, width = 210, collision = false, type = "linear"},
		[_E] = { name = "LuxLightStrikeKugel", speed = 1300, delay = 0.25, range = 1100, width = 325, collision = false, type = "circular", dmgAP = function(source, target) return 15+45*source:GetSpellData(_E).level+0.6*source.ap end},
		[_R] = { name = "LuxMaliceCannon", speed = math.huge, delay = 1, range = 3340, width = 250, collision = false, type = "linear", dmgAP = function(source, target) return 200+100*source:GetSpellData(_R).level+0.75*source.ap end}
	},
	["Malphite"] = {
		[_R] = { name = "", speed = 1600, delay = 0.5, range = 900, width = 500, collision = false, aoe = true, type = "circular"}
	},
	["Malzahar"] = {
		[_Q] = { name = "AlZaharCalloftheVoid1", speed = math.huge, delay = 1, range = 900, width = 100, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 25+55*source:GetSpellData(_Q).level+0.8*source.ap end},
		[_W] = { name = "", speed = math.huge, delay = 0.5, range = 800, width = 250, collision = false, aoe = false, type = "circular", dmgAP = function(source, target) return (3+source:GetSpellData(_W).level+source.ap*0.01)*target.maxHealth*0.01 end},
		[_E] = { name = "", range = 650, dmgAP = function(source, target) return (20+60*source:GetSpellData(_E).level)/8+0.1*source.ap end},
		[_R] = { name = "", range = 700, dmgAP = function(source, target) return 20+30*source:GetSpellData(_R).level+0.26*source.ap end}
	},
	["Maokai"] = {
		[_Q] = { name = "", speed = math.huge, delay = 0.25, range = 600, width = 100, collision = false, aoe = false, type = "linear"},
		[_E] = { name = "", speed = 1500, delay = 0.25, range = 1100, width = 175, collision = false, aoe = false, type = "circular"}
	},
	["MasterYi"] = {
	},
	["MissFortune"] = {
		[_E] = { name = "", speed = math.huge, delay = 0.25, range = 800, width = 200, collision = false, aoe = true, type = "circular"},
		[_R] = { name = "", speed = math.huge, delay = 0.25, range = 1400, width = 700, collision = false, aoe = true, type = "cone"}
	},
	["Mordekaiser"] = {
		[_E] = { name = "", speed = math.huge, delay = 0.25, range = 700, width = 0, collision = false, aoe = true, type = "cone"}
	},
	["Morgana"] = {
		[_Q] = { name = "DarkBindingMissile", speed = 1200, delay = 0.250, range = 1300, width = 80, collision = true, aoe = false, type = "linear"}
	},
	["Nami"] = {
		[_Q] = { name = "NamiQ", speed = math.huge, delay = 0.8, range = 850, width = 0, collision = false, aoe = true, type = "circular"}
	},
	["Nasus"] = {
		[_E] = { name = "", speed = math.huge, delay = 0.25, range = 450, width = 250, collision = false, aoe = true, type = "circular"}
	},
	["Nautilus"] = {
		[_Q] = { name = "NautilusAnchorDrag", speed = 2000, delay = 0.250, range = 1080, width = 80, collision = true, aoe = false, type = "linear"}
	},
	["Nidalee"] = {
		[_Q] = { name = "JavelinToss", speed = 1350, delay = 0.25, range = 1625, width = 37.5, collision = true, type = "linear", dmgAP = function(source, target) return (30+20*source:GetSpellData(_Q).level+0.4*source.ap)*math.max(1,math.min(3,GetDistance(source,target)/1250*3)) end}
	},
	["Nocturne"] = {
		[_Q] = { name = "NocturneDuskbringer", speed = 1400, delay = 0.250, range = 1125, width = 60, collision = false, aoe = false, type = "linear"}
	},
	["Nunu"] = {
	},
	["Olaf"] = {
		[_Q] = { name = "OlafAxeThrow", speed = 1600, delay = 0.25, range = 1000, width = 90, collision = false, aoe = false, type = "linear"}
	},
	["Orianna"] = {
		[_Q] = { name = "OrianaIzunaCommand", speed = 1200, delay = 0.250, range = 825, width = 175, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 30+30*source:GetSpellData(_Q).level+0.5*source.ap end},
		[_W] = { name = "OrianaDissonanceCommand", speed = math.huge, delay = 0.250, range = 0, width = 225, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 25+45*source:GetSpellData(_W).level+0.7*source.ap end},
		[_E] = { name = "OrianaRedactCommand", speed = 1800, delay = 0.250, range = 825, width = 80, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 30+30*source:GetSpellData(_E).level+0.3*source.ap end},
		[_R] = { name = "OrianaDetonateCommand", speed = math.huge, delay = 0.250, range = 0, width = 410, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 75+75*source:GetSpellData(_R).level+0.7*source.ap end}
	},
	["Pantheon"] = {
		[_E] = { name = "", speed = math.huge, delay = 0.250, range = 400, width = 100, collision = false, aoe = true, type = "cone"},
		[_R] = { name = "", speed = 3000, delay = 1, range = 5500, width = 1000, collision = false, aoe = true, type = "circular"}
	},
	["Poppy"] = {
	},
	["Quinn"] = {
		[_Q] = { name = "QuinnQ", speed = 1550, delay = 0.25, range = 1050, width = 80, collision = true, aoe = false, type = "linear", dmgAD = function(source, target) return 30+40*source:GetSpellData(_Q).level+0.65*source.addDamage+0.5*source.ap end},
		[_W] = { },
		[_E] = { range = 0, dmgAD = function(source, target) return 10+30*source:GetSpellData(_E).level+0.2*source.addDamage end},
		[_R] = { range = 0, dmgAD = function(source, target) return (70+50*source:GetSpellData(_R).level+0.5*source.addDamage)*(1+((target.maxHealth-target.health)/target.maxHealth)) end}
	},
	["Rammus"] = {
	},
	["RekSai"] = {
		[_Q] = { name = "", speed = 1550, delay = 0.25, range = 1050, width = 180, collision = true, aoe = false, type = "linear"}
	},
	["Renekton"] = {
		[_Q] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 450, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "", speed = 1225, delay = 0.25, range = 450, width = 150, collision = false, aoe = false, type = "linear"}
	},
	["Rengar"] = {
		[_Q] = { range = 450+myHero.boundingRadius*2, dmgAD = function(source, target) return 30*source:GetSpellData(_Q).level+(0.95+0.05*source:GetSpellData(_Q).level)*source.totalDamage end},
		[_W] = { name = "RengarW", speed = math.huge, delay = 0.25, range = 0, width = 490, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "RengarE", speed = 1225, delay = 0.25, range = 1000, width = 80, collision = true, aoe = false, type = "linear"},
		[_R] = { range = 4000}
	},
	["Riven"] = {
		[_Q] = { name = "RivenTriCleave", speed = math.huge, delay = 0.250, range = 310, width = 225, collision = false, aoe = true, type = "circular", dmgAD = function(source, target) return 0-10+20*myHero:GetSpellData(_Q).level+(0.35+0.05*myHero:GetSpellData(_Q).level)*source.totalDamage end},
		[_W] = { name = "RivenMartyr", speed = math.huge, delay = 0.250, range = 0, width = 265, collision = false, aoe = true, type = "circular", dmgAD = function(source, target) return 20+30*myHero:GetSpellData(_W).level+source.totalDamage end},
        [_E] = { range = 390},
		[_R] = { name = "rivenizunablade", speed = 2200, delay = 0.5, range = 1100, width = 200, collision = false, aoe = false, type = "cone", dmgAD = function(source, target) return (40+40*myHero:GetSpellData(_R).level+0.6*source.addDamage)*(math.min(3,math.max(1,4*(target.maxHealth-target.health)/target.maxHealth))) end}
	},
	["Rumble"] = {
		[_Q] = { name = "RumbleFlameThrower", speed = math.huge, delay = 0.250, range = 600, width = 500, collision = false, aoe = false, type = "cone", dmgAP = function(source, target) return 5+20*source:GetSpellData(_Q).level+0.33*source.ap end},
		[_W] = { range = myHero.boundingRadius},
		[_E] = { name = "RumbleGrenadeMissile", speed = 1200, delay = 0.250, range = 850, width = 90, collision = true, aoe = false, type = "linear", dmgAP = function(source, target) return 20+25*source:GetSpellData(_E).level+0.4*source.ap end},
		[_R] = { name = "RumbleCarpetBomb", speed = 1200, delay = 0.250, range = 1700, width = 90, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 75+55*source:GetSpellData(_R).level+0.3*source.ap end}
	},
	["Ryze"] = {
		[_Q] = { name = "RyzeQ", speed = 1700, delay = 0.25, range = 900, width = 50, collision = true, aoe = false, type = "linear", dmgAP = function(source, target) return 35+25*source:GetSpellData(_Q).level+0.55*source.ap+(0.015+0.005*source:GetSpellData(_Q).level)*source.maxMana end},
		[_W] = { name = "RyzeW", range = 600, dmgAP = function(source, target) return 60+20*source:GetSpellData(_W).level+0.4*source.ap+0.025*source.maxMana end},
		[_E] = { name = "RyzeE", range = 600, dmgAP = function(source, target) return 34+16*source:GetSpellData(_E).level+0.3*source.ap+0.02*source.maxMana end},
		[_R] = { name = "RyzeR", range = 900}
	},
	["Sejuani"] = {
		[_Q] = { range = 0, dmgAP = function(source, target) return 35+45*source:GetSpellData(_Q).level+0.4*source.ap end},
		[_W] = { range = 0, dmgAP = function(source, target) return end},
		[_E] = { range = 0, dmgAP = function(source, target) return 30+30*source:GetSpellData(_E).level*0.5*source.ap end},
		[_R] = { name = "SejuaniGlacialPrisonCast", speed = 1600, delay = 0.250, range = 1200, width = 110, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 50+100*source:GetSpellData(_R).level*0.8*source.ap end}
	},
	["Shaco"] = {
	},
	["Shen"] = {
		[_E] = { name = "ShenShadowDash", speed = 1200, delay = 0.25, range = 600, width = 40, collision = false, aoe = false, type = "linear"}
	},
	["Shyvana"] = {
		[_Q] = { range = 0, dmgAD = function(source, target) return (0.75+0.05*source:GetSpellData(_Q).level)*source.totalDamage end},
		[_W] = { range = 0, dmgAP = function(source, target) return 5+15*source:GetSpellData(_W).level+0.2*source.totalDamage end},
		[_E] = { name = "", speed = 1500, delay = 0.250, range = 925, width = 60, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 20+40*source:GetSpellData(_E).level+0.6*source.totalDamage end},
		[_R] = { range = 0, dmgAP = function(source, target) return 50+125*source:GetSpellData(_R).level+0.7*source.ap end}
	},
	["Singed"] = {
	},
	["Sion"] = {
		[_Q] = { name = "", speed = math.huge, delay = 0.125, range = 925, width = 250, collision = false, aoe = false, type = "cone"}
	},
	["Sivir"] = {
		[_Q] = { name = "SivirQ", speed = 1330, delay = 0.250, range = 1075, width = 0, collision = false, aoe = false, type = "linear"}
	},
	["Skarner"] = {
		[_E] = { name = "", speed = 1200, delay = 0.600, range = 350, width = 60, collision = false, aoe = false, type = "linear"}
	},
	["Sona"] = {
		[_R] = { name = "SonaCrescendo", speed = 2400, delay = 0.5, range = 900, width = 160, collision = false, aoe = false, type = "linear"}
	},
	["Soraka"] = {
		[_Q] = { name = "SorakaQ", speed = 2400, delay = 0.25, range = 900, width = 160, collision = false, aoe = true, type = "circular"}
	},
	["Swain"] = {
		[_W] = { name = "SwainShadowGrasp", speed = math.huge, delay = 0.850, range = 900, width = 125, collision = false, aoe = true, type = "circular"}
	},
	["Syndra"] = {
		[_Q] = { name = "SyndraQ", speed = math.huge, delay = 0.67, range = 790, width = 125, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return ((source:GetSpellData(_Q).level == 5 and target.type == myHero.type) and 1.15 or 1)*(5+45*source:GetSpellData(_Q).level+0.6*source.ap) end},
		[_W] = { name = "syndrawcast", speed = math.huge, delay = 0.8, range = 925, width = 190, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 40+40*source:GetSpellData(_W).level+0.7*source.ap end},
		[_E] = { name = "", speed = 2500, delay = 0.25, range = 730, width = 45, collision = false, aoe = true, type = "cone", dmgAP = function(source, target) return 25+45*source:GetSpellData(_E).level+0.4*source.ap end},
		[_R] = { name = "", range = 725, dmgAP = function(source, target, stacks) return math.max((stacks or 1) + 3, 7)*(45+45*source:GetSpellData(_R).level+0.2*source.ap) end}
	},
	["Talon"] = {
		[_Q] = { name = "", range = myHero.range+myHero.boundingRadius*2, dmgAD = function(source, target) return source.totalDamage+30*source:GetSpellData(_Q).level+0.3*(source.addDamage) end},
		[_W] = { name = "", speed = 900, delay = 0.25, range = 600, width = 200, collision = false, aoe = false, type = "cone", dmgAD = function(source, target) return 2*(5+25*source:GetSpellData(_W).level+0.6*(source.addDamage)) end},
		[_E] = { name = "", range = 700},
		[_R] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 650, collision = false, aoe = false, type = "circular", dmgAD = function(source, target) return 2*(70+50*source:GetSpellData(_R).level+0.75*(source.addDamage)) end}
	},
	["Taric"] = {
		[_R] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 175, collision = false, aoe = false, type = "circular"}
	},
	["Teemo"] = {
		[_Q] = { name = "", range = myHero.range+myHero.boundingRadius*3, dmgAP = function(source, target) return 35+45*source:GetSpellData(_Q).level+0.8*source.ap end},
		[_W] = { name = "", range = 25000},
		[_E] = { name = "", range = myHero.range+myHero.boundingRadius, dmgAP = function(source, target) return 10*source:GetSpellData(_E).level+0.3*source.ap end},
		[_R] = { name = "", speed = 1200, delay = 1.25, range = 900, width = 250, type = "circular", dmgAP = function(source, target) return 75+125*source:GetSpellData(_E).level+0.5*source.ap end}
	},
	["Thresh"] = {
		[_Q] = { name = "ThreshQ", speed = 1825, delay = 0.25, range = 1050, width = 70, collision = true, aoe = false, type = "linear", dmgAP = function(source, target) return 35+45*source:GetSpellData(_Q).level+0.8*source.ap end},
		[_W] = { range = 25000},
		[_E] = { name = "ThreshE", speed = 2000, delay = 0.25, range = 450, width = 110, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 9*source:GetSpellData(_E).level+0.3*source.ap end},
		[_R] = { range = 450, width = 250}
	},
	["Tristana"] = {
		[_Q] = { name = "", range = 543 },
		[_W] = { name = "", speed = 2100, delay = 0.25, range = 900, width = 125, collision = false, aoe = false, type = "circular", dmgAP = function(source, target, stacks) return (1+(stacks or 0)*0.25)*(45+35*source:GetSpellData(_W).level+0.5*source.ap) end},
		[_E] = { name = "", range = 543, dmgAD = function(source, target, stacks) return (1+(stacks or 0)*0.3)*(50+10*source:GetSpellData(_E).level+0.5*source.ap+(0.35+0.15*source:GetSpellData(_E).level)*source.addDamage) end },
		[_R] = { name = "", range = 543, dmgAP = function(source, target) return 200+100*source:GetSpellData(_R).level+source.ap end }
	},
	["Trundle"] = {
		[_Q] = { name = "", speed = math.huge, delay = 0.25, range = 1000, width = 125, collision = false, aoe = false, type = "circular"}
	},
	["Tryndamere"] = {
		[_E] = { name = "", speed = 700, delay = 0.250, range = 650, width = 160, collision = false, aoe = false, type = "linear"}
	},
	["TwistedFate"] = {
		[_Q] = { name = "WildCards", speed = 1500, delay = 0.250, range = 1200, width = 80, collision = false, aoe = false, type = "cone"}
	},
	["Twitch"] = {
		[_W] = { name = "", speed = 1750, delay = 0.250, range = 950, width = 275, collision = false, aoe = true, type = "circular"}
	},
	["Udyr"] = {
	},
	["Urgot"] = {
		[_Q] = { name = "UrgotHeatseekingLineMissile", speed = 1575, delay = 0.175, range = 1000, width = 80, collision = true, aoe = false, type = "linear"},
		[_E] = { name = "UrgotPlasmaGrenade", speed = 1750, delay = 0.25, range = 890, width = 200, collision = false, aoe = true, type = "circular"}
	},
	["Varus"] = {
		[_Q] = { name = "VarusQ", speed = 1500, delay = 0.5, range = 1475, width = 100, collision = false, aoe = false, type = "linear"},
		[_E] = { name = "VarusEMissile", speed = 1750, delay = 0.25, range = 925, width = 235, collision = false, aoe = true, type = "circular"},
		[_R] = { name = "VarusR", speed = 1200, delay = 0.5, range = 800, width = 100, collision = false, aoe = false, type = "linear"}
	},
	["Vayne"] = {
		[_Q] = { name = "", range = 450, dmgAD = function(source, target) return (1.25+0.05*source:GetSpellData(_Q).level)*source.totalDamage end},
		[_W] = { name = "", range = myHero.range+myHero.boundingRadius*2, dmgTRUE = function(source, target) return 10+10*source:GetSpellData(_W).level+((0.03+0.01*source:GetSpellData(_W).level)*target.maxHealth) end},
		[_E] = { name = "", speed = 2000, delay = 0.25, range = 650, width = 0, collision = false, aoe = false, type = "linear", dmgAD = function(source, target) return 10+35*source:GetSpellData(_E).level+0.5*source.addDamage end},
		[_R] = { name = "", range = 1000}
	},
	["Veigar"] = {
		[_Q] = { name = "VeigarBalefulStrike", speed = 1200, delay = 0.25, range = 900, width = 70, collision = true, aoe = false, type = "linear", dmgAP = function(source, target) return 30+40*source:GetSpellData(_Q).level+0.6*source.ap end},
		[_W] = { name = "VeigarDarkMatter", speed = math.huge, delay = 1.2, range = 900, width = 225, collision = false, aoe = false, type = "circular", dmgAP = function(source, target) return 50+50*source:GetSpellData(_W).level+source.ap end},
		[_E] = { name = "", speed = math.huge, delay = 0.75, range = 725, width = 275, collision = false, aoe = false, type = "circular"},
		[_R] = { name = "", range = 650, dmgAP = function(source, target) return 125+125*source:GetSpellData(_R).level+source.ap+target.ap end}
	},
	["VelKoz"] = {
		[_Q] = { name = "VelKozQ", speed = 1300, delay = 0.066, range = 1050, width = 50, collision = true, aoe = false, type = "linear"},
		[_W] = { name = "VelKozW", speed = 1700, delay = 0.064, range = 1050, width = 80, collision = false, aoe = false, type = "linear"},
		[_E] = { name = "VelKozE", speed = 1500, delay = 0.333, range = 850, width = 225, collision = false, aoe = true, type = "circular"},
		[_R] = { name = "VelKozR", speed = math.huge, delay = 0.333, range = 1550, width = 50, collision = false, aoe = false, type = "linear"}
	},
	["Vi"] = {
		[_Q] = { name = "", speed = 1500, delay = 0.25, range = 715, width = 55, collision = false, aoe = false, type = "linear"}
	},
	["Viktor"] = {
		[_Q] = { range = 0, dmgAP = function(source, target) return 20+20*source:GetSpellData(_Q).level+0.2*source.ap end},
		[_W] = { name = "", speed = 750, delay = 0.6, range = 700, width = 125, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "ViktorDeathRay", speed = 1200, delay = 0.25, range = 1200, width = 0, collision = false, aoe = false, type = "linear", dmgAP = function(source, target) return 25+45*source:GetSpellData(_E).level+0.7*source.ap end},
		[_R] = { name = "", speed = 1000, delay = 0.25, range = 700, width = 0, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 50+100*source:GetSpellData(_R).level+0.55*source.ap end}
	},
	["Vladimir"] = {
	},
	["Volibear"] = {
		[_Q] = { range = myHero.range+myHero.boundingRadius*2, dmgAD = function(source, target) return 30*source:GetSpellData(_Q).level+source.totalDamage end},
		[_W] = { range = myHero.range*2+myHero.boundingRadius+25, dmgAD = function(source, target) return ((1+(target.maxHealth-target.health)/target.maxHealth))*(45*source:GetSpellData(_W).level+35+0.15*(source.maxHealth-(440+86*source.level))) end},
		[_E] = { range = myHero.range*2+myHero.boundingRadius*2+10, dmgAP = function(source, target) return 45*source:GetSpellData(_E).level+15+0.6*source.ap end},
		[_R] = { range = myHero.range+myHero.boundingRadius, dmgAP = function(source, target) return 40*source:GetSpellData(_R).level+35+0.3*source.ap end}
	},
	["Warwick"] = {
	},
	["Wukong"] = {
	},
	["Xerath"] = {
		[_Q] = { name = "", speed = math.huge, delay = 1.75, range = 750, width = 100, collision = false, aoe = false, type = "linear"},
		[_W] = { name = "", speed = math.huge, delay = 0.25, range = 1100, width = 100, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "", speed = 1600, delay = 0.25, range = 1050, width = 70, collision = true, aoe = false, type = "linear"},
		[_R] = { name = "", speed = math.huge, delay = 0.75, range = 3200, width = 245, collision = false, aoe = true, type = "circular"}
	},
	["XinZhao"] = {
		[_R] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 375, collision = false, aoe = true, type = "circular"}
	},
	["Yasuo"] = {
		[_Q] = { name = "YasuoQ", speed = math.huge, delay = 0.25, range = 475, width = 40, collision = false, aoe = false, type = "linear", dmgAD = function(source, target) return 20*source:GetSpellData(_Q).level+source.totalDamage-10 end},
		[_W] = { name = "", range = 350},
		[_E] = { name = "", range = 475, dmgAP = function(source, target) return 50+20*source:GetSpellData(_E).level+source.ap end},
		[_R] = { name = "", range = 1200, dmgAD = function(source, target) return 100+100*source:GetSpellData(_R).level+1.5*source.totalDamage end},
		[-2] = { name = "", range = 1200, speed = 1200, delay = 0.125, width = 65, collision = false, aoe = false, type = "linear" }
	},
	["Yorick"] = {
		[_Q] = { range = 0, dmgAD = function(source, target) return 30*source:GetSpellData(_Q).level+1.2*source.totalDamage+source.totalDamage end},
		[_W] = { name = "", speed = math.huge, delay = 0.25, range = 600, width = 175, collision = false, aoe = true, type = "circular", dmgAP = function(source, target) return 50+20*source:GetSpellData(_W).level+source.ap end},
		[_E] = { range = 0, dmgAD = function(source, target) return 100+100*source:GetSpellData(_E).level+source.addDamage*1.5 end},
	},
	["Zac"] = {
		[_Q] = { name = "", speed = 2500, delay = 0.110, range = 500, width = 110, collision = false, aoe = false, type = "linear"}
	},
	["Zed"] = {
		[_Q] = { name = "ZedShuriken", speed = 1700, delay = 0.25, range = 900, width = 48, collision = false, aoe = false, type = "linear"},
		[_E] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 300, collision = false, aoe = true, type = "circular"}
	},
	["Ziggs"] = {
		[_Q] = { name = "ZiggsQ", speed = 1750, delay = 0.25, range = 1400, width = 155, collision = true, aoe = false, type = "linear"},
		[_W] = { name = "ZiggsW", speed = 1800, delay = 0.25, range = 970, width = 275, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "ZiggsE", speed = 1750, delay = 0.12, range = 900, width = 350, collision = false, aoe = true, type = "circular"},
		[_R] = { name = "ZiggsR", speed = 1750, delay = 0.14, range = 5300, width = 525, collision = false, aoe = true, type = "circular"}
	},
	["Zilean"] = {
		[_Q] = { name = "", speed = math.huge, delay = 0.5, range = 900, width = 150, collision = false, aoe = true, type = "circular"}
	},
	["Zyra"] = {
		[-1] = { name = "zyrapassivedeathmanager" },
		[_Q] = { name = "ZyraQFissure", speed = math.huge, delay = 0.7, range = 800, width = 85, collision = false, aoe = true, type = "circular"},
		[_E] = { name = "ZyraGraspingRoots", speed = 1150, delay = 0.25, range = 1100, width = 70, collision = false, aoe = false, type = "linear"},
		[_R] = { name = "ZyraBrambleZone", speed = math.huge, delay = 1, range = 1100, width = 500, collision=false, aoe = true, type = "circular"}
	}
}


----------- 
--Manuals--
-----------
function pickle(t)
  	return Pickle:clone():pickle_(t)
end

Pickle = {
  	clone = function (t) local nt={}; for i, v in pairs(t) do nt[i]=v end return nt end 
}

function Pickle:pickle_(root)
  if type(root) ~= "table" then 
    error("can only pickle tables, not ".. type(root).."s")
  end
  self._tableToRef = {}
  self._refToTable = {}
  local savecount = 0
  self:ref_(root)
  local s = ""

  while #self._refToTable > savecount do
    savecount = savecount + 1
    local t = self._refToTable[savecount]
    s = s.."{\n"
    for i, v in pairs(t) do
        s = string.format("%s[%s]=%s,\n", s, self:value_(i), self:value_(v))
    end
    s = s.."},\n"
  end

  return string.format("{%s}", s)
end

function Pickle:value_(v)
  local vtype = type(v)
  if     vtype == "string" then return string.format("%q", v)
  elseif vtype == "number" then return v
  elseif vtype == "boolean" then return tostring(v)
  elseif vtype == "table" then return "{"..self:ref_(v).."}"
  else --error("pickle a "..type(v).." is not supported")
  end  
end

function Pickle:ref_(t)
  local ref = self._tableToRef[t]
  if not ref then 
    if t == self then error("can't pickle the pickle class") end
    table.insert(self._refToTable, t)
    ref = #self._refToTable
    self._tableToRef[t] = ref
  end
  return ref
end

function unpickle(s)
  if type(s) ~= "string" then
    error("can't unpickle a "..type(s)..", only strings")
  end
  local gentables = load("return "..s)
  local tables = gentables()
  
  for tnum = 1, #tables do
    local t = tables[tnum]
    local tcopy = {}; for i, v in pairs(t) do tcopy[i] = v end
    for i, v in pairs(tcopy) do
      local ni, nv
      if type(i) == "table" then ni = tables[i[1]] else ni = i end
      if type(v) == "table" then nv = tables[v[1]] else nv = v end
      t[i] = nil
      t[ni] = nv
    end
  end
  return tables[1]
end

function GetDistance2D( o1, o2 )
    local c = "z"
    if o1.z == nil or o2.z == nil then c = "y" end
    return math.sqrt(math.pow(o1.x - o2.x, 2) + math.pow(o1[c] - o2[c], 2))
end

function GVD(startPos, distance, endPos)
	return Vector(startPos) + distance * (Vector(endPos)-Vector(startPos)):normalized()
end

function IsPassWall(startPos, endPos)
	count = GetDistance(startPos, endPos)
	i=1
	while i < count do
		i = i+10
		local pos = GVD(startPos, i, endPos)
		if IsWall(D3DXVECTOR3(pos.x, pos.y, pos.z)) then return true end
	end
	return false
end


function DrawCircleNew(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
		DrawCircleNextLvl(x, y, z, radius, 1, color, 300) 
	end
end
_G.DrawCircle = DrawCircleNew

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8, Round(180 / math.deg((math.asin((chordlength / (2 * radius)))))))
	quality = 2 * math.pi / quality
	radius = radius * .92
	local points = {}
	
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end

function Round(number)
	if number >= 0 then 
		return math.floor(number+.5) 
	else 
		return math.ceil(number-.5) 
	end
end

function sortByDistanceNodes(a,b)
  return GetDistance2D(a,_G.hflTasks[MAPNAME][TEAMNUMBER][1].point) < GetDistance2D(b,_G.hflTasks[MAPNAME][TEAMNUMBER][1].point)
end

function split(str, sep)
   local result = {}
   local regex = ("([^%s]+)"):format(sep)
   for each in str:gmatch(regex) do
      table.insert(result, each)
   end
   return result
end

function Set(list)
    local set = {}
    for _, l in ipairs(list) do 
      set[l] = true 
    end
    return set
end

function levelUp()
	local abilitySequence = {}
    if myHero.charName == "Aatrox" then           abilitySequence = { 1, 2, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif myHero.charName == "Ahri" then         abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 2, 2, }
    elseif myHero.charName == "Akali" then        abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Alistar" then      abilitySequence = { 1, 3, 2, 1, 3, 4, 1, 3, 1, 3, 4, 1, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Amumu" then        abilitySequence = { 2, 3, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Anivia" then       abilitySequence = { 1, 3, 1, 3, 3, 4, 3, 2, 3, 2, 4, 1, 1, 1, 2, 4, 2, 2, }
    elseif myHero.charName == "Annie" then        abilitySequence = { 2, 1, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Ashe" then         abilitySequence = { 2, 3, 2, 1, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Blitzcrank" then   abilitySequence = { 1, 3, 2, 3, 2, 4, 3, 2, 3, 2, 4, 3, 2, 1, 1, 4, 1, 1, }
    elseif myHero.charName == "Brand" then        abilitySequence = { 2, 3, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif myHero.charName == "Caitlyn" then      abilitySequence = { 2, 1, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Cassiopeia" then   abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Chogath" then      abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif myHero.charName == "Corki" then        abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, }
    elseif myHero.charName == "Darius" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
    elseif myHero.charName == "Diana" then        abilitySequence = { 2, 1, 2, 3, 1, 4, 1, 1, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "DrMundo" then      abilitySequence = { 2, 1, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif myHero.charName == "Draven" then       abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Elise" then        abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, } rOff = -1
    elseif myHero.charName == "Evelynn" then      abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Ezreal" then       abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "FiddleSticks" then abilitySequence = { 3, 2, 2, 1, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Fiora" then        abilitySequence = { 2, 1, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif myHero.charName == "Fizz" then         abilitySequence = { 3, 1, 2, 1, 2, 4, 1, 1, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Galio" then        abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 3, 3, 2, 2, 4, 3, 3, }
    elseif myHero.charName == "Gangplank" then    abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif myHero.charName == "Yasuo" then        abilitySequence = { 1, 2, 3, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Garen" then        abilitySequence = { 1, 2, 3, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Gragas" then       abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
    elseif myHero.charName == "Graves" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 3, 4, 3, 3, 3, 2, 4, 2, 2, }
    elseif myHero.charName == "Hecarim" then      abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Heimerdinger" then abilitySequence = { 1, 2, 2, 1, 1, 4, 3, 2, 2, 2, 4, 1, 1, 3, 3, 4, 1, 1, }
    elseif myHero.charName == "Irelia" then       abilitySequence = { 3, 1, 2, 2, 2, 4, 2, 3, 2, 3, 4, 1, 1, 3, 1, 4, 3, 1, }
    elseif myHero.charName == "Janna" then        abilitySequence = { 3, 1, 3, 2, 3, 4, 3, 2, 3, 2, 1, 2, 2, 1, 1, 1, 4, 4, }
    elseif myHero.charName == "JarvanIV" then     abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 2, 1, 4, 3, 3, 3, 2, 4, 2, 2, }
    elseif myHero.charName == "Jax" then          abilitySequence = { 3, 2, 1, 2, 2, 4, 2, 3, 2, 3, 4, 1, 3, 1, 1, 4, 3, 1, }
	elseif myHero.charName == "Gnar" then        abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Jayce" then        abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, } rOff = -1
    elseif myHero.charName == "Karma" then        abilitySequence = { 1, 3, 1, 2, 3, 1, 3, 1, 3, 1, 3, 1, 3, 2, 2, 2, 2, 2, }
    elseif myHero.charName == "Karthus" then      abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 1, 3, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Kassadin" then     abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Katarina" then     abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 3, 2, 1, 4, 1, 1, 1, 3, 4, 3, 3, }
    elseif myHero.charName == "Kayle" then        abilitySequence = { 3, 2, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
    elseif myHero.charName == "Kennen" then       abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Khazix" then       abilitySequence = { 1, 3, 1, 2 ,1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "KogMaw" then       abilitySequence = { 2, 3, 2, 1, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Leblanc" then      abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
    elseif myHero.charName == "LeeSin" then       abilitySequence = { 3, 1, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Leona" then        abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif myHero.charName == "Lissandra" then    abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Lucian" then       abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Lulu" then         abilitySequence = { 3, 2, 1, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
    elseif myHero.charName == "Lux" then          abilitySequence = { 3, 1, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Malphite" then     abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, }
	elseif myHero.charName == "MasterYi" then     abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, }
    elseif myHero.charName == "Master Yi" then     abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, }
    elseif myHero.charName == "Malzahar" then     abilitySequence = { 1, 3, 3, 2, 3, 4, 1, 3, 1, 3, 4, 2, 1, 2, 1, 4, 2, 2, }
    elseif myHero.charName == "Maokai" then       abilitySequence = { 3, 1, 2, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
    elseif myHero.charName == "MasterYi" then     abilitySequence = { 3, 1, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 2, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "MissFortune" then  abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "MonkeyKing" then   abilitySequence = { 3, 1, 2, 1, 1, 4, 3, 1, 3, 1, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Mordekaiser" then  abilitySequence = { 3, 1, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Morgana" then      abilitySequence = { 1, 2, 2, 3, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Nami" then         abilitySequence = { 1, 2, 3, 2, 2, 4, 2, 2, 3, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif myHero.charName == "Nasus" then        abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
    elseif myHero.charName == "Nautilus" then     abilitySequence = { 2, 3, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif myHero.charName == "Nidalee" then      abilitySequence = { 2, 3, 1, 3, 1, 4, 3, 2, 3, 1, 4, 3, 1, 1, 2, 4, 2, 2, }
    elseif myHero.charName == "Nocturne" then     abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Nunu" then         abilitySequence = { 3, 1, 3, 2, 1, 4, 3, 1, 3, 1, 4, 1, 3, 2, 2, 4, 2, 2, }
	elseif myHero.charName == "Braum" then        abilitySequence = { 3, 1, 3, 2, 1, 4, 3, 1, 3, 1, 4, 1, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Olaf" then         abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Orianna" then      abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Pantheon" then     abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, }
    elseif myHero.charName == "Poppy" then        abilitySequence = { 3, 2, 1, 1, 1, 4, 1, 2, 1, 2, 2, 2, 3, 3, 3, 3, 4, 4, }
    elseif myHero.charName == "Quinn" then        abilitySequence = { 3, 1, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Rammus" then       abilitySequence = { 1, 2, 3, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
    elseif myHero.charName == "Renekton" then     abilitySequence = { 2, 1, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Rengar" then       abilitySequence = { 1, 3, 2, 1, 1, 4, 2, 1, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Riven" then        abilitySequence = { 1, 2, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
	elseif myHero.charName == "Velkoz" then       abilitySequence = { 3, 1, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Rumble" then       abilitySequence = { 3, 1, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Ryze" then         abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Sejuani" then      abilitySequence = { 2, 1, 3, 3, 2, 4, 3, 2, 3, 3, 4, 2, 1, 2, 1, 4, 1, 1, }
    elseif myHero.charName == "Shaco" then        abilitySequence = { 2, 3, 1, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
    elseif myHero.charName == "Shen" then         abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Shyvana" then      abilitySequence = { 2, 1, 2, 3, 2, 4, 2, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, }
    elseif myHero.charName == "Singed" then       abilitySequence = { 1, 3, 1, 3, 1, 4, 1, 2, 1, 2, 4, 3, 2, 3, 2, 4, 2, 3, }
    elseif myHero.charName == "Sion" then         abilitySequence = { 1, 3, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Sivir" then        abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
    elseif myHero.charName == "Skarner" then      abilitySequence = { 1, 2, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 3, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Sona" then         abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Soraka" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 3, 4, 2, 3, 2, 3, 4, 2, 3, }
    elseif myHero.charName == "Swain" then        abilitySequence = { 2, 3, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Syndra" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Talon" then        abilitySequence = { 2, 3, 1, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Taric" then        abilitySequence = { 3, 2, 1, 2, 2, 4, 1, 2, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Teemo" then        abilitySequence = { 1, 3, 2, 3, 1, 4, 3, 3, 3, 1, 4, 2, 2, 1, 2, 4, 2, 1, }
    elseif myHero.charName == "Thresh" then       abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif myHero.charName == "Tristana" then     abilitySequence = { 3, 2, 2, 3, 2, 4, 2, 1, 2, 1, 4, 1, 1, 1, 3, 4, 3, 3, }
    elseif myHero.charName == "Trundle" then      abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 3, 4, 2, 3, 2, 3, 4, 2, 3, }
    elseif myHero.charName == "Tryndamere" then   abilitySequence = { 3, 1, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "TwistedFate" then  abilitySequence = { 2, 1, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Twitch" then       abilitySequence = { 1, 3, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 1, 2, 2, }
    elseif myHero.charName == "Udyr" then         abilitySequence = { 4, 2, 3, 4, 4, 2, 4, 2, 4, 2, 2, 1, 3, 3, 3, 3, 1, 1, }
    elseif myHero.charName == "Urgot" then        abilitySequence = { 3, 1, 1, 2, 1, 4, 1, 2, 1, 3, 4, 2, 3, 2, 3, 4, 2, 3, }
    elseif myHero.charName == "Varus" then        abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Vayne" then        abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Veigar" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 2, 2, 2, 2, 4, 3, 1, 1, 3, 4, 3, 3, }
    elseif myHero.charName == "Vi" then           abilitySequence = { 3, 1, 2, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Viktor" then       abilitySequence = { 3, 2, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, }
    elseif myHero.charName == "Vladimir" then     abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Volibear" then     abilitySequence = { 2, 3, 2, 1, 2, 4, 3, 2, 1, 2, 4, 3, 1, 3, 1, 4, 3, 1, }
    elseif myHero.charName == "Warwick" then      abilitySequence = { 2, 1, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 3, 2, 4, 2, 2, }
    elseif myHero.charName == "Xerath" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "XinZhao" then      abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Yorick" then       abilitySequence = { 2, 3, 1, 3, 3, 4, 3, 2, 3, 1, 4, 2, 1, 2, 1, 4, 2, 1, }
    elseif myHero.charName == "Zac" then          abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Zed" then          abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Ziggs" then        abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif myHero.charName == "Zilean" then       abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif myHero.charName == "Zyra" then         abilitySequence = { 3, 2, 1, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    else abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    end

	if _G.aiSpells then
		abilitySequence = _G.aiSpells
	end    

    if abilitySequence and #abilitySequence == 18 then
    	local qL, wL, eL, rL = myHero:GetSpellData(_Q).level, myHero:GetSpellData(_W).level, myHero:GetSpellData(_E).level, myHero:GetSpellData(_R).level
		if qL + wL + eL + rL < myHero.level then
			local spellSlot = { _Q, _W, _E, _R, }
			local level = { 0, 0, 0, 0 }
			for i = 1, myHero.level, 1 do
				level[abilitySequence[i]] = level[abilitySequence[i]] + 1
			end
			for i, v in ipairs({ qL, wL, eL, rL }) do
				if v < level[i] then PACKETS:spellUp(spellSlot[i]) end
			end
		end
    end
end

function getHeroItems()
	assassins = {"Akali","Diana","Evelynn","Fizz","Katarina","Nidalee"}
	adtanks = {"DrMundo","Garen","Hecarim","Jarvan IV","Nasus","Skarner","Volibear","Yorick"}
	adcs = {"Kalista","Jinx","Ashe","Caitlyn","Corki","Draven","Ezreal","Gankplank","Graves","KogMaw","Lucian","MissFortune","Quinn","Sivir","Thresh","Tristana","Tryndamere","Twitch","Urgot","Varus","Vayne"}
	aptanks = {"Alistar","Amumu","Blitzcrank","ChoGath","Leona","Malphite","Maokai","Nautilus","Rammus","Sejuani","Shen","Singed","Zac"}
	mages = {"Ahri","Soraka","Anivia","Annie","Brand","Cassiopeia","Galio","Gragas","Heimerdinger","Janna","Karma","Karthus","LeBlanc","Lissandra","Lulu","Lux","Malzahar","Morgana","Nami","Nunu","Orianna","Ryze","Sona","Soraka","Swain","Syndra","Taric","TwistedFate","Veigar","Viktor","Xerath","Ziggs","Zilian","Zyra"}
	hybrids = {"Kayle","Teemo"}
	bruisers = {"Darius","Irelia","Khazix","LeeSin","Olaf","Pantheon","Renekton","Rengar","Riven","Shyvana","Talon","Trundle","Vi","Wukong","Zed"}
	fighters = {"Aatrox","Fiora","Jax","Jayce","Nocturne","Poppy","Sion","Udyr","Warwick","XinZhao"}
	apcs = {"Elise","FiddleSticks","Kennen","Mordekaiser","Rumble","Vladimir"}
	heroType = nil

	for i,nam in pairs(adcs) do
		if nam == myHero.charName then
			heroType = 1
		end
	end

	for i,nam in pairs(adtanks) do
		if nam == myHero.charName then
			heroType = 2
		end
	end
	for i,nam in pairs(aptanks) do
		if nam == myHero.charName then
			heroType = 3
		end
	end
	for i,nam in pairs(hybrids) do
		if nam == myHero.charName then
			heroType = 4
		end
	end
	for i,nam in pairs(bruisers) do
		if nam == myHero.charName then
			heroType = 5
		end
	end
	for i,nam in pairs(assassins) do
		if nam == myHero.charName then
			heroType = 6
		end
	end
	for i,nam in pairs(mages) do
		if nam == myHero.charName then
			heroType = 7
		end
	end
	for i,nam in pairs(apcs) do
		if nam == myHero.charName then
			heroType = 8
		end
	end
	for i,nam in pairs(fighters) do
		if nam == myHero.charName then
			heroType = 9
		end
	end
	if heroType == nil then
		heroType = 10
	end

	if heroType == 1 then  --Done ADCS
		shopList = {itemTable["Dagger"],itemTable["Dagger"],itemTable["Recurve Bow"],itemTable["Long Sword"],itemTable["Vampiric Scepter"],itemTable["Long Sword"],itemTable["Blade of the Ruined King"],itemTable["Boots of Speed"],itemTable["Dagger"],itemTable["Berserker's Greaves"],itemTable["Brawler's Gloves"],itemTable["Avarice Blade"],itemTable["Long Sword"],itemTable["Long Sword"],itemTable["The Brutalizer"],itemTable["Youmuu's Ghostblade"],itemTable["Dagger"],itemTable["Brawler's Gloves"],itemTable["Zeal"],itemTable["Dagger"],itemTable["Cloak of Agility"],itemTable["Phantom Dancer"],itemTable["B. F. Sword"],itemTable["Pickaxe"],
		itemTable["Infinity Edge"],itemTable["The Bloodthirster"],0}
	end
	if heroType == 2 then --Done AdTanks
		shopList = {itemTable["Pickaxe"],itemTable["Rejuvenation Bead"],itemTable["Rejuvenation Bead"],itemTable["Long Sword"],itemTable["Tiamat"],itemTable["Long Sword"],itemTable["Vampiric Scepter"],itemTable["Boots of Speed"],itemTable["Ruby Crystal"],itemTable["Giant's Belt"],itemTable["Ravenous Hydra"],itemTable["Cloth Armor"],itemTable["Chain Vest"],itemTable["Ruby Crystal"],itemTable["Bami's Cinder"],itemTable["Sunfire Cape"],itemTable["Null-Magic Mantle"],itemTable["Mercury's Treads"],itemTable["Cloth Armor"],itemTable["Cloth Armor"],itemTable["Warden's Mail"],itemTable["Randuin's Omen"],itemTable["Phage"],itemTable["Sheen"],itemTable["Trinity Force"],itemTable["Guardian Angel"],0}
	end
	if heroType == 3 then --Done ApTanks
		shopList = {itemTable["Ruby Crystal"],itemTable["Giant's Belt"],itemTable["Amplifying Tome"],itemTable["Needlessly Large Rod"],itemTable["Rylai's Crystal Scepter"],itemTable["Null-Magic Mantle"],itemTable["Boots of Speed"],itemTable["Mercury's Treads"],itemTable["Ruby Crystal"],itemTable["Amplifying Tome"],itemTable["Haunting Guise"],itemTable["Blasting Wand"],itemTable["Liandry's Torment"],itemTable["Ruby Crystal"],itemTable["Giant's Belt"],itemTable["Cloth Armor"],itemTable["Cloth Armor"],itemTable["Warden's Mail"],itemTable["Randuin's Omen"],itemTable["Cloth Armor"],itemTable["Chain Vest"],itemTable["Cloth Armor"],itemTable["Thornmail"],itemTable["Abyssal Scepter"],0}
	end
	if heroType == 4 then --Done Hybrids
		shopList = {itemTable["Faerie Charm"],itemTable["Faerie Charm"],itemTable["Null-Magic Mantle"],itemTable["Chalice of Harmony"],itemTable["Boots of Speed"],itemTable["Sorcerer's Shoes"],itemTable["Amplifying Tome"],itemTable["Fiendish Codex"],itemTable["Amplifying Tome"],itemTable["Athene's Unholy Grail"],itemTable["Amplifying Tome"],itemTable["Ruby Crystal"],itemTable["Haunting Guise"],itemTable["Blasting Wand"],itemTable["Liandry's Torment"],itemTable["Cloth Armor"],itemTable["Amplifying Tome"],itemTable["Seeker's Armguard"],itemTable["Needlessly Large Rod"],itemTable["Zhonya's Hourglass"],itemTable["Amplifying Tome"],itemTable["Blasting Wand"],itemTable["Needlessly Large Rod"],itemTable["Rabadon's Deathcap"],itemTable["Needlessly Large Rod"],itemTable["Luden's Echo"],0}
	end
	if heroType == 5 then --Done Brusiers
		shopList = {itemTable["Pickaxe"],itemTable["Rejuvenation Bead"],itemTable["Rejuvenation Bead"],itemTable["Long Sword"],itemTable["Tiamat"],itemTable["Long Sword"],itemTable["Vampiric Scepter"],itemTable["Boots of Speed"],itemTable["Ruby Crystal"],itemTable["Giant's Belt"],itemTable["Ravenous Hydra"],itemTable["Cloth Armor"],itemTable["Chain Vest"],itemTable["Ruby Crystal"],itemTable["Bami's Cinder"],itemTable["Sunfire Cape"],itemTable["Null-Magic Mantle"],itemTable["Mercury's Treads"],itemTable["Cloth Armor"],itemTable["Cloth Armor"],itemTable["Warden's Mail"],itemTable["Randuin's Omen"],itemTable["Phage"],itemTable["Sheen"],itemTable["Trinity Force"],itemTable["Guardian Angel"],0}
	end
	if heroType == 6 then --DONE ASSASINS
		shopList = {itemTable["Blasting Wand"],itemTable["Null-Magic Mantle"],itemTable["Negatron Cloak"],itemTable["Abyssal Scepter"],itemTable["Boots of Speed"],itemTable["Sorcerer's Shoes"],itemTable["Amplifying Tome"],itemTable["Athene's Unholy Grail"],itemTable["Amplifying Tome"],itemTable["Ruby Crystal"],itemTable["Haunting Guise"],itemTable["Blasting Wand"],itemTable["Liandry's Torment"],itemTable["Cloth Armor"],itemTable["Amplifying Tome"],itemTable["Seeker's Armguard"],itemTable["Needlessly Large Rod"],itemTable["Zhonya's Hourglass"],itemTable["Amplifying Tome"],itemTable["Blasting Wand"],itemTable["Needlessly Large Rod"],itemTable["Rabadon's Deathcap"],itemTable["Needlessly Large Rod"],itemTable["Luden's Echo"],0}
	end
	if heroType == 7 then --DONE Mages
		shopList = {itemTable["Faerie Charm"],itemTable["Faerie Charm"],itemTable["Null-Magic Mantle"],itemTable["Chalice of Harmony"],itemTable["Boots of Speed"],itemTable["Sorcerer's Shoes"],itemTable["Amplifying Tome"],itemTable["Fiendish Codex"],itemTable["Amplifying Tome"],itemTable["Athene's Unholy Grail"],itemTable["Amplifying Tome"],itemTable["Ruby Crystal"],itemTable["Haunting Guise"],itemTable["Blasting Wand"],itemTable["Liandry's Torment"],itemTable["Cloth Armor"],itemTable["Amplifying Tome"],itemTable["Seeker's Armguard"],itemTable["Needlessly Large Rod"],itemTable["Zhonya's Hourglass"],itemTable["Amplifying Tome"],itemTable["Blasting Wand"],itemTable["Needlessly Large Rod"],itemTable["Rabadon's Deathcap"],itemTable["Needlessly Large Rod"],itemTable["Luden's Echo"],0}
	end
	if heroType == 8 then --Done Apc
		shopList = {itemTable["Faerie Charm"],itemTable["Faerie Charm"],itemTable["Null-Magic Mantle"],itemTable["Chalice of Harmony"],itemTable["Boots of Speed"],itemTable["Sorcerer's Shoes"],itemTable["Amplifying Tome"],itemTable["Fiendish Codex"],itemTable["Amplifying Tome"],itemTable["Athene's Unholy Grail"],itemTable["Amplifying Tome"],itemTable["Ruby Crystal"],itemTable["Haunting Guise"],itemTable["Blasting Wand"],itemTable["Liandry's Torment"],itemTable["Cloth Armor"],itemTable["Amplifying Tome"],itemTable["Seeker's Armguard"],itemTable["Needlessly Large Rod"],itemTable["Zhonya's Hourglass"],itemTable["Amplifying Tome"],itemTable["Blasting Wand"],itemTable["Needlessly Large Rod"],itemTable["Rabadon's Deathcap"],itemTable["Needlessly Large Rod"],itemTable["Luden's Echo"],0}
	end
	if heroType == 9 or heroType == 10 then --Done Fighters
		shopList = {itemTable["Pickaxe"],itemTable["Rejuvenation Bead"],itemTable["Rejuvenation Bead"],itemTable["Long Sword"],itemTable["Tiamat"],itemTable["Long Sword"],itemTable["Vampiric Scepter"],itemTable["Boots of Speed"],itemTable["Ruby Crystal"],itemTable["Giant's Belt"],itemTable["Ravenous Hydra"],itemTable["Cloth Armor"],itemTable["Chain Vest"],itemTable["Ruby Crystal"],itemTable["Bami's Cinder"],itemTable["Sunfire Cape"],itemTable["Null-Magic Mantle"],itemTable["Mercury's Treads"],itemTable["Cloth Armor"],itemTable["Cloth Armor"],itemTable["Warden's Mail"],itemTable["Randuin's Omen"],itemTable["Phage"],itemTable["Sheen"],itemTable["Trinity Force"],itemTable["Guardian Angel"],0}
	end
	return shopList
end

function loadedSettingsItems()
	if _G.aiItems then
		shopList = _G.aiItems
	else
		shopList = getHeroItems()
	end

	return shopList
end

function  OnLoad()
	init()
end
