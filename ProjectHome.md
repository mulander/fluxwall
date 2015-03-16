A simple perl script that allows to quickly change wallpapers from the fluxbox context menu. It is bundled with simple install/uninstall scripts written in bash.

After initial setup and installation, the script will add two entries to the fluxbox menu. **Wallpapers** and **Refresh Fluxwall**. The first one is a reflection of a directory containing wallpapers that the user pointed the script at. The second one, tells fluxwall to rescan the folder and rebuild the menu. You can click on the items in the **Wallpapers** menu, to change your fluxbox wallpaper.

The script uses fbsetbg to actually change the wallpaper, but this behavior can be changed.