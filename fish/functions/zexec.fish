function zexec
    set dir (zoxide query -l | sk)
    if test -n "$dir"
        z "$dir"
        read --prompt "Enter command: " cmd
        eval $cmd
    end
end
