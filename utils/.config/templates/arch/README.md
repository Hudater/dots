## taken from: https://bbs.archlinux.org/viewtopic.php?id=56601

## wget packages file on new installation
``` bash
wget https://raw.githubusercontent.com/Hudater/dots/refs/heads/main/utils/.config/templates/arch/package_list.txt
```

## To install arch packages:
``` bash
for x in $(cat package_list.txt); do yay -Syu $x --noconfirm; done
```

OR

``` bash
yay -Syu `cat package_list.txt` --noconfirm
```
