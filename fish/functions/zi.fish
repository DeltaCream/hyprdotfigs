function zi
    set dir (zoxide query -l | sk)
    if test -n "$dir"
        z "$dir"
    end
end
