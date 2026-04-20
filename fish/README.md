Contents in this folder are meant for ~/.config/fish/

Meaning that this config.fish here is meant for ~/.config/fish/config.fish, and functions/z.fish is meant for ~/.config/fish/functions/z.fish
For ~/.local/share/fish/vendor_completions.d, it's shown under the vendor_completions.d folder

However, on CachyOS, the default completions are located at /usr/share/fish/completions, with vendor completions located at /usr/share/fish/vendor_completions.d

The main explanation for the following section, which involves defining custom functions, goes like this:

The functions are defined from [this tutorial](https://zoxide.org/tutorials/fzf-integration/), which then is converted from a bash/zsh script to a fish script, if the tutorial doesn't already have it, then explains how the function is converted to use sk instead of fzf.

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

Based on [this zoxide blog post](https://zoxide.org/blog/zoxide-linux-en/), you can alias cd to use zoxide like this:

```zsh
eval "$(zoxide init zsh --cmd cd)"
```

# z

# zi

For zi, which uses a fuzzy finder to select a result, the original implementation of zi according to [this tutorial](https://zoxide.org/tutorials/fzf-integration/) goes like this:

```fish
function zi
 set dir (zoxide query -l | fzf)
 if test -n "$dir"
 z "$dir"
 end
end
```

The way to simply make it use skim instead of fzf is just to replace fzf with skim (whose command is just `sk`):

```fish
function zi
    set dir (zoxide query -l | sk)
    if test -n "$dir"
        z "$dir"
    end
end
```

This pattern is pretty much prevalent for the other commands, which will show its original, fzf-based implementation, converting it to a fish script (if it does not have a fish implementation already) and then modifying it to use skim.

# zexec

zexec is used to search a directory, then running a command.

Original (fzf), in bash:

```bash
zexec() {
 local dir cmd
 dir=$(zoxide query -l | fzf)
 if [ -n "$dir" ]; then
 z "$dir"
 read -p "Enter command: " cmd
 eval "$cmd"
 fi
}
```

Original (fzf), converted to fish:

```fish
function zexec
    set dir (zoxide query -l | fzf)
    if test -n "$dir"
        z "$dir"
        read --prompt "Enter command: " cmd
        eval $cmd
    end
end
```

skim:

```fish
function zexec
    set dir (zoxide query -l | sk)
    if test -n "$dir"
        z "$dir"
        read --prompt "Enter command: " cmd
        eval $cmd
    end
end
```

# zfp

zfp is used to jump to a given directory, showing a preview of its directory content structure using tree.

Original (fzf), in bash:

```bash
zfp() {
 local dir
 dir=$(zoxide query -l | fzf --preview 'tree -L 2 {}')
 [ -n "$dir" ] && z "$dir" && ls -la
}
```

Original (fzf), converted to fish:

```fish
function zfp
    set dir (zoxide query -l | fzf --preview 'tree -L 2 {}')
    if test -n "$dir"
        z "$dir"
        ls -la
    end
end
```

skim:

```fish
function zfp
    set dir (zoxide query -l | sk --preview 'tree -L 2 {}')
    if test -n "$dir"
        z "$dir"
        ls -la
    end
end
```

# zgit

zgit is an example of a command that uses zoxide to filter directories by type in this case being git repos, and then jumping to one of them.

Original (fzf), in bash:

```bash
zgit() {
 local dir
 dir=$(zoxide query -l | xargs -I {} sh -c 'test -d {}/.git && echo {}' | fzf)
 [ -n "$dir" ] && z "$dir"
}
```

Original (fzf), converted to fish:

```fish
function zgit
    set dir (zoxide query -l | xargs -I {} sh -c 'test -d {}/.git && echo {}' | fzf)
    if test -n "$dir"
        z "$dir"
    end
end
```

skim:

```fish
function zgit
    set dir (zoxide query -l | xargs -I {} sh -c 'test -d {}/.git && echo {}' | sk)
    if test -n "$dir"
        z "$dir"
    end
end
```

# zp

zp is used for quick project switching.

Original (fzf), in bash:

```bash
zp() {
 local dir
 dir=$(zoxide query -l | grep -i project | fzf)
 [ -n "$dir" ] && z "$dir"
}
```

Original (fzf), converted to fish:

```fish
function zp
    set dir (zoxide query -l | grep -i project | sk)
    if test -n "$dir"
        z "$dir"
    end
end
```

skim:

```fish
function zp
    set dir (zoxide query -l | grep -i project | sk)
    if test -n "$dir"
        z "$dir"
    end
end
```

# zr

zr simply interactively lists recent directories visited for you to jump on.
Original (fzf), in bash:

```bash
zr() {
 local dir
 dir=$(zoxide query -l | sort -k2 -rn | fzf)
 [ -n "$dir" ] && z "$dir"
}
```

Original (fzf), converted to fish:

```fish
function zr
    set dir (zoxide query -l | sort -k2 -rn | fzf)
    if test -n "$dir"
        z "$dir"
    end
end
```

skim:

```fish
function zr
    set dir (zoxide query -l | sort -k2 -rn | sk)
    if test -n "$dir"
        z "$dir"
    end
end
```

# Bonus: zedz

Below contains a custom function based on [zcode](https://zoxide.org/tutorials/fzf-integration/), which, while zcode uses the Code editor to run at the given directory using fzf, this function uses Zed instead, piping the `zoxide query -l` to sk instead of fzf.

Original (fzf), for zcode in bash:

```bash
zcode() {
 local dir
 dir=$(zoxide query -l | fzf)
 [ -n "$dir" ] && z "$dir" && code .
}
```

Original (fzf), for zcode converted to fish:

```fish
function zcode
    set dir (zoxide query -l | fzf)
    if test -n "$dir"
        z "$dir"
        code .
    end
end
```

Using this logic for zcode, we can do this for the zed editor, like this:

skim (fish):

```sh
function zedz
    set dir (zoxide query -l | sk)
    if test -n "$dir"
        z "$dir"
        zeditor .
    end
end
```
