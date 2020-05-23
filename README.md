# Dotfiles for my Arch Linux System

Using Awesome-git for WM, Arch as Distro and many more things like ZSH, Kitty etc

Uses GNU Stow to manage Dotfiles

## Installation

Just run:
```bash
 stow -nvt ~ *
 ```
 to see the changes and 
 ```bash
 stow -vt ~ *
 ```
 to commit the dotfiles

## Removal

Run:
```bash
stow -nvDt ~ *
```

to see what will be unlinked and
```bash
stow -vDt ~ *
```

to commit unlinking of dotfiles

## Dependencies
[Link to DEPENDENCIES.md](DEPENDENCY.md)

## Notes

Remove * in the installation and removal with the name of the directries you want to link or unlink.
For Example:
```bash
stow -vt ~ kitty
```
will link kitty's dotfiles only


## To-Do's

- [ ] Rice i3wm after watching code cast's vids
- [x] Make a dependency.md with commands for Arch Linux (BTW)
