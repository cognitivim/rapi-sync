(c) 2004-2010 Willem Jan Hengeveld <itsme@xs4all.nl>

A collection of tools to do many things to a windows CE device via Activesync/RAPI.

These tools should work on most CE devices, tested on wince 3.0, 4.2, 5.0, 5.1
PocketPC 2002 and PocketPC 2003, windows mobile 2003, smartphone 2003, wm5, wm6, wm6.5


-----------------------------------------------------------------------------
INTRO:

.... rapi tools
pps        - dumps active wince processes
pdblist    - dumps wince databases
pdel       - delete wince file
pdir       - list wince directory
pmkdir     - create wince directory
pget       - copy file from wince
pkill      - kill wince process
pmemdump   - copy memory block from wince
psetmem    - set RAM memory location in your device
pmemmap    - list available memory blocks on wince
pput       - copy file to wince
pregutl    - manipulate the wince registry
prun       - run program in wince
pdebug     - capture debugoutput of processes
pdocread   - raw read of wince flash memory
pdocwrite  - raw write of wince flash memory
psdread    - raw read from sd card in your device
psdwrite   - raw write to the sd card in your device
psynctime  - sync time with pc.
ppostmsg   - tool to send/post message to wince windows
prapi      - interface to the wince provisioning api
preboot    - reboot your device
pmv        - rename files on your device
pchmod     - change dir/file attributes on your device
pdial      - dial a number using RIL
psendsms   - send an SMS using RIL
phandle    - list all open files / handles on your device

.... win32 tools
regutl     - manipulate the win32 registry
dump       - hexdump local file.
memdump    - hexdump local process or physical windows memory
setmem     - wrote to local process or physical windows memory
postmsg    - send message to local window
wprops     - dump detailed info on all windows
sdread     - lowlevel read windows disks
sdwrite    - lowlevel write windows disks

.... windows ce tools
regbk      - tool to dump registry to a file
qualbufmon - tool to monitor the msm7xxx baseband IPC
sambufmon  - tool to monitor the samsung baseband IPC
gsmbufmon  - tool to monitor the omap730/omap850 baseband IPC
dbglog     - tool to monitor the kernellog

.... support dlls
msvcr71.dll    - microsoft support dll
libeay32.dll   - from openssl, used by dump.exe
itsutils.dll   - rapi interface dll
itsutilsd.dll  - rapi interface dll with debug logging

NOTE: The experimental tools may not work, or may even cause damage.
    - Use at your own risk, and after reading the source, and making
      sure you understand what they do!!!

To build it both the embedded vc++ and 'desktop' vc++ compiler are needed.

Some environment variables pointing to various sdks need to be set to the
correct values in mk.bat and mkarm.bat to build it correctly.

'itsutils.dll' is automatically copied to the windows directory of your 
CE device when it is detected to be out of date.

A compiled version is available at http://www.xs4all.nl/~itsme/download/itsutils.zip

you can browse the source at http://viewcvs.xda-developers.com/cgi-bin/viewcvs.cgi/xdautils/

to compile, point the variables at the start of the mk.bat and mkarm.bat
scripts to the right sdks. and run them.

you need the following compilers/sdk's:
   - Microsoft Visual C++  ( version not important )
   - Microsoft Embedded Visual C++ v3.0
   - Platformbuilder v3.0


CODE SIGNING / APPLICATION LOCK

note that itsutils.dll needs to be codesigned.
The rapi tools will try to automatically unlock your device,
this is not successful in all cases however.
It may also be nescesary to change the rapi policy
by using a registry editor like regeditstg.exe


-----------------------------------------------------------------------------
USAGE:


       dump.exe

This tool is not specifically meant for use with a windows CE device.
I use it to make hexdumps of memory dumps.

If you have for example a romimage saved to a file, and the first byte in
the file maps to address 0x80000000 in the CE device, and you want to list
the dwords starting at 0x80040000. You would type something like this:

    dump -b 0x80000000 -f romimage.bin -o 0x80040000 -4 -l 0x100

