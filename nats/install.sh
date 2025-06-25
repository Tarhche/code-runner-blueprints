#!/bin/sh

# Step 1: Detect OS and Architecture
OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Normalize architecture name
case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  amd64) ARCH="amd64" ;;
  aarch64) ARCH="arm64" ;;
  armv7l) ARCH="arm7" ;;
  armv6l) ARCH="arm6" ;;
  i386 | i686) ARCH="386" ;;
  *) echo "Unsupported arch: $ARCH"; exit 1;;
esac

# Step 2: Get Latest NATS CLI Version
VERSION=$(wget --no-check-certificate -qO- https://api.github.com/repos/nats-io/natscli/releases/latest | grep '"tag_name":' | head -n 1 | cut -d '"' -f4)

if [ -z "$VERSION" ]; then
    echo "Failed to get latest NATS version."
    exit 1
fi

echo "Detected OS: $OS"
echo "Detected Architecture: $ARCH"
echo "Latest NATS Version: $VERSION"

# Step 3: Build Download URL
VERSION_NUMBER=$(echo "$VERSION" | sed 's/^v//')
FILE_NAME="nats-${VERSION_NUMBER}-${OS}-${ARCH}"
ZIP_FILE="${FILE_NAME}.zip"
URL="https://github.com/nats-io/natscli/releases/download/${VERSION}/${ZIP_FILE}"

# Step 4: Download and Extract
wget --no-check-certificate $URL -O /tmp/$ZIP_FILE

if [ $? -ne 0 ]; then
    echo "Failed to download NATS."
    exit 1
fi

cd /tmp
unzip $ZIP_FILE

# Step 5: Move binary to /usr/local/bin
mv $FILE_NAME/nats /usr/local/bin/

# Step 6: Cleanup
rm -rf $ZIP_FILE $FILE_NAME

echo "NATS server installed successfully."
