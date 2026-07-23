# 🚀 Quick Start - Run in 3 Commands

## Prerequisites
- Mac with Xcode 13+
- XcodeGen installed: `brew install xcodegen`

## Run These Commands

```bash
# 1. Clone to your Mac
git clone http://local_proxy@127.0.0.1:41729/git/rebaneado/agent
cd agent

# 2. Generate the Xcode project
xcodegen generate

# 3. Open and run
open AISchedulingApp.xcodeproj
```

Then in Xcode:
- Press **Cmd + R** to run

That's it! 🎉

## What Happens?

✅ `xcodegen generate` reads `project.yml` and creates the `.xcodeproj`  
✅ All your Swift files are automatically included  
✅ Core Data model is configured  
✅ Build settings are optimized  

## Troubleshooting

**If `xcodegen` command not found:**
```bash
brew install xcodegen
```

**If build fails:**
```bash
# Clean and rebuild
xcodebuild clean -scheme AISchedulingApp
xcodegen generate
open AISchedulingApp.xcodeproj
```

**See app build output:**
```bash
xcodegen generate -v
```

## Next Steps

1. Configure API in `.env` file
2. Create an account or set up backend
3. Build and test on simulator or device

Enjoy! 🎊
