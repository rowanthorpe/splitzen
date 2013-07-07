splitzen: a batch-script for drag-n-drop splitting and rejoining of large files
          to arbitrary sizes with checksum integrity checking for Windows
Version: 0.6.4
Copyright: (c) 2010-2011,2013 Rowan Thorpe

Splitzen relies on a small handful of unix tools. It is easy to edit a few
labelled lines at the top of the script to use any installed (compatible)
binaries.

This project is under the GNU Affero General Public License version 3 or
greater (http://www.gnu.org/licenses/agpl.html).

If the external GnuWin32 binaries and/or sources (coreutils, libiconv, libintl)
are not bundled with this release they can be found at
http://sourceforge.net/projects/gnuwin32

Features
========

* Drag and drop
* Checksum integrity checking
* Portable (between different Windows systems >= NT)
* Small size
* Fully configurable (by file and at runtime)
* Non-intrusive and easily disposable
* Simple
* Lean

Installation & Usage:
=====================

* Unless using the auto-installer, unzip the splitzen package and open its
  "bin" directory.

* To split a file: drag it onto the "splitzen.cmd" icon, then follow
  instructions (usually just say "yes"). If you wish the output splitfiles to
  be in a clean new directory then copy the original file into an empty
  directory and operate on that copy. Send the splitzen package to the
  recipient first, then send each of the splitfiles and the checksum file, in
  pieces.

* To join splitfiles: put all of the splitfiles and checksum file in an empty
  folder, drag any one of the splitfiles from there onto the "splitzen.cmd"
  icon, then follow instructions (just confirm, then say yes). The pieces
  will be joined in the correct order regardless which file you drop on the
  icon.

* If you want to properly "install" this tool, then copy the splitzen folder to
  somewhere like: "C:\Program Files (x86)\splitzen" (probably needing admin
  permissions), then right-click-and-drag the "splitzen.cmd" onto the desktop,
  clicking "create a shortcut" when given the option. You can optionally edit
  the shortcut to include the --non-interactive flag after you are happy with
  your settings in the config file (to avoid having to hit [enter] all the
  time). Then you can drag the files onto that shortcut in the same fashion as
  above.

* If you wish to change any setting like using md5sums instead of sha1sums,
  ensure the appropriate GNU tool is in the bin subdirectory, or an external
  version is correctly named in the configuration.

* splitzen.cmd can of course be used from scripts. Enter
  "[path-to]\splitzen.cmd --help" at a command prompt for usage message.

Motivations
===========

I found myself repeatedly stuck on Windows machines (for work reasons) and
having to quickly send large files to colleagues. With files usually being too
large to attach to standard emails, I had to resort to uploading to free
download servers like Sendspace, etc. However, often that was overkill for a
file that was only marginally too big to attach to a single email, or
not-very-computer-literate people at the other end would get confused and
flustered at having to click "Download" links on strange looking sites. Also,
it was at times problematic using things like 7-zip or Rar to split files down,
because often the people at the other end either didn't have them installed,
didn't want to download full applications, didn't understand how to use them
(or where to find their split functions), or couldn't get Admin-permission for
installation, etc. Splitzen is a tiny self-contained bundle requiring no
"installation", based around a tiny batch-script and 2 optionally bundled tiny
GNU tools, which when unzipped from an email attachment can provide drag-n-drop
rejoining of files also sent by email attachments. This is an option which is
tiny, easy to setup, ridiculously easy to use, and easy to throw away
afterwards, while still providing some peace of mind through checksum integrity
checking.

Web site:
=========

 http://github.com/rowanthorpe/splitzen
 
 Please make bug reports, feature requests, nagging, and whatever to:

   Rowan Thorpe <rowan _at_ rowanthorpe [dot] com>

 ...but please understand that this is designed to be a very small, simple and
 convenient drag-n-drop tool (& easy/quick to read, therefore easy to trust),
 so I am highly unlikely to implement many more "features" than it already has.
 I am most interested in bug reports and security patches. If you want to make
 a bigger snazzier version of this feel free to start your own project with
 those different (yet valid) goals, or use Splitjoin, ZIP, Tar, Rar or 7zip...
