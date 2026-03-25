source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
zoxide init fish --no-cmd | source
# The zoxide --no-cmd flag prevents zoxide automatically defining z and zi and letting us define it at ~/.config/fish/functions/

# Override the built-in __zoxide_z_complete function, which uses fzf, with skim
function __zoxide_z_complete
    set -l tokens (builtin commandline --current-process --tokenize)
    set -l curr_tokens (builtin commandline --cut-at-cursor --current-process --tokenize)

    if test (builtin count $tokens) -le 2 -a (builtin count $curr_tokens) -eq 1
        # If there are < 2 arguments, use `cd` completions.
        complete --do-complete "'' "(builtin commandline --cut-at-cursor --current-token) | string match --regex -- '.*/$'
    else if test (builtin count $tokens) -eq (builtin count $curr_tokens)
        # If the last argument is empty, use interactive selection.
        set -l query $tokens[2..-1]
        set -l result (command zoxide query --exclude (__zoxide_pwd) -l -- $query | sk) # Override "(__zoxide_pwd) --interactive -- $query" with "(__zoxide_pwd) -l -- $query | sk" instead.
        and __zoxide_cd $result
        and builtin commandline --function cancel-commandline repaint
    end
end

fish_add_path /home/cream/.spicetify

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# For sudoedit
set -x SUDO_EDITOR nvim
