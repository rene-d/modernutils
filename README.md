# modernutils

_Because it's 2022, not the 90s._

Collection of modern, powerful and efficient command-line utilities, mostly written in Rust.

Some of them are already available in recent Linux distributions.

For help, use option `--help` or `-h` or go to their web page.

## Utilities

### [ripgrep](https://github.com/BurntSushi/ripgrep)

ripgrep recursively searches directories for a regex pattern while respecting your gitignore.

Replaces/improves: [grep](https://manpages.debian.org/testing/grep/grep.1.en.html)

Example: `rg -l c 'int main' /sources/`

### [watchexec](https://github.com/watchexec/watchexec)

Executes commands in response to file modifications

Example: `watchexec -w /workspace -e c -- make -j`

### [btm](https://github.com/ClementTsang/bottom)

Yet another cross-platform graphical process/system monitor.

Replaces/improves: [top](https://manpages.debian.org/testing/procps/top.1.en.html) [htop](https://manpages.debian.org/testing/htop/htop.1.en.html)

Example: `btm -T --default_widget_type cpu`

### [dua](https://github.com/Byron/dua-cli)

View disk space usage and delete unwanted data, fast.

Remplaces/improves: [du](https://manpages.debian.org/testing/coreutils/du.1.en.html) [ncdu](https://manpages.debian.org/testing/ncdu/ncdu.1.en.html)

Example: `dua i`

### [bat](https://github.com/sharkdp/bat)

A cat(1) clone with wings.

Replaces/improves: [cat](https://manpages.debian.org/testing/coreutils/cat.1.en.html)

### [lsd](https://github.com/Peltoche/lsd)

The next gen ls command.

Replaces/improves: [ls](https://manpages.debian.org/testing/coreutils/ls.1.en.html)

### [gitui](https://github.com/extrawurst/gitui)

Blazing 💥 fast terminal-ui for git written in rust 🦀.

Replaces/improves: [gitk](https://manpages.debian.org/testing/gitk/gitk.1.en.html)

### [hexyl](https://github.com/sharkdp/hexyl)

A command-line hex viewer.

Replaces/improves: [hexdump](https://manpages.debian.org/bullseye/bsdextrautils/hexdump.1.en.html)

### [xsv](https://github.com/BurntSushi/xsv)

A fast CSV command line toolkit written in Rust.

### [fd](https://github.com/sharkdp/fd)

A simple, fast and user-friendly alternative to 'find'.

Replaces/improves: [find](https://manpages.debian.org/testing/findutils/find.1.en.html)

### [broot](https://github.com/Canop/broot)

A new way to see and navigate directory trees : <https://dystroy.org/broot>

### [dive](https://github.com/wagoodman/dive)

A tool for exploring each layer in a docker image.

### [fzf](https://github.com/junegunn/fzf)

🌸 A command-line fuzzy finder.

### [lazygit](https://github.com/jesseduffield/lazygit)

Simple terminal UI for git commands.

## Links

[awesome cli app](https://github.com/agarrharr/awesome-cli-apps)
[awesome shell](https://github.com/alebcay/awesome-shell)
