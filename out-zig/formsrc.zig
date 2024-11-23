//----------------------
//---date text----------
//----------------------



const std = @import("std");
// terminal Fonction
const term = @import("cursed");
// keyboard
const kbd = @import("cursed").kbd;

// cadre
const cdr = @import("forms").CADRE;
const lne = @import("forms").LINE;

// Error
const dsperr = @import("forms").dsperr;

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

// line horizontal
const lnh = @import("forms").lnh;

// line vertival
const lnv = @import("forms").lnv;

// line grid/combo
const grd = @import("grid").grd;

// tools utility
const utl = @import("utils");



//----------------------
// Define Global DSPF PANEL
//----------------------



pub fn Panel_DEFREP() *pnl.PANEL{
			//----------------------
			var Panel : *pnl.PANEL = pnl.newPanelC("DEFREP",
			1, 1,
			44, 168,
			cdr.line1,
			"Def.REPERTOIRE");

			//----------------------
			Panel.button.append(btn.newButton(kbd.F1,true,false,"Help")) catch unreachable ;
			Panel.button.append(btn.newButton(kbd.F3,true,false,"Exit")) catch unreachable ;
			Panel.button.append(btn.newButton(kbd.F5,true,false,"display GRID")) catch unreachable ;
			Panel.button.append(btn.newButton(kbd.F9,true,false,"Enrg.")) catch unreachable ;
			Panel.button.append(btn.newButton(kbd.F11,true,false,"Update")) catch unreachable ;
			Panel.button.append(btn.newButton(kbd.F12,true,false,"Return")) catch unreachable ;
			Panel.button.append(btn.newButton(kbd.F23,true,false,"Delette")) catch unreachable ;

			//----------------------
			Panel.label.append(lbl.newLabel("L33",3,4,"Name Extended")) catch unreachable ;
			Panel.label.append(lbl.newLabel("L320",3,20,"Text")) catch unreachable ;
			Panel.label.append(lbl.newLabel("L371",3,71,"MNEMO")) catch unreachable ;
			Panel.label.append(lbl.newLabel("L378",3,78,"T")) catch unreachable ;
			Panel.label.append(lbl.newLabel("L380",3,80,"Long")) catch unreachable ;
			Panel.label.append(lbl.newLabel("L385",3,85,"Width")) catch unreachable ;
			Panel.label.append(lbl.newLabel("L391",3,91,"Scal")) catch unreachable ;

			//----------------------

			Panel.field.append(fld.newFieldTextFree("MNEXTD",4,4,15,
			"",
			true,
			"Le nom est obligantoire",
			"Nom de la zone étendue",
			"")) catch unreachable ;

			Panel.field.append(fld.newFieldTextFree("TEXT",4,20,50,
			"",
			true,
			"Text Invalide",
			"Libellé de la zone NAME Extended",
			"")) catch unreachable ;

			Panel.field.append(fld.newFieldAlphaNumericUpper("MNEMO",4,71,6,
			"",
			true,
			"Mnemonic onmigatoire",
			"mnemoniqque de la zone MXEXTD",
			"")) catch unreachable ;

			Panel.field.append(fld.newFieldFunc("TYPE",4,78,1,
			"?",
			true,
			"Ctype",
			"Type obligatoire",
			"Type de zone")) catch unreachable ;

			Panel.field.append(fld.newFieldUDigit("LONG",4,81,3,
			"",
			true,
			"Longueur de la zone extended Invalide",
			"Longueur de la zone",
			"[0-9]{1,3}")) catch unreachable ;

			Panel.field.append(fld.newFieldUDigit("WIDTH",4,87,3,
			"",
			true,
			"Width Obligatoire",
			"longueur de la zone numérique",
			"[0-9]{1,3}")) catch unreachable ;

			Panel.field.append(fld.newFieldUDigit("SCAL",4,92,3,
			"",
			true,
			"Scal Obligatoire",
			"partie decimale",
			"[0-9]{1,3}")) catch unreachable ;


			return Panel;


	}



	//Errors
	pub const Error = error{
		main_function_Enum_invalide,
		main_run_EnumTask_invalide,
	};





//----------------------------------
//  run emun Function ex: combo
//----------------------------------
	fn Ctype( vpnl : *pnl.PANEL , vfld :* fld.FIELD) void {
		var cellPos:usize = 0;
		const Xcombo : *grd.GRID = grd.newGridC(
				"Ctype",
				5, 78,
				7,
				grd.gridStyle,
				grd.CADRE.line1,
		);

		defer grd.freeGrid(Xcombo);
		defer grd.allocatorGrid.destroy(Xcombo);

		grd.newCell(Xcombo,"Type",4, grd.REFTYP.TEXT_FREE, term.ForegroundColor.fgGreen);
		grd.newCell(Xcombo,"Label",10, grd.REFTYP.TEXT_FREE, term.ForegroundColor.fgYellow);
		grd.setHeaders(Xcombo) ;

		// data
		grd.addRows(Xcombo , &.{"T","Text"});
		grd.addRows(Xcombo , &.{"N","Numéric"});
		grd.addRows(Xcombo , &.{"B","Bool"});

		if (std.mem.eql(u8,vfld.text,"T") == true) 	cellPos = 0;
		if (std.mem.eql(u8,vfld.text,"N") == true) 	cellPos = 1;
		if (std.mem.eql(u8,vfld.text,"B") == true) 	cellPos = 2;

		// Interrogation
		var Gkey :grd.GridSelect = undefined ;
		defer Gkey.Buf.deinit();

		Gkey =grd.ioCombo(Xcombo,cellPos);
		pnl.rstPanel(grd.GRID,Xcombo, vpnl);

		if ( Gkey.Key == kbd.esc ) return ;
		vfld.text = Gkey.Buf.items[0];
		return ;
	}


	const FuncEnum = enum {
		Ftype,

		none,
		fn run(self: FuncEnum, vpnl : *pnl.PANEL, vfld: *fld.FIELD ) void {
			switch (self) {
			.Ftype => Ctype(vpnl,vfld),
			else => dsperr.errorForms(vpnl, Error.main_function_Enum_invalide),
			}
		}
		fn searchFn ( vtext: [] const u8 ) FuncEnum {
			inline for (@typeInfo(FuncEnum).@"enum".fields) |f| {
				if ( std.mem.eql(u8, f.name , vtext) ) return @as(FuncEnum,@enumFromInt(f.value));
			}
			return FuncEnum.none;
		}
	};
	var callFunc: FuncEnum = undefined;



