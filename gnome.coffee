exec = require('child_process').exec

shell = (command) ->
  exec command, (err, stdout, stderr) ->
    console.log "> #{command}"
    throw err if err?
    console.log stdout
    console.error stderr

# HINTS
# View: gsettings list-keys org.gnome.desktop.wm.keybindings
# Search: gsettings list-recursively | grep "<Super>n"
# Muli:
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up '["<Super>p", "<Super>9"]'

######################
#
# Workspace
#
######################

shell "gsettings set org.gnome.shell.overrides dynamic-workspaces false"
shell "gsettings set org.gnome.desktop.wm.preferences num-workspaces 6"

for i in [1..6]
  shell "gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-#{i} '[\"<Super>#{i}\"]'"

shell "gsettings set org.gnome.shell.keybindings focus-active-notification '[]'" # release s-n
shell "gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down '[\"<Super>n\"]'"
shell "gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up '[\"<Super>p\"]'"


######################
#
# Commands
#
######################

commands = []

commands.push ["gnome-terminal", "<Super>Return"]
commands.push ["emacsclient -c", "<Super>e"]


################
#
# handle commands
#
################

customs = [1..commands.length].map (nth) -> "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom#{nth}/"
shell "gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings '#{JSON.stringify customs}'"
for nth in [0...commands.length]
  console.log nth
  shell "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:#{customs[nth]} binding '#{commands[nth][1]}'"
  shell "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:#{customs[nth]} command '#{commands[nth][0]}'"
  shell "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:#{customs[nth]} name '#{commands[nth][0]}'"
