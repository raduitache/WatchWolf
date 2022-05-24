#!/usr/bin/env python3

from rich import print as pprint
from utils.helpers import get_commit_hash
import psutil
import argparse
import os
import time
import boto3
import base64
import json


service = f"""\
[Unit]
Description=Watchwolf service
After=multi-user.target

[Service]
Type=simple
Restart=always
ExecStart=/usr/bin/python3 /usr/local/bin/watchwolf/{os.path.basename(__file__)} 

[Install]
WantedBy=multi-user.target
"""

def intro():
    """Display the intro message."""
    pprint(f'[red]INFO[/red]\tWatchWolf revision number: [b]'
           f'{get_commit_hash()}[/b].')

def main():
    """The main driver of the program."""
    intro()

    if os.geteuid() != 0:
        print("Please run as root.")
        exit(1)

    #if license:
    #my_parser = argparse.ArgumentParser(description='Watchwolf agent')
    #my_parser.add_argument('--license-key', action='store', type=str, required=True,  help='License key')
    #args = my_parser.parse_args()
    #license check here!!!
    #add to service path --license-key {args.license_key}

    if not os.path.exists('/usr/local/bin/watchwolf'):
        os.mkdir('/usr/local/bin/watchwolf')
        os.system(f'cp \'{__file__}\' /usr/local/bin/watchwolf/')
        os.system(f'chmod +x \'/usr/local/bin/watchwolf/{os.path.basename(__file__)}\'')
        with open('/usr/lib/systemd/system/watchwolf.service', 'w') as f:
            f.write(service)
        os.system('systemctl daemon-reload')
        os.system('systemctl enable watchwolf.service')
        os.system('systemctl start watchwolf.service')

    while True:
        cpu_level = psutil.cpu_percent()
        cpu_freq = psutil.cpu_freq().current
        vmem_level = psutil.virtual_memory().percent
        hdd_level = psutil.disk_usage('/').percent
        boot_time = psutil.boot_time()

        client = boto3.client('firehose', region_name='us-east-1')
        response = client.put_record(
        DeliveryStreamName='watchwolf-dev-terraform-kinesis-firehose',
        Record={
            'Data': base64.b64encode(json.dumps({'timestamp': time.time(), 'cpu_level': cpu_level, 'cpu_freq': cpu_freq, 'vmem_level': vmem_level, 'hdd_level': hdd_level, 'boot_time': boot_time}).encode()) + b'!'
            }
        )
        print(response)
        time.sleep(10)


if __name__ == '__main__':
    main()
