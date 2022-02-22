#!/usr/bin/env python3

import sys
import json
import os
import shutil

# path in wsl
settings_path=sys.argv[1]
# path in windows
settings_winpath=sys.argv[2]
settings_fn=settings_path + '/settings.json'

with open(settings_fn, 'rb') as fp:
    j = fp.read().decode('utf8')
    settings = json.loads(j)

dirty = False

if 'Snazzy' not in [x['name'] for x in settings['schemes']]:
    dirty = True
    settings['schemes'].append({
            "background": "#282A36",
            "black": "#282A36",
            "blue": "#57C7FF",
            "brightBlack": "#686868",
            "brightBlue": "#57C7FF",
            "brightCyan": "#9AEDFE",
            "brightGreen": "#5AF78E",
            "brightPurple": "#FF6AC1",
            "brightRed": "#FF5C57",
            "brightWhite": "#EFF0EB",
            "brightYellow": "#F3F99D",
            "cursorColor": "#97979B",
            "cyan": "#9AEDFE",
            "foreground": "#EFF0EB",
            "green": "#5AF78E",
            "name": "Snazzy",
            "purple": "#FF6AC1",
            "red": "#FF5C57",
            "selectionBackground": "#3E404A",
            "white": "#F1F1F0",
            "yellow": "#F3F99D"
        })

for profile in settings['profiles']['list']:
    if 'ubuntu' in profile['name'].lower():
        dirty = True
        shutil.copy("windows_terminal/ubuntu.png", settings_path)
        profile["backgroundImage"] = settings_winpath + "\\ubuntu.png"
        profile["backgroundImageAlignment"] = "bottomRight"
        profile["backgroundImageOpacity"] = 0.25
        profile["backgroundImageStretchMode"] = "none"
        profile["bellStyle"] = "window"
        profile["colorScheme"] = "Snazzy"
        profile["font"] = {
            "face": "JetBrainsMono Nerd Font"
        }
        profile['acrylicOpacity'] = 0.91

if dirty:
    try:
        tmp_fn = settings_fn + '.tmp'
        json.dump(settings, open(tmp_fn, 'w'), indent=4)
    except Exception as ex:
        print(ex)
    else:
        print('updated ', settings_fn)
        os.rename(tmp_fn, settings_fn)