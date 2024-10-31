# GDM

GNOME CLASSIC VS UBUNTU vs WAYLAND VS XORG
ls /usr/share/xsessions/

<https://help.ubuntu.com/stable/ubuntu-help/gnome-classic.html.en>
<https://www.reddit.com/r/Ubuntu/comments/hby264/can_anyone_help_me_with_what_does_gnome_classic/>

- Gnome classic (wayland?)
Exec=gnome-session-classic
TryExec=gnome-session

- Gnome classic on Xorg
Exec=env GNOME_SHELL_SESSION_MODE=classic gnome-session
TryExec=gnome-session
GNOME 46 has been released in coordination with the latest GTK version, 4.14

- Ubuntu (wayland?)
Exec=env GNOME_SHELL_SESSION_MODE=ubuntu /usr/bin/gnome-session --session=ubuntu
TryExec=/usr/bin/gnome-shell

- Ubuntu on Xorg
Exec=env GNOME_SHELL_SESSION_MODE=ubuntu /usr/bin/gnome-session --session=ubuntu
TryExec=/usr/bin/gnome-shell

Classic emulates gnome 2
The Xorg sessions are legacy and shouldn’t be used unless you have a specific need.
