# Welcome to linux-super

Linux-super is a modified ```5.14.xx``` kernel patched for speed. This kernel isn't expected to be super secure, but secure to some degree. Expect missing things and bugs, if there is report them and or push a commit.

- This kernel doesn't have hardening to certain extents.
- This kernel was also pushed out to the public early.
- This kernel is for advanced users only.

We recommend linux ```5.14.21```, this will appear in GRUB under advanced options as ```linux-5.14.21```.

# Known-issues

- Supports only ```5.xx.xx``` kernels
- Will use git soon!

# Requirements

- ```sudo``` / ```doas``` (for elevation)
- ```cmake``` (for building)
- ```dracut``` (for initramfs)
- ```zstd``` (to increase compatibility)
- ```tar``` (to extract)
- ```grub``` (required to be installed)
- ```wget``` (required but will be removed soon)
- ```gcc``` (required)

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
