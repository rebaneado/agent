.PHONY: help setup run build clean test

help:
	@echo "🎯 AI Scheduling App - Available Commands"
	@echo ""
	@echo "Setup & Run:"
	@echo "  make setup      - Install dependencies and open Xcode"
	@echo "  make run        - Build and run on simulator (Cmd+R in Xcode)"
	@echo "  make open       - Open project in Xcode"
	@echo ""
	@echo "Building:"
	@echo "  make build      - Build the app"
	@echo "  make generate   - Generate Xcode project from project.yml"
	@echo "  make clean      - Clean build files"
	@echo ""
	@echo "Development:"
	@echo "  make test       - Run unit tests"
	@echo "  make lint       - Run SwiftLint"
	@echo ""

setup:
	@echo "🚀 Setting up AI Scheduling App..."
	@bash setup.sh

run:
	@echo "▶️  Running app..."
	xcodebuild -scheme AISchedulingApp -configuration Debug -destination 'generic/platform=iOS Simulator' build

build:
	@echo "🔨 Building..."
	xcodebuild -scheme AISchedulingApp build

generate:
	@echo "📦 Generating Xcode project..."
	xcodegen generate

open:
	@echo "📂 Opening in Xcode..."
	open AISchedulingApp.xcodeproj

clean:
	@echo "🧹 Cleaning..."
	rm -rf build/
	rm -rf ~/Library/Developer/Xcode/DerivedData/AISchedulingApp-*
	xcodebuild clean -scheme AISchedulingApp

test:
	@echo "🧪 Running tests..."
	xcodebuild test -scheme AISchedulingApp

lint:
	@echo "🔍 Running SwiftLint..."
	which swiftlint || brew install swiftlint
	swiftlint
