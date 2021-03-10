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

# If argument "close" is passed, close the project.
for var in $@
do
  if [[ "$var" == "close" ]]; then
    echo -e "Killing Xcode."
    osascript -e 'tell app "Xcode" to quit'
  fi
done

# Removes the temporary folders if they are alrady present.
rm -rf projxcuserdata

# Move the project userdata folder to a temporary folder.
if ls *.xcodeproj/xcuserdata 1> /dev/null 2>&1; then
  mv *.xcodeproj/xcuserdata projxcuserdata
fi
# Remove present .xcodeproj.
rm -rf *.xcodeproj

# Run xcodegen to generate a new project file.
xcodegen

# Move back the project userdata folder to the correct folder.
if ls projxcuserdata 1> /dev/null 2>&1; then
  mv projxcuserdata *.xcodeproj/
  mv *.xcodeproj/projxcuserdata $PROJECT_NAME.xcodeproj/xcuserdata
fi

for var in $@
do
  # If "open" argument is passed, open the project.
  if [[ "$var" == "open" ]]; then
    echo -e "Opening project."
    open $PROJECT_NAME.xcodeproj
  fi
done
