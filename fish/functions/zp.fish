function zp
    set dir (zoxide query -l | grep -i project | sk)
    if test -n "$dir"
        z "$dir"
    end
end