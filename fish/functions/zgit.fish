function zgit
    set dir (zoxide query -l | xargs -I {} sh -c 'test -d {}/.git && echo {}' | sk)
    if test -n "$dir"
        z "$dir"
    end
end
