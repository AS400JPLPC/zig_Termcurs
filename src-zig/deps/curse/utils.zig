const std = @import("std");

const utf = @import("std").unicode;

/// terminal Fonction
const term = @import("cursed");
// keyboard
const kbd = @import("cursed").kbd;

// display grid
pub const CTRUE  = "✔";
pub const CFALSE = " ";
// input   field
pub const STRUE  = "✔";
pub const SFALSE = "◉";



pub const CMP = enum {
	LT,
	EQ,
	GT
};


pub const ALIGNS = enum {
	left ,
	rigth
	};


///------------------------------------
/// utility
///------------------------------------

/// Errors that may occur when using String
pub const ErrUtils = error{
				Invalide_subStr_Index,
};


/// Tools for internal variables
//free memory 
var arenaUStr = std.heap.ArenaAllocator.init(std.heap.page_allocator);
pub var  allocStr = arenaUStr.allocator();
pub fn deinitUStr() void {
	arenaUStr.deinit();
	arenaUStr = std.heap.ArenaAllocator.init(std.heap.page_allocator);
	allocStr = arenaUStr.allocator();
}



//const allocstr = std.heap.page_allocator;
/// Iterator support iteration string
pub const iteratStr = struct {
	var strbuf:[] const u8 = undefined;



	/// Errors that may occur when using String
	pub const ErrNbrch = error{
		InvalideAllocBuffer,
	};
	


	pub const StringIterator = struct {
		buf: []u8 ,
		index: usize ,


		fn allocBuffer ( size :usize) ErrNbrch![]u8 {
			var buf = allocStr.alloc(u8, size) catch {
				return ErrNbrch.InvalideAllocBuffer;
			};
			return buf;
		}

		/// Deallocates the internal buffer
		pub fn deinit(self: *StringIterator) void {
			if (self.buf.len > 0)	allocStr.free(self.buf); 
			strbuf = "";
		}

		pub fn next(it: *StringIterator) ?[]const u8 {
			var optional_buf: ?[]u8	= allocBuffer(strbuf.len) catch return null;

 			it.buf= optional_buf orelse "";
			var idx : usize = 0;
			while (true) {
				if (idx >= strbuf.len) break;
				it.buf[idx] = strbuf[idx];
				idx += 1;
			}

			if (it.index == it.buf.len) return null;
			idx = it.index;
			it.index += getUTF8Size(it.buf[idx]);
			return it.buf[idx..it.index];
		}

		pub fn preview(it: *StringIterator) ?[]const u8 {
			var optional_buf: ?[]u8	= allocBuffer(strbuf.len) catch return null;

			it.buf= optional_buf orelse "";
			var idx : usize = 0;
			while (true) {
				if (idx >= strbuf.len) break;
				it.buf[idx] = strbuf[idx];
				idx += 1;
			}

			if (it.index == 0) return null;
			idx = it.buf.len;
			it.index -= getUTF8Size(it.buf[idx]);
			return it.buf[idx..it.index];
		}
	};

	/// iterator String
	pub fn iterator(str:[] const u8) StringIterator {
		strbuf = str;
		return StringIterator{
			.buf = undefined,
			.index = 0,
		};
	}

	/// Returns the UTF-8 character's size
	fn getUTF8Size(char: u8) u3 {
		return std.unicode.utf8ByteSequenceLength(char) 
			catch |err| { @panic(@errorName(err));};
	}
};


/// number characters String
pub fn nbrCharStr(str:[] const u8) usize {
	return std.fmt.count("{s}",.{str});
}



/// remove espace to STRING left and rigth
pub fn trimStr(str:[] const u8) [] const u8{
	var val =std.mem.trim(u8, str ," ");
	return val;
}




/// is String isAlphabetic Latin
pub fn isAlphabeticStr(str:[] const u8) bool {
	
	const result = allocStr.alloc(u8, str.len ) 
		catch |err| { @panic(@errorName(err));};
	defer allocStr.free(result);

	std.mem.copy(u8, result, str);
	var idx:usize = 0;
	var b: bool= true;
	while (idx < result.len) :(idx += 1 ) {
		if (! std.ascii.isAlphabetic(result[idx]) ) b = false ;
	}
	return b;
}




/// is String Upper Latin
pub fn isUpperStr(str:[] const u8) bool {

	const result = allocStr.alloc(u8, str.len ) 
		catch |err| { @panic(@errorName(err));};
	defer allocStr.free(result);

	std.mem.copy(u8, result, str);
	var idx:usize = 0;
	var b: bool= true;
	while (idx < result.len) :(idx += 1 ) {
		if (! std.ascii.isUpper(result[idx]) ) b = false ;
	}
	return b;
}




