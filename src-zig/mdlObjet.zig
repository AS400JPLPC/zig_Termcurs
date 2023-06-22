const std = @import("std");


const dds = @import("deps/curse/dds.zig");

// terminal Fonction
const term = @import("deps/curse/cursed.zig");
// keyboard
const kbd = @import("deps/curse/cursed.zig").kbd;

// full
const forms = @import("deps/curse/forms.zig");
// error
const dsperr = @import("deps/curse/forms.zig").dsperr;
// frame
const frm = @import("deps/curse/forms.zig").frm;
// panel
const pnl = @import("deps/curse/forms.zig").pnl;
// button
const btn = @import("deps/curse/forms.zig").btn;
// label
const lbl = @import("deps/curse/forms.zig").lbl;
// menu
const mnu = @import("deps/curse/forms.zig").mnu;
// grid
const grd = @import("deps/curse/forms.zig").grd;
// flied
const fld = @import("deps/curse/forms.zig").fld;
// line horizontal
const lnh = @import("deps/curse/forms.zig").lnh;
// line vertival
const lnv = @import("deps/curse/forms.zig").lnv;

// tools utility
const utl = @import("deps/curse/utils.zig");

// tools regex
const reg = @import("deps/curse/match.zig");



var numPanel: usize = undefined;

pub const ErrMain = error{
    main_append_XPANEL_invalide,
    main_run_EnumFunc_invalide,
    main_run_EnumTask_invalide,
    main_loadPanel_allocPrint_invalide,
    main_updatePanel_allocPrint_invalide,
    main_XPANEL_invalide,
};



//=================================================
// description Function
// choix work panel
pub fn qryPanel(vpnl: *std.ArrayList(pnl.PANEL)) usize {
    var cellPos: usize = 0;


    var Xcombo =  grd.initGrid(
        "qryPanel",
        1,
        1,
        20,
        grd.gridStyle,
        dds.CADRE.line1,
    );


    grd.newCell(&Xcombo,"ID", 3, dds.REFTYP.UDIGIT, dds.ForegroundColor.fgGreen);
    grd.newCell(&Xcombo,"Name", 10, dds.REFTYP.TEXT_FREE, dds.ForegroundColor.fgYellow);
    grd.newCell(&Xcombo,"Title", 15, dds.REFTYP.TEXT_FREE, dds.ForegroundColor.fgGreen);
    grd.setHeaders(&Xcombo);

    var idx: usize = 0;
    for (vpnl.items) |p| {
        grd.addRows(&Xcombo, &.{ utl.usizeToStr(idx), p.name, p.frame.title });
        idx += 1;
    }

    var Gkey: grd.GridSelect = undefined;
    while (true) {
        Gkey = grd.ioCombo(&Xcombo, cellPos);

        if (Gkey.Key == kbd.enter) {
            //grd.rstPanel(&Xcombo, frompnl);
            grd.resetGrid(&Xcombo);
            Xcombo = undefined;
            return utl.strToUsize(Gkey.Buf.items[0]) catch unreachable;
        }


        if (Gkey.Key == kbd.esc) {
            //grd.rstPanel(&Xcombo, frompnl);
            grd.resetGrid(&Xcombo);
            Xcombo = undefined;
            return 999;
        }
    }
}

// end desription Function
//=================================================


var maxY: usize = 0;
var maxX: usize = 0;
var minY: usize = 0;
var minX: usize = 0;
var X: usize = 0;
var Y: usize = 0;