using the -md5, -sha1, -sha256, -crc or -sum options, you can use dump.exe to
calculate the checksum, crc or hash of a specific region of a file.  you can
also use dump.exe to extract a specific region of a file, and save it to
another file by specifying a second filename on the commandline.

you can also use dump also to lowlevel read from disk devices, 

  dump \\.\PhysicalDrive0 -xx -o 0  -l 0xa00000000 -s 0x100000000

will dump 64 ascii chars every 4G of your 40G disk.



       itsutils.dll

This is the workhorse for some of these tools ( pdebug, pkill, pmemdump, pps ).
It it implements a interface callable by 'CeRapiInvoke' to do various useful
things for the world.
it is automatically copied to your device.


       pdblist.exe

This tool provides various ways of looking at the databases stored on your CE device.
To get a list of all databases type 'pdblist -d', it lists the objectid, the database flags,
the type of database, the nr of records, the size, the name, and the available indexes.
Or if you know the name or id of the database you can list all records in this database
by typing, 'pdblist -d pmailMsgClasses'  ( ignore the error message, it does not mean anything )
or 'pdblist -d 0x1001568'. For each record it lists the record id, size, nr of fields, and the fields.
For each field, it lists the field id, type, length, flags and value.
To just list the contents of 1 record, you can type 'pdblist -r 0x0100156f' ( where 0100156f is the object id
of the record )
you can also use this to list information about files. 'pdblist -r 0' will get you info on the root directory.

NOTE: this tool no longer works properly with windows mobile 2005. microsoft changed the database API on the device. but did not update the activesync api to access databases.


       pdebug.exe

This tool attaches as a debugger to the specified process, and prints all debug output to the console.


       pdel.exe

This tool works as 'del' under DOS. you can specify multiple files, and optionally a current directory with '-d'
where these file should be deleted from.
for example 'pdel -d \temp tst1.txt tst2.txt'  will delete \temp\tst1.txt and \temp\tst2.txt.

you can also specify wildcards, or delete directories recursively.
Sometimes the CE device gets in a state where it will not allow files to be deleted anymore, a reboot
will usually fix this.


       pdir.exe

Lists directories from your CE device. Specify '-r' to list them recursively.
You can specify any number of paths with wildcards to list.
Example: 'pdir \Temp \Windows'  will list both the \temp and \windows directories.
directories will be listed [bracketed].

you can specify device language independent paths using variables like %CSIDL_STARTUP%. to get a complete list of supported variables, type: pdir -l

       
       pmkdir.exe

Tool to create directories on your WinCE device.
pmkdir also supports %CSIDL style variables.


       pget.exe

Tool to copy files from your CE device to your local machine.
you may use wildcards or multiple filenames to specify the source files.
you may specify a directory for the target, if no target is specified
it will default to the current directory.
Example: 'pget \Windows\toolhelp.dll'  will copy toolhelp.dll to the current directory.

This tool currently does not allow you to copy certain ROM files. see 'dumprom' for that.

pget also supports %CSIDL style variables.
you can recursively copy all copyable files using pget -r


       pkill.exe

Allows you to kill one or more processes on your CE device.
If multiple processes exist with the same name, all will be killed.
if result '2' is reported, this means kill successful, result '1' means process found,
but unable to kill, '0' means process not found.


       pmemdump.exe

Copies memory blocks to a local file, or just prints a hexdump on the console.
you can specify the process context from which to read the memory.
You can see the difference in context by dumping address 0x11000.
for instance look at the difference between:
   pmemdump -n filesys.exe 0x11000
and
   pmemdump -n shell32.exe 0x11000

if no context is specified, memory is read from the perspective of the 'rapisrv.exe' process.
You can use '-m' to read memory directly, bypassing ReadProcessMemory, this will crash when an
invalid memory location is read.

you can specify physical memory offsets using the -p option
to get a rough overview of what you is in memory you can use the step -s option:
pmemdump 0x80000000 0x02000000 -s 0x10000
will list 16 bytes every 64k.
pmemdump options are almost the same as dump.exe options
memdump.exe is the same tool, but then to access your local desktop pc memory.


       psetmem.exe

