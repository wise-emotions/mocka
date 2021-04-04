#!/bin/bash
set -e

PROJECT_NAME="Mocka"
SWIFT_FORMAT_VERSION="swift-5.3-branch"

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
    # Install Swift Format on the current working directory if needed.
    if [[ ! -d "swift-format" ]]; then
      echo 'swift-format is not installed.' >&2

      CURRENT_WORKING_DIRECTORY=$(pwd)

      git clone -b $SWIFT_FORMAT_VERSION https://github.com/apple/swift-format.git
      cd swift-format
      swift build
    else
      echo "Check if swift-format version is $SWIFT_FORMAT_VERSION." >&2

      cd swift-format

      CURRENT_BRANCH=$(git branch --show-current)

      # If it's already installed, check that it's the right version.
      if [[ $CURRENT_BRANCH != $SWIFT_FORMAT_VERSION ]]; then
        echo "Installing swift-format $SWIFT_FORMAT_VERSION version." >&2
        git fetch --all
        git checkout --track origin/$SWIFT_FORMAT_VERSION || git checkout $SWIFT_FORMAT_VERSION

        swift build
      else
        echo "swift-format $SWIFT_FORMAT_VERSION already installed." >&2
      fi
    fi

    echo "Formatting code..." >&2

    # Run local swift-format
    swift run swift-format --configuration ../swiftformat.json -m format -r -i ./../Sources

    cd ..
  fi
done

# Create a temporary folder.
mkdir -p .temp

# Move the project userdata folder to a temporary folder.
if ls $PROJECT_NAME.xcodeproj/xcuserdata 1> /dev/null 2>&1; then
  mv $PROJECT_NAME.xcodeproj/xcuserdata .temp/projxcuserdata
fi

# Remove present .xcodeproj.
rm -rf $PROJECT_NAME.xcodeproj

# Run xcodegen to generate a new project file.
xcodegen

# Move back the project userdata folder to the correct folder.
if ls .temp/projxcuserdata 1> /dev/null 2>&1; then
  mv .temp/projxcuserdata $PROJECT_NAME.xcodeproj/
  mv $PROJECT_NAME.xcodeproj/projxcuserdata $PROJECT_NAME.xcodeproj/xcuserdata
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