//pub fn main() !void {
pub fn fnPanel(XPANEL: *std.ArrayList(pnl.PANEL)) !void {
    
    term.cls();

    numPanel = qryPanel(XPANEL);

    if (numPanel == 999) return;


    var pFmt01 = pnl.initPanel("FRAM01",
                  XPANEL.items[numPanel].posx,
                  XPANEL.items[numPanel].posy,
                  XPANEL.items[numPanel].lines,
                  XPANEL.items[numPanel].cols,
                  XPANEL.items[numPanel].frame.cadre,
                  XPANEL.items[numPanel].frame.title);
                  
                  


    for (XPANEL.items[numPanel].button.items) |p| {
    pFmt01.button.append(p) catch unreachable ;
    }
    for (XPANEL.items[numPanel].label.items) |p| {
    pFmt01.label.append(p) catch unreachable ;
    }
    for (XPANEL.items[numPanel].field.items) |p| {
    pFmt01.field.append(p) catch unreachable ;
    }
    for (XPANEL.items[numPanel].linev.items) |p| {
    pFmt01.linev.append(p) catch unreachable ;
    }
    for (XPANEL.items[numPanel].lineh.items) |p| {
    pFmt01.lineh.append(p) catch unreachable ;
    }
    for (XPANEL.items[numPanel].grid.items) |p| {
    pFmt01.grid.append(p) catch unreachable ;
    }
    for (XPANEL.items[numPanel].menu.items) |p| {
    pFmt01.menu.append(p) catch unreachable ;
    }


    pFmt01.menu.append(mnu.newMenu(
                      "Choix",                // name
                      1, 1,                  // posx, posy  
                      dds.CADRE.line1,        // type line fram
                      dds.MNUVH.vertical,     // type menu vertical / horizontal
                      &.{                    // item
                      "Label-Order",
                      "Label-Remove",
                      }
                      )) catch unreachable ;

    pnl.printPanel(&pFmt01);

    maxY = pFmt01.cols + pFmt01.posy;
    if (pFmt01.frame.cadre != dds.CADRE.line0) maxY -= 0;
    minY = pFmt01.posy;
    if (pFmt01.frame.cadre != dds.CADRE.line0) minY += 1;

    maxX = pFmt01.lines + pFmt01.posx;
    if (pFmt01.frame.cadre != dds.CADRE.line0) maxX -= 2;
    minX = pFmt01.posx;
    if (pFmt01.frame.cadre != dds.CADRE.line0) minX += 1;

    term.onMouse();
    var Tkey : term.Keyboard = undefined ; // defines the receiving structure of the keyboard
    while (true) {
        term.cursShow();
        Tkey = kbd.getKEY();

        if (Tkey.Key == kbd.mouse)  { forms.dspMouse(&pFmt01);  continue;  } // active display Cursor x/y mouse

        switch (Tkey.Key) {
            .F10 =>  {
                XPANEL.items[numPanel].label.clearRetainingCapacity(); 
                for (pFmt01.label.items) |p| {
                XPANEL.items[numPanel].label.append(p) catch unreachable ;
                }

                pnl.deinitPanel(&pFmt01);
                pFmt01 = undefined;
                dds.deinitUtils();
                dds.deinitScreen();



                return;
            },
            .F12 => {
                pnl.deinitPanel(&pFmt01);
                pFmt01 = undefined;
                dds.deinitUtils();
                dds.deinitScreen();

                return ; 
            } ,
            .altT => {
                term.getCursor(); 
                if (term.posCurs.x < minX or term.posCurs.x > maxX or
                term.posCurs.y < minY or term.posCurs.y > maxY ) continue ;
                term.offMouse();
                writeLabel(&pFmt01, true);
                pnl.printPanel(&pFmt01);
                term.onMouse();
            },
            .altL => {
                term.getCursor();
                if (term.posCurs.x < minX or term.posCurs.x > maxX or
                    term.posCurs.y < minY or term.posCurs.y > maxY) continue;
                term.offMouse();
                writeLabel(&pFmt01, false);
                pnl.printPanel(&pFmt01);
                term.onMouse();
            },
            .altW => {
                var nitem  :usize = 0;
                  nitem  = mnu.ioMenu(&pFmt01,pFmt01.menu.items[0],nitem);

                  if (nitem == 0) writeLabel(&pFmt01, false);  // remove
                  if (nitem == 1) writeLabel(&pFmt01, false);  // order
            },
            else => {},
        }
    }
}

//------------------------------------------------------------------
// definition label

fn writeLabel(vpnl: *pnl.PANEL, Title: bool) void {
    //term.getCursor();
    var e_count: usize = 0;
    var tampon: []const u8 = undefined;
    var text: []const u8 = undefined;
    const allocator = std.heap.page_allocator;
    var e_LABEL = std.ArrayList([]const u8).init(allocator);
    defer e_LABEL.deinit();
    var e_posx: usize = term.posCurs.x;
    var e_posy: usize = term.posCurs.y;
    var e_curs: usize = e_posy;

    // defines the receiving structure of the keyboard
    var Lkey: term.Keyboard = undefined;
    var i: usize = 0;
    while (i < vpnl.cols) : (i += 1) {
        e_LABEL.append(" ") catch unreachable;
    }
    while (true) {
        forms.dspCursor(vpnl, e_posx, e_curs);

        Lkey = kbd.getKEY();

        //dspMouse(vpnl);  // active display Cursor x/y mouse
        //std.debug.print("Key: {d}  - {d}\n\r",.{term.posCurs.x, term.posCurs.y});
        switch (Lkey.Key) {
            .F12 => return,

		
            .ctrlV => {
                tampon = std.fmt.allocPrint(dds.allocatorRecord,"L{d}{d}",.{e_posx,e_posy}) catch unreachable;
                text = utl.trimStr(utl.listToStr(e_LABEL));
              if (Title) {
                vpnl.label.append(lbl.newTitle(
                tampon, e_posx ,e_posy,utl.ToStr(text)
                )) catch unreachable;
              }
              else {
                vpnl.label.append(lbl.newLabel(
                tampon, e_posx ,e_posy,utl.ToStr(text)
                )) catch unreachable;
              }
              return ;
            },
            .home => {
                e_count = 0;
                e_curs  = e_posy;
            },
            .end => {
                tampon = utl.listToStr(e_LABEL);
                e_count = utl.trimStr(tampon).len - 1;
                e_curs = e_posy + utl.trimStr(tampon).len - 1;
            },
            .right, .tab => {
                if (e_curs < (vpnl.cols + vpnl.posy) - 1 ) {
                    e_count += 1;
                    e_curs += 1;
                }
            },
            .left, .stab => {
                if (e_curs > e_posy) {
                    e_count -= 1;
                    e_curs -= 1;
                }
            },
            .char => {
                if (e_curs < (vpnl.cols + vpnl.posy) - 1 ) {
                  if (Title) {
                      term.writeStyled(Lkey.Char, lbl.AtrTitle);
                      e_LABEL.items[e_count] = Lkey.Char;
                  } else {
                      term.writeStyled(Lkey.Char, lbl.AtrLabel);
                      e_LABEL.items[e_count] = Lkey.Char;
                  }
                  if (e_count < vpnl.cols) {
                      e_count += 1;
                      e_curs += 1;
                  }
                }
            },
            else => {},
        }
    }
}
