Dolphin doesn't work?
https://github.com/n4zz/Fix-Dolphin-File-Associations
Start here: https://github.com/n4zz/Fix-Dolphin-File-Associations?tab=readme-ov-file#-fix-steps

Credit to this comment: https://www.reddit.com/r/hyprland/comments/1nglwou/comment/ne5o0ty/

For any issues regarding Wi-Fi connection via nm-applet, check this website:
https://wiki.archlinux.org/title/GNOME/Keyring#Automatically_change_keyring_password_with_user_password

Equibop or other apps freeze?
Check if you have a notification daemon running. If not, either install one, or enable it if you have one installed.
https://wiki.hypr.land/Useful-Utilities/Must-have/#a-notification-daemon

See this error?
`hyprctl: error while loading shared libraries: libhyprutils.so.11: cannot open shared object file: No such file or directory`

Check `/usr/bin`, `/usr/local/bin` and the like if hyprland-like binaries are installed. Especially if it's located at `/usr/local/bin`, that means you compiled it from source, which may conflict with the package manager's version (or vice versa).
