bootstrap: dependencies permissions

dependencies:
	sudo bash bootstrap.sh
permissions:
	sudo chmod a+w /sys/class/backlight/intel_backlight/brightness


CONFIG_HOME=${HOME}/.config

${CONFIG_HOME}/dunst:
	mkdir $@
${CONFIG_HOME}/dunst/dunstrc: ${CONFIG_HOME}/dunst
	ln -sf $(CURDIR)/dunst/dunstrc $@
dunstrc: ${CONFIG_HOME}/dunst/dunstrc

restart-dunst:
	pkill dunst

try-dunst:
	notify-send -u critical "Warning!" "A Test notification"
	notify-send -u normal "Title" "A Test notification"
	notify-send -u low "Longer longer Title" "A Test notification"
	notify-send -u normal "No title"
	notify-send --icon=audio-speakers "Bluetooth Speaker" "Battery < 20%"
	dunstify  --hints=int:value:"50%" "SmartTech101" "Progressbar"

try-dunst-tabulated:
	notify-send "Memory Consumption (%):" "$$(ps axch -o cmd:15,%mem --sort=-%mem | head -n 30)"

try-dunst-action:
	dunstify --action="open_image,Open the image." --action="open,Open the directory." --action="delete,Delete it." --action="edit,Gimp it" -i "$filename" "Screenshot" "Saved & Copied."

try-dunst-progress-bar:
	dunstify --hints=int:value:"50%" "SmartTech101" "Progressbar"

find-icons:
	find /usr/share/icons/Papirus/48x48 -type f | fzf

${CONFIG_HOME}/i3blocks:
	mkdir $@
${CONFIG_HOME}/i3blocks/config: ${CONFIG_HOME}/i3blocks
	ln -sf $(CURDIR)/i3blocks/config $@
i3blocks-config: ${CONFIG_HOME}/i3blocks/config

ROFI_HOME=${CONFIG_HOME}/rofi
${ROFI_HOME}:
	mkdir $@
${ROFI_HOME}/config.rasi:
	(cd rofi/rofi && echo 1 | bash setup.sh)

${CONFIG_HOME}/networkmanager-dmenu:
	mkdir $@

${CONFIG_HOME}/networkmanager-dmenu/config.ini:
	ln -sf $(CURDIR)/rofi/networkmanager-dmenu.config.ini $@

${ROFI_HOME}/monitor-switcher.rasi:
	ln -sf $(CURDIR)/rofi/rofi-monitor-selector/rofi-theme/monitor-switcher.rasi $@
${ROFI_HOME}/arc_dark_transparent_colors.rasi:
	ln -sf $(CURDIR)/rofi/rofi-monitor-selector/rofi-theme/arc_dark_transparent_colors.rasi $@
rofi-monitor-selector-config: ${ROFI_HOME}/monitor-switcher.rasi ${ROFI_HOME}/arc_dark_transparent_colors.rasi
${ROFI_HOME}/theme.rasi:
	ln -sf $(CURDIR)/rofi/rofi-monitor-selector/rofi-theme/arc_dark_transparent_colors.rasi $@

rofi-config: ${ROFI_HOME}/config.rasi ${ROFI_HOME}/theme.rasi ${CONFIG_HOME}/networkmanager-dmenu/config.ini rofi-monitor-selector-config


configure: dunstrc rofi-config i3blocks-config
