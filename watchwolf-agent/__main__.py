#!/usr/bin/env python3

from rich import print as pprint
from utils.helpers import get_commit_hash


def intro():
    """Display the intro message."""
    pprint(f'[red]INFO[/red]\tWatchWolf revision number: [b]'
           f'{get_commit_hash()}[/b].')


def main():
    """The main driver of the program."""
    intro()


if __name__ == '__main__':
    main()