this is the opposite of pmemdump, you can specify an offset and a list of
bytes, words, or dwords to write to this location.
this app does not write to flash memory, only to RAM.
setmem.exe is the same tool, but then to access your local desktop pc memory.


       pmemmap.exe

tool to inspect the pagetables or section tables. you can also use it to create a 'hardcopy' of a specific section.


       pps.exe

Display a list of processes currently running on your device.
It also lists memory usage, processor usage, and commandline for each process.
With '-m' you can specify how long it has to measure to get an accurate cpu usage reading.
you can also see detailed thread information with '-t'
'-m' will list all modules currently loaded in the device.


       pput.exe

Like pget, but the other way around. Copies files from your local machine to your CE device.
this is actually the same tool, just called with a different name.
using '-c', pput copies data from its stdin to the device file, this is useful for instance to create .lnk files like this:
printf "#yourprogram.exe"|pput -c \windows\startup\yourpgm.lnk


       pregutl.exe


Allows you to inspect the registry of your CE device
you can specify the hive to display ( hkcu, hkcr, hklm )
you can also import .reg files using this tool, delete keys,
or modify values.


       regutl.exe

The same functionality as pregutl.exe, but then for the desktop registry


       prun.exe

allows you to start programs on your CE device from your desktop machine.
for instance:
    prun cprog.exe -url tel:121

will start the phone application, and prompt you if you want to dial '121'.


       psdread.exe
       psdwrite.exe

These can be used to do raw disk read/writes from the disk device in your
CE device, or USB/pccard flashdisk reader. ( like an MMC/SD card )
it defaults to using disk 1. ( on the XDA-II / Himalaya the sd card is DSK3: )
you have to specify a linear offset from the start of the device.

You can view all available disks with 'psdread -l'
You can find the exact disk size of any device by specifying the '-t' option.
This is because the size of Flashdisks is reported incorrectly by WindowsXP.

local (to windows) disks should be specified by drive-letter.
WARNING: the drive letter assignments are quite dynamic, a disk may return on a different
letter after removing/ re-adding it. psdwrite does attempt to verify that you are not
overwriting your harddisk, but still be sure to specify the correct drive.

psdwrite/psdread can now also write/read partial sectors.


       pdocread.exe

This tool can be used to read and list various parts of various types of flash devices.
DiskOnChip, Qualcomm flashdrv ( -F ), samsung ondisk ( -N ).
The -d, -p, and -h options can be used to select a specific disk device.
Only specifying -d  will open that device directly. Specifying -d and -p, will open
the device using the storage manager, and then us the partition specified with -p.
To circumvent a problem with truncated device names in some WinCE versions, you can
also specify a known open device handle, using -h.

Use "pdocread -l" to get a list of known devices, and open handles on your wince device.

The -n, -w, and -o options are used to select what access method is to be used.
-n 0  will read from the binary partition number 0.  -w will use the standard disk api
to access the device, -o will access the One-time-programmable area of your DOC.
when no access method is specified, the 'normal' TFFS partition will be accessed.

Be warned that the tffs API is not very stable, it causes device crashes, and on
several devices it is only partially implemented.

binary partition sectorsizes

the sector size can be different for each sector in binary partitions, to find out how the layout of these sectors, you can use this cmd.exe command:
for %i in (0 1 2 3 4 5 6 7 8 9 a b c d e f) do (
  pdocread -n 1 -b 0x1000 -G 0x400000 0x%i000 0x400000 x
)
it will try to read a very large block from each sector, and output errors, indicating how many bytes were actually read.
to read the bootloader on a G4 htc device, you would need to specify -b 0x20000, while on a G3 device you would need to specify -b 0x8000.
or to read the bootsplash on a G4 device you would need to do this:

pdocread -n 1 -G 0x30000 -b 0x10000 0xF0000 0x30000 bdk1-f-splash.nb

