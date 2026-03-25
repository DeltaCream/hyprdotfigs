function zr
    set dir (zoxide query -l | sort -k2 -rn | sk)
    if test -n "$dir"
        z "$dir"
    end
end
