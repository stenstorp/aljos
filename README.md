# ALJOS - Automated Linux Journal OS
A series of scripts created to automate the building of an updated version of Linux Journal OS.

## Linux Journal OS
Written by Petros Koutoupis in 2018, LJOS was written as a guide to creating the most basic Linux based operating system as possible (within reason), inspired by Linux From Scratch (LFS). https://www.linuxjournal.com/content/diy-build-custom-minimal-linux-distribution-source

This project aims to make the building of LJOS automatic and trivially extendable and updatable.
Please feel free to fork this project to create your own minimal (or not so minimal) Linux based operating system!

## NOTES
- Support is currently limited to the x86_64 architecture and uses default configurations for busybox and the kernel. This may be changed in the future.
- This project currently only creates a root filesystem that can be chrooted into. Additional, more easily distributable formats may be added in the future.

# Build instructions

1. preparation:  
In order to build components from source, the correct dependencies must be installed. For simplicities sake, you can use the `build-dep` options for apt or dnf.  
Fedora: `sudo dnf build-dep binutils gcc glibc gmp kernel mpc mpfr zlib`  
Ubuntu/Debian: `sudo apt build-dep binutils gcc glibc gmp linux mpc libmpfr-dev zlib`  
This will install a lot of packages, some of which may not be needed but it's better to be safe.  
NOTE: CentOS 7, Debian Jessie, Ubuntu 14.04 and earlier will NOT work as the versions of dependencies are too old.
2. Edit variables
In your text editor of choice, edit the `variables` file and change the threads, CPU and target variables as you require.
3. Build
For a simple build, just run `make` or `make all`. This will do everything for you.  
Available options:  
\- `init`: Sets up initial directories.  
\- `clean`: Remove build directory and OS directory.  
\- `clean-all`: Remove build directory, OS directory and source directory.  
\- `rootfs`: Create an archive containing the root filesystem.  
\- `cross-compiler`: Builds the cross compiler for building the system.  
\- `system`: Builds the OS.