reading qualcomm flash
  pdocread -F 0     - reads the first sector of the application flash
  pdocread -ux -F 0 - reads the first sector of the baseband flash


       pdocwrite.exe

This tool can write wince flash disks.
The -u PASSWD option can be used to temporarily unlock a locked diskonchip device, useful for instance for writing the himalaya extended rom, which has password "aYaLaMiH"

other options are identical to those of pdocread.


       psynctime.exe

Tool to synchronize your PDA time with your desktop pc, you have it run automatically
by adding this value to your PC registry:
  [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows CE Services\AutoStartOnConnect]
  "psynctime"="c:\\path-to\\psynctime.exe"
this will also correct a problem that your current application loses focus when your
cradle your device.


       preboot.exe

Utility to reboot your device, while it is in it's cradle.


      ppostmsg.exe

Utility to send messages to windows on your pocket pc device.
You can also use this tool to list all windows: ppostmsg -l
postmsg.exe does the same for your desktop windows.


      prapi.exe

tool interfacing with the device provisioning API, you can use this to:
   * edit/view the registry
   * edit/view the certificate store
   * edit/view policy settings
   * edit/view metabase settings

      pmv.exe

move or rename files on the device, without transfering the data over activesync.

      pchmod.exe

set file or directory attributes.

      pdial.exe

dials a number on your phone

      psendsms.exe

sends sms to specified phone number

      phandle.exe

lists all open files, and which processes have those files open.
phandle can also dump the KData kernel info struct: phandle -k

====================
**** WINCE APPS ****
====================

      qualbufmon.exe
      sambufmon.exe
      gsmbufmon.exe

Windows CE tools - you need to run them on the device.
to capture all baseband/wince IPC to a logfile.
this includes all gsm AT commands, gprs/3g ip traffic, 
baseband debug logging etc.

      regbk.exe

wince tool to dump the complete windows ce registry to a file.
Just run, it will beep when ready ( this can take 10 - 20 minutes )

      dbglog.exe

wince tool monitoring the kernellog, output is saved in \dbg-XXXXXX.log


CONFIGURATION

you can control how itsutils is loaded via some registry keys on your pc:
registry path:  HKCU\Software\itsutils

  logtype  DWORD
     0
     1
     2
  devicelogpath  STRING  - filename of the itsutils.log file
  devicedllpath  STRING  - where to copy itsutils.dll to on the device
     * these two are useful if you don't want to modify the device filesystem

  dllname  STRING  - what dll to use for itsutils
     * when you set this to 'itsutilsd.dll' you will get the debugging version of itsutils

example: enable logging with debugging version of itsutils:

regutl -c HKCU\Software\itsutils 
regutl -s HKCU\Software\itsutils :logtype=dword:2 ":devicelogpath=sz:\\itsutils.log" :dllname=sz:itsutilsd.dll

example: disable logging:

regutl -d HKCU\Software\itsutils 

-----------------------------------------------------------------------------
COMPILING:

You need the following tools installed:
   - cygwin, with bash, perl
   - gnumake v3.81 from http://www.xs4all.nl/~itsme/download/make.exe
   - boost 1.41.0
   - microsoft embedded visual c++ compiler
   - microsoft visual c++ compiler
   - windows ce platform builder
   - pocketpc 2003 sdk OR windows mobile 6.5 sdk
   - headers from the wince3, wince4, wince5 platformbuilder preview editions

update local.mak according to your needs.

then type 'make'

note: very old versions used to be compiled with a batchfile, instead of a Makefile.
that style of building is no longer supported.


-----------------------------------------------------------------------------
FUTURE:

pdblist:
    - should get a better interface, 
    -DONE allow specific fields to be listed for all records
    - allow less verbose field display, f.i. column wise
    -DONE allow user to set/add field, values to a record
    -DONE add support for other database volumes

itsutils:
    - create macro for method declaration
    - add seakable stream-interface to read-memory
    -DONE add handle-scan
    -DONE add cmdline to processinfo
    - add socketinfo interface
    -DONE add version check
    -DONE add mechanism for tools to automatically update dll if nescesary