/// is String Lower Latin
pub fn isLowerStr(str:[] const u8) bool {
	
	const result = allocStr.alloc(u8, str.len ) 
		catch |err| { @panic(@errorName(err));};
	defer allocStr.free(result);

	std.mem.copy(u8, result, str);
	var idx:usize = 0;
	var b: bool= true;
	while (idx < result.len) :(idx+= 1 ) {
		if (! std.ascii.iLower(result[idx]) ) b = false ;
	}
	return b;
}




/// is String isDigit 
pub fn isDigitStr(str:[] const u8) bool {
	var iter = iteratStr.iterator(str);
	defer iter.deinit();
	var b:bool = true;

	while (iter.next()) |ch| {

		var x = utf.utf8Decode(ch)
			catch |err| { @panic(@errorName(err));};
		switch (x) {
			'0'...'9' => continue ,
			else => b = false ,
		}
	}
	return b;
}




/// is String isDecimal
pub fn isDecimalStr(str:[] const u8) bool {
	var iter = iteratStr.iterator(str);
	defer iter.deinit();
	var b:bool = true;
	var idx : usize =0;
	var p: bool = false; // dot
	while (iter.next()) |ch| :( idx += 1) {

		var x = utf.utf8Decode(ch) 
		catch |err| { @panic(@errorName(err));};
		switch (x) {
			'0'...'9' => continue ,

			'.' => {
				if ( p ) b = false 
					else {	p = true ; continue ; }	// control is . unique
			},

			'-' => { if ( idx ==	0 ) continue else b= false ; } ,

			'+' => { if ( idx ==	0 ) continue else b = false ; } ,

			else => b = false ,
		}
	}
	return b;
}


/// is String isDigit 
pub fn isSignedStr(str:[] const u8) bool {
	var iter = iteratStr.iterator(std.mem.trim(u8, str ," "));
	defer iter.deinit();
	var b:bool = false;
	while (iter.next()) |ch| {

		var x = utf.utf8Decode(ch) 
		catch |err| { @panic(@errorName(err));};
		switch (x) {

			'-' => b = true ,

			'+' =>	b = true ,

			else => b = false ,
		}
		break;
	}
	return b;
}



/// is String isLetter
/// testing caracter Keyboard 103
pub fn isLetterStr(str:[] const u8) bool {
	var iter = iteratStr.iterator(str);
	defer iter.deinit();
	var b:bool = true;
	while (iter.next()) |ch| {

		var x = utf.utf8Decode(ch) 
			catch |err| { @panic(@errorName(err));};
		switch (x) {
			'0'...'9' => b = false,
			'&' => b = false,
			'¹' => b = false,
			'²' => b = false,
			'³' => b = false,
			'¼' => b = false,
			'½' => b = false,
			'¾' => b = false,
			'~' => b = false,
			'"' => b = false,
			'#' => b = false,
			'\'' => b = false,
			'{' => b = false,
			'(' => b = false,
			'[' => b = false,
			'-' => b = false,
			'|' => b = false,
			'`' => b = false,
			'_' => b = false,
			'\\' => b = false,
			'^' => b = false,
			'@' => b = false,
			'°' => b = false,
			')' => b = false,
			']' => b = false,
			'+' => b = false,
			'=' => b = false,
			'}' => b = false,
			'€' => b = false,
			'$' => b = false,
			'£' => b = false,
			'¢' => b = false,
			'¥' => b = false,
			'þ' => b = false,
			'¨' => b = false,
			'ø' => b = false,
			'ß' => b = false,
			'‘' => b = false,
			'´' => b = false,
			'%' => b = false,
			'µ' => b = false,
			'*' => b = false,
			'<' => b = false,
			'>' => b = false,
			'«' => b = false,
			'»' => b = false,
			'↕' => b = false,
			'↓' => b = false,
			'↑' => b = false,
			'←' => b = false,
			'→' => b = false,
			'↔' => b = false,
			'↙' => b = false,
			'↘' => b = false,
			'↖' => b = false,
			'↗' => b = false,
			'©' => b = false,
			'®' => b = false,
			'™' => b = false,
			'¬' => b = false,
			'¿' => b = false,
			'?' => b = false,
			',' => b = false,
			'×' => b = false,
			'.' => b = false,
			';' => b = false,
			'÷' => b = false,
			'/' => b = false,
			':' => b = false,
			'¡' => b = false,
			'§' => b = false,
			'!' => b = false,
			else => {},
		}
	}
	return	b ;
}




