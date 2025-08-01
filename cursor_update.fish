#!/usr/bin/env fish
function cursor_update
    set -l repo "lde-axelor/cursor-deb"
    set -l package "cursor-ide"
    
    set -l installed (get_installed_version $repo $package)
    set -l latest (get_latest_version)
    
    if test -n "$latest" -a "$installed" != "$latest"
        echo "Updating cursor to version $latest"
        install_version $latest
    else
        echo "Cursor is already up to date"
    end
end

function get_installed_version
    if dpkg -s cursor-ide >/dev/null 2>&1
        dpkg -s cursor-ide | grep '^Version:' | cut -d' ' -f2
    else
        echo "none"
    end
end

function get_latest_version
    curl -s "https://api.github.com/repos/lde-axelor/cursor-deb/releases/latest" | jq -r '.tag_name' | sed 's/^v//'
end

function install_version
    set -l ver $argv[1]
    set -l url "https://github.com/lde-axelor/cursor-deb/releases/download/v$ver/cursor-ide_"$ver"_amd64.deb"
    set -l deb "/tmp/cursor-ide_"$ver"_amd64.deb"
    
    curl -sL -o $deb $url
    and test -s $deb
    and sudo apt install -y $deb
    and rm $deb
end