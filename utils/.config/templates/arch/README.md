## taken from: https://bbs.archlinux.org/viewtopic.php?id=56601
## To install arch packages:
``` bash
for x in $(cat package_list.txt); do yay -Syu $x --noconfirm; done
```
OR
``` bash
yay -Syu `cat package_list.txt` --noconfirm
```
