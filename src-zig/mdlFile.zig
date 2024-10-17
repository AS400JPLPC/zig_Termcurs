	///-----------------------
	/// prog mdlFile
	/// zig 0.13.0 dev
	///-----------------------

const std = @import("std");

/// terminal Fonction
const term = @import("cursed");
// keyboard
const kbd = @import("cursed").kbd;

// error
const dsperr = @import("forms").dsperr;

// full delete for produc
const forms = @import("forms");

// frame
const frm = @import("forms").frm;
// panel
const pnl = @import("forms").pnl;
// button
const btn = @import("forms").btn;
// label
const lbl = @import("forms").lbl;
// flied
const fld = @import("forms").fld;


// grid
const grd = @import("grid").grd;
// menu
const mnu = @import("menu").mnu;

// tools utility
const utl = @import("utils");

// tools regex
const reg = @import("mvzr");



// sauvegarde JSON
const mdlSjson = @import("mdlSjson");

// Restore JSON
const mdlRjson = @import("mdlRjson");






pub fn Panel_Fmt01(title: [] const u8) *pnl.PANEL {
	const termSize = term.getSize() ;


	var Panel : *pnl.PANEL = pnl.newPanelC("FRAM01",
										1, 1,
										termSize.height,
										termSize.width ,
										forms.CADRE.line1,
										title,
										);

	Panel.button.append(btn.newButton(
									kbd.F3,			// function
									true,			// show
									false,			// check field
									"Exit",			// title 
									)
								) catch unreachable ;

	Panel.button.append(btn.newButton(
									kbd.F6,			// function
									true,			// show
									false,			// check field
									"Dir",			// title 
									)
								) catch unreachable ;

	Panel.button.append(btn.newButton(
									kbd.F9,				// function
									true,				// show
									true,				// check field
									"Creat File Json",	// title 
									)
								) catch unreachable ;



	Panel.button.append(btn.newButton(
									kbd.F11,			// function
										true,			// show
										false,			// check field
									"File recovery",	// title 
									)
								) catch unreachable ;




	Panel.label.append(lbl.newLabel("hdir"	     ,2,2, "Dir......:") ) catch unreachable ;
	Panel.label.append(lbl.newLabel("dir"	     ,2,12, "?") ) catch unreachable ;
	Panel.label.append(lbl.newLabel("nameJson"	 ,4,2, "name.....:") ) catch unreachable ;


	Panel.field.append(fld.newFieldAlphaNumeric("nameJson",4,12,30,"",false,
								"required","please enter text ex:Panel09",
								"^[a-z]{1,1}[a-z0-9]{0,}$")) catch unreachable ;

	return Panel;
}

pub fn Panel_Fmt00(title: [] const u8) *pnl.PANEL {
	const termSize = term.getSize() ;


	var Panel : *pnl.PANEL = pnl.newPanelC("FRAM00",
										1, 1,
										termSize.height,
										termSize.width ,
										forms.CADRE.line1,
										title,
										);

	Panel.button.append(btn.newButton(
									kbd.F3,			// function
									true,			// show
									false,			// check field
									"Exit",			// title 
									)
								) catch unreachable ;

	Panel.button.append(btn.newButton(
									kbd.enter,			// function
									true,			// show
									false,			// check field
									"return",			// title 
									)
								) catch unreachable ;


	Panel.label.append(lbl.newLabel("hdir"	     ,2,2, "Dir......:") ) catch unreachable ;
	Panel.label.append(lbl.newLabel("dir"	     ,2,12, "?") ) catch unreachable ;

	return Panel;
}


var vdir : []const u8 = "";
const vbool = true;
fn isFile(name: []const u8 ) bool {

	
	const cDIR = std.fs.cwd().openDir(vdir,.{}) catch unreachable;
	
	var file = cDIR.createFile(name, .{ .read = true }) catch |e|
		switch (e) {
			error.PathAlreadyExists => return true,
			else =>return false,
		};

	defer file.close();
	return false;
}

fn newFile(name: []const u8 ) void {

	
	const cDIR = std.fs.cwd().openDir(vdir,.{}) catch unreachable;
	
	var file = cDIR.openFile(name, .{}) catch unreachable;
	cDIR.deleteFile(name) catch unreachable;
	file= cDIR.createFile(name, .{ .read = true }) catch unreachable;	
	defer file.close();
}

