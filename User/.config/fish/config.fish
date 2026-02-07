if status is-interactive

   # Func
   
   # Tmux 
   function new-attach
       if test (count $argv) -eq 0
           echo "Usage: new-attach <session_name>"
           return 1
       end

       tmux new -A -s $argv[1]
   end

   # setup-ssh-agent <path_to_private_key>
   function setup-ssh-agent
       if test (count $argv) -eq 0
           echo "Usage: setup-ssh-agent <path_to_private_key>"
           return 1
       end

       set key $argv[1]

       # Start ssh-agent and capture its environment variables
       eval (ssh-agent -c)

       # Add the provided key
       ssh-add $key
   end

   # Mount and unmount encrypted HDD (HDDex)

    function hddex-mount
        if test (count $argv) -ne 3
            echo "Usage: hddex-mount <UUID> <mapper_name> <mount_point>"
            return 1
        end

        set uuid $argv[1]
        set mapper $argv[2]
        set mount_point $argv[3]

        sudo cryptsetup open /dev/disk/by-uuid/$uuid $mapper
        sudo mount /dev/mapper/$mapper $mount_point

        echo "Mounted $mapper at $mount_point"
    end

    function hddex-umount
        if test (count $argv) -ne 2
            echo "Usage: hddex-umount <mapper_name> <mount_point>"
            return 1
        end

        set mapper $argv[1]
        set mount_point $argv[2]

        sudo umount $mount_point
        sudo cryptsetup close $mapper

        echo "Unmounted $mapper"
    end

    # Hyprland
    function switch-workspace
        if test (count $argv) -eq 0
            echo "Usage: switch-workspace <number>"
            return 1
        end

        hyprctl dispatch workspace $argv[1]
    end

    function Float-Setup
        hyprctl dispatch workspace special:magic

        # Term1: clock
        kitty --class Term1 sh -c "tty-clock -c -C 6 -B; exec bash" >/dev/null 2>&1 &
        sleep 0.2

        # Term2: cava
        foot --app-id=Term2 sh -c "cava; exec bash" >/dev/null 2>&1 &

        sleep 0.2

        # Term3: fish
        kitty --class Term3 >/dev/null 2>&1 &
        sleep 0.5

        # Resize Term1
        hyprctl dispatch focuswindow 'class:^Term1$'
        hyprctl dispatch resizeactive exact 50% 30%

        sleep 0.5

        # Mouse
        ydotool mousemove --absolute 100 100
    end


    function neofetch
        set ascii_dir ~/Documents/art-hypr/neofetch

        if test (count $argv) -eq 0
            command neofetch --ascii $ascii_dir/neofetch0
            return
        end

        if test $argv[1] = "default"
            command neofetch
            return
        end

        if string match -rq '^[0-9]+$' -- $argv[1]
            if test $argv[1] -ge 1 -a $argv[1] -le 5
                command neofetch --ascii $ascii_dir/neofetch$argv[1]
            else
                command neofetch --ascii $ascii_dir/neofetch0
            end
            return
        end

        command neofetch $argv
    end

    # Type
    function key-type
        if test (count $argv) -eq 0
            echo "Usage: key-type <teks>"
            return 1
        end

        echo "[ydotool] typing teks: $argv"
        ydotool type "$argv"
    end
    
    # Play music playlist with mpv
    function MusicPlaylist
        if test (count $argv) -eq 0
            echo "Usage: MusicPlaylist <path-to-playlist.m3u>"
            return 1
        end
    
        mpv \
            --vf=scale=640:360 \
            --loop-playlist \
            --no-osc \
            --osd-level=0 \
            "$argv[1]"
    end

    # Cli
    function launch_cli_art
        set tty (tty)
        set cols (tput cols)
        set lines (tput lines)

        if test "$tty" = "/dev/tty1" -o "$tty" = "/dev/tty2" -o "$tty" = "/dev/tty3"
            ~/Documents/art-hypr/user.sh
        else if test $cols -ge 160; and test $lines -ge 35
            ~/Documents/art-hypr/start-art.sh
        else
            neofetch
            ~/Documents/art-hypr/user.sh
        end
    end

    launch_cli_art

    function audio-tran
        kitty --class kitty-audio \
              --config $HOME/File/Script/kitty/kitty-transparant.conf \
              -e cava &
    end


    # Alias

    # Better ls
    alias ls='eza --icons --group-directories-first -1'
    alias ls-T='eza --icons --group-directories-first -1 -T'
    alias ls-TM='eza --icons --group-directories-first -1 --sort=newest -T'
    alias ls-M='eza --icons --group-directories-first -1 --sort=newest'

    # Fish Config
    alias Reload='cd; clear; source ~/.config/fish/config.fish'
    alias Reload-Here='clear; source ~/.config/fish/config.fish'
    alias Reload-Here-Keep='source ~/.config/fish/config.fish'
    alias FishConfig='nano ~/.config/fish/config.fish'

    # Wallpaper
    alias mpv-auto='tmux new-session -d -s mpv-auto-session "bash $HOME/File/Script/mpvpaper/auto.sh"; and echo "Session mpv-auto-session started in background"'
    alias mpv-auto-pause='tmux new-session -d -s mpv-pause-session "bash $HOME/File/Script/mpvpaper/auto-pause.sh"; and echo "Session mpv-pause-session started in background"'

    # Script
    alias Random-Script='cd ~/File/Script/random; exa -T'
    alias key-input='~/File/Script/random/key.sh'

    # Subs
    alias Subtitle='~/File/Script/subtitle/subtitle-setting.sh'
    alias Subtitle-Con='~/File/Script/subtitle/convert-subtitle.sh'

    # Bios
    alias RebootToBios='systemctl reboot --firmware-setup'

    # Nix Config
    alias NIXConfig='cd ~/Nix-lupaminum/'
    alias NIXReload='sudo nixos-rebuild switch --flake /etc/nixos#Tutturuu'
    alias NIXHistory='sudo nix-env --list-generations --profile /nix/var/nix/profiles/system'
 
    # Style
    alias clock='tty-clock -c -C 6 -B'

    # Mpvpaper
    alias mpv-next-default='mpv-next 7'

    # Hyprland
    alias Floatpanel='hyprctl dispatch togglespecialworkspace magic'

    # Vol
    alias VolNow='wpctl get-volume @DEFAULT_AUDIO_SINK@'
    alias VolUp='$HOME/File/Script/audio/vol.sh up'
    alias VolDown='$HOME/File/Script/audio/vol.sh down'

    # Hyprlock
    alias unlock='pkill -USR1 hyprlock'

    # App
    alias Tabletdriver='systemctl --user start opentabletdriver.service'

    set -g fish_greeting

    starship init fish | source

end


