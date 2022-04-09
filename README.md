# Welcome to linux-super

Linux-super is a kernel patched for speed. This kernel isn't expected to be super secure, but secure to some degree. Expect missing things and bugs, if there is report them and or push a commit.

# Known-issues

- Pressing anything besides prompted input will cause unknown issues
- Only supports 5.xx.xx kernels

# Credits

TkG Linux kernel! Please check them out!
- https://github.com/Frogging-Family/linux-tkg

# Requirements

- ```sudo``` / ```doas``` (for elevation)
- ```cmake``` (for building)
- ```dracut``` (for initramfs)
- ```zstd``` (to increase compatibility)
- ```tar``` (to extract)
- ```grub``` (required to be installed)
- ```gcc``` (required)

# Setting it all up (default kernel)

Include personal patches for the default kernel version ```(5.14.21)``` as follows:

Change directory if you have not already
```
cd linux-super
```

Make the default ```(5.14.21)``` patch directory:
```
mkdir linux-super-usr-patches-def
```
Include patches in that folder for the ```(5.14.21)``` kernel

# Setting it all up (alternative kernel)

Include personal patches for the alternative kernel as follows:

Change directory if you have not already
```
cd linux-super
```

Make the default kernel patch directory:
```
mkdir linux-super-usr-patches
```
Include patches in that folder for the kernel.

# Installation

The procedure is simple at first:

```
chmod +x run.sh
```
```
./run.sh
```