fn cleanProgram(vpnl : *pnl.PANEL ) void {
	vdir = "";
	pnl.freePanel(vpnl);
	forms.allocatorForms.destroy(vpnl);

	term.deinitTerm();
	utl.deinitUtl();
}

const Data = struct {
  data: [] const u8,
  
};
fn cmpByData( a: [] const u8, b: [] const u8) bool {
   const order = std.mem.order(u8, a, b);
    switch (order) {
        .lt => return true,
        else => return false,
    }
}

fn wrkDir(pnlFmt :*pnl.PANEL, xdir : [] const u8) !void {

	vdir ="";
	_= std.fs.cwd().openDir(xdir,.{})
		catch try std.fs.cwd().makeDir(xdir);
	const iter_dir= std.fs.cwd().openDir(xdir,.{.iterate = true}) catch unreachable;

	// list file and sort 
	var iteratorD = iter_dir.iterate();
	var list_fileD = std.ArrayList(Data).init(utl.allocUtl);
					
	while (try iteratorD.next()) |path| {
        if (path.kind == .directory)
       	 	try list_fileD.append(Data{.data =path.name}) ;
	}
	var list_xD = std.ArrayList(Data).init(utl.allocUtl);
	
	var n:usize = list_fileD.items.len; 
	while ( n > 0) {
	    var i:usize = 0;
	    var r:usize = 0;
	    var reverse : bool  = false ;
	    if ( n > 1 ){
	        while (n > 1) : (i +=1) { 
	            if (reverse == false ) {
	                if (cmpByData(list_fileD.items[i].data,list_fileD.items[r].data)) {
	                    try list_xD.append(Data{.data =list_fileD.items[i].data}) ;
	                    _=list_fileD.orderedRemove(i);
	                    n = list_fileD.items.len;                     
	                    reverse = false;
	                    break ; 
	                }
	            }
	            else {
	                if (cmpByData(list_fileD.items[r].data, list_fileD.items[i].data) ) {
	                    try list_xD.append(Data{.data =list_fileD.items[r].data}) ;
	                    _=list_fileD.orderedRemove(r);
	                    n = list_fileD.items.len;                     
	                    reverse = false;
	                    break ; 
	                }
	            }

	            if ( i == n - 1) { reverse = true ; i = 0 ; r = 0;}
	        }
	    }
	    else {
	        try list_xD.append(Data{.data =list_fileD.items[0].data}) ;
	        _=list_fileD.orderedRemove(0);
	        break ; 
	    }

	}   
	// end list sort

	const Grid00 : *grd.GRID =	grd.newGridC(
	"Grid01",			// Name
	5, 2,				// posx, posy
	20,					// numbers lines
	grd.gridStyle,		// separator | or space
	grd.CADRE.line1,	// type line 1
	);
	defer grd.freeGrid(Grid00);
	var ok_file= false;
	var Gkey :grd.GridSelect = undefined ;

	grd.resetRows(Grid00);

	if (grd.countColumns(Grid00) == 0) {
		grd.newCell(Grid00,"Name",25,grd.REFTYP.TEXT_FREE,term.ForegroundColor.fgYellow);
		grd.setHeaders(Grid00);
		grd.printGridHeader(Grid00);
	}
	
	for (list_xD.items) |f| {
		ok_file = true;
		grd.addRows(Grid00, &.{f.data});
	}	

	if (!ok_file) {return; }
	while (vbool ){
		Gkey =grd.ioCombo(Grid00,0);

		pnl.displayPanel(pnlFmt);
		if ( Gkey.Key == kbd.esc) {
			vdir ="";
			lbl.updateText(pnlFmt,1,vdir) catch unreachable;
			 break;
		 }

		if ( Gkey.Key == kbd.enter) {
			vdir = std.fmt.allocPrint(utl.allocUtl,"{s}" ,.{Gkey.Buf.items[0]}) catch unreachable;
			lbl.updateText(pnlFmt,1,vdir) catch unreachable;
			break;
		}
	}
}




