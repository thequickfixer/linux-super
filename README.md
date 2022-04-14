# Welcome to linux-super

Linux-super is a modified ```5.14.xx``` kernel patched for speed. This kernel isn't expected to be super secure, but secure to some degree.

- This kernel doesn't have hardening to certain extents.
- Frequently updated, so if there is bugs please feel free to let us know!

We recommend linux ```5.14.21``` as there are more options for the kernel. The kernel will appear in GRUB under advanced options labeled as ```linux-5.14.21```.

# Requirements

- ```sudo``` / ```doas``` (for elevation)
- ```make``` (for building)
- ```dracut``` (for initramfs)
- ```patch``` (to patch the kernel)
- ```zstd``` (to increase compatibility)
- ```tar``` (to extract)
- ```grub``` (required to be installed)
- ```wget``` (required but will be removed soon)
- ```gcc``` (required)

# Known-issues

- Supports only ```5.xx.xx``` kernels
- Will use git soon!
- Doesn't support multi-spaced folders

# Installation

Setting up grub beforehand:

```
sudo nano /etc/default/grub
```
Ctrl+w to find this:

```GRUB_CMDLINE_LINUX_DEFAULT```

Un-comment (#) it out and replace it with this:

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet audit=0 loglevel=0 no_debug_objects"
```

git clone the linux-super repo:

```
git clone https://github.com/thequickfixer/linux-super.git
```
Change the directory:

```
cd linux-super/
```

Then do:

```
./run.sh
```

# Credits

TkG Linux kernel!
- https://github.com/Frogging-Family/linux-tkg

Xanmod!
- https://github.com/xanmod/linux-patches

Graysky for his uarch patch!
- https://github.com/graysky2/kernel_compiler_patch

# Setting the patches (default kernel) (optional)

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

# Setting the patches (alternative kernel) (optional)

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