pdel:
    -DONE add support for recursive delete.

pget:
    - clean up code
        * DONE. - merged code with pput.
    -DONE change interface, to allow specification of rootdir, and multiple src files.
    -DONE think of convenient way of encoding both 'default to curdir' and 'other target file/dir'
    -DONE support recursive downloading
    -DONE support wildcards 

pput:
    -DONE clean up code
    -DONE change interface, to allow specification of multiple source files
    - support recursive uploading
    -DONE support wildcards

pps:
    -DONE add cmdline info
    -DONE add openfiles info, ... [ in phandle ]

pregdmp:
    - clean up code
    - make more efficient
    - allow change of registry
    OBSOLETE: replaced by pregutl

pkill:
    -DONE clean up code

prun:
    -DONE clean up code

ptlbdump:
    -DONE finish implementing it. - now named pmemmap

pregdel:
    - finish implementing it.
    DONE: now called 'pregutl'

.....add these tools:
pmkdir - DONE
prmdir - DONE: pdel -r


Changelog

040318 -> 050119
 * made hexdumping interface more universal among different tools
 * switched compiler from EVC3 to EVC4 
 * added tffsreader interface to itsutils.dll
 * itsutils logs to \storage on smartphones
 * added 'readphysicalmemory' -p  option to pmemdump
 * pps now also works on smartphones
 * added more handle interpreters to 'testpi.cpp'
 * added cpu speed testing tool
 * added several requests and notifications to RilClass.cpp
 * dump can now also save a chunk of a file
 * more types of hexdump formatting.
 * pdblist now also supports volumes
 * added pdocread tool, to read from tffs / DOC chips
 * added new himalaya, and magician roms support to pnewbootloader
 *  * added option to pput, to take data from stdin.
 *  * pregutl now compiles both to wince and win32 tool
 *  * merged psdread and psdwrite tools

050119 -> 050628

 * dumprom: fixed problem with negative import RVA's
 * dumprom: added support for wm2005 xip sections
 * dumprom: cleaned up output
 * dumpxip: now uses xdadevelopers::NbfUtils, fixed decompress.
 * parsecrash.pl: added more constantsa, usage info.
 * formatdata.idc: added functions to inspect internals of IDA.
 * hotkeys.idc: added function to swap 2 instructions, and relocate appropriately.
 * hotkeys.idc: added several useful hotkeys
 * debug.cpp: now logfile automatically written to the correct root.
 * stringutils.cpp: simplified conversion functions
 * pmemmap: now reads from page+section tables. much quicker.
 * pnewbootloader: added several osses.
 * pget: now can recursively copy from wince to pc.
 * pregutl: added support to also run under wince.
 * hexedit: added unicode-string, and fill-range options
 * zipdbg: script to analyze .zip file
 * peinfo: script to analyze EXE file
 * makexip: added options to specify most rom params
 * reg2fdf: entries no longer sorted. ... fixes problem with smartphone rom generation
 * splitrom: user patches are now applied last
 * typeinfo.cpp: missing from wce sdk, allows use of exception handling
 * itsutils/math: scripts to do simple rsa signing/verification
 * regsort: sorts a .reg file
 * yakumo-img-info: manages eten-p300 image flash files
 * psdwrite: now writing of DOC is supported.
 * nbfutils: perl support module, for faster manipulation of nbf's.
 * typhoonnbfdecode: now also can create flashable sd-card images.
 * crc32: calculate crc32 of a file
 * im.cmd: interface to image magick commands
 * rdmsflsh.pl: script to decode MSFLSH50 rom filesystem
 * Added option to pmemmap, to save an entire section as a 32M file.

050628 -> 070323

 * ... TODO: have to write up a summary for this some time

