const std = @import("std");
const fmt = std.fmt;


inline fn gen_semaphore_var_name(comptime provider:[]const u8, comptime name: []const u8) 
        *const [provider.len + name.len + 15:0]u8{
    return "sdt_semaphore_" ++ provider ++ "_" ++ name;
}

pub inline fn SDT_DEFINE_SEMAPHORE(comptime provider:[]const u8, comptime name: []const u8) void {
    comptime const sema_name = gen_semaphore_var_name(provider, name);

    const SEMAPHORE = struct {
        var x:u16 = 0;
    };
    @export(SEMAPHORE.x, .{ .name = sema_name, .linkage = .Strong , .section=".probes"});
}


pub inline fn SDT_ENABLED(comptime provider:[]const u8, comptime name: []const u8) bool {
    comptime const sema_name = gen_semaphore_var_name(provider, name);
    
    var ret: u32 = 0;
    asm volatile(
        "movzwl " ++ sema_name ++ "(%%rip), %[ret]"
        : [ret] "=r" (ret)
        :
    );
    return ret != 0;
}

pub inline fn SDT(comptime provider:[]const u8, comptime name: []const u8, args:anytype) void {
    _SDT(provider, name, "0", args);
}

pub inline fn SDT_WITH_SEMAPHORE(comptime provider:[]const u8, comptime name: []const u8, args:anytype) void {
    comptime const sema_name = gen_semaphore_var_name(provider, name);
    _SDT(provider, name, sema_name , args);
}




inline fn _SDT(comptime provider:[]const u8, comptime name: []const u8, comptime sema: []const u8, args:anytype) void {
    comptime const width = blk: {
        const ptr_width = std.builtin.cpu.arch.ptrBitWidth();
        if(ptr_width == 64){
            break :blk " .8byte ";
        } else if(ptr_width == 32){
            break :blk " .4byte ";
        } else {
            unreachable;
        }
    };

    comptime const part1 = 
    \\ 990: nop
    \\ .pushsection .note.stapsdt,"","note"
    \\ .balign 4
    \\ .4byte 992f-991f,994f-993f,3
    \\ 991: .asciz "stapsdt"
    \\ 992: .balign 4
    \\
    ++ " 993:" ++ width ++ "990b" ++ "\n"
    ++ width ++ "0" ++ "\n"
    ++ width ++ sema ++ "\n"
    ++ " .asciz \"" ++ provider ++ "\"\n"
    ++ " .asciz \"" ++ name ++ "\"\n"
    ++ " .asciz \"";

    comptime const part3 =  "\"\n" ++
    \\ 994: .balign 4
    \\ .popsection
    \\
     ;

    comptime var buffer: [200]u8 = undefined;
    comptime var var_name = 'a';
    comptime var arg_index = 0;
    comptime const arg_len = args.len;
    comptime var end = 0;
    inline while(arg_index<arg_len) :(arg_index += 1){
        comptime var h = fmt.bufPrint(buffer[end..], "-{}@%[{c}] ", .{ @sizeOf(@TypeOf(args[arg_index])), var_name}) catch unreachable;
        var_name += 1;
        end += h.len;
    }
    if(end > 0)
        end -= 1;
    
    comptime const result = part1 ++ buffer[0..end] ++ part3;

    if(arg_len == 0){
        asm volatile(
            result
            :
            :
        );
    } else if(arg_len == 1){
        const a = args[0];
        asm volatile(
            result
            :
            :
            [a] "nor" (a),
       );
    } else if(arg_len == 2){
        const a = args[0];
        const b = args[1];
        asm volatile(
            result
            :
            :
            [a] "nor" (a),
            [b] "nor" (b),
       );
    } else if(arg_len == 3) {
        const a = args[0];
        const b = args[1];
        const c = args[2];
        asm volatile(
            result
            :
            :
            [a] "nor" (a),
            [b] "nor" (b),
            [c] "nor" (c),
       );
    } else if(arg_len == 4) {
        const a = args[0];
        const b = args[1];
        const c = args[2];
        const d = args[3];
        asm volatile(
            result
            :
            :
            [a] "nor" (a),
            [b] "nor" (b),
            [c] "nor" (c),
            [d] "nor" (d),
       );
    } else if(arg_len == 5) {
        const a = args[0];
        const b = args[1];
        const c = args[2];
        const d = args[3];
        const e = args[4];
        asm volatile(
            result
            :
            :
            [a] "nor" (a),
            [b] "nor" (b),
            [c] "nor" (c),
            [d] "nor" (d),
            [e] "nor" (e),
       );
    } else if(arg_len == 6) {
        const a = args[0];
        const b = args[1];
        const c = args[2];
        const d = args[3];
        const e = args[4];
        const f = args[5];
        asm volatile(
            result
            :
            :
            [a] "nor" (a),
            [b] "nor" (b),
            [c] "nor" (c),
            [d] "nor" (d),
            [e] "nor" (e),
            [f] "nor" (f),
       );
    } else if(arg_len == 7) {
        const a = args[0];
        const b = args[1];
        const c = args[2];
        const d = args[3];
        const e = args[4];
        const f = args[5];
        const g = args[6];
        asm volatile(
            result
            :
            :
            [a] "nor" (a),
            [b] "nor" (b),
            [c] "nor" (c),
            [d] "nor" (d),
            [e] "nor" (e),
            [f] "nor" (f),
            [g] "nor" (g),
       );
    } else if(arg_len == 8) {
        const a = args[0];
        const b = args[1];
        const c = args[2];
        const d = args[3];
        const e = args[4];
        const f = args[5];
        const g = args[6];
        const h = args[7];
        asm volatile(
            result
            :
            :
            [a] "nor" (a),
            [b] "nor" (b),
            [c] "nor" (c),
            [d] "nor" (d),
            [e] "nor" (e),
            [f] "nor" (f),
            [g] "nor" (g),
            [h] "nor" (h),
       );
    } else {
        @compileLog("too many arguments");
    }
}
