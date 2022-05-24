#!/bin/bash

pip install -r ../requirements.txt
pip install pyinstaller
pyinstaller __main__.py --onefile -p .
mkdir /usr/local/bin/watchwolf
cp dist/__main__ /usr/local/bin/watchwolf/watchwolf
echo "Now, create the service file and run start_service.sh."