070323 -> 070705

 * pdir/pput/pget/prun/pmkir/pdel now support %CSIDL_...% style paths
 * pdir -l lists all csidl paths
 * pdir -l CSIDL_... prints only that path
 * (p)regutl: fixed 'expand' specification
 * (p)regutl: allow for much longer lines to be read
 * (p)setmem: fixed '-l' load file option
 * prapi: added '-d' to delete item
 * prapi: added '-m' to add metabase entry
 * improved activesync wait
 * pdocread/write: added '-S' option to specify the partition signature, useful for H3 based devices
 * pdocread/write: added '-u' option for password protected partitions

070705 -> 080602

 * with 'psetmem -l filename' you can now specify a fileoffset and bytecount.
 * psynctime -q will print the current device time.
 * pregutl: increased size of value buf, fixed crash on empty hex keys.
 * pregutl: -x, -xx, -xxx print more/everything in hex, to be able to find strange keys.
 * pps: increased max nr of threads displayed.
 * pps: no longer needs 'toolhelp.dll' on the device.
 * pps: improved heap usage display.
 * memdump '-p' option now works again
 * pdocwrite: added '-W' to specify the address of a write unlock flag.
 * pps : improved module name detection for threads, added '-s0' option, to print the absolute thread times.
 * dump, pget now open files with maximum sharing, making it possible to read more types of files.
 * dump: now using openssl for hashing
 * dump: -sum now also prints various crc's
 * dump: -h prints all kinds of hashes.
 * dump.exe and pdir.exe now build under macosx
 * pdir: added '-v' to list file attributes
 * ppostmsg: added 'trace messages' feature, added --setforeground, and many other window operations
 * fixed unicode handling, now using the proper utf16<->utf8 conversion functions
 * pmemmap: reduced memory usage.
 * pdocread : '-o' (read OTP area) now really works.

080602 -> 080730

 * ppostmsg: fixed '-W' option, now instead of waiting for the window handle ( which is not something that has an effect ), now ppostmsg waits for the window's process handle.
 * pkill: added '-w' option, to wait until a process has really terminated
 * pput: recursive copy does not abort on errors.
 * prun: added 'waitforprocess' option, to wait until a process has exited
 * prun: better quoting process parameters
 * prun: added option to copy and execute a local file.

080730 -> 080731

 * you can configure logging by setting values in your pc's registry: HKCU\software\itsutils
 * logtype= 0:no logging, 1:kernellog, 2:file, default=0(none)
 * devicelogpath= filename of the logfile, when type=2
 * devicedllpath= where to store itsutils.dll on the device, default=\windows\itsutils.dll

080731 -> 080731-2

 * you can now specify handles for pdocread by index in the 'pdocread -l' handle list
 * example: pdocread -h #1 -t

080731-2 -> 080923

 * added 'psendsms', to send smsses from the windows commandline
 * added 'pdial' to dial a number on the connected phone
 * added 'pmv' to move or rename files on the device
 * added 'pchmod' to change file permissions on the device
 * fixed recently introduced bug in prun, where it would no longer take params.
 * dump.exe now supports files larger than 4G
 * you can use dump.exe to read from devices too.
 * dump.exe now has improved summary line handling
 * fixed pmemmap issue where it would not save memory blocks