//----------------------------------
//  run emun Task ex: control Field
//----------------------------------
	fn TctlName(vpnl: *pnl.PANEL, vfld: *fld.FIELD) void {
		if (std.mem.eql(u8, vfld.text ,"")) {
			pnl.msgErr(vpnl, "Le nom est obligantoire");
			vpnl.keyField = kbd.task;
		}
	}
	fn TctlMnemo(vpnl: *pnl.PANEL, vfld: *fld.FIELD) void {
		if (std.mem.eql(u8, vfld.text ,"")) {
			pnl.msgErr(vpnl, "Mnemonic onmigatoire");
			vpnl.keyField = kbd.task;
		}
	}
	fn TctrlType(vpnl: *pnl.PANEL, vfld: *fld.FIELD) void {
		if (std.mem.eql(u8, vfld.text ,"")) {
			pnl.msgErr(vpnl, "Type obligatoire");
			vpnl.keyField = kbd.task;
		}
	}
	fn TcrtlLong(vpnl: *pnl.PANEL, vfld: *fld.FIELD) void {
		if (std.mem.eql(u8, vfld.text ,"")) {
			pnl.msgErr(vpnl, "Longueur de la zone extended Invalide");
			vpnl.keyField = kbd.task;
		}
	}
	fn TctrlWidth(vpnl: *pnl.PANEL, vfld: *fld.FIELD) void {
		if (std.mem.eql(u8, vfld.text ,"")) {
			pnl.msgErr(vpnl, "Width Obligatoire");
			vpnl.keyField = kbd.task;
		}
	}
	fn TctrlScal(vpnl: *pnl.PANEL, vfld: *fld.FIELD) void {
		if (std.mem.eql(u8, vfld.text ,"")) {
			pnl.msgErr(vpnl, "Scal Obligatoire");
			vpnl.keyField = kbd.task;
		}
	}


	const TaskEnum = enum {
		TctlName,

		TctlMnemo,

		TctrlType,

		TcrtlLong,

		TctrlWidth,

		TctrlScal,

		none,
		fn run(self: TaskEnum, vpnl : *pnl.PANEL, vfld: *fld.FIELD ) void {
			switch (self) {
			.TctlName => TctlName(vpnl,vfld),
			.TctlMnemo => TctlMnemo(vpnl,vfld),
			.TctrlType => TctrlType(vpnl,vfld),
			.TcrtlLong => TcrtlLong(vpnl,vfld),
			.TctrlWidth => TctrlWidth(vpnl,vfld),
			.TctrlScal => TctrlScal(vpnl,vfld),
			else => dsperr.errorForms(vpnl, Error.main_run_EnumTask_invalide),
			}
		}
		fn searchFn ( vtext: [] const u8 ) TaskEnum {
			inline for (@typeInfo(TaskEnum).@"enum".fields) |f| {
				if ( std.mem.eql(u8, f.name , vtext) ) return @as(TaskEnum,@enumFromInt(f.value));
			}
			return TaskEnum.none;
		}
	};
	var callTask: TaskEnum = undefined;



//----------------------------------
// squelette
//----------------------------------

pub fn main() !void {
// init terminal
term.enableRawMode();
defer term.disableRawMode() ;

// Initialisation
term.titleTerm("MY-TITLE");

term.cls();

// define Panel
var pDEFREP = Panel_DEFREP();

// work Panel-01
term.resizeTerm(pDEFREP.lines,pDEFREP.cols);

// defines the receiving structure of the keyboard
var Tkey : term.Keyboard = undefined ;

	while (true) {
		Tkey.Key = pnl.ioPanel(pDEFREP);
		//--- ---

		switch (Tkey.Key) {
			.func => {
			callFunc = FuncEnum.searchFn(pDEFREP.field.items[pDEFREP.idxfld].procfunc);
			callFunc.run(pDEFREP, &pDEFREP.field.items[pDEFREP.idxfld]);
			},

			// call proc contrôl chek value
			.task => {
			callTask = TaskEnum.searchFn(pDEFREP.field.items[pDEFREP.idxfld].proctask);
			callTask.run(pDEFREP, &pDEFREP.field.items[pDEFREP.idxfld]);
			},

			else => {},

		}

		if (Tkey.Key == kbd.F3) break; // end work
	}

}

