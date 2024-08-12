# zig_TermCurs

terminal access function <br />
<u>**zig 0.13.0**</u><BR />
<br />

**TESTING** <br />
*look at the bottom of the testing page* <br />

**os linux** <br />
<u>Normally should work POSIX </u><br />
<br />
**the termcurs library, does what ncurse does (hopefully).<br />
it manages the interface between the terminal and the user.<br />
as does the 5250 of the OS400 with PC sauce.<br />
Panel, window, field, grid, menu etc.<br />
this can be used with a terminal with some editing eg: F10 etc. for convenience.<br />
the easiest way is to make your own terminal with libvte of which I provide an example in the src-c folder.<br />
this produces very lightweight programs for doing utilities or intensive typing for business management.<br />
Currently everything is not operational and the goal is to make a screen generator to simplify development, considering that this is only secondary and that the heart of the problem is the program itself and not the interface.<br />**
<br />
** I use the gencurs program to thoroughly test the termcurs lib.<br />**
<br />
<BR />
Thank you<br/>
a little more : XYAMAN
Resumption of the project https://github.com/xyaman/mibu<BR />

Thank you<BR />
https://zig.news/<BR />
https://zig.news/lhp/want-to-create-a-tui-application-the-basics-of-uncooked-terminal-io-17gm<BR /><BR />
thank you for your valuable explanations   David Vanderson<br />
https://zig.news/david_vanderson<br /> <br />
Structure the complex build
https://zig.news/xq/zig-build-explained-part-3-1ima <BR /><br />

thank you for your valuable explanations  Sam Atman 
https://github.com/mnemnion/mvzr/<BR /> <br />


extra..., to follow and have a history
https://github.com/kissy24/zig-logger/<BR /> <br />
<br />

![](assets/20230605_135950_Exemple.png)
<br />

**In the example, some errors are introduced such as the mail, all of this is voluntary and allows you to see the default interaction of the input control.<br />**
<br />

![](assets/20230213_012619_mdlPanel.png)

<br />

<br />

![](assets/20230812_012345_Field.png)

---

<BR/><BR/>


| Field                | Regex        | Text     | Type                                   |
| ---------------------- | -------------- | ---------- | ---------------------------------------- |
| TEXT_FREE            | Y            | Y        | Free                                   |
| TEXT_FULL            | Y            | Y        | Letter Digit Char-special              |
| ALPHA                | Y            | Y        | Letter                                 |
| ALPHA_UPPER          | Y            | Y        | Letter                                 |
| ALPHA_NUMERIC        | Y            | Y        | Letter Digit espace -                  |
| ALPHA_NUMERICT_UPPER | Y            | Y        | Letter Digit espace -                  |
| PASSWORD             | N            | Y        | Letter Digit and normaliz char-special |
| YES_NO               | N            | Y        | 'y' or 'Y' / 'o' or 'O'                |
| UDIGIT               | N            | Y        | Digit unsigned                         |
| DIGIT                | N            | Y        | Digit signed                           |
| UDECIMAL             | N            | Y        | Decimal unsigned                       |
| DECIMAL              | N            | Y        | Decimal signed                         |
| DATE_ISO             | DEFAULT      | Y        | YYYY/MM/DD                             |
| DATE_FR              | DEFAULT      | Y        | DD/MM/YYYY                             |
| DATE_US              | DEFAULT      | Y        | MM/DD/YYYY                             |
| TELEPHONE            | Y OR DEFAULT | Y        | +(033) 6 00 01 00 02                   |
| MAIL_ISO             | DEFAULT      | Y        | normalize mail regex                   |
| SWITCH               | N            | N / BOOL | CTRUE CFALSE                           |
| FUNC                 | N            | y        | **dynamic function call**              |
| TASK                 | N            | y        | **dynamic function call ex: control**  |
| CALL                 | N            | y        | **dynamic call exter                   |
|                      |              |          |                                        |

<BR/>
MOUSE<BR/>


| Type   | up | down | left | Middle | right | X/Y |
| -------- | ---- | ------ | ------ | -------- | ------- | ----- |
| Menu   | Y  | Y    | Y    | Y      | Y     | N   |
| GRID   | Y  | Y    | Y    | Y      | Y     | N   |
| FIELD  | Y  | Y    | Y    | Y      | Y     | N   |
| getKEY | Y  | Y    | Y    | Y      | Y     | Y   |
| <BR/>  |    |      |      |        |       |     |

<BR/>
FIELD<BR/>


