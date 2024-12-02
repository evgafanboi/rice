#!/usr/bin/env python3
import subprocess

def get_media_info():
    try:
        stat = subprocess.check_output(["playerctl", "status"]).decode("utf-8").strip()
        if (stat=="Paused"):
            return "Paused"
        elif (stat=="No player could handle this command"):
            return "No music"
        else:
            output = subprocess.check_output(["playerctl", "metadata", "--format", "{{title}}", "2>", "/dev/null"]).decode("utf-8").strip()
            return output if output else "No media playing"
    except subprocess.CalledProcessError:
        return "No music"

if __name__ == "__main__":
    print(get_media_info())
