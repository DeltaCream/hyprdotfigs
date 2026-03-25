function zedz
    set dir (zoxide query -l | sk)
    if test -n "$dir"
        z "$dir"
        zeditor .
    end
end