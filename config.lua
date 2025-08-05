Config = {}

-- Vehicle class RPM limits for 2-Step (in RPM)
Config.TwoStepRPMByClass = {
    [0] = 2500,  -- Compacts
    [1] = 3000,  -- Sedans
    [2] = 2800,  -- SUVs
    [3] = 3200,  -- Coupes
    [4] = 3500,  -- Muscle
    [5] = 4000,  -- Sports Classics
    [6] = 4200,  -- Sports
    [7] = 4500,  -- Super
    [8] = 2000,  -- Motorcycles
}

Config.TwoStepKey = 21 -- LEFT SHIFT
Config.ToggleKey = 311 -- K key

-- Antilag settings per vehicle class (ms)
Config.AntilagDurationByClass = {
    [0] = 1500,
    [1] = 1700,
    [2] = 1600,
    [3] = 1800,
    [4] = 2000,
    [5] = 2200,
    [6] = 2300,
    [7] = 2500,
    [8] = 1400,
}

Config.BackfireChance = 75 -- %

-- Sound files (in sounds/ folder)
Config.Sounds = {
    TwoStep = "twostep_custom.ogg",
    Backfire = "backfire_custom.ogg",
    TurboFlutter = "turboflutter_custom.ogg"
}

-- FX assets & names for exhaust flames
Config.FxAssets = {
    ParticleAsset = "core",
    ParticleName = "veh_exhaust_flame"
}

-- Controls for throttle and brake
Config.ThrottleControl = 71 -- W
Config.BrakeControl = 72    -- S
