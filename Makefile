

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
	notify-send "A Test notification"


configure: dunstrc


${CONFIG_HOME}/i3blocks:
	mkdir $@
${CONFIG_HOME}/i3blocks/config: ${CONFIG_HOME}/i3blocks
	ln -sf $(CURDIR)/i3blocks/config $@
i3blocks-config: ${CONFIG_HOME}/i3blocks/config

${CONFIG_HOME}/rofi:
	mkdir $@
${CONFIG_HOME}/rofi/config.rasi:
	(cd rofi/rofi && echo 1 | bash setup.sh)
rofi-config: ${CONFIG_HOME}/rofi/config.rasi

