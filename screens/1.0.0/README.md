# Screens
Structure Source Code in a Collection of Screens

## Intro
In traditional Forth systems, source code is managed using a block-based approach. A block is a fixed-size unit of storage that contains Forth source code. The size of a block can vary depending on the Forth system, but it is typically a fixed number of characters or bytes often 1 KB. When used to store source code blocks are also called screens as they are displayed one after the other on a terminal's screen. Often screens are organized as 16 lines with 64 characters without line termination. 

The Forth interpreter or compiler treats each block as a separate entity. The blocks are sequentially numbered, starting from zero, and can be individually edited and loaded (executed). The Forth system typically provides commands and utilities to manipulate and navigate through these blocks. For example, a command like `u LOAD` loads the contents of the block with number `u` into memory and interprets its content, `u LIST` displays its content.

When working with a Forth system, the user can interactively edit or input source code into a screen using an editor provided by the system. The source code is usually stored in memory or in a separate file. Most Forth systems use a buffer scheme to manage reading from and writing blocks to mask storage (disk, flash, ...) for efficient access.

One of the key features of managing source code in blocks is that blocks can be loaded, modified, and saved independently of each other. This modular approach allows developers to work on specific sections of code without affecting the rest of the program. It also enables incremental development and easy maintenance of large programs.
Screens are like pages in a book and can be displayed on screen without the need for scrolling.


One of the limitations of the block-based approach in traditional Forth systems is the fixed block size. Each block has a predetermined size, often a fixed number of characters or bytes, which can restrict the amount of source code that can be accommodated within a single block. If the code exceeds the block's capacity, it needs to be split across multiple blocks, potentially leading to fragmentation and decreased readability. Developers must carefully manage the size of their code and plan accordingly to ensure it fits within the available block space or make adjustments by splitting the code across multiple blocks, which can introduce complexity and hinder code organization.

## Flexible Screens

This repository contains ANS Standard Forth (aka Forth-94) definitions to work with flexible screens of arbitrary line width and variable number of lines on each screen. This is achived by adding page separators (formfeed ^L, character $0C) to a standard line structured text file thus giving it a structure of screens.

All typical Forth user level words that work on block based fixed size screens are also provided for flexibla screens. Have a look at [glossary.md](glossary.md) for details.

## How to use

In order to use flexible screens just `INCLUDE` the file `screens.fs` on any Forth-94 standard systems that provides the file access and the memory allocation word set. See the file [requirements.md](requirements.md) for standard conformant labeling of this program.

After loading `screens.fs` you can select a screen file by `USE filename`. `screenfile.fs` is preselected.
You can inspect the screens by using `L`, `N`, `B`. (See [glossary.md](glossary.md)  for a complete list of user interface words).

## Sample Screen Files

Please have a look at the file [screenfile.fs](screenfile.fs) especially its screen 0 that explains the files content.

You can edit screenfiles with most text editors. Emacs' `pages.el` mode is a convenient way to do so. YMMV.

---

Enjoy, Ulrich Hoffmann `<uh@xlerb.de>`