/// is String isSpecial
// testing caracter Keyboard 103
// force omit ; csv
pub fn isSpecialStr(str:[] const u8) bool {
	var iter = iteratStr.iterator(str);
	defer iter.deinit();
	var b:bool = true;
	while (iter.next()) |ch| {

		var x = utf.utf8Decode(ch) 
						catch |err| { @panic(@errorName(err));};
		switch (x) {
			'&' => continue ,
			'¹' => continue ,
			'²' => continue ,
			'³' => continue ,
			'¼' => continue ,
			'½' => continue ,
			'¾' => continue ,
			'#' => continue ,
			'{' => continue ,
			'(' => continue ,
			'[' => continue ,
			'-' => continue ,
			'|' => continue ,
			'\'' => continue ,
			'@' => continue ,
			'°' => continue ,
			')' => continue ,
			']' => continue ,
			'+' => continue ,
			'=' => continue ,
			'}' => continue ,
			'€' => continue ,
			'$' => continue ,
			'£' => continue ,
			'¢' => continue ,
			'¥' => continue ,
			'%' => continue ,
			'*' => continue ,
			'¿' => continue ,
			'?' => continue ,
			',' => continue ,
			'.' => continue ,
			'÷' => continue ,
			'/' => continue ,
			':' => continue ,
			'¡' => continue ,
			'§' => continue ,
			'!' => continue ,
			'_' => continue ,

			else => b = false ,
		}
	}
	return b;
}




/// is String Punctuation
/// force omit ' ; csv
pub fn isPunct(str:[] const u8,) bool {
	var iter = iteratStr.iterator(str);
	defer iter.deinit();
	var b:bool = true;
	while (iter.next()) |ch| {

		var x = utf.utf8Decode(ch) 
			catch |err| { @panic(@errorName(err));};
		switch (x) {
			'.' => continue ,
			':' => continue ,
			',' => continue ,
			'!' => continue ,
			'-' => continue ,
			'(' => continue ,
			')' => continue ,
			'>' => continue ,
			'<' => continue ,
			'«' => continue ,
			'»' => continue ,
			'`' => continue ,
			'/' => continue ,
			'[' => continue ,
			']' => continue ,
			else =>	b = false ,
		}
	}
	return b ;
}




/// is	String omit char 
pub fn isCarOmit(str: [] const u8) bool {
	var iter = iteratStr.iterator(str);
	defer iter.deinit();
	var b:bool = true;
	while (iter.next()) |ch| {

		var x = utf.utf8Decode(ch) 
			catch |err| { @panic(@errorName(err));};
		switch (x) {
			';' => continue ,
			'~' => continue ,
			'|' => continue ,
			'_' => continue ,
			'"' => continue ,
			'\'' => continue ,
			'\\' => continue ,
			else =>	b = false ,
		}
	}
	return b;
}




/// is String to PASSWORD
/// !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~ 
/// omit , ; / \ _ ` | ~ 
pub fn isPassword(str:[] const u8) bool {
	var iter = iteratStr.iterator(str);
	defer iter.deinit();
	var b:bool = true;
	while (iter.next()) |ch| {

		var x = utf.utf8Decode(ch) 
						catch |err| { @panic(@errorName(err));};
		switch (x) {
			'!' => continue ,
			'#' => continue ,
			'$' => continue ,
			'%' => continue ,
			'&' => continue ,
			'(' => continue ,
			')' => continue ,
			'*' => continue ,
			'+' => continue ,
			'-' => continue ,
			'.' => continue ,
			':' => continue ,
			'<' => continue ,
			'=' => continue ,
			'>' => continue ,
			'?' => continue ,
			'@' => continue ,
			'[' => continue ,
			']' => continue ,
			'^' => continue ,
			'{' => continue ,
			'}' => continue ,

			else => {
				if (isLetterStr(ch)) continue ;
				if (isDigitStr(ch)) continue ;
				b = false ;
			},
		}
		
	}
	return b;
}



/// is String to Mail
/// a-zA-Z 0-9 +.-_@
pub fn isMailStr(str:[] const u8) bool {
	var iter = iteratStr.iterator(str);
	defer iter.deinit();
	var b:bool = true;
	while (iter.next()) |ch| {

		var x = utf.utf8Decode(ch) 
						catch |err| { @panic(@errorName(err));};

		switch (x) {
			'+' => continue ,
			'-' => continue ,
			'_' => continue ,
			'.' => continue ,
			'@' => continue ,
			else => {
				if (x >= 191 and x <= 255 ) return false;
				if (isLetterStr(ch)) continue ;
				if (isDigitStr(ch)) continue ;
				b = false ;
			},
		}
		
	}
	return b;
}




/// upper-case String Latin
pub fn upperStr(str:[] const u8) [] const u8 {
	const result = allocStr.alloc(u8, str.len )
		catch |err| { @panic(@errorName(err));};
	defer allocStr.free(result);

	std.mem.copy(u8, result, str);
	var idx:usize = 0;
	while (idx < result.len) :(idx += 1 ) {
		result[idx] = std.ascii.toUpper(result[idx]);
		}
	return std.fmt.allocPrint(allocStr,"{s}",.{result},)
		catch |err| { @panic(@errorName(err));};
}




