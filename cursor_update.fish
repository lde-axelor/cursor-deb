function cursor_update
    set -l installed (get_installed_version)
    set -l latest (get_latest_version)
    
    if test -n "$latest" -a "$installed" != "$latest"
        echo "Updating cursor to version $latest"
        install_version $latest
    else
        echo "Cursor is already up to date"
    end
end

function get_installed_version
    set -l package cursor-ide
    if dpkg -s $package >/dev/null 2>&1
        dpkg -s $package | grep '^Version:' | cut -d' ' -f2
    else
        echo "none"
    end
end

function get_latest_version
    curl -s "https://api.github.com/repos/lde-axelor/cursor-deb/releases/latest" | jq -r '.tag_name' | sed 's/^v//'
end

function install_version
    set -l ver $argv[1]
    set -l package cursor-ide_"$ver"_amd64.deb
    echo "https://github.com/lde-axelor/cursor-deb/releases/download/v$ver/$package"
    set -l url "https://github.com/lde-axelor/cursor-deb/releases/download/v$ver/$package"
    set -l deb "/tmp/$package"
    
    curl -sL -o $deb $url
    and test -s $deb
    and sudo apt install -y $deb
    and rm $deb
end
