Contents in this folder are meant for ~/.config/fish/

Meaning that this config.fish here is meant for ~/.config/fish/config.fish, and functions/z.fish is meant for ~/.config/fish/functions/z.fish
For ~/.local/share/fish/vendor_completions.d, it's shown under the vendor_completions.d folder

# zoxide init fish

First we begin with this:

```sh
zoxide init fish | source
```

Normally, this is the very beginning of how zoxide is used on a shell like fish.

But this time, we need to do this:

```sh
zoxide init fish --no-cmd | source
```

The zoxide --no-cmd flag prevents zoxide automatically defining z and zi and letting us define these at ~/.config/fish/functions/.

# \_\_zoxide_z_complete

And then we begin with a builtin function. Doing `type __zoxide_z_complete`, we get this:

```sh
# Defined via `source`
function __zoxide_z_complete
    set -l tokens (builtin commandline --current-process --tokenize)
    set -l curr_tokens (builtin commandline --cut-at-cursor --current-process --tokenize)

    if test (builtin count $tokens) -le 2 -a (builtin count $curr_tokens) -eq 1
        # If there are < 2 arguments, use `cd` completions.
        complete --do-complete "'' "(builtin commandline --cut-at-cursor --current-token) | string match --regex -- '.*/$'
    else if test (builtin count $tokens) -eq (builtin count $curr_tokens)
        # If the last argument is empty, use interactive selection.
        set -l query $tokens[2..-1]
        set -l result (command zoxide query --exclude (__zoxide_pwd) --interactive -- $query)
        and __zoxide_cd $result
        and builtin commandline --function cancel-commandline repaint
    end
end
```

To switch this (which apparently uses fzf) to skim, we need to take a look at this line:

```sh
set -l result (command zoxide query --exclude (__zoxide_pwd) --interactive -- $query)
```

And so we override `(__zoxide_pwd) --interactive -- $query` with `(__zoxide_pwd) -l -- $query | sk` instead:

```sh
set -l result (command zoxide query --exclude (__zoxide_pwd) -l -- $query | sk)
```

Showing the full function with a comment denoting the change:

```sh
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
```

# cd

# z

# zi

# zexec

# zfp

# zgit

# zp

# zr

# Bonus: zedz

Below contains a custom function based on zcode, which, while zcode uses the Code editor to run at the given directory using fzf, this function uses Zed instead, piping the `zoxide query -l` to sk instead of fzf.

```sh
function zedz
    set dir (zoxide query -l | sk)
    if test -n "$dir"
        z "$dir"
        zeditor .
    end
end
```
