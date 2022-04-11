# Welcome to linux-super

Linux-super is a kernel patched for speed. This kernel isn't expected to be super secure, but secure to some degree. Expect missing things and bugs, if there is report them and or push a commit.

# Known-issues

- Only supports ```5.xx.xx``` kernels
- Will use git soon!
- Does not support ```5.18+``` kernels at the moment

# Credits

TkG Linux kernel! Please check them out!
- https://github.com/Frogging-Family/linux-tkg

Xanmod!
- https://github.com/graysky2/kernel_compiler_patch

Graysky for his uarch patch!
- https://github.com/xanmod/linux-patches

# Requirements

- ```sudo``` / ```doas``` (for elevation)
- ```cmake``` (for building)
- ```dracut``` (for initramfs)
- ```zstd``` (to increase compatibility)
- ```tar``` (to extract)
- ```grub``` (required to be installed)
- ```wget``` (required but will be removed soon)
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
./run.sh
```
