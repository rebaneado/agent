#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 AI Scheduling App - Setup Script${NC}\n"

# Check if on Mac
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${YELLOW}⚠️  This script is for macOS only${NC}"
    exit 1
fi

# Check if Xcode is installed
if ! command -v xcode-select &> /dev/null; then
    echo -e "${YELLOW}⚠️  Xcode Command Line Tools not found${NC}"
    echo "Please install: xcode-select --install"
    exit 1
fi

echo -e "${GREEN}✅ Xcode found${NC}\n"

# Install Homebrew if needed
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install XcodeGen if needed
if ! command -v xcodegen &> /dev/null; then
    echo -e "${YELLOW}📦 Installing XcodeGen...${NC}"
    brew install xcodegen
    echo -e "${GREEN}✅ XcodeGen installed${NC}\n"
else
    echo -e "${GREEN}✅ XcodeGen already installed${NC}\n"
fi

# Generate Xcode project
echo -e "${BLUE}🔨 Generating Xcode project...${NC}"
xcodegen generate

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Xcode project generated${NC}\n"
else
    echo -e "${YELLOW}❌ Failed to generate Xcode project${NC}"
    exit 1
fi

# Install dependencies (if needed)
if [ -f "Podfile" ]; then
    echo -e "${BLUE}📦 Installing CocoaPods dependencies...${NC}"
    pod install
fi

# Open in Xcode
echo -e "${BLUE}📂 Opening Xcode...${NC}"
open AISchedulingApp.xcodeproj

echo -e "\n${GREEN}✅ Setup complete!${NC}"
echo -e "${BLUE}Next steps:${NC}"
echo -e "1. In Xcode, select an iPhone simulator at the top"
echo -e "2. Press ${YELLOW}Cmd + R${NC} to build and run"
echo -e "3. App will launch in the simulator\n"