080923 -> 090331

 * major new features:
 * read qualcomm flash memory, samsung flash memory ( in addition to disk on chip flash )
 * tries to automatically appunlock your device
 * phandle - tool to show open files
 * pdblist: added '-R' to delete a record
 * pdblist: a guid can now be specified as volume name.
 * dump: now you can get a sum/hash for each step chunk when combing -hash and -s
 * dump: '-md5 -s STEPSIZE' implies -w STEPSIZE
 * pdocread/pdocwrite: added -N, to r/w samsung onenand disks
 * pdocread/pdocwrite: added -F, to r/w qualcomm flashdrv disks ( found in htc 3g phones )
 * pdocread -N and -F also support '-ux' to unlock the hidden, or protected area's in flash.
 * note that the '-ux' option patches nk.exe (-N) or flashdrv.dll (-F). it is possible that rom versions exist where pdocread is not able to find what to patch. phones known to work: sony xperia, htc-viva, htc-s310
 * note that the flash offsets are different for '-F' and '-F -ux': '-F' reads the wince section of flash, '-F -ux' reads both the gsm and wince sections, there is a difference of 0x2400000 between the two.
 * itsutils tools now try to automatically app-unlock a device.
 * added phandle, which can dump the kdata struct, and produce a list of all open handles with descriptions.
 * MemoryUsage: improved heap ptr location finder: now getting coredll.dll data segment using GetModule(Data)VirtualRange
 * 'pdir' now outputs utf8, this does however not display very well in windows cmd.exe, i need to research how to encode to the current codepage.
 * 'pps -m' now also prints the module handle
 * added -b and -B options to psdread, like the pdocread options
 * improved the -R option for pregutl, to specify the maximum recursion depth
 * fixed addproc and delproc options for ppostmsg -t
 * psynctime now prints timedifference in seconds
 * --- updated plumbing:
 * improved ondisk kernel patch, now also works on the htc viva
 * changed itsutils config state to use LoadLibrary, instead of window handle
 * MemoryUsage: improved heap ptr location finder: now getting coredll.dll data segment using GetModule(Data)VirtualRange
 * ondisk now supports other phones than the omnia too. ( now searching nk.exe address space for patch )
 * added rough check for sanity of the found patches, to prevent only one of 'read' and 'write' being patched.
 * improved hexdump implementation
 * some wince ( on device ) tools

 * regbk: tool running on wince device to dump registry
 * rdwlan, loadflashdrv: tools to read kaiser flash
 * tstdev: test device drivers
 * logdev: logging device driver, sits in between the dev, and the real device driver.
 * gsmbufmon: tool to monitor communication between wince and the TI radio part on htc omap baed phones
 * tstdevio : tool to manually call DeviceIoControl
 * tstrilmon : dumps sim contents.

090331 -> 090515

 * great speed improvement by using the same IRAPIStream for all requests
 * improved accuracy of psynctime
 * fix -m for psetmem
 * prapi now can take the cert from a .exe (originally you needed a .cer file)
 * when uploading itsutils, the certificate used to sign the dll is automatically uploaded to the device, it is no longer nescesary to keep the cert in a seperate file.

090515 -> 091117

 * itsutils: fixed hang when old version of itsutils was on device: stream started with ITStartStream
 * itsutils: fixed stream issues: no exception on termination
 * prun: -w now returns the process return code
 * prun: added option to pass base64 encoded argument strings
 * phandle: better decoding of kdata struct
 * sdread: added option to specify win32 physicalDisk, -l also lists physicaldisks
 * psdread: -b option now really works
 * pput: fixed issue with trailing slash in target dirname
 * pput: fixed issue with c:\

091117 -> 100222

 * various stream/backwd compatibility issues
 * added GetWindowText to ppostmsg output
 * added wm65 support to ppostmsg
 * including qualbufmon, gsmbufmon and sambufmon tools to monitor the baseband ipc
 * improved psynctime accuracy
 * pdebug improvements

100222 -> 100324

 * several minor bugfixes: pmv, pdial, psendsms
 * pps: removed obsolete '-h' option
 * added 'dllname' registry value, to specify what itsutils.dll to use
 * added itsutilsd.dll, which is a version with debug logging enabled
 * removed obsolete tools: tlbdump.exe pcoldboot.exe pflashrom.exe pnewbmp.exe pnewbootloader.exe pregdmp.exe

100324 -> 111201

 * new option: pps -vv  for hexdump of entire process/thread/module struct
 * new option: pps -c  for continuous dumping of process list
 * new option: pget -m for monitoring of changes to specified file
 * ppostmsg  : added 'addproc' keyword to -t
 * phandle  now prints paths for FNOT handles
 * dump: now you can extract stepped chunks with -w+-s+-c
 * umemdump:  osx version of pmemdump
 * various: added support for htc hd2, htc hdmini
 * dump -o NEGATIVEOFS: negative offset means: relative to end of file
 * pdocread now supports devices with nand.dll