| KEY       | text                                           |
| ----------- | ---------------------------------------------|
| MOUSE     | mouse array reference                          |
| escape    | Restores the original area                     |
| ctrl-H    | Show help                                      |
| ctrl-P    | exec program extern                            |
| home      | Position at start of area                      |
| end       | Position at end   of area                      |
| right     | Position + 1 of area                           |
| tab       | Position + 1 of area                           |
| left      | Position - 1 of area                           |
| shift tab | Position - 1 of area                           |
| bacspace  | Position -1 of area and delete char            |
| bacspace  | Position  of area and delete char              |
| insert    | Position  of area   change cursor              |
| enter     | Control valide update origine next field       |
| up        | Control valide update origine prior field      |
| down      | Control valide update origine next field       |
| char      | Treatment of the character of the area         |
| func      | Interactive function linked to the input area. |
| task      | Task executed after input in the zone.         |
| call      | Interactive function exec program extern       |

<BR/>

GRID<BR/>


| KEY      | text         |
| ---------- | -------------- |
| MOUSE    | active       |
| escape   | return key   |
| F12      | return key   |
| enter    | return ligne |
| up       | prior  ligne |
| down     | next   ligne |
| pageUp   | prior  page  |
| pageDown | next   page  |
| return   | Arg          |

<BR/>

COMBO<BR/>


| KEY      | text                   |
| ---------- | ------------------------ |
| CellPos  | Position start display |
| MOUSE    | active                 |
| escape   | return key             |
| enter    | return field           |
| up       | prior  ligne           |
| down     | next   ligne           |
| pageUp   | prior  page            |
| pageDown | next   page            |
| <BR/>    |                        |

<BR/><BR/>


<u>---Organization-project------------------------------------------</u><BR />
&rarr;&nbsp; folder deps: Filing of files zig including reference sources <br />
&rarr;&nbsp; folder library:  zig       source files <br />
&rarr;&nbsp; folder src_c:    C/C++     source files <br />
&rarr;&nbsp; folder src_zig:  ZIG-lang  source files <br />
&rarr;&nbsp; folder lib:      src xx.H  source files <br />
&rarr;&nbsp; build: build+source-name ex: buildexemple <br />
&rarr;&nbsp; makefile <br />
<br />

<u>--peculiarity-------------------------------------------------</u><BR />
test alt-ctrl ctrshift... etc for <br />

But it is no longer transportable.
another way is to use IOCTL but again, there is a good chance of being forced to use root.

Anyway, to make management applications or Terminal type tools are more than enough.

ctrl or alt combinations plus Fn(1..36) TAB Backspace home end insert delete pageup pagedown enter escape alt ctrl left rigth up down altgr mouse
and the utf8 keyboard is a lot.<br />

<u>--styling-------------------------------------------------</u><BR />
make it compatible as close as possible to IBM 400 ex:<br />
<br />
ex: pub const AtrLabel : stl.ZONATRB = .{<br />
&nbsp;&nbsp;&nbsp;.styled=[_]i32{@enumToInt(stl.Style.styleBright),<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;@enumToInt(stl.Style.styleItalic),<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;@enumToInt(stl.Style.notstyle),<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;@enumToInt(stl.Style.notstyle)},<br />
&nbsp;&nbsp;&nbsp;.backgr = stl.BackgroundColor.bgBlack,<br />
&nbsp;&nbsp;&nbsp;.backBright = false,<br />
&nbsp;&nbsp;&nbsp;.foregr = stl.ForegroundColor.fgGreen,<br />
&nbsp;&nbsp;&nbsp;.foreBright = true <br />
};

<u>-------Current treatments------------------------------------</u><BR />
&rarr;&nbsp; forms.zig <br />
&rarr;&nbsp; fram / panel / label /button / Menu / Grid / Combo / dynamic function Exec ** OK <br />
&rarr;&nbsp; Preparation of "Field" processing as well as keyboard input.

Please wait, if there are bugs everything is not fixed.<br />

<u>-------TESTING------------------------------------</u><BR />
&rarr;&nbsp; *Use the gtk Term.c terminal, it's much simpler terminals  ex: exf4-terminal* <br />
<u>-------To write and think--------------------------------</u><BR />
&rarr;&nbsp; inspiration `<br />`

