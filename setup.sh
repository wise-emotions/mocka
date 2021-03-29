#!/bin/bash
set -e

PROJECT_NAME="Mocka"

# Install Homebrew dependency manager.
if ! [[ -x "$(command -v brew)" ]]; then
  echo 'Homebrew is not installed.' >&2
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install XcodeGen to generate the xcodeproj.
if ! [[ -x "$(command -v xcodegen)" ]]; then
  echo 'XcodeGen is not installed.' >&2
  brew install xcodegen
fi

for var in $@
do
  # If argument "close" is passed, close the project.
  if [[ "$var" == "close" ]]; then
    echo -e "Killing Xcode."
    osascript -e 'tell app "Xcode" to quit'
  fi

  # If argument "format" is passed, format all the code by using swift-format.
  if [[ "$var" == "format" ]]; then
    echo -e "Formatting code..."

    if [[ -x "$(command -v swift-format)" ]]; then
      swift-format --configuration swiftformat.json -m format -r -i ./
    fi
  fi
done

# Create a temporary folder.
mkdir -p .temp
# Move the project userdata folder to a temporary folder.
if ls *.xcodeproj/xcuserdata 1> /dev/null 2>&1; then
  mv *.xcodeproj/xcuserdata .temp/projxcuserdata
fi
# Remove present .xcodeproj.
rm -rf *.xcodeproj

# Run xcodegen to generate a new project file.
xcodegen

# Move back the project userdata folder to the correct folder.
if ls projxcuserdata 1> /dev/null 2>&1; then
  mv .temp/projxcuserdata *.xcodeproj/
  mv *.xcodeproj/projxcuserdata $PROJECT_NAME.xcodeproj/xcuserdata
fi
# Remove the temporary folder.
rm -rf .temp

# Move config files to right place.
cp IDETemplateMacros.plist $PROJECT_NAME.xcodeproj/xcshareddata/IDETemplateMacros.plist

for var in $@
do
  # If "open" argument is passed, open the project.
  if [[ "$var" == "open" ]]; then
    echo -e "Opening project."
    open $PROJECT_NAME.xcodeproj
  fi
done
