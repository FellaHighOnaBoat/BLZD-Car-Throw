# 🚗 Carry & Throw Cars (FiveM Script)

A fun (dumb) and lightweight FiveM script that lets players pick up cars, charge a strength bar, and throw them in the direction they're facing.

---

## 📦 Installation

1. Drop the folder into your `resources` directory.
2. Add this to your `server.cfg`:

    ensure carcarry

---

## 🎮 Controls

- `/carrycar` — Pick up or drop the nearest vehicle.
- Hold `E` — Charge throw strength.
- Release `E` — Throw the vehicle forward.

---

## ⚙️ Configuration

You can tweak values directly in `client.lua`:

```lua
local maxThrowStrength = 100        -- Max charge level
local offset = 2.0                  -- Distance in front of player before throw
local upwardForce = 5.0             -- Vertical lift applied
local forceMultiplier = 100.0       -- Throw power scaling
```

---

## 🔧 Dependencies
None — this script is fully standalone.