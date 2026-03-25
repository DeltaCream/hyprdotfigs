function zfp
    set dir (zoxide query -l | sk --preview 'tree -L 2 {}')
    if test -n "$dir"
        z "$dir"
        ls -la
    end
end