# 🏃 Run the App on Your Mac

## Option 1: Automatic Setup (Easiest) ⭐

Run one command in your Mac terminal:

```bash
# Clone repo
git clone http://local_proxy@127.0.0.1:41729/git/rebaneado/agent
cd agent

# Run setup script
bash setup.sh
```

**That's it!** The script will:
- ✅ Check for Xcode
- ✅ Install XcodeGen (if needed)
- ✅ Generate the Xcode project
- ✅ Open Xcode automatically

Then in Xcode → Press **Cmd + R**

---

## Option 2: Manual Steps (3 Commands)

```bash
# 1. Clone
git clone http://local_proxy@127.0.0.1:41729/git/rebaneado/agent
cd agent

# 2. Generate project
xcodegen generate

# 3. Open Xcode
open AISchedulingApp.xcodeproj
```

In Xcode → Press **Cmd + R**

---

## Option 3: Using Make

```bash
git clone http://local_proxy@127.0.0.1:41729/git/rebaneado/agent
cd agent
make setup
```

---

## Once Xcode is Open

### To Run the App:

1. **Select Simulator:**
   - Top toolbar, click device selector
   - Choose "iPhone 15" (or preferred model)

2. **Run:**
   - Press **Cmd + R** OR
   - Click Play button ▶️

3. **Wait for build** (first time ~30-60 seconds)

4. **App launches in simulator!** 🎉

---

## Useful Xcode Shortcuts

| Action | Shortcut |
|--------|----------|
| Run app | `Cmd + R` |
| Stop app | `Cmd + .` |
| Build | `Cmd + B` |
| Clean | `Cmd + Shift + K` |
| Open console | `Cmd + Shift + C` |

---

## Troubleshooting

### Build Fails?

```bash
# Clean and rebuild
make clean
make generate
open AISchedulingApp.xcodeproj
# Cmd + R
```

### Simulator Not Showing?

```bash
# In Xcode: Window → Devices and Simulators
# Or reset simulator: xcrun simctl erase all
```

### XcodeGen Not Found?

```bash
brew install xcodegen
xcodegen generate
```

### Still Having Issues?

```bash
# Try resetting everything
rm -rf AISchedulingApp.xcodeproj
xcodegen generate
open AISchedulingApp.xcodeproj
```

---

## After First Run

- Edit files in Xcode
- Press **Cmd + R** to see changes
- Check console (Cmd + Shift + C) for logs

Happy coding! 🚀
