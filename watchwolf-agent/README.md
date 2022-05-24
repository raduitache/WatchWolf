# watchwolf-agent
## Installation steps
- Install the requirements with `pip install -r ../requirements.txt` 
- Install awscli, boto3, and configure aws with `sudo apt install boto3 awscli; aws configure`
- Install pyinstaller with `pip install pyinstaller`
- Compile the executable with `pyinstaller __main__.py --onefile -p .`
- Copy `dist/__main__` as `/usr/local/bin/watchwolf/watchwolf` 
- Create the file `/usr/lib/systemd/system/watchwolf.service` and write inside the following: 
```
[Unit]
Description=Watchwolf agent service
After=multi-user.target

[Service]
Type=simple
Restart=always
ExecStart=/usr/local/bin/watchwolf/watchwolf 

[Install]
WantedBy=multi-user.target
```
- Run the following commands: 
```
systemctl daemon-reload
systemctl enable watchwolf.service
systemctl start watchwolf.service
```