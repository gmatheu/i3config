

bootstrap:
	sudo bash bootstrap.sh
	sudo chmod a+w /sys/class/backlight/intel_backlight/brightness

dunst:
	mkdir ~/.config/dunst

dunstrc: dunst
	ln -sf $(CURDIR)/dunst/dunstrc ~/.config/dunst/dunstrc

restart-dunst:
	pkill dunst

try-dunst:
	notify-send "A Test notification"



${HOME}/.config/i3blocks: i3blocks/i3blocks-contrib
	ln -sf $(CURDIR)/i3blocks/i3blocks-contrib ~/.config/i3blocks
i3blocks/i3blocks-contrib:
	git clone https://github.com/vivien/i3blocks-contrib i3blocks/i3blocks-contrib
${HOME}/.config/i3blocks/config:
	cp i3blocks/config ${HOME}/.config/i3blocks/config