pub fn wrkJson (XPANEL: *std.ArrayList(pnl.PANEL),
				XGRID:  *std.ArrayList(grd.GRID),
				XMENU:  *std.ArrayList(mnu.DEFMENU),
				wrkSav: bool) !void {

	if (XPANEL.items.len == 0 and wrkSav) return;


	
	var twork: [] const u8 = undefined;
	if (wrkSav)  twork = "Save-File-JSON" 
	else twork = "Recovery-File-Json";

	vdir ="";
	var Tkey : term.Keyboard = undefined ;	
	var pFmt01 = Panel_Fmt01(twork);
	const pFmt00 = Panel_Fmt00(twork);
	defer pnl.freePanel(pFmt00);
	defer forms.allocatorForms.destroy(pFmt00);
 
	while(std.mem.eql(u8 ,vdir, "") == true) {
		
			wrkDir(pFmt00,"./")  catch |err| {	@panic(@errorName(err));};
			if (std.mem.eql(u8 ,vdir, "")) {
				pnl.msgErr(pFmt00, "no directory available");
				Tkey.Key = pnl.ioPanel(pFmt00);
				switch (Tkey.Key) {
					.F3 => {
								cleanProgram(pFmt01);
								return ; 
							},
					else => {}
				}
			} else lbl.updateText(pFmt01,1,vdir) catch unreachable;
	}

	if (wrkSav == false) {
			 try btn.setActif(pFmt01,try btn.getIndex(pFmt01,kbd.F9),false);
			 try lbl.setActif(pFmt01,2,false);
			 try fld.setActif(pFmt01,0,false);
		} else {
			 try btn.setActif(pFmt01,try btn.getIndex(pFmt01,kbd.F9),true);
			 try lbl.setActif(pFmt01,2,true);
			 try fld.setActif(pFmt01,0,true);
		}

	// _= std.fs.cwd().openDir(vdir,.{})
	// catch try std.fs.cwd().makeDir(vdir); 
	var err: bool = true ;
	var nameJson : [] const u8 = undefined;


	// Grid ---------------------------------------------------------------
	const Grid01 : *grd.GRID =	grd.newGridC(
					"Grid01",			// Name
					4, 2,				// posx, posy
					20,					// numbers lines
					grd.gridStyle,		// separator | or space
					grd.CADRE.line1,	// type line 1
					);
	defer grd.freeGrid(Grid01);
	

	while (vbool) {
			//Tkey = kbd.getKEY();
			
	
		Tkey.Key = pnl.ioPanel(pFmt01);
	
		switch (Tkey.Key) {
			.F6 => {
				if (!std.mem.eql(u8,vdir ,"" ))  {
					var sdir:[] const u8 = "";
					while( true) {
						if (std.mem.eql(u8,vdir , "")) { vdir = "./" ; sdir =""; }
						else  sdir =utl.concatStr(vdir,"/") ;
						
						wrkDir(pFmt00,vdir)  catch unreachable;
						if (std.mem.eql(u8,vdir , "")) pnl.msgErr(pFmt00, "no directory available");
						lbl.updateText(pFmt00,1,vdir) catch unreachable;
						Tkey.Key = pnl.ioPanel(pFmt00);
						switch (Tkey.Key) {
							.F3 => {
										cleanProgram(pFmt01);
										return ; 
									},
							else => {}
						}
								if (!std.mem.eql(u8,vdir ,"" ))  {
									if (!std.mem.eql(u8,sdir ,"" ))  vdir = utl.concatStr(sdir,vdir) ;
									lbl.updateText(pFmt01,1,vdir) catch unreachable;
									pnl.displayPanel(pFmt01);
									break;
								} 
					}	
				}
			},
			.F9 => {
				if (std.mem.eql(u8,vdir ,"" ))  { 
					pnl.msgErr(pFmt01, "no directory available");  
					wrkDir(pFmt00,"./")  catch unreachable;
					lbl.updateText(pFmt01,1,vdir) catch unreachable;
					continue;
				}
				for (pFmt01.field.items , 0..) |f , idx| {
					pFmt01.idxfld = idx ;
					pFmt01.keyField = kbd.none;
					err =false;
				
					if (f.text.len == 0) {
						pnl.msgErr(pFmt01, "Name Json incorrect ");
						err =true;
						continue;
					}
					else {
						nameJson = try fld.getText(pFmt01,try fld.getIndex(pFmt01,"nameJson"));
						err = isFile(nameJson);
					
						if (err) pnl.msgErr(pFmt01, "Name Json incorrect allready exist ")
						else {
							pnl.msgErr(pFmt01, try std.fmt.allocPrint(utl.allocUtl, "Save {s} Json", .{nameJson})) ;
							try mdlSjson.SavJson(XPANEL, XGRID, XMENU, vdir ,nameJson);
							cleanProgram(pFmt01);
						return;
						}
					}
				}
			},
			
			.F11 => {
				if (std.mem.eql(u8,vdir ,"" ))  { 
					pnl.msgErr(pFmt01, "no directory available");  
					wrkDir(pFmt00,"./")  catch unreachable;
					lbl.updateText(pFmt01,1,vdir) catch unreachable;
					continue;
				}
				const iter_dir= std.fs.cwd().openDir(vdir[0..],.{.iterate = true}) catch unreachable;

				// list file and sort 
				var iterator = iter_dir.iterate();
				var list_file = std.ArrayList(Data).init(utl.allocUtl);
								
				while (try iterator.next()) |path| {
                    if (path.kind == .file)
		           	 	try list_file.append(Data{.data =path.name}) ;
				}

				if (list_file.items.len == 0 ) return;
				var list_x = std.ArrayList(Data).init(utl.allocUtl);
						
				var n:usize = list_file.items.len; 
				while ( n > 0) {
				    var i:usize = 0;
				    var r:usize = 0;
				    var reverse : bool  = false ;
				    if ( n > 1 ){
				        while (n > 1) : (i +=1) { 
				            if (reverse == false ) {
				                if (cmpByData(list_file.items[i].data, list_file.items[r].data) ) {
				                    try list_x.append(Data{.data =list_file.items[i].data}) ;
				                    _=list_file.orderedRemove(i);
				                    n = list_file.items.len;                     
				                    reverse = false;
				                    break ; 
				                }
				            }
				            else {
				                if (cmpByData(list_file.items[r].data, list_file.items[i].data) ) {
				                    try list_x.append(Data{.data =list_file.items[r].data}) ;
				                    _=list_file.orderedRemove(r);
				                    n = list_file.items.len;                     
				                    reverse = false;
				                    break ; 
				                }
				            }

				            if ( i == n - 1) { reverse = true ; i = 0 ; r = 0;}
				        }
				    }
				    else {
				        try list_x.append(Data{.data =list_file.items[0].data}) ;
				        _=list_file.orderedRemove(0);
				        break ; 
				    }
    
				}   
				// end list sort

				
				var ok_file= false;
				var Gkey :grd.GridSelect = undefined ;

				grd.resetRows(Grid01);

				if (grd.countColumns(Grid01) == 0) {
					grd.newCell(Grid01,"Name",25,grd.REFTYP.TEXT_FREE,term.ForegroundColor.fgYellow);
					grd.setHeaders(Grid01);
					grd.printGridHeader(Grid01);
				}
				
				for (list_x.items) |f| {
					ok_file = true;
					grd.addRows(Grid01, &.{f.data});
				}	

				if (!ok_file) { pnl.msgErr(pFmt01, "no file available"); continue; }
				while (vbool ){
					Gkey =grd.ioGrid(Grid01,false);

					pnl.displayPanel(pFmt01);
					if ( Gkey.Key == kbd.esc) {pnl.displayPanel(pFmt01); break; }

					if ( Gkey.Key == kbd.enter) {
						nameJson =Gkey.Buf.items[0];
						pnl.msgErr(pFmt01, try std.fmt.allocPrint(utl.allocUtl, "Working {s} Json", .{nameJson})) ;
						if (wrkSav){
							newFile(nameJson);
							try mdlSjson.SavJson(XPANEL, XGRID, XMENU, vdir ,nameJson);
						} 
						else try mdlRjson.RstJson(XPANEL, XGRID, XMENU, vdir ,nameJson) ;
						cleanProgram(pFmt01);
						return ; 
					}
				}
			},
			// exit module panel 
			.F3 => {
				cleanProgram(pFmt01);
				return ; 
			},

			else => {}
		}
	}
}