* [nim-termcurs](https://github.com/AS400JPLPC)<br />

<u>---------------------------------------------------------</u><BR />
<br />
|   for information|
→  2023-02-28<br />
Hello, it is now possible to use a terminal without leaving a trace, I added in "curse" the "reset" function,
on the other hand, i included in the cls function the underlying cleanup of the terminal, i put here the terminal start function for, you help ( xfce4-terminal --hide-menubar --hide-scrollbar --hide -toolbar --geometry="158x42" --font="DejaVu Sans Mono 12" just add -e ./...program <br />
→  2023-02-28<br />
**Applications no longer need lib-GTK VTE**
in general to debug well, to use the console, it is advisable to deactivate preferences F10 and ALT... ,
then compile with SMALL and to ensure violation of ALT-F4 use the cpp program gtk-vte an example is there.
But in terminal mode the application is viable (to do with the commit data-base)<br />
<br />
→  2023-02-05 Doc version 0.11.1 "view use TermCurs"
[READ-DOCS](http://htmlpreview.github.io/?https://github.com/AS400JPLPC/zig_TermCurs/blob/master/Docs_Exemples/index.html) <br />
<BR/>


![](assets/20231129_012345_Gen00.png)

<br />

![](assets/20231122_012345_Gen01.png)
<BR />
<BR />
les news:<BR />
<br />
→  2024-01-04<br />
LINUX<br />
Should it work with MAC?<br />
TRADUCTOR chatgpt<br />
Hello, there are very significant changes, why?<br />
Firstly, for better memory management.<br />
Greater coherence.<br />
All modules have their own allocators.<br />
Avoiding back-and-forth between modules.<br />
<br />
<br />
"CURSED" (named in memory of "NCURSEW"):<br />
Encompasses everything needed for writing to a terminal, including reading keyboard codes, mouse management, cursor handling, UTF8 work. I may introduce the "termios" concept for META codes. I took advantage of the restructuring to bring clarification.<br />
<br />
"FORMS":<br />
Includes management for:<br />
LABEL - BUTTON - LINEV - LINEH - FIELD - FRAME - PANEL<br />
Works with a matrix corresponding to the terminal surface so that the window can be restored. The FORMS allocator is designed for Fields and panel initialization. FORMS no longer includes GRID management, which is autonomous, nor MENU, which is autonomous<br />
<br />
"GRID":<br />
Functions similarly to forms, allowing the display and retrieval of arguments either from a database or working as a combo. It is autonomous, but you must consider that it should be included in your Panel, as it positions itself within the terminal window.<br />
<br />
"MENU":<br />
Operates like GRID but is much simplified; the returned argument is usize.which doesn't work with the matrix but directly with the terminal.<br />
<br />
"UTILS": (various tools and functions)<br />
Contains various functions to manage the control needs of FIELD or STRING management ([] u8 const).<br />
<br />
The Example program demonstrates how to manage and use these functions. A tip: the first Panel can serve as the definition of the terminal window.<br />
<br />
"MATCH": (regex MVZR pur zig)<br />
<br />
"LOGGER": <br />
Allows for a written record of variables or waypoints.<br />
<br />
"CALLPGM": Executes in Zig mode, manages the call and the wait.<br />
<br />

<br />
"INFO"<br />
Display attributes are in CURSED, e.g., term.ZONATRB, the CURSOR type.<br />
REFTYP is in Forms and Grid.<br />
CTRUE/CFALSE are in Forms and Grid.<br />
CADRE is in Forms and Grid.<br />
LINE is in Forms.<br />
"CURSED" and "UTILS" are being called within "Forms", "Grid" and "Menu"<br />
"MATCH" are being called within "Forms"<br />
<br />
<br />
<br /><br />
→  2024-01-05<br />
    I tested with two versions, 0.11.0 and 0.12.0-dev. Everything works fine except in mdlFile.zig:<br />

```
// 0.11.0 active
const iter_dir = try std.fs.cwd().openIterableDir(vdir, .{});

// 0.12.0 
// const iter_dir = std.fs.cwd().openDir(vdir, .{.iterate = true}) catch unreachable;
```

<BR/>
→  2024-02-01<br />
**Significant modification due to the addition of the callPgm function (module.zig).**<br />
&nbsp;&nbsp;&nbsp;.Exec to the program associated with the Field zone. CTRL+P <br /><br />
&nbsp;&nbsp;&nbsp;.Look at the example: Exemple.zig, the execve function in the source /deps/callpgm.zig.<br /><br />
&nbsp;&nbsp;&nbsp;.Several corrections: handling of Fields within the Panel function, plus a few message associations...<br /><br />
&nbsp;&nbsp;&nbsp;.Addition to the Field structure: progcall zone [] const u8, setCall, and getCall functions.<br /><br />
→  2024-02-02<br />
&nbsp;&nbsp;&nbsp;.correction mineur<br />
------------------------------------------------------------------<br />
→  2024-02-10<br />
The 'exemple' folder demonstrates how to use a shared library in your project that may contain multiple programs.<br />
<br />
→  2024-02-14<br />
Correction of the "rstpanel" function.<br />
Correction of "label.name" (memory issue).<br />
Possibility of adding the program name to an input field.<br />
Correct alignment in the Json backup files.<br />
<br />
I am progressing slowly (many tests). I have even considered directly addressing the memory.<br />
<BR/><BR/>
<BR/>
→  2024-03-25<BR/>
&nbsp;&nbsp;&nbsp; update version 0.12.0-dev.3429.<BR/>
Inclusion of modules callPgmPid, zmmap  only v0.12

Addition of the updateField function from mdlForms

Minor correction in ioCombo, the cursor wasn't moving up

In cursed, the handling of IOCTL has changed with the new Zig version

I've left the lines for downgrading, with 2 or 3 exceptions.(cursed)

Afterwards, I will only work with version 0.12.dev.

test  :  "./Gen"  for Gencurs

I'm still mulling over my design for the table generator.

→  2024-04-23<BR/>
new version zig 0.12.0 stable
Adding the 'mdlGrid' function.<br />
- Alt-G: Create GRID definition<BR/>
- Alt-C: Create text columns<BR/>
- Alt-R: Remove GRID<BR/>
- Alt-W: Tools menu (View GRID, View Cell, Order Cell, Remove Cell)<br />


→  2024-06-29<BR/>
new version zig 0.13.0 stable<br />
Implementation of the lib "library" removal of "deps"<br />
I'm making progress, this MENU <br />

→  2024-07-03<BR/> 
curse/forms shell <br />


→  2024-07-22<BR/> 
-  big update cursed  F1..F36 extension <br />
-  Change of REGEX module <br />
Following the work provided by **Sam Atman**, a basic "regex" library allowing on-the-fly constraint testing of a form, all written in ZIG, now my project is in pure ZIG.
-  Therefore, update of the forms module, revision of the mdlPanel module to integrate the functions F1..F36, and correction of an error in mdlJson. <br />


→  2024-07-23<BR/>
-  correction of mdlForms following the inclusion of the new regex module. <br />

→  2024-07-27<BR/>
Added MENU definition function
you have to understand the menu option as a fixed combo with constant values <br />
- Alt-M: Create MENU definition<BR/>
- Alt-C: Create / UPDATE  text columns<BR/> 
- Alt-W: Tools menu (View MENU, Remove MENU)<br />

I'm making progress, and I'm going to create the JSON.<br />


→  2024-07-31<BR/>
**JSON function enabled for grid and menu.**<br />
- full test GRID/MENU<BR/>
- various changes due to testing and implementation of the JSON function<BR/>
- This should not alter the old definitions.<BR/>
- you will find results in the dspf directory<BR/>


→  2024-08-03 / 04 <BR/>
*backup/restore*<br />
**add directory choice**<br />
**sort directory and files**<br />
- Small bug fixed with testing<br /><br />
- this morning some big tests:<br /><br />
- refining uppercase extended ascii mode<br />
- in-depth regex test MVRZR MACH activation<br />
- scan and roll test JSON<br /><br />


→  2024-08-12<BR/>
-  upgrade version 0.13 / 0.14 token<br /><br />
-  debug GRID  add type :<br />
I made an update in the GRID module:<br />

There are two ways to manage grids:<br />
a) Combo starts with the letter C.<br />
b) Grid starts with the letter G.<br />

Why this naming convention? It's for code generation. A Combo handles a single value and is loaded as a fixed value.<br />

For the Grid, it should be considered as a sub-file that can paginate, return multiple values, etc.<br />

Even though both use the same routines, the functionality is different.<br />
-  add orderGrid :<br /><br />
-  add module Gensrc :<br />
-Added the Gensrc program, restructured logger (file), and added logcons (console). This program will create the reference between the functions areas and the Combo/Grid definitions.<br /><br />



<br />
------------------------------------------------------------------<br />

Now that the entire designer allows for saving and restoring the code, this has allowed me to test my functions, and especially to take a little tour of the Zig language. I opted for working and writing with maximum use of the Zig language, so I don't use addressing or hex code; everything is in Zig.<br /> <br />

PAUSE<br /> <br />

In the current state, one could very well use JSON files and encapsulate them in the program, and why not make the forms in the project dynamic... I did this on the AS400.<br />
