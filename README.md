# Dotfiles for my Arch Linux System

Using Awesome-git and i3-gaps for WM, Arch as Distro and many more things like ZSH, Kitty etc

## Notes

 Awesome rice is not mine. It's work of u/ilovecookieee. A lot of stuff in these dotfiles are work of someone else which are modified for my usecase and preference. Fork it and play around.
Link to ilovecookieee's awesome rice dotfiles: https://github.com/manilarome/the-glorious-dotfiles

 I am not updating powerlevel10k theme, some zsh plugins etc because I need to use git modules to make sure those things get pushed to github. It's not recommended to do things like this so please look into it if you wish to use my dotfiles.

Using GNU Stow to manage Dotfiles

## Installation

Clone:
```bash
git clone git@github.com:Hudater/dots.git
```

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
[Link to DEPENDENCIES.md](DEPENDENCIES.md)

## Notes

Remove * in the installation and removal with the name of the directries you want to link or unlink.
For Example:
```bash
stow -vt ~ kitty
```
will link kitty's dotfiles only


## To-Do's

- [x] Rice i3wm after watching code cast's vids
- [x] Make a dependency.md with commands for Arch Linux (BTW)
