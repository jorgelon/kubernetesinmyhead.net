# Gnome tips for ultrawide oled monitor

> This is based in Ubuntu 24.04

## Prevent burn in issues

### Pure black theme

Here we must search for gnome-shell and gtk/3/4 themes.

We can find some themes here. Some of them provide both gnome-shell and gtk themes

<https://www.pling.com/browse?cat=366&ord=latest>

Ir order to install them we need to install the gnome-tweaks package and the User Themes extension

gnome-extensions-app

<https://www.reddit.com/r/gnome/comments/15c16hx/anyone_have_a_matte_black_theme/>

#### Gnome shell themes

The gnome shell themes change the appearance of the GNOME Shell interface, including the top bar, system menus, notifications, and the overview screen.

The system themes are installed in /usr/share/themes/NAME-OF-THEME/gnome-shell and they can be installed by the user in the ./themes/NAME-OF-THEME/gnome-shell directory

#### Gtk/3/4 themes

They change the appearance of GTK applications, including window decorations, buttons, sliders, and other UI elements.

The system themes are installed in

- /usr/share/themes/NAME-OF-THEME/gtk-3.0
- /usr/share/themes/NAME-OF-THEME/gtk-4.0

And they can be installed by de user

- GTK3: ~/.themes/NAME-OF-THEME/gtk-3.0
- GTK4: ~/.themes/NAME-OF-THEME/gtk-4.0

### Full black desktop background

```shell
gsettings set org.gnome.desktop.background picture-options 'none'
gsettings set org.gnome.desktop.background primary-color '#000000'
```

> Other option is to use some pure black wallpapers combined with the "Wallpaper slideshow" gnome-shell extension

### Auto hide the dock

We can enable autohide in the dock via settings - Ubuntu Desktop - Dock and enable "Auto-hide the Dock"

### Dont show desktop icons

Go to settings > Ubuntu Desktop and disable Desktop icons

### Auto hide the top bar

We can hide the top back installing the "Hide Top Bar" gnome-shell extension

### Other applications

- Chrome and firefox

<https://darkreader.org/>

- VSCODE

Choose the dark high contrast theme

## Organize windows

We can use Ubuntu tiling asistant installing the gnome-shell-extension-ubuntu-tiling-assistant package

<https://extensions.gnome.org/extension/3733/tiling-assistant/>
<https://github.com/Leleat/Tiling-Assistant>

There are other similar tools like Linux Powertoys <https://github.com/domferr/Linux-PowerToys>