/// Lower String Latin
pub fn lowerStr(str:[] const u8) [] const u8 {
	const result = allocStr.alloc(u8, str.len )
		catch |err| { @panic(@errorName(err));};
	defer allocStr.free(result);

	std.mem.copy(u8, result, str);
	var idx:usize = 0;
	while (idx < result.len) :(idx += 1 ) {
		result[idx] = std.ascii.toLower(result[idx]);
		}
	return std.fmt.allocPrint(allocStr,"{s}",.{result},)
		catch |err| { @panic(@errorName(err));};
}




/// concat String
pub fn concatStr( a: []const u8, b: []const u8) []const u8 {
	return std.fmt.allocPrint(allocStr,"{s}{s}",.{a,b},)
		catch |err| { @panic(@errorName(err));};
}







/// comp string
/// LT EQ GT -> enum CMP
pub fn compStr( str1 : [] const u8 , str2 : [] const u8) CMP {

	var c1 = std.fmt.count("{s}",.{str1});
	var c2 = std.fmt.count("{s}",.{str2});

	if (c1 > c2)	return CMP.GT ;
	if (c1 == c2) {
		var idx: u8 = 0;
		var n: i32 = 0;
		while (idx < c1 ) : (idx += 1) {
			if ( str1[idx] < str2[idx]) n -= 1 ;
			if ( str1[idx] > str2[idx]) n += 1 ;
		}
		if ( n < 0 ) return CMP.LT ; 
		if ( n > 0 ) return CMP.GT 
		else return CMP.EQ;
	}
	return CMP.LT ;
}




/// aligned string 
pub fn alignStr(text: []const u8,aligns :ALIGNS, wlen : usize ) []const u8 {

	var idx : usize =0;
	var iter = iteratStr.iterator(text);

	var string: [] const u8 = "" ;

	while (iter.next()) |ch|	{
		idx += 1 ;
		if (idx > wlen) break;
		if (idx == 1 ) string = ch
		else {
			string =	concatStr(string,ch);
		}
	}

	if (aligns == ALIGNS.left) {
		while (idx < wlen)	: (idx += 1) {
			string =	concatStr(string," ");
		}
	}

	if (aligns == ALIGNS.rigth) {
		while (idx < wlen)	: (idx +=1) {
			string =	concatStr(" ",string);
		}
	}

	return string;
}







/// Delete Items ArrayList
pub fn removeListStr(self: *std.ArrayList([]const u8), i: usize) void{

	var LIST = std.ArrayList([] const u8).init(allocStr);
	var idx : usize = 0;
	for (self.items) | val| {
		if ( idx != i-1 ) LIST.append(val) catch |err| { @panic(@errorName(err));};

		idx += 1;
	}
	self.clearAndFree();

	for (LIST.items) | val| {
		self.append(val) catch |err| { @panic(@errorName(err));};
	}
}




/// Add Text ArrayList
pub fn addListStr(self: *std.ArrayList([]const u8), text : []const u8) void{

	var iter = iteratStr.iterator(text);
	defer iter.deinit();

	while (iter.next()) |ch|	{
		self.append(ch) catch |err| { @panic(@errorName(err));};
	}

}




/// ArrayList to String
pub fn listToStr( self: std.ArrayList([]const u8))	[]const u8 {
	var result : []const u8 = "" ;
	for (self.items) |ch| {
		result =	concatStr(result,ch);
	}
	return result;
}




///------- bool--------------

/// bool to str
pub fn boolToStr(v: bool) []const u8 {
	return if (v) "1"	else "0";
}



/// str to bool
pub fn strToBool(v: []const u8) bool {
	return if (std.mem.eql(u8,v, "1")) true	else	false;
}

/// str to switch STRUE/SFALSE bool
pub fn strToCbool(v: []const u8) []const u8 {
	return if (std.mem.eql(u8,v, "1")) STRUE	else SFALSE;
}

/// bool to switch STRUE/SFALSE 
pub fn boolToCbool(v: bool) []const u8 {
	return if	(v == true ) STRUE	else SFALSE;
}

/// switch STRUE/SFALSE bool to bool
pub fn cboolToBool(v: []const u8) bool {
	return if ( std.mem.eql(u8,v, STRUE) ) true	else	false;
}

// switch STRUE / SFALSE bool to str
pub fn cboolToStr(v: []const u8) []const u8 {
	return if ( std.mem.eql(u8,v, STRUE) ) "1"	else	"0";
}
