pub const va_list = __builtin_va_list;
pub const __gnuc_va_list = __builtin_va_list;
pub const __u_char = u8;
pub const __u_short = c_ushort;
pub const __u_int = c_uint;
pub const __u_long = c_ulong;
pub const __int8_t = i8;
pub const __uint8_t = u8;
pub const __int16_t = c_short;
pub const __uint16_t = c_ushort;
pub const __int32_t = c_int;
pub const __uint32_t = c_uint;
pub const __int64_t = c_long;
pub const __uint64_t = c_ulong;
pub const __int_least8_t = __int8_t;
pub const __uint_least8_t = __uint8_t;
pub const __int_least16_t = __int16_t;
pub const __uint_least16_t = __uint16_t;
pub const __int_least32_t = __int32_t;
pub const __uint_least32_t = __uint32_t;
pub const __int_least64_t = __int64_t;
pub const __uint_least64_t = __uint64_t;
pub const __quad_t = c_long;
pub const __u_quad_t = c_ulong;
pub const __intmax_t = c_long;
pub const __uintmax_t = c_ulong;
pub const __dev_t = c_ulong;
pub const __uid_t = c_uint;
pub const __gid_t = c_uint;
pub const __ino_t = c_ulong;
pub const __ino64_t = c_ulong;
pub const __mode_t = c_uint;
pub const __nlink_t = c_ulong;
pub const __off_t = c_long;
pub const __off64_t = c_long;
pub const __pid_t = c_int;
const struct_unnamed_1 = extern struct {
    __val: [2]c_int,
};
pub const __fsid_t = struct_unnamed_1;
pub const __clock_t = c_long;
pub const __rlim_t = c_ulong;
pub const __rlim64_t = c_ulong;
pub const __id_t = c_uint;
pub const __time_t = c_long;
pub const __useconds_t = c_uint;
pub const __suseconds_t = c_long;
pub const __suseconds64_t = c_long;
pub const __daddr_t = c_int;
pub const __key_t = c_int;
pub const __clockid_t = c_int;
pub const __timer_t = ?*c_void;
pub const __blksize_t = c_long;
pub const __blkcnt_t = c_long;
pub const __blkcnt64_t = c_long;
pub const __fsblkcnt_t = c_ulong;
pub const __fsblkcnt64_t = c_ulong;
pub const __fsfilcnt_t = c_ulong;
pub const __fsfilcnt64_t = c_ulong;
pub const __fsword_t = c_long;
pub const __ssize_t = c_long;
pub const __syscall_slong_t = c_long;
pub const __syscall_ulong_t = c_ulong;
pub const __loff_t = __off64_t;
pub const __caddr_t = [*c]u8;
pub const __intptr_t = c_long;
pub const __socklen_t = c_uint;
pub const __sig_atomic_t = c_int;
const union_unnamed_3 = extern union {
    __wch: c_uint,
    __wchb: [4]u8,
};
const struct_unnamed_2 = extern struct {
    __count: c_int,
    __value: union_unnamed_3,
};
pub const __mbstate_t = struct_unnamed_2;
pub const struct__G_fpos_t = extern struct {
    __pos: __off_t,
    __state: __mbstate_t,
};
pub const __fpos_t = struct__G_fpos_t;
pub const struct__G_fpos64_t = extern struct {
    __pos: __off64_t,
    __state: __mbstate_t,
};
pub const __fpos64_t = struct__G_fpos64_t;
pub const struct__IO_marker = opaque {};
pub const struct__IO_codecvt = opaque {};
pub const struct__IO_wide_data = opaque {};
pub const struct__IO_FILE = extern struct {
    _flags: c_int,
    _IO_read_ptr: [*c]u8,
    _IO_read_end: [*c]u8,
    _IO_read_base: [*c]u8,
    _IO_write_base: [*c]u8,
    _IO_write_ptr: [*c]u8,
    _IO_write_end: [*c]u8,
    _IO_buf_base: [*c]u8,
    _IO_buf_end: [*c]u8,
    _IO_save_base: [*c]u8,
    _IO_backup_base: [*c]u8,
    _IO_save_end: [*c]u8,
    _markers: ?*struct__IO_marker,
    _chain: [*c]struct__IO_FILE,
    _fileno: c_int,
    _flags2: c_int,
    _old_offset: __off_t,
    _cur_column: c_ushort,
    _vtable_offset: i8,
    _shortbuf: [1]u8,
    _lock: ?*_IO_lock_t,
    _offset: __off64_t,
    _codecvt: ?*struct__IO_codecvt,
    _wide_data: ?*struct__IO_wide_data,
    _freeres_list: [*c]struct__IO_FILE,
    _freeres_buf: ?*c_void,
    __pad5: usize,
    _mode: c_int,
    _unused2: [20]u8,
};
pub const __FILE = struct__IO_FILE;
pub const FILE = struct__IO_FILE;
pub const _IO_lock_t = c_void;
pub const off_t = __off_t;
pub const fpos_t = __fpos_t;
pub extern var stdin: [*c]FILE;
pub extern var stdout: [*c]FILE;
pub extern var stderr: [*c]FILE;
pub extern fn remove(__filename: [*c]const u8) c_int;
pub extern fn rename(__old: [*c]const u8, __new: [*c]const u8) c_int;
pub extern fn renameat(__oldfd: c_int, __old: [*c]const u8, __newfd: c_int, __new: [*c]const u8) c_int;
pub extern fn tmpfile() [*c]FILE;
pub extern fn tmpnam(__s: [*c]u8) [*c]u8;
pub extern fn tmpnam_r(__s: [*c]u8) [*c]u8;
pub extern fn tempnam(__dir: [*c]const u8, __pfx: [*c]const u8) [*c]u8;
pub extern fn fclose(__stream: [*c]FILE) c_int;
pub extern fn fflush(__stream: [*c]FILE) c_int;
pub extern fn fflush_unlocked(__stream: [*c]FILE) c_int;
pub extern fn fopen(__filename: [*c]const u8, __modes: [*c]const u8) [*c]FILE;
pub extern fn freopen(noalias __filename: [*c]const u8, noalias __modes: [*c]const u8, noalias __stream: [*c]FILE) [*c]FILE;
pub extern fn fdopen(__fd: c_int, __modes: [*c]const u8) [*c]FILE;
pub extern fn fmemopen(__s: ?*c_void, __len: usize, __modes: [*c]const u8) [*c]FILE;
pub extern fn open_memstream(__bufloc: [*c][*c]u8, __sizeloc: [*c]usize) [*c]FILE;
pub extern fn setbuf(noalias __stream: [*c]FILE, noalias __buf: [*c]u8) void;
pub extern fn setvbuf(noalias __stream: [*c]FILE, noalias __buf: [*c]u8, __modes: c_int, __n: usize) c_int;
pub extern fn setbuffer(noalias __stream: [*c]FILE, noalias __buf: [*c]u8, __size: usize) void;
pub extern fn setlinebuf(__stream: [*c]FILE) void;
pub extern fn fprintf(__stream: [*c]FILE, __format: [*c]const u8, ...) c_int;
pub extern fn printf(__format: [*c]const u8, ...) c_int;
pub extern fn sprintf(__s: [*c]u8, __format: [*c]const u8, ...) c_int;
pub const struct___va_list_tag = extern struct {
    gp_offset: c_uint,
    fp_offset: c_uint,
    overflow_arg_area: ?*c_void,
    reg_save_area: ?*c_void,
};
pub extern fn vfprintf(__s: [*c]FILE, __format: [*c]const u8, __arg: [*c]struct___va_list_tag) c_int;
pub fn vprintf(arg___fmt: [*c]const u8, arg___arg: [*c]struct___va_list_tag) callconv(.C) c_int {
    var __fmt = arg___fmt;
    var __arg = arg___arg;
    return vfprintf(stdout, __fmt, __arg);
}
pub extern fn vsprintf(__s: [*c]u8, __format: [*c]const u8, __arg: [*c]struct___va_list_tag) c_int;
pub extern fn snprintf(__s: [*c]u8, __maxlen: c_ulong, __format: [*c]const u8, ...) c_int;
pub extern fn vsnprintf(__s: [*c]u8, __maxlen: c_ulong, __format: [*c]const u8, __arg: [*c]struct___va_list_tag) c_int;
pub extern fn vdprintf(__fd: c_int, noalias __fmt: [*c]const u8, __arg: [*c]struct___va_list_tag) c_int;
pub extern fn dprintf(__fd: c_int, noalias __fmt: [*c]const u8, ...) c_int;
pub extern fn fscanf(noalias __stream: [*c]FILE, noalias __format: [*c]const u8, ...) c_int;
pub extern fn scanf(noalias __format: [*c]const u8, ...) c_int;
pub extern fn sscanf(noalias __s: [*c]const u8, noalias __format: [*c]const u8, ...) c_int;
pub const _Float32 = f32;
pub const _Float64 = f64;
pub const _Float32x = f64;
pub const _Float64x = c_longdouble;
pub extern fn vfscanf(noalias __s: [*c]FILE, noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag) c_int;
pub extern fn vscanf(noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag) c_int;
pub extern fn vsscanf(noalias __s: [*c]const u8, noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag) c_int;
pub extern fn fgetc(__stream: [*c]FILE) c_int;
pub extern fn getc(__stream: [*c]FILE) c_int;
pub fn getchar() callconv(.C) c_int {
    return getc(stdin);
} // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:402:33: warning: TODO implement translation of CastKind BuiltinFnToFnPtr
pub const getc_unlocked = @compileError("unable to translate function"); // /usr/lib/zig/libc/include/generic-glibc/bits/stdio.h:66:1
// /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:402:33: warning: TODO implement translation of CastKind BuiltinFnToFnPtr
pub const getchar_unlocked = @compileError("unable to translate function"); // /usr/lib/zig/libc/include/generic-glibc/bits/stdio.h:73:1
// /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:402:33: warning: TODO implement translation of CastKind BuiltinFnToFnPtr
pub const fgetc_unlocked = @compileError("unable to translate function"); // /usr/lib/zig/libc/include/generic-glibc/bits/stdio.h:56:1
pub extern fn fputc(__c: c_int, __stream: [*c]FILE) c_int;
pub extern fn putc(__c: c_int, __stream: [*c]FILE) c_int;
pub fn putchar(arg___c: c_int) callconv(.C) c_int {
    var __c = arg___c;
    return putc(__c, stdout);
} // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:402:33: warning: TODO implement translation of CastKind BuiltinFnToFnPtr
pub const fputc_unlocked = @compileError("unable to translate function"); // /usr/lib/zig/libc/include/generic-glibc/bits/stdio.h:91:1
// /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:402:33: warning: TODO implement translation of CastKind BuiltinFnToFnPtr
pub const putc_unlocked = @compileError("unable to translate function"); // /usr/lib/zig/libc/include/generic-glibc/bits/stdio.h:101:1
// /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:402:33: warning: TODO implement translation of CastKind BuiltinFnToFnPtr
pub const putchar_unlocked = @compileError("unable to translate function"); // /usr/lib/zig/libc/include/generic-glibc/bits/stdio.h:108:1
pub extern fn getw(__stream: [*c]FILE) c_int;
pub extern fn putw(__w: c_int, __stream: [*c]FILE) c_int;
pub extern fn fgets(noalias __s: [*c]u8, __n: c_int, noalias __stream: [*c]FILE) [*c]u8;
pub extern fn __getdelim(noalias __lineptr: [*c][*c]u8, noalias __n: [*c]usize, __delimiter: c_int, noalias __stream: [*c]FILE) __ssize_t;
pub extern fn getdelim(noalias __lineptr: [*c][*c]u8, noalias __n: [*c]usize, __delimiter: c_int, noalias __stream: [*c]FILE) __ssize_t;
pub extern fn getline(noalias __lineptr: [*c][*c]u8, noalias __n: [*c]usize, noalias __stream: [*c]FILE) __ssize_t;
pub extern fn fputs(noalias __s: [*c]const u8, noalias __stream: [*c]FILE) c_int;
pub extern fn puts(__s: [*c]const u8) c_int;
pub extern fn ungetc(__c: c_int, __stream: [*c]FILE) c_int;
pub extern fn fread(__ptr: ?*c_void, __size: c_ulong, __n: c_ulong, __stream: [*c]FILE) c_ulong;
pub extern fn fwrite(__ptr: ?*const c_void, __size: c_ulong, __n: c_ulong, __s: [*c]FILE) c_ulong;
pub extern fn fread_unlocked(noalias __ptr: ?*c_void, __size: usize, __n: usize, noalias __stream: [*c]FILE) usize;
pub extern fn fwrite_unlocked(noalias __ptr: ?*const c_void, __size: usize, __n: usize, noalias __stream: [*c]FILE) usize;
pub extern fn fseek(__stream: [*c]FILE, __off: c_long, __whence: c_int) c_int;
pub extern fn ftell(__stream: [*c]FILE) c_long;
pub extern fn rewind(__stream: [*c]FILE) void;
pub extern fn fseeko(__stream: [*c]FILE, __off: __off_t, __whence: c_int) c_int;
pub extern fn ftello(__stream: [*c]FILE) __off_t;
pub extern fn fgetpos(noalias __stream: [*c]FILE, noalias __pos: [*c]fpos_t) c_int;
pub extern fn fsetpos(__stream: [*c]FILE, __pos: [*c]const fpos_t) c_int;
pub extern fn clearerr(__stream: [*c]FILE) void;
pub extern fn feof(__stream: [*c]FILE) c_int;
pub extern fn ferror(__stream: [*c]FILE) c_int;
pub extern fn clearerr_unlocked(__stream: [*c]FILE) void;
pub fn feof_unlocked(arg___stream: [*c]FILE) callconv(.C) c_int {
    var __stream = arg___stream;
    return (((__stream).*._flags & @as(c_int, 16)) != @as(c_int, 0));
}
pub fn ferror_unlocked(arg___stream: [*c]FILE) callconv(.C) c_int {
    var __stream = arg___stream;
    return (((__stream).*._flags & @as(c_int, 32)) != @as(c_int, 0));
}
pub extern fn perror(__s: [*c]const u8) void;
pub extern fn fileno(__stream: [*c]FILE) c_int;
pub extern fn fileno_unlocked(__stream: [*c]FILE) c_int;
pub extern fn popen(__command: [*c]const u8, __modes: [*c]const u8) [*c]FILE;
pub extern fn pclose(__stream: [*c]FILE) c_int;
pub extern fn ctermid(__s: [*c]u8) [*c]u8;
pub extern fn flockfile(__stream: [*c]FILE) void;
pub extern fn ftrylockfile(__stream: [*c]FILE) c_int;
pub extern fn funlockfile(__stream: [*c]FILE) void;
pub extern fn __uflow([*c]FILE) c_int;
pub extern fn __overflow([*c]FILE, c_int) c_int;
pub const STBI_default = @enumToInt(enum_unnamed_4.STBI_default);
pub const STBI_grey = @enumToInt(enum_unnamed_4.STBI_grey);
pub const STBI_grey_alpha = @enumToInt(enum_unnamed_4.STBI_grey_alpha);
pub const STBI_rgb = @enumToInt(enum_unnamed_4.STBI_rgb);
pub const STBI_rgb_alpha = @enumToInt(enum_unnamed_4.STBI_rgb_alpha);
const enum_unnamed_4 = extern enum(c_int) {
    STBI_default = 0,
    STBI_grey = 1,
    STBI_grey_alpha = 2,
    STBI_rgb = 3,
    STBI_rgb_alpha = 4,
    _,
};
pub const wchar_t = c_int;
const struct_unnamed_5 = extern struct {
    quot: c_int,
    rem: c_int,
};
pub const div_t = struct_unnamed_5;
const struct_unnamed_6 = extern struct {
    quot: c_long,
    rem: c_long,
};
pub const ldiv_t = struct_unnamed_6;
const struct_unnamed_7 = extern struct {
    quot: c_longlong,
    rem: c_longlong,
};
pub const lldiv_t = struct_unnamed_7;
pub extern fn __ctype_get_mb_cur_max() usize;
pub fn atof(arg___nptr: [*c]const u8) callconv(.C) f64 {
    var __nptr = arg___nptr;
    return strtod(__nptr, @ptrCast([*c][*c]u8, @alignCast(@alignOf([*c]u8), (@intToPtr(?*c_void, @as(c_int, 0))))));
}
pub fn atoi(arg___nptr: [*c]const u8) callconv(.C) c_int {
    var __nptr = arg___nptr;
    return @bitCast(c_int, @truncate(c_int, strtol(__nptr, @ptrCast([*c][*c]u8, @alignCast(@alignOf([*c]u8), (@intToPtr(?*c_void, @as(c_int, 0))))), @as(c_int, 10))));
}
pub fn atol(arg___nptr: [*c]const u8) callconv(.C) c_long {
    var __nptr = arg___nptr;
    return strtol(__nptr, @ptrCast([*c][*c]u8, @alignCast(@alignOf([*c]u8), (@intToPtr(?*c_void, @as(c_int, 0))))), @as(c_int, 10));
}
pub fn atoll(arg___nptr: [*c]const u8) callconv(.C) c_longlong {
    var __nptr = arg___nptr;
    return strtoll(__nptr, @ptrCast([*c][*c]u8, @alignCast(@alignOf([*c]u8), (@intToPtr(?*c_void, @as(c_int, 0))))), @as(c_int, 10));
}
pub extern fn strtod(__nptr: [*c]const u8, __endptr: [*c][*c]u8) f64;
pub extern fn strtof(__nptr: [*c]const u8, __endptr: [*c][*c]u8) f32;
pub extern fn strtold(__nptr: [*c]const u8, __endptr: [*c][*c]u8) c_longdouble;
pub extern fn strtol(__nptr: [*c]const u8, __endptr: [*c][*c]u8, __base: c_int) c_long;
pub extern fn strtoul(__nptr: [*c]const u8, __endptr: [*c][*c]u8, __base: c_int) c_ulong;
pub extern fn strtoq(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8, __base: c_int) c_longlong;
pub extern fn strtouq(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8, __base: c_int) c_ulonglong;
pub extern fn strtoll(__nptr: [*c]const u8, __endptr: [*c][*c]u8, __base: c_int) c_longlong;
pub extern fn strtoull(__nptr: [*c]const u8, __endptr: [*c][*c]u8, __base: c_int) c_ulonglong;
pub extern fn l64a(__n: c_long) [*c]u8;
pub extern fn a64l(__s: [*c]const u8) c_long;
pub const u_char = __u_char;
pub const u_short = __u_short;
pub const u_int = __u_int;
pub const u_long = __u_long;
pub const quad_t = __quad_t;
pub const u_quad_t = __u_quad_t;
pub const fsid_t = __fsid_t;
pub const loff_t = __loff_t;
pub const ino_t = __ino_t;
pub const dev_t = __dev_t;
pub const gid_t = __gid_t;
pub const mode_t = __mode_t;
pub const nlink_t = __nlink_t;
pub const uid_t = __uid_t;
pub const pid_t = __pid_t;
pub const id_t = __id_t;
pub const daddr_t = __daddr_t;
pub const caddr_t = __caddr_t;
pub const key_t = __key_t;
pub const clock_t = __clock_t;
pub const clockid_t = __clockid_t;
pub const time_t = __time_t;
pub const timer_t = __timer_t;
pub const ulong = c_ulong;
pub const ushort = c_ushort;
pub const uint = c_uint;
pub const u_int8_t = __uint8_t;
pub const u_int16_t = __uint16_t;
pub const u_int32_t = __uint32_t;
pub const u_int64_t = __uint64_t;
pub const register_t = c_long;
pub fn __bswap_16(arg___bsx: __uint16_t) callconv(.C) __uint16_t {
    var __bsx = arg___bsx;
    return (@bitCast(__uint16_t, @truncate(c_short, (((@bitCast(c_int, @as(c_uint, (__bsx))) >> @intCast(@import("std").math.Log2Int(c_int), 8)) & @as(c_int, 255)) | ((@bitCast(c_int, @as(c_uint, (__bsx))) & @as(c_int, 255)) << @intCast(@import("std").math.Log2Int(c_int), 8))))));
}
pub fn __bswap_32(arg___bsx: __uint32_t) callconv(.C) __uint32_t {
    var __bsx = arg___bsx;
    return ((((((__bsx) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24)) | (((__bsx) & @as(c_uint, 16711680)) >> @intCast(@import("std").math.Log2Int(c_uint), 8))) | (((__bsx) & @as(c_uint, 65280)) << @intCast(@import("std").math.Log2Int(c_uint), 8))) | (((__bsx) & @as(c_uint, 255)) << @intCast(@import("std").math.Log2Int(c_uint), 24)));
}
pub fn __bswap_64(arg___bsx: __uint64_t) callconv(.C) __uint64_t {
    var __bsx = arg___bsx;
    return @bitCast(__uint64_t, @truncate(c_ulong, (((((((((@bitCast(c_ulonglong, @as(c_ulonglong, (__bsx))) & @as(c_ulonglong, 18374686479671623680)) >> @intCast(@import("std").math.Log2Int(c_ulonglong), 56)) | ((@bitCast(c_ulonglong, @as(c_ulonglong, (__bsx))) & @as(c_ulonglong, 71776119061217280)) >> @intCast(@import("std").math.Log2Int(c_ulonglong), 40))) | ((@bitCast(c_ulonglong, @as(c_ulonglong, (__bsx))) & @as(c_ulonglong, 280375465082880)) >> @intCast(@import("std").math.Log2Int(c_ulonglong), 24))) | ((@bitCast(c_ulonglong, @as(c_ulonglong, (__bsx))) & @as(c_ulonglong, 1095216660480)) >> @intCast(@import("std").math.Log2Int(c_ulonglong), 8))) | ((@bitCast(c_ulonglong, @as(c_ulonglong, (__bsx))) & @as(c_ulonglong, 4278190080)) << @intCast(@import("std").math.Log2Int(c_ulonglong), 8))) | ((@bitCast(c_ulonglong, @as(c_ulonglong, (__bsx))) & @as(c_ulonglong, 16711680)) << @intCast(@import("std").math.Log2Int(c_ulonglong), 24))) | ((@bitCast(c_ulonglong, @as(c_ulonglong, (__bsx))) & @as(c_ulonglong, 65280)) << @intCast(@import("std").math.Log2Int(c_ulonglong), 40))) | ((@bitCast(c_ulonglong, @as(c_ulonglong, (__bsx))) & @as(c_ulonglong, 255)) << @intCast(@import("std").math.Log2Int(c_ulonglong), 56)))));
}
pub fn __uint16_identity(arg___x: __uint16_t) callconv(.C) __uint16_t {
    var __x = arg___x;
    return __x;
}
pub fn __uint32_identity(arg___x: __uint32_t) callconv(.C) __uint32_t {
    var __x = arg___x;
    return __x;
}
pub fn __uint64_identity(arg___x: __uint64_t) callconv(.C) __uint64_t {
    var __x = arg___x;
    return __x;
}
const struct_unnamed_8 = extern struct {
    __val: [16]c_ulong,
};
pub const __sigset_t = struct_unnamed_8;
pub const sigset_t = __sigset_t;
pub const struct_timeval = extern struct {
    tv_sec: __time_t,
    tv_usec: __suseconds_t,
};
pub const struct_timespec = extern struct {
    tv_sec: __time_t,
    tv_nsec: __syscall_slong_t,
};
pub const suseconds_t = __suseconds_t;
pub const __fd_mask = c_long;
const struct_unnamed_9 = extern struct {
    __fds_bits: [16]__fd_mask,
};
pub const fd_set = struct_unnamed_9;
pub const fd_mask = __fd_mask;
pub extern fn select(__nfds: c_int, noalias __readfds: [*c]fd_set, noalias __writefds: [*c]fd_set, noalias __exceptfds: [*c]fd_set, noalias __timeout: [*c]struct_timeval) c_int;
pub extern fn pselect(__nfds: c_int, noalias __readfds: [*c]fd_set, noalias __writefds: [*c]fd_set, noalias __exceptfds: [*c]fd_set, noalias __timeout: [*c]const struct_timespec, noalias __sigmask: [*c]const __sigset_t) c_int;
pub const blksize_t = __blksize_t;
pub const blkcnt_t = __blkcnt_t;
pub const fsblkcnt_t = __fsblkcnt_t;
pub const fsfilcnt_t = __fsfilcnt_t;
pub const struct___pthread_internal_list = extern struct {
    __prev: [*c]struct___pthread_internal_list,
    __next: [*c]struct___pthread_internal_list,
};
pub const __pthread_list_t = struct___pthread_internal_list;
pub const struct___pthread_internal_slist = extern struct {
    __next: [*c]struct___pthread_internal_slist,
};
pub const __pthread_slist_t = struct___pthread_internal_slist;
pub const struct___pthread_mutex_s = extern struct {
    __lock: c_int,
    __count: c_uint,
    __owner: c_int,
    __nusers: c_uint,
    __kind: c_int,
    __spins: c_short,
    __elision: c_short,
    __list: __pthread_list_t,
};
pub const struct___pthread_rwlock_arch_t = extern struct {
    __readers: c_uint,
    __writers: c_uint,
    __wrphase_futex: c_uint,
    __writers_futex: c_uint,
    __pad3: c_uint,
    __pad4: c_uint,
    __cur_writer: c_int,
    __shared: c_int,
    __rwelision: i8,
    __pad1: [7]u8,
    __pad2: c_ulong,
    __flags: c_uint,
};
const struct_unnamed_11 = extern struct {
    __low: c_uint,
    __high: c_uint,
};
const union_unnamed_10 = extern union {
    __wseq: c_ulonglong,
    __wseq32: struct_unnamed_11,
};
const struct_unnamed_13 = extern struct {
    __low: c_uint,
    __high: c_uint,
};
const union_unnamed_12 = extern union {
    __g1_start: c_ulonglong,
    __g1_start32: struct_unnamed_13,
};
pub const struct___pthread_cond_s = extern struct {
    unnamed_0: union_unnamed_10,
    unnamed_1: union_unnamed_12,
    __g_refs: [2]c_uint,
    __g_size: [2]c_uint,
    __g1_orig_size: c_uint,
    __wrefs: c_uint,
    __g_signals: [2]c_uint,
};
pub const __tss_t = c_uint;
pub const __thrd_t = c_ulong;
const struct_unnamed_14 = extern struct {
    __data: c_int,
};
pub const __once_flag = struct_unnamed_14;
pub const pthread_t = c_ulong;
const union_unnamed_15 = extern union {
    __size: [4]u8,
    __align: c_int,
};
pub const pthread_mutexattr_t = union_unnamed_15;
const union_unnamed_16 = extern union {
    __size: [4]u8,
    __align: c_int,
};
pub const pthread_condattr_t = union_unnamed_16;
pub const pthread_key_t = c_uint;
pub const pthread_once_t = c_int;
pub const union_pthread_attr_t = extern union {
    __size: [56]u8,
    __align: c_long,
};
pub const pthread_attr_t = union_pthread_attr_t;
const union_unnamed_17 = extern union {
    __data: struct___pthread_mutex_s,
    __size: [40]u8,
    __align: c_long,
};
pub const pthread_mutex_t = union_unnamed_17;
const union_unnamed_18 = extern union {
    __data: struct___pthread_cond_s,
    __size: [48]u8,
    __align: c_longlong,
};
pub const pthread_cond_t = union_unnamed_18;
const union_unnamed_19 = extern union {
    __data: struct___pthread_rwlock_arch_t,
    __size: [56]u8,
    __align: c_long,
};
pub const pthread_rwlock_t = union_unnamed_19;
const union_unnamed_20 = extern union {
    __size: [8]u8,
    __align: c_long,
};
pub const pthread_rwlockattr_t = union_unnamed_20;
pub const pthread_spinlock_t = c_int;
const union_unnamed_21 = extern union {
    __size: [32]u8,
    __align: c_long,
};
pub const pthread_barrier_t = union_unnamed_21;
const union_unnamed_22 = extern union {
    __size: [4]u8,
    __align: c_int,
};
pub const pthread_barrierattr_t = union_unnamed_22;
pub extern fn random() c_long;
pub extern fn srandom(__seed: c_uint) void;
pub extern fn initstate(__seed: c_uint, __statebuf: [*c]u8, __statelen: usize) [*c]u8;
pub extern fn setstate(__statebuf: [*c]u8) [*c]u8;
pub const struct_random_data = extern struct {
    fptr: [*c]i32,
    rptr: [*c]i32,
    state: [*c]i32,
    rand_type: c_int,
    rand_deg: c_int,
    rand_sep: c_int,
    end_ptr: [*c]i32,
};
pub extern fn random_r(noalias __buf: [*c]struct_random_data, noalias __result: [*c]i32) c_int;
pub extern fn srandom_r(__seed: c_uint, __buf: [*c]struct_random_data) c_int;
pub extern fn initstate_r(__seed: c_uint, noalias __statebuf: [*c]u8, __statelen: usize, noalias __buf: [*c]struct_random_data) c_int;
pub extern fn setstate_r(noalias __statebuf: [*c]u8, noalias __buf: [*c]struct_random_data) c_int;
pub extern fn rand() c_int;
pub extern fn srand(__seed: c_uint) void;
pub extern fn rand_r(__seed: [*c]c_uint) c_int;
pub extern fn drand48() f64;
pub extern fn erand48(__xsubi: [*c]c_ushort) f64;
pub extern fn lrand48() c_long;
pub extern fn nrand48(__xsubi: [*c]c_ushort) c_long;
pub extern fn mrand48() c_long;
pub extern fn jrand48(__xsubi: [*c]c_ushort) c_long;
pub extern fn srand48(__seedval: c_long) void;
pub extern fn seed48(__seed16v: [*c]c_ushort) [*c]c_ushort;
pub extern fn lcong48(__param: [*c]c_ushort) void;
pub const struct_drand48_data = extern struct {
    __x: [3]c_ushort,
    __old_x: [3]c_ushort,
    __c: c_ushort,
    __init: c_ushort,
    __a: c_ulonglong,
};
pub extern fn drand48_r(noalias __buffer: [*c]struct_drand48_data, noalias __result: [*c]f64) c_int;
pub extern fn erand48_r(__xsubi: [*c]c_ushort, noalias __buffer: [*c]struct_drand48_data, noalias __result: [*c]f64) c_int;
pub extern fn lrand48_r(noalias __buffer: [*c]struct_drand48_data, noalias __result: [*c]c_long) c_int;
pub extern fn nrand48_r(__xsubi: [*c]c_ushort, noalias __buffer: [*c]struct_drand48_data, noalias __result: [*c]c_long) c_int;
pub extern fn mrand48_r(noalias __buffer: [*c]struct_drand48_data, noalias __result: [*c]c_long) c_int;
pub extern fn jrand48_r(__xsubi: [*c]c_ushort, noalias __buffer: [*c]struct_drand48_data, noalias __result: [*c]c_long) c_int;
pub extern fn srand48_r(__seedval: c_long, __buffer: [*c]struct_drand48_data) c_int;
pub extern fn seed48_r(__seed16v: [*c]c_ushort, __buffer: [*c]struct_drand48_data) c_int;
pub extern fn lcong48_r(__param: [*c]c_ushort, __buffer: [*c]struct_drand48_data) c_int;
pub extern fn malloc(__size: c_ulong) ?*c_void;
pub extern fn calloc(__nmemb: c_ulong, __size: c_ulong) ?*c_void;
pub extern fn realloc(__ptr: ?*c_void, __size: c_ulong) ?*c_void;
pub extern fn reallocarray(__ptr: ?*c_void, __nmemb: usize, __size: usize) ?*c_void;
pub extern fn free(__ptr: ?*c_void) void;
pub extern fn alloca(__size: c_ulong) ?*c_void;
pub extern fn valloc(__size: usize) ?*c_void;
pub extern fn posix_memalign(__memptr: [*c]?*c_void, __alignment: usize, __size: usize) c_int;
pub extern fn aligned_alloc(__alignment: usize, __size: usize) ?*c_void;
pub extern fn abort() noreturn;
pub extern fn atexit(__func: ?fn () callconv(.C) void) c_int;
pub extern fn at_quick_exit(__func: ?fn () callconv(.C) void) c_int;
pub extern fn on_exit(__func: ?fn (c_int, ?*c_void) callconv(.C) void, __arg: ?*c_void) c_int;
pub extern fn exit(__status: c_int) noreturn;
pub extern fn quick_exit(__status: c_int) noreturn;
pub extern fn _Exit(__status: c_int) noreturn;
pub extern fn getenv(__name: [*c]const u8) [*c]u8;
pub extern fn putenv(__string: [*c]u8) c_int;
pub extern fn setenv(__name: [*c]const u8, __value: [*c]const u8, __replace: c_int) c_int;
pub extern fn unsetenv(__name: [*c]const u8) c_int;
pub extern fn clearenv() c_int;
pub extern fn mktemp(__template: [*c]u8) [*c]u8;
pub extern fn mkstemp(__template: [*c]u8) c_int;
pub extern fn mkstemps(__template: [*c]u8, __suffixlen: c_int) c_int;
pub extern fn mkdtemp(__template: [*c]u8) [*c]u8;
pub extern fn system(__command: [*c]const u8) c_int;
pub extern fn realpath(noalias __name: [*c]const u8, noalias __resolved: [*c]u8) [*c]u8;
pub const __compar_fn_t = ?fn (?*const c_void, ?*const c_void) callconv(.C) c_int;
pub fn bsearch(arg___key: ?*const c_void, arg___base: ?*const c_void, arg___nmemb: usize, arg___size: usize, arg___compar: __compar_fn_t) callconv(.C) ?*c_void {
    var __key = arg___key;
    var __base = arg___base;
    var __nmemb = arg___nmemb;
    var __size = arg___size;
    var __compar = arg___compar;
    var __l: usize = undefined;
    var __u: usize = undefined;
    var __idx: usize = undefined;
    var __p: ?*const c_void = undefined;
    var __comparison: c_int = undefined;
    __l = @bitCast(usize, @as(c_long, @as(c_int, 0)));
    __u = __nmemb;
    while (__l < __u) {
        __idx = ((__l +% __u) / @bitCast(c_ulong, @as(c_long, @as(c_int, 2))));
        __p = @intToPtr(?*c_void, @ptrToInt(((@ptrCast([*c]const u8, @alignCast(@alignOf(u8), __base))) + (__idx *% __size))));
        __comparison = (__compar).?(__key, __p);
        if (__comparison < @as(c_int, 0)) __u = __idx else if (__comparison > @as(c_int, 0)) __l = (__idx +% @bitCast(c_ulong, @as(c_long, @as(c_int, 1)))) else return @intToPtr(?*c_void, @ptrToInt(__p));
    }
    return (@intToPtr(?*c_void, @as(c_int, 0)));
}
pub extern fn qsort(__base: ?*c_void, __nmemb: usize, __size: usize, __compar: __compar_fn_t) void;
pub extern fn abs(__x: c_int) c_int;
pub extern fn labs(__x: c_long) c_long;
pub extern fn llabs(__x: c_longlong) c_longlong;
pub extern fn div(__numer: c_int, __denom: c_int) div_t;
pub extern fn ldiv(__numer: c_long, __denom: c_long) ldiv_t;
pub extern fn lldiv(__numer: c_longlong, __denom: c_longlong) lldiv_t;
pub extern fn ecvt(__value: f64, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int) [*c]u8;
pub extern fn fcvt(__value: f64, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int) [*c]u8;
pub extern fn gcvt(__value: f64, __ndigit: c_int, __buf: [*c]u8) [*c]u8;
pub extern fn qecvt(__value: c_longdouble, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int) [*c]u8;
pub extern fn qfcvt(__value: c_longdouble, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int) [*c]u8;
pub extern fn qgcvt(__value: c_longdouble, __ndigit: c_int, __buf: [*c]u8) [*c]u8;
pub extern fn ecvt_r(__value: f64, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int, noalias __buf: [*c]u8, __len: usize) c_int;
pub extern fn fcvt_r(__value: f64, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int, noalias __buf: [*c]u8, __len: usize) c_int;
pub extern fn qecvt_r(__value: c_longdouble, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int, noalias __buf: [*c]u8, __len: usize) c_int;
pub extern fn qfcvt_r(__value: c_longdouble, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int, noalias __buf: [*c]u8, __len: usize) c_int;
pub extern fn mblen(__s: [*c]const u8, __n: usize) c_int;
pub extern fn mbtowc(noalias __pwc: [*c]wchar_t, noalias __s: [*c]const u8, __n: usize) c_int;
pub extern fn wctomb(__s: [*c]u8, __wchar: wchar_t) c_int;
pub extern fn mbstowcs(noalias __pwcs: [*c]wchar_t, noalias __s: [*c]const u8, __n: usize) usize;
pub extern fn wcstombs(noalias __s: [*c]u8, noalias __pwcs: [*c]const wchar_t, __n: usize) usize;
pub extern fn rpmatch(__response: [*c]const u8) c_int;
pub extern fn getsubopt(noalias __optionp: [*c][*c]u8, noalias __tokens: [*c]const [*c]u8, noalias __valuep: [*c][*c]u8) c_int;
pub extern fn getloadavg(__loadavg: [*c]f64, __nelem: c_int) c_int;
pub const stbi_uc = u8;
pub const stbi_us = c_ushort;
const struct_unnamed_23 = extern struct {
    read: ?fn (?*c_void, [*c]u8, c_int) callconv(.C) c_int,
    skip: ?fn (?*c_void, c_int) callconv(.C) void,
    eof: ?fn (?*c_void) callconv(.C) c_int,
};
pub const stbi_io_callbacks = struct_unnamed_23;
pub extern fn stbi_load_from_memory(buffer: [*c]const stbi_uc, len: c_int, x: [*c]c_int, y: [*c]c_int, channels_in_file: [*c]c_int, desired_channels: c_int) [*c]stbi_uc;
pub extern fn stbi_load_from_callbacks(clbk: [*c]const stbi_io_callbacks, user: ?*c_void, x: [*c]c_int, y: [*c]c_int, channels_in_file: [*c]c_int, desired_channels: c_int) [*c]stbi_uc;
pub extern fn stbi_load(filename: [*c]const u8, x: [*c]c_int, y: [*c]c_int, channels_in_file: [*c]c_int, desired_channels: c_int) [*c]stbi_uc;
pub extern fn stbi_load_from_file(f: [*c]FILE, x: [*c]c_int, y: [*c]c_int, channels_in_file: [*c]c_int, desired_channels: c_int) [*c]stbi_uc;
pub extern fn stbi_load_gif_from_memory(buffer: [*c]const stbi_uc, len: c_int, delays: [*c][*c]c_int, x: [*c]c_int, y: [*c]c_int, z: [*c]c_int, comp: [*c]c_int, req_comp: c_int) [*c]stbi_uc;
pub extern fn stbi_load_16_from_memory(buffer: [*c]const stbi_uc, len: c_int, x: [*c]c_int, y: [*c]c_int, channels_in_file: [*c]c_int, desired_channels: c_int) [*c]stbi_us;
pub extern fn stbi_load_16_from_callbacks(clbk: [*c]const stbi_io_callbacks, user: ?*c_void, x: [*c]c_int, y: [*c]c_int, channels_in_file: [*c]c_int, desired_channels: c_int) [*c]stbi_us;
pub extern fn stbi_load_16(filename: [*c]const u8, x: [*c]c_int, y: [*c]c_int, channels_in_file: [*c]c_int, desired_channels: c_int) [*c]stbi_us;
pub extern fn stbi_load_from_file_16(f: [*c]FILE, x: [*c]c_int, y: [*c]c_int, channels_in_file: [*c]c_int, desired_channels: c_int) [*c]stbi_us;
pub extern fn stbi_loadf_from_memory(buffer: [*c]const stbi_uc, len: c_int, x: [*c]c_int, y: [*c]c_int, channels_in_file: [*c]c_int, desired_channels: c_int) [*c]f32;
pub extern fn stbi_loadf_from_callbacks(clbk: [*c]const stbi_io_callbacks, user: ?*c_void, x: [*c]c_int, y: [*c]c_int, channels_in_file: [*c]c_int, desired_channels: c_int) [*c]f32;
pub extern fn stbi_loadf(filename: [*c]const u8, x: [*c]c_int, y: [*c]c_int, channels_in_file: [*c]c_int, desired_channels: c_int) [*c]f32;
pub extern fn stbi_loadf_from_file(f: [*c]FILE, x: [*c]c_int, y: [*c]c_int, channels_in_file: [*c]c_int, desired_channels: c_int) [*c]f32;
pub extern fn stbi_hdr_to_ldr_gamma(gamma: f32) void;
pub extern fn stbi_hdr_to_ldr_scale(scale: f32) void;
pub extern fn stbi_ldr_to_hdr_gamma(gamma: f32) void;
pub extern fn stbi_ldr_to_hdr_scale(scale: f32) void;
pub extern fn stbi_is_hdr_from_callbacks(clbk: [*c]const stbi_io_callbacks, user: ?*c_void) c_int;
pub extern fn stbi_is_hdr_from_memory(buffer: [*c]const stbi_uc, len: c_int) c_int;
pub extern fn stbi_is_hdr(filename: [*c]const u8) c_int;
pub extern fn stbi_is_hdr_from_file(f: [*c]FILE) c_int;
pub extern fn stbi_failure_reason() [*c]const u8;
pub extern fn stbi_image_free(retval_from_stbi_load: ?*c_void) void;
pub extern fn stbi_info_from_memory(buffer: [*c]const stbi_uc, len: c_int, x: [*c]c_int, y: [*c]c_int, comp: [*c]c_int) c_int;
pub extern fn stbi_info_from_callbacks(clbk: [*c]const stbi_io_callbacks, user: ?*c_void, x: [*c]c_int, y: [*c]c_int, comp: [*c]c_int) c_int;
pub extern fn stbi_is_16_bit_from_memory(buffer: [*c]const stbi_uc, len: c_int) c_int;
pub extern fn stbi_is_16_bit_from_callbacks(clbk: [*c]const stbi_io_callbacks, user: ?*c_void) c_int;
pub extern fn stbi_info(filename: [*c]const u8, x: [*c]c_int, y: [*c]c_int, comp: [*c]c_int) c_int;
pub extern fn stbi_info_from_file(f: [*c]FILE, x: [*c]c_int, y: [*c]c_int, comp: [*c]c_int) c_int;
pub extern fn stbi_is_16_bit(filename: [*c]const u8) c_int;
pub extern fn stbi_is_16_bit_from_file(f: [*c]FILE) c_int;
pub extern fn stbi_set_unpremultiply_on_load(flag_true_if_should_unpremultiply: c_int) void;
pub extern fn stbi_convert_iphone_png_to_rgb(flag_true_if_should_convert: c_int) void;
pub extern fn stbi_set_flip_vertically_on_load(flag_true_if_should_flip: c_int) void;
pub extern fn stbi_set_flip_vertically_on_load_thread(flag_true_if_should_flip: c_int) void;
pub extern fn stbi_zlib_decode_malloc_guesssize(buffer: [*c]const u8, len: c_int, initial_size: c_int, outlen: [*c]c_int) [*c]u8;
pub extern fn stbi_zlib_decode_malloc_guesssize_headerflag(buffer: [*c]const u8, len: c_int, initial_size: c_int, outlen: [*c]c_int, parse_header: c_int) [*c]u8;
pub extern fn stbi_zlib_decode_malloc(buffer: [*c]const u8, len: c_int, outlen: [*c]c_int) [*c]u8;
pub extern fn stbi_zlib_decode_buffer(obuffer: [*c]u8, olen: c_int, ibuffer: [*c]const u8, ilen: c_int) c_int;
pub extern fn stbi_zlib_decode_noheader_malloc(buffer: [*c]const u8, len: c_int, outlen: [*c]c_int) [*c]u8;
pub extern fn stbi_zlib_decode_noheader_buffer(obuffer: [*c]u8, olen: c_int, ibuffer: [*c]const u8, ilen: c_int) c_int;
pub const __INTMAX_TYPE__ = @compileError("unable to translate C expr: unexpected token .Keyword_int"); // (no file):62:9
pub const __UINTMAX_TYPE__ = @compileError("unable to translate C expr: unexpected token .Keyword_unsigned"); // (no file):66:9
pub const __PTRDIFF_TYPE__ = @compileError("unable to translate C expr: unexpected token .Keyword_int"); // (no file):73:9
pub const __INTPTR_TYPE__ = @compileError("unable to translate C expr: unexpected token .Keyword_int"); // (no file):77:9
pub const __SIZE_TYPE__ = @compileError("unable to translate C expr: unexpected token .Keyword_unsigned"); // (no file):81:9
pub const __UINTPTR_TYPE__ = @compileError("unable to translate C expr: unexpected token .Keyword_unsigned"); // (no file):96:9
pub const __INT64_TYPE__ = @compileError("unable to translate C expr: unexpected token .Keyword_int"); // (no file):159:9
pub const __UINT64_TYPE__ = @compileError("unable to translate C expr: unexpected token .Keyword_unsigned"); // (no file):187:9
pub const __INT_LEAST64_TYPE__ = @compileError("unable to translate C expr: unexpected token .Keyword_int"); // (no file):225:9
pub const __UINT_LEAST64_TYPE__ = @compileError("unable to translate C expr: unexpected token .Keyword_unsigned"); // (no file):229:9
pub const __INT_FAST64_TYPE__ = @compileError("unable to translate C expr: unexpected token .Keyword_int"); // (no file):265:9
pub const __UINT_FAST64_TYPE__ = @compileError("unable to translate C expr: unexpected token .Keyword_unsigned"); // (no file):269:9
pub const __GLIBC_USE = @compileError("unable to translate C expr: unexpected token .HashHash"); // /usr/lib/zig/libc/include/generic-glibc/features.h:179:9
pub const __NTH = @compileError("unable to translate C expr: unexpected token .Identifier"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:57:11
pub const __NTHNL = @compileError("unable to translate C expr: unexpected token .Identifier"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:58:11
pub const __CONCAT = @compileError("unable to translate C expr: unexpected token .HashHash"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:105:9
pub const __STRING = @compileError("unable to translate C expr: unexpected token .Hash"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:106:9
pub const __ptr_t = @compileError("unable to translate C expr: unexpected token .Nl"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:109:9
pub const __warndecl = @compileError("unable to translate C expr: unexpected token .Keyword_extern"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:133:10
pub const __warnattr = @compileError("unable to translate C expr: unexpected token .Nl"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:134:10
pub const __errordecl = @compileError("unable to translate C expr: unexpected token .Keyword_extern"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:135:10
pub const __flexarr = @compileError("unable to translate C expr: unexpected token .LBracket"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:143:10
pub const __REDIRECT = @compileError("unable to translate C expr: unexpected token .Hash"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:174:10
pub const __REDIRECT_NTH = @compileError("unable to translate C expr: unexpected token .Hash"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:181:11
pub const __REDIRECT_NTHNL = @compileError("unable to translate C expr: unexpected token .Hash"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:183:11
pub const __ASMNAME2 = @compileError("unable to translate C expr: unexpected token .Identifier"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:187:10
pub const __attribute_alloc_size__ = @compileError("unable to translate C expr: unexpected token .Nl"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:219:10
pub const __extern_inline = @compileError("unable to translate C expr: unexpected token .Keyword_extern"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:346:11
pub const __extern_always_inline = @compileError("unable to translate C expr: unexpected token .Keyword_extern"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:347:11
pub const __attribute_copy__ = @compileError("unable to translate C expr: unexpected token .Nl"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:441:10
pub const __LDBL_REDIR2_DECL = @compileError("unable to translate C expr: unexpected token .Nl"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:512:10
pub const __LDBL_REDIR_DECL = @compileError("unable to translate C expr: unexpected token .Nl"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:513:10
pub const __glibc_macro_warning1 = @compileError("unable to translate C expr: unexpected token .Hash"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:527:10
pub const __attr_access = @compileError("unable to translate C expr: unexpected token .Nl"); // /usr/lib/zig/libc/include/generic-glibc/sys/cdefs.h:559:11
pub const __S16_TYPE = @compileError("unable to translate C expr: unexpected token .Keyword_int"); // /usr/lib/zig/libc/include/generic-glibc/bits/types.h:109:9
pub const __U16_TYPE = @compileError("unable to translate C expr: unexpected token .Keyword_int"); // /usr/lib/zig/libc/include/generic-glibc/bits/types.h:110:9
pub const __SLONGWORD_TYPE = @compileError("unable to translate C expr: unexpected token .Keyword_int"); // /usr/lib/zig/libc/include/generic-glibc/bits/types.h:113:9
pub const __ULONGWORD_TYPE = @compileError("unable to translate C expr: unexpected token .Keyword_int"); // /usr/lib/zig/libc/include/generic-glibc/bits/types.h:114:9
pub const __SQUAD_TYPE = @compileError("unable to translate C expr: unexpected token .Keyword_int"); // /usr/lib/zig/libc/include/generic-glibc/bits/types.h:128:10
pub const __UQUAD_TYPE = @compileError("unable to translate C expr: unexpected token .Keyword_int"); // /usr/lib/zig/libc/include/generic-glibc/bits/types.h:129:10
pub const __SWORD_TYPE = @compileError("unable to translate C expr: unexpected token .Keyword_int"); // /usr/lib/zig/libc/include/generic-glibc/bits/types.h:130:10
pub const __UWORD_TYPE = @compileError("unable to translate C expr: unexpected token .Keyword_int"); // /usr/lib/zig/libc/include/generic-glibc/bits/types.h:131:10
pub const __S64_TYPE = @compileError("unable to translate C expr: unexpected token .Keyword_int"); // /usr/lib/zig/libc/include/generic-glibc/bits/types.h:134:10
pub const __U64_TYPE = @compileError("unable to translate C expr: unexpected token .Keyword_int"); // /usr/lib/zig/libc/include/generic-glibc/bits/types.h:135:10
pub const __STD_TYPE = @compileError("unable to translate C expr: unexpected token .Keyword_typedef"); // /usr/lib/zig/libc/include/generic-glibc/bits/types.h:137:10
pub const __TIMER_T_TYPE = @compileError("unable to translate C expr: unexpected token .Nl"); // /usr/lib/zig/libc/include/x86_64-linux-gnu/bits/typesizes.h:71:9
pub const __FSID_T_TYPE = @compileError("unable to translate C expr: unexpected token .Keyword_struct"); // /usr/lib/zig/libc/include/x86_64-linux-gnu/bits/typesizes.h:73:9
pub const __getc_unlocked_body = @compileError("TODO postfix inc/dec expr"); // /usr/lib/zig/libc/include/generic-glibc/bits/types/struct_FILE.h:102:9
pub const __putc_unlocked_body = @compileError("TODO postfix inc/dec expr"); // /usr/lib/zig/libc/include/generic-glibc/bits/types/struct_FILE.h:106:9
pub const __f32 = @compileError("unable to translate C expr: unexpected token .HashHash"); // /usr/lib/zig/libc/include/generic-glibc/bits/floatn-common.h:91:12
pub const __f64x = @compileError("unable to translate C expr: unexpected token .HashHash"); // /usr/lib/zig/libc/include/generic-glibc/bits/floatn-common.h:120:13
pub const __CFLOAT32 = @compileError("unable to translate C expr: unexpected token .Keyword_complex"); // /usr/lib/zig/libc/include/generic-glibc/bits/floatn-common.h:149:12
pub const __CFLOAT64 = @compileError("unable to translate C expr: unexpected token .Keyword_complex"); // /usr/lib/zig/libc/include/generic-glibc/bits/floatn-common.h:160:13
pub const __CFLOAT32X = @compileError("unable to translate C expr: unexpected token .Keyword_complex"); // /usr/lib/zig/libc/include/generic-glibc/bits/floatn-common.h:169:12
pub const __CFLOAT64X = @compileError("unable to translate C expr: unexpected token .Keyword_complex"); // /usr/lib/zig/libc/include/generic-glibc/bits/floatn-common.h:178:13
pub const __builtin_huge_valf32 = @compileError("unable to translate C expr: unexpected token .RParen"); // /usr/lib/zig/libc/include/generic-glibc/bits/floatn-common.h:218:12
pub const __builtin_inff32 = @compileError("unable to translate C expr: unexpected token .RParen"); // /usr/lib/zig/libc/include/generic-glibc/bits/floatn-common.h:219:12
pub const __builtin_huge_valf64 = @compileError("unable to translate C expr: unexpected token .RParen"); // /usr/lib/zig/libc/include/generic-glibc/bits/floatn-common.h:255:13
pub const __builtin_inff64 = @compileError("unable to translate C expr: unexpected token .RParen"); // /usr/lib/zig/libc/include/generic-glibc/bits/floatn-common.h:256:13
pub const __builtin_huge_valf32x = @compileError("unable to translate C expr: unexpected token .RParen"); // /usr/lib/zig/libc/include/generic-glibc/bits/floatn-common.h:272:12
pub const __builtin_inff32x = @compileError("unable to translate C expr: unexpected token .RParen"); // /usr/lib/zig/libc/include/generic-glibc/bits/floatn-common.h:273:12
pub const __builtin_huge_valf64x = @compileError("unable to translate C expr: unexpected token .RParen"); // /usr/lib/zig/libc/include/generic-glibc/bits/floatn-common.h:289:13
pub const __builtin_inff64x = @compileError("unable to translate C expr: unexpected token .RParen"); // /usr/lib/zig/libc/include/generic-glibc/bits/floatn-common.h:290:13
pub const MB_CUR_MAX = @compileError("unable to translate C expr: unexpected token .RParen"); // /usr/lib/zig/libc/include/generic-glibc/stdlib.h:96:9
pub const __FD_ZERO = @compileError("unable to translate C expr: unexpected token .Keyword_do"); // /usr/lib/zig/libc/include/generic-glibc/bits/select.h:25:9
pub const __FD_SET = @compileError("unable to translate C expr: expected ')''"); // /usr/lib/zig/libc/include/generic-glibc/bits/select.h:32:9
pub const __FD_CLR = @compileError("unable to translate C expr: expected ')''"); // /usr/lib/zig/libc/include/generic-glibc/bits/select.h:34:9
pub const _SIGSET_NWORDS = @compileError("unable to translate C expr: expected ')'"); // /usr/lib/zig/libc/include/generic-glibc/bits/types/__sigset_t.h:4:9
pub const __PTHREAD_MUTEX_INITIALIZER = @compileError("unable to translate C expr: unexpected token .LBrace"); // /usr/lib/zig/libc/include/x86_64-linux-gnu/bits/struct_mutex.h:56:10
pub const __PTHREAD_RWLOCK_ELISION_EXTRA = @compileError("unable to translate C expr: unexpected token .LBrace"); // /usr/lib/zig/libc/include/x86_64-linux-gnu/bits/struct_rwlock.h:40:11
pub const __ONCE_FLAG_INIT = @compileError("unable to translate C expr: unexpected token .LBrace"); // /usr/lib/zig/libc/include/generic-glibc/bits/thread-shared-types.h:127:9
pub const STBIDEF = @compileError("unable to translate C expr: unexpected token .Keyword_extern"); // stb_image.h:367:9
pub const __llvm__ = 1;
pub const __clang__ = 1;
pub const __clang_major__ = 11;
pub const __clang_minor__ = 0;
pub const __clang_patchlevel__ = 1;
pub const __clang_version__ = "11.0.1 ";
pub const __GNUC__ = 4;
pub const __GNUC_MINOR__ = 2;
pub const __GNUC_PATCHLEVEL__ = 1;
pub const __GXX_ABI_VERSION = 1002;
pub const __ATOMIC_RELAXED = 0;
pub const __ATOMIC_CONSUME = 1;
pub const __ATOMIC_ACQUIRE = 2;
pub const __ATOMIC_RELEASE = 3;
pub const __ATOMIC_ACQ_REL = 4;
pub const __ATOMIC_SEQ_CST = 5;
pub const __OPENCL_MEMORY_SCOPE_WORK_ITEM = 0;
pub const __OPENCL_MEMORY_SCOPE_WORK_GROUP = 1;
pub const __OPENCL_MEMORY_SCOPE_DEVICE = 2;
pub const __OPENCL_MEMORY_SCOPE_ALL_SVM_DEVICES = 3;
pub const __OPENCL_MEMORY_SCOPE_SUB_GROUP = 4;
pub const __PRAGMA_REDEFINE_EXTNAME = 1;
pub const __VERSION__ = "Clang 11.0.1";
pub const __OBJC_BOOL_IS_BOOL = 0;
pub const __CONSTANT_CFSTRINGS__ = 1;
pub const __OPTIMIZE__ = 1;
pub const __ORDER_LITTLE_ENDIAN__ = 1234;
pub const __ORDER_BIG_ENDIAN__ = 4321;
pub const __ORDER_PDP_ENDIAN__ = 3412;
pub const __BYTE_ORDER__ = __ORDER_LITTLE_ENDIAN__;
pub const __LITTLE_ENDIAN__ = 1;
pub const _LP64 = 1;
pub const __LP64__ = 1;
pub const __CHAR_BIT__ = 8;
pub const __SCHAR_MAX__ = 127;
pub const __SHRT_MAX__ = 32767;
pub const __INT_MAX__ = 2147483647;
pub const __LONG_MAX__ = @as(c_long, 9223372036854775807);
pub const __LONG_LONG_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __WCHAR_MAX__ = 2147483647;
pub const __WINT_MAX__ = @as(c_uint, 4294967295);
pub const __INTMAX_MAX__ = @as(c_long, 9223372036854775807);
pub const __SIZE_MAX__ = @as(c_ulong, 18446744073709551615);
pub const __UINTMAX_MAX__ = @as(c_ulong, 18446744073709551615);
pub const __PTRDIFF_MAX__ = @as(c_long, 9223372036854775807);
pub const __INTPTR_MAX__ = @as(c_long, 9223372036854775807);
pub const __UINTPTR_MAX__ = @as(c_ulong, 18446744073709551615);
pub const __SIZEOF_DOUBLE__ = 8;
pub const __SIZEOF_FLOAT__ = 4;
pub const __SIZEOF_INT__ = 4;
pub const __SIZEOF_LONG__ = 8;
pub const __SIZEOF_LONG_DOUBLE__ = 16;
pub const __SIZEOF_LONG_LONG__ = 8;
pub const __SIZEOF_POINTER__ = 8;
pub const __SIZEOF_SHORT__ = 2;
pub const __SIZEOF_PTRDIFF_T__ = 8;
pub const __SIZEOF_SIZE_T__ = 8;
pub const __SIZEOF_WCHAR_T__ = 4;
pub const __SIZEOF_WINT_T__ = 4;
pub const __SIZEOF_INT128__ = 16;
pub const __INTMAX_FMTd__ = "ld";
pub const __INTMAX_FMTi__ = "li";
pub const __INTMAX_C_SUFFIX__ = L;
pub const __UINTMAX_FMTo__ = "lo";
pub const __UINTMAX_FMTu__ = "lu";
pub const __UINTMAX_FMTx__ = "lx";
pub const __UINTMAX_FMTX__ = "lX";
pub const __UINTMAX_C_SUFFIX__ = UL;
pub const __INTMAX_WIDTH__ = 64;
pub const __PTRDIFF_FMTd__ = "ld";
pub const __PTRDIFF_FMTi__ = "li";
pub const __PTRDIFF_WIDTH__ = 64;
pub const __INTPTR_FMTd__ = "ld";
pub const __INTPTR_FMTi__ = "li";
pub const __INTPTR_WIDTH__ = 64;
pub const __SIZE_FMTo__ = "lo";
pub const __SIZE_FMTu__ = "lu";
pub const __SIZE_FMTx__ = "lx";
pub const __SIZE_FMTX__ = "lX";
pub const __SIZE_WIDTH__ = 64;
pub const __WCHAR_TYPE__ = c_int;
pub const __WCHAR_WIDTH__ = 32;
pub const __WINT_TYPE__ = c_uint;
pub const __WINT_WIDTH__ = 32;
pub const __SIG_ATOMIC_WIDTH__ = 32;
pub const __SIG_ATOMIC_MAX__ = 2147483647;
pub const __CHAR16_TYPE__ = c_ushort;
pub const __CHAR32_TYPE__ = c_uint;
pub const __UINTMAX_WIDTH__ = 64;
pub const __UINTPTR_FMTo__ = "lo";
pub const __UINTPTR_FMTu__ = "lu";
pub const __UINTPTR_FMTx__ = "lx";
pub const __UINTPTR_FMTX__ = "lX";
pub const __UINTPTR_WIDTH__ = 64;
pub const __FLT_DENORM_MIN__ = @as(f32, 1.40129846e-45);
pub const __FLT_HAS_DENORM__ = 1;
pub const __FLT_DIG__ = 6;
pub const __FLT_DECIMAL_DIG__ = 9;
pub const __FLT_EPSILON__ = @as(f32, 1.19209290e-7);
pub const __FLT_HAS_INFINITY__ = 1;
pub const __FLT_HAS_QUIET_NAN__ = 1;
pub const __FLT_MANT_DIG__ = 24;
pub const __FLT_MAX_10_EXP__ = 38;
pub const __FLT_MAX_EXP__ = 128;
pub const __FLT_MAX__ = @as(f32, 3.40282347e+38);
pub const __FLT_MIN_10_EXP__ = -37;
pub const __FLT_MIN_EXP__ = -125;
pub const __FLT_MIN__ = @as(f32, 1.17549435e-38);
pub const __DBL_DENORM_MIN__ = 4.9406564584124654e-324;
pub const __DBL_HAS_DENORM__ = 1;
pub const __DBL_DIG__ = 15;
pub const __DBL_DECIMAL_DIG__ = 17;
pub const __DBL_EPSILON__ = 2.2204460492503131e-16;
pub const __DBL_HAS_INFINITY__ = 1;
pub const __DBL_HAS_QUIET_NAN__ = 1;
pub const __DBL_MANT_DIG__ = 53;
pub const __DBL_MAX_10_EXP__ = 308;
pub const __DBL_MAX_EXP__ = 1024;
pub const __DBL_MAX__ = 1.7976931348623157e+308;
pub const __DBL_MIN_10_EXP__ = -307;
pub const __DBL_MIN_EXP__ = -1021;
pub const __DBL_MIN__ = 2.2250738585072014e-308;
pub const __LDBL_DENORM_MIN__ = @as(c_longdouble, 3.64519953188247460253e-4951);
pub const __LDBL_HAS_DENORM__ = 1;
pub const __LDBL_DIG__ = 18;
pub const __LDBL_DECIMAL_DIG__ = 21;
pub const __LDBL_EPSILON__ = @as(c_longdouble, 1.08420217248550443401e-19);
pub const __LDBL_HAS_INFINITY__ = 1;
pub const __LDBL_HAS_QUIET_NAN__ = 1;
pub const __LDBL_MANT_DIG__ = 64;
pub const __LDBL_MAX_10_EXP__ = 4932;
pub const __LDBL_MAX_EXP__ = 16384;
pub const __LDBL_MAX__ = @as(c_longdouble, 1.18973149535723176502e+4932);
pub const __LDBL_MIN_10_EXP__ = -4931;
pub const __LDBL_MIN_EXP__ = -16381;
pub const __LDBL_MIN__ = @as(c_longdouble, 3.36210314311209350626e-4932);
pub const __POINTER_WIDTH__ = 64;
pub const __BIGGEST_ALIGNMENT__ = 16;
pub const __WINT_UNSIGNED__ = 1;
pub const __INT8_TYPE__ = i8;
pub const __INT8_FMTd__ = "hhd";
pub const __INT8_FMTi__ = "hhi";
pub const __INT16_TYPE__ = c_short;
pub const __INT16_FMTd__ = "hd";
pub const __INT16_FMTi__ = "hi";
pub const __INT32_TYPE__ = c_int;
pub const __INT32_FMTd__ = "d";
pub const __INT32_FMTi__ = "i";
pub const __INT64_FMTd__ = "ld";
pub const __INT64_FMTi__ = "li";
pub const __INT64_C_SUFFIX__ = L;
pub const __UINT8_TYPE__ = u8;
pub const __UINT8_FMTo__ = "hho";
pub const __UINT8_FMTu__ = "hhu";
pub const __UINT8_FMTx__ = "hhx";
pub const __UINT8_FMTX__ = "hhX";
pub const __UINT8_MAX__ = 255;
pub const __INT8_MAX__ = 127;
pub const __UINT16_TYPE__ = c_ushort;
pub const __UINT16_FMTo__ = "ho";
pub const __UINT16_FMTu__ = "hu";
pub const __UINT16_FMTx__ = "hx";
pub const __UINT16_FMTX__ = "hX";
pub const __UINT16_MAX__ = 65535;
pub const __INT16_MAX__ = 32767;
pub const __UINT32_TYPE__ = c_uint;
pub const __UINT32_FMTo__ = "o";
pub const __UINT32_FMTu__ = "u";
pub const __UINT32_FMTx__ = "x";
pub const __UINT32_FMTX__ = "X";
pub const __UINT32_C_SUFFIX__ = U;
pub const __UINT32_MAX__ = @as(c_uint, 4294967295);
pub const __INT32_MAX__ = 2147483647;
pub const __UINT64_FMTo__ = "lo";
pub const __UINT64_FMTu__ = "lu";
pub const __UINT64_FMTx__ = "lx";
pub const __UINT64_FMTX__ = "lX";
pub const __UINT64_C_SUFFIX__ = UL;
pub const __UINT64_MAX__ = @as(c_ulong, 18446744073709551615);
pub const __INT64_MAX__ = @as(c_long, 9223372036854775807);
pub const __INT_LEAST8_TYPE__ = i8;
pub const __INT_LEAST8_MAX__ = 127;
pub const __INT_LEAST8_FMTd__ = "hhd";
pub const __INT_LEAST8_FMTi__ = "hhi";
pub const __UINT_LEAST8_TYPE__ = u8;
pub const __UINT_LEAST8_MAX__ = 255;
pub const __UINT_LEAST8_FMTo__ = "hho";
pub const __UINT_LEAST8_FMTu__ = "hhu";
pub const __UINT_LEAST8_FMTx__ = "hhx";
pub const __UINT_LEAST8_FMTX__ = "hhX";
pub const __INT_LEAST16_TYPE__ = c_short;
pub const __INT_LEAST16_MAX__ = 32767;
pub const __INT_LEAST16_FMTd__ = "hd";
pub const __INT_LEAST16_FMTi__ = "hi";
pub const __UINT_LEAST16_TYPE__ = c_ushort;
pub const __UINT_LEAST16_MAX__ = 65535;
pub const __UINT_LEAST16_FMTo__ = "ho";
pub const __UINT_LEAST16_FMTu__ = "hu";
pub const __UINT_LEAST16_FMTx__ = "hx";
pub const __UINT_LEAST16_FMTX__ = "hX";
pub const __INT_LEAST32_TYPE__ = c_int;
pub const __INT_LEAST32_MAX__ = 2147483647;
pub const __INT_LEAST32_FMTd__ = "d";
pub const __INT_LEAST32_FMTi__ = "i";
pub const __UINT_LEAST32_TYPE__ = c_uint;
pub const __UINT_LEAST32_MAX__ = @as(c_uint, 4294967295);
pub const __UINT_LEAST32_FMTo__ = "o";
pub const __UINT_LEAST32_FMTu__ = "u";
pub const __UINT_LEAST32_FMTx__ = "x";
pub const __UINT_LEAST32_FMTX__ = "X";
pub const __INT_LEAST64_MAX__ = @as(c_long, 9223372036854775807);
pub const __INT_LEAST64_FMTd__ = "ld";
pub const __INT_LEAST64_FMTi__ = "li";
pub const __UINT_LEAST64_MAX__ = @as(c_ulong, 18446744073709551615);
pub const __UINT_LEAST64_FMTo__ = "lo";
pub const __UINT_LEAST64_FMTu__ = "lu";
pub const __UINT_LEAST64_FMTx__ = "lx";
pub const __UINT_LEAST64_FMTX__ = "lX";
pub const __INT_FAST8_TYPE__ = i8;
pub const __INT_FAST8_MAX__ = 127;
pub const __INT_FAST8_FMTd__ = "hhd";
pub const __INT_FAST8_FMTi__ = "hhi";
pub const __UINT_FAST8_TYPE__ = u8;
pub const __UINT_FAST8_MAX__ = 255;
pub const __UINT_FAST8_FMTo__ = "hho";
pub const __UINT_FAST8_FMTu__ = "hhu";
pub const __UINT_FAST8_FMTx__ = "hhx";
pub const __UINT_FAST8_FMTX__ = "hhX";
pub const __INT_FAST16_TYPE__ = c_short;
pub const __INT_FAST16_MAX__ = 32767;
pub const __INT_FAST16_FMTd__ = "hd";
pub const __INT_FAST16_FMTi__ = "hi";
pub const __UINT_FAST16_TYPE__ = c_ushort;
pub const __UINT_FAST16_MAX__ = 65535;
pub const __UINT_FAST16_FMTo__ = "ho";
pub const __UINT_FAST16_FMTu__ = "hu";
pub const __UINT_FAST16_FMTx__ = "hx";
pub const __UINT_FAST16_FMTX__ = "hX";
pub const __INT_FAST32_TYPE__ = c_int;
pub const __INT_FAST32_MAX__ = 2147483647;
pub const __INT_FAST32_FMTd__ = "d";
pub const __INT_FAST32_FMTi__ = "i";
pub const __UINT_FAST32_TYPE__ = c_uint;
pub const __UINT_FAST32_MAX__ = @as(c_uint, 4294967295);
pub const __UINT_FAST32_FMTo__ = "o";
pub const __UINT_FAST32_FMTu__ = "u";
pub const __UINT_FAST32_FMTx__ = "x";
pub const __UINT_FAST32_FMTX__ = "X";
pub const __INT_FAST64_MAX__ = @as(c_long, 9223372036854775807);
pub const __INT_FAST64_FMTd__ = "ld";
pub const __INT_FAST64_FMTi__ = "li";
pub const __UINT_FAST64_MAX__ = @as(c_ulong, 18446744073709551615);
pub const __UINT_FAST64_FMTo__ = "lo";
pub const __UINT_FAST64_FMTu__ = "lu";
pub const __UINT_FAST64_FMTx__ = "lx";
pub const __UINT_FAST64_FMTX__ = "lX";
pub const __FINITE_MATH_ONLY__ = 0;
pub const __GNUC_STDC_INLINE__ = 1;
pub const __GCC_ATOMIC_TEST_AND_SET_TRUEVAL = 1;
pub const __CLANG_ATOMIC_BOOL_LOCK_FREE = 2;
pub const __CLANG_ATOMIC_CHAR_LOCK_FREE = 2;
pub const __CLANG_ATOMIC_CHAR16_T_LOCK_FREE = 2;
pub const __CLANG_ATOMIC_CHAR32_T_LOCK_FREE = 2;
pub const __CLANG_ATOMIC_WCHAR_T_LOCK_FREE = 2;
pub const __CLANG_ATOMIC_SHORT_LOCK_FREE = 2;
pub const __CLANG_ATOMIC_INT_LOCK_FREE = 2;
pub const __CLANG_ATOMIC_LONG_LOCK_FREE = 2;
pub const __CLANG_ATOMIC_LLONG_LOCK_FREE = 2;
pub const __CLANG_ATOMIC_POINTER_LOCK_FREE = 2;
pub const __GCC_ATOMIC_BOOL_LOCK_FREE = 2;
pub const __GCC_ATOMIC_CHAR_LOCK_FREE = 2;
pub const __GCC_ATOMIC_CHAR16_T_LOCK_FREE = 2;
pub const __GCC_ATOMIC_CHAR32_T_LOCK_FREE = 2;
pub const __GCC_ATOMIC_WCHAR_T_LOCK_FREE = 2;
pub const __GCC_ATOMIC_SHORT_LOCK_FREE = 2;
pub const __GCC_ATOMIC_INT_LOCK_FREE = 2;
pub const __GCC_ATOMIC_LONG_LOCK_FREE = 2;
pub const __GCC_ATOMIC_LLONG_LOCK_FREE = 2;
pub const __GCC_ATOMIC_POINTER_LOCK_FREE = 2;
pub const __PIC__ = 2;
pub const __pic__ = 2;
pub const __FLT_EVAL_METHOD__ = 0;
pub const __FLT_RADIX__ = 2;
pub const __DECIMAL_DIG__ = __LDBL_DECIMAL_DIG__;
pub const __SSP_STRONG__ = 2;
pub const __GCC_ASM_FLAG_OUTPUTS__ = 1;
pub const __code_model_small__ = 1;
pub const __amd64__ = 1;
pub const __amd64 = 1;
pub const __x86_64 = 1;
pub const __x86_64__ = 1;
pub const __SEG_GS = 1;
pub const __SEG_FS = 1;
pub const __seg_gs = __attribute__(address_space(256));
pub const __seg_fs = __attribute__(address_space(257));
pub const __corei7 = 1;
pub const __corei7__ = 1;
pub const __tune_corei7__ = 1;
pub const __NO_MATH_INLINES = 1;
pub const __AES__ = 1;
pub const __PCLMUL__ = 1;
pub const __LZCNT__ = 1;
pub const __RDRND__ = 1;
pub const __FSGSBASE__ = 1;
pub const __BMI__ = 1;
pub const __BMI2__ = 1;
pub const __POPCNT__ = 1;
pub const __RTM__ = 1;
pub const __PRFCHW__ = 1;
pub const __RDSEED__ = 1;
pub const __ADX__ = 1;
pub const __MOVBE__ = 1;
pub const __FMA__ = 1;
pub const __F16C__ = 1;
pub const __FXSR__ = 1;
pub const __XSAVE__ = 1;
pub const __XSAVEOPT__ = 1;
pub const __XSAVEC__ = 1;
pub const __XSAVES__ = 1;
pub const __CLFLUSHOPT__ = 1;
pub const __SGX__ = 1;
pub const __INVPCID__ = 1;
pub const __AVX2__ = 1;
pub const __AVX__ = 1;
pub const __SSE4_2__ = 1;
pub const __SSE4_1__ = 1;
pub const __SSSE3__ = 1;
pub const __SSE3__ = 1;
pub const __SSE2__ = 1;
pub const __SSE2_MATH__ = 1;
pub const __SSE__ = 1;
pub const __SSE_MATH__ = 1;
pub const __MMX__ = 1;
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 = 1;
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 = 1;
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 = 1;
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 = 1;
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_16 = 1;
pub const __SIZEOF_FLOAT128__ = 16;
pub const unix = 1;
pub const __unix = 1;
pub const __unix__ = 1;
pub const linux = 1;
pub const __linux = 1;
pub const __linux__ = 1;
pub const __ELF__ = 1;
pub const __gnu_linux__ = 1;
pub const __FLOAT128__ = 1;
pub const __STDC__ = 1;
pub const __STDC_HOSTED__ = 1;
pub const __STDC_VERSION__ = @as(c_long, 201710);
pub const __STDC_UTF_16__ = 1;
pub const __STDC_UTF_32__ = 1;
pub const _DEBUG = 1;
pub const _STDIO_H = 1;
pub const _FEATURES_H = 1;
pub inline fn __GNUC_PREREQ(maj: anytype, min: anytype) @TypeOf(((__GNUC__ << 16) + __GNUC_MINOR__) >= ((maj << 16) + min)) {
    return ((__GNUC__ << 16) + __GNUC_MINOR__) >= ((maj << 16) + min);
}
pub inline fn __glibc_clang_prereq(maj: anytype, min: anytype) @TypeOf(((__clang_major__ << 16) + __clang_minor__) >= ((maj << 16) + min)) {
    return ((__clang_major__ << 16) + __clang_minor__) >= ((maj << 16) + min);
}
pub const _DEFAULT_SOURCE = 1;
pub const __GLIBC_USE_ISOC2X = 0;
pub const __USE_ISOC11 = 1;
pub const __USE_ISOC99 = 1;
pub const __USE_ISOC95 = 1;
pub const __USE_POSIX_IMPLICITLY = 1;
pub const _POSIX_SOURCE = 1;
pub const _POSIX_C_SOURCE = @as(c_long, 200809);
pub const __USE_POSIX = 1;
pub const __USE_POSIX2 = 1;
pub const __USE_POSIX199309 = 1;
pub const __USE_POSIX199506 = 1;
pub const __USE_XOPEN2K = 1;
pub const __USE_XOPEN2K8 = 1;
pub const _ATFILE_SOURCE = 1;
pub const __USE_MISC = 1;
pub const __USE_ATFILE = 1;
pub const __USE_FORTIFY_LEVEL = 0;
pub const __GLIBC_USE_DEPRECATED_GETS = 0;
pub const __GLIBC_USE_DEPRECATED_SCANF = 0;
pub const _STDC_PREDEF_H = 1;
pub const __STDC_IEC_559__ = 1;
pub const __STDC_IEC_559_COMPLEX__ = 1;
pub const __STDC_ISO_10646__ = @as(c_long, 201706);
pub const __GNU_LIBRARY__ = 6;
pub const __GLIBC__ = 2;
pub const __GLIBC_MINOR__ = 32;
pub inline fn __GLIBC_PREREQ(maj: anytype, min: anytype) @TypeOf(((__GLIBC__ << 16) + __GLIBC_MINOR__) >= ((maj << 16) + min)) {
    return ((__GLIBC__ << 16) + __GLIBC_MINOR__) >= ((maj << 16) + min);
}
pub const _SYS_CDEFS_H = 1;
pub const __THROW = __attribute__(__nothrow__ ++ __LEAF);
pub const __THROWNL = __attribute__(__nothrow__);
pub inline fn __glibc_clang_has_extension(ext: anytype) @TypeOf(__has_extension(ext)) {
    return __has_extension(ext);
}
pub inline fn __P(args: anytype) @TypeOf(args) {
    return args;
}
pub inline fn __PMT(args: anytype) @TypeOf(args) {
    return args;
}
pub inline fn __bos(ptr: anytype) @TypeOf(__builtin_object_size(ptr, __USE_FORTIFY_LEVEL > 1)) {
    return __builtin_object_size(ptr, __USE_FORTIFY_LEVEL > 1);
}
pub inline fn __bos0(ptr: anytype) @TypeOf(__builtin_object_size(ptr, 0)) {
    return __builtin_object_size(ptr, 0);
}
pub const __glibc_c99_flexarr_available = 1;
pub inline fn __ASMNAME(cname: anytype) @TypeOf(__ASMNAME2(__USER_LABEL_PREFIX__, cname)) {
    return __ASMNAME2(__USER_LABEL_PREFIX__, cname);
}
pub const __attribute_malloc__ = __attribute__(__malloc__);
pub const __attribute_pure__ = __attribute__(__pure__);
pub const __attribute_const__ = __attribute__(__const__);
pub const __attribute_used__ = __attribute__(__used__);
pub const __attribute_noinline__ = __attribute__(__noinline__);
pub const __attribute_deprecated__ = __attribute__(__deprecated__);
pub inline fn __attribute_deprecated_msg__(msg: anytype) @TypeOf(__attribute__(__deprecated__(msg))) {
    return __attribute__(__deprecated__(msg));
}
pub inline fn __attribute_format_arg__(x: anytype) @TypeOf(__attribute__(__format_arg__(x))) {
    return __attribute__(__format_arg__(x));
}
pub inline fn __attribute_format_strfmon__(a: anytype, b: anytype) @TypeOf(__attribute__(__format__(__strfmon__, a, b))) {
    return __attribute__(__format__(__strfmon__, a, b));
}
pub inline fn __nonnull(params: anytype) @TypeOf(__attribute__(__nonnull__ ++ params)) {
    return __attribute__(__nonnull__ ++ params);
}
pub const __attribute_warn_unused_result__ = __attribute__(__warn_unused_result__);
pub const __always_inline = __inline ++ __attribute__(__always_inline__);
pub const __fortify_function = __extern_always_inline ++ __attribute_artificial__;
pub const __restrict_arr = __restrict;
pub inline fn __glibc_unlikely(cond: anytype) @TypeOf(__builtin_expect(cond, 0)) {
    return __builtin_expect(cond, 0);
}
pub inline fn __glibc_likely(cond: anytype) @TypeOf(__builtin_expect(cond, 1)) {
    return __builtin_expect(cond, 1);
}
pub inline fn __glibc_has_attribute(attr: anytype) @TypeOf(__has_attribute(attr)) {
    return __has_attribute(attr);
}
pub const __WORDSIZE = 64;
pub const __WORDSIZE_TIME64_COMPAT32 = 1;
pub const __SYSCALL_WORDSIZE = 64;
pub const __LDOUBLE_REDIRECTS_TO_FLOAT128_ABI = 0;
pub inline fn __LDBL_REDIR1(name: anytype, proto: anytype, alias: anytype) @TypeOf(name ++ proto) {
    return name ++ proto;
}
pub inline fn __LDBL_REDIR(name: anytype, proto: anytype) @TypeOf(name ++ proto) {
    return name ++ proto;
}
pub inline fn __LDBL_REDIR1_NTH(name: anytype, proto: anytype, alias: anytype) @TypeOf(name ++ proto ++ __THROW) {
    return name ++ proto ++ __THROW;
}
pub inline fn __LDBL_REDIR_NTH(name: anytype, proto: anytype) @TypeOf(name ++ proto ++ __THROW) {
    return name ++ proto ++ __THROW;
}
pub inline fn __REDIRECT_LDBL(name: anytype, proto: anytype, alias: anytype) @TypeOf(__REDIRECT(name, proto, alias)) {
    return __REDIRECT(name, proto, alias);
}
pub inline fn __REDIRECT_NTH_LDBL(name: anytype, proto: anytype, alias: anytype) @TypeOf(__REDIRECT_NTH(name, proto, alias)) {
    return __REDIRECT_NTH(name, proto, alias);
}
pub inline fn __glibc_macro_warning(message: anytype) @TypeOf(__glibc_macro_warning1(GCC ++ warning ++ message)) {
    return __glibc_macro_warning1(GCC ++ warning ++ message);
}
pub const __HAVE_GENERIC_SELECTION = 1;
pub const __USE_EXTERN_INLINES = 1;
pub const __GLIBC_USE_LIB_EXT2 = 0;
pub const __GLIBC_USE_IEC_60559_BFP_EXT = 0;
pub const __GLIBC_USE_IEC_60559_BFP_EXT_C2X = 0;
pub const __GLIBC_USE_IEC_60559_FUNCS_EXT = 0;
pub const __GLIBC_USE_IEC_60559_FUNCS_EXT_C2X = 0;
pub const __GLIBC_USE_IEC_60559_TYPES_EXT = 0;
pub const NULL = (@import("std").meta.cast(?*c_void, 0));
pub inline fn va_start(ap: anytype, param: anytype) @TypeOf(__builtin_va_start(ap, param)) {
    return __builtin_va_start(ap, param);
}
pub inline fn va_end(ap: anytype) @TypeOf(__builtin_va_end(ap)) {
    return __builtin_va_end(ap);
}
pub inline fn va_arg(ap: anytype, type_1: anytype) @TypeOf(__builtin_va_arg(ap, type_1)) {
    return __builtin_va_arg(ap, type_1);
}
pub inline fn __va_copy(d: anytype, s: anytype) @TypeOf(__builtin_va_copy(d, s)) {
    return __builtin_va_copy(d, s);
}
pub inline fn va_copy(dest: anytype, src: anytype) @TypeOf(__builtin_va_copy(dest, src)) {
    return __builtin_va_copy(dest, src);
}
pub const __GNUC_VA_LIST = 1;
pub const _BITS_TYPES_H = 1;
pub const __TIMESIZE = __WORDSIZE;
pub const __S32_TYPE = c_int;
pub const __U32_TYPE = c_uint;
pub const __SLONG32_TYPE = c_int;
pub const __ULONG32_TYPE = c_uint;
pub const _BITS_TYPESIZES_H = 1;
pub const __SYSCALL_SLONG_TYPE = __SLONGWORD_TYPE;
pub const __SYSCALL_ULONG_TYPE = __ULONGWORD_TYPE;
pub const __DEV_T_TYPE = __UQUAD_TYPE;
pub const __UID_T_TYPE = __U32_TYPE;
pub const __GID_T_TYPE = __U32_TYPE;
pub const __INO_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __INO64_T_TYPE = __UQUAD_TYPE;
pub const __MODE_T_TYPE = __U32_TYPE;
pub const __NLINK_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSWORD_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __OFF_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __OFF64_T_TYPE = __SQUAD_TYPE;
pub const __PID_T_TYPE = __S32_TYPE;
pub const __RLIM_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __RLIM64_T_TYPE = __UQUAD_TYPE;
pub const __BLKCNT_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __BLKCNT64_T_TYPE = __SQUAD_TYPE;
pub const __FSBLKCNT_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSBLKCNT64_T_TYPE = __UQUAD_TYPE;
pub const __FSFILCNT_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSFILCNT64_T_TYPE = __UQUAD_TYPE;
pub const __ID_T_TYPE = __U32_TYPE;
pub const __CLOCK_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __TIME_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __USECONDS_T_TYPE = __U32_TYPE;
pub const __SUSECONDS_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __SUSECONDS64_T_TYPE = __SQUAD_TYPE;
pub const __DADDR_T_TYPE = __S32_TYPE;
pub const __KEY_T_TYPE = __S32_TYPE;
pub const __CLOCKID_T_TYPE = __S32_TYPE;
pub const __BLKSIZE_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __SSIZE_T_TYPE = __SWORD_TYPE;
pub const __CPU_MASK_TYPE = __SYSCALL_ULONG_TYPE;
pub const __OFF_T_MATCHES_OFF64_T = 1;
pub const __INO_T_MATCHES_INO64_T = 1;
pub const __RLIM_T_MATCHES_RLIM64_T = 1;
pub const __STATFS_MATCHES_STATFS64 = 1;
pub const __KERNEL_OLD_TIMEVAL_MATCHES_TIMEVAL64 = 1;
pub const __FD_SETSIZE = 1024;
pub const _BITS_TIME64_H = 1;
pub const __TIME64_T_TYPE = __TIME_T_TYPE;
pub const _____fpos_t_defined = 1;
pub const ____mbstate_t_defined = 1;
pub const _____fpos64_t_defined = 1;
pub const ____FILE_defined = 1;
pub const __FILE_defined = 1;
pub const __struct_FILE_defined = 1;
pub const _IO_EOF_SEEN = 0x0010;
pub inline fn __feof_unlocked_body(_fp: anytype) @TypeOf(((_fp.*._flags) & _IO_EOF_SEEN) != 0) {
    return ((_fp.*._flags) & _IO_EOF_SEEN) != 0;
}
pub const _IO_ERR_SEEN = 0x0020;
pub inline fn __ferror_unlocked_body(_fp: anytype) @TypeOf(((_fp.*._flags) & _IO_ERR_SEEN) != 0) {
    return ((_fp.*._flags) & _IO_ERR_SEEN) != 0;
}
pub const _IO_USER_LOCK = 0x8000;
pub const _IOFBF = 0;
pub const _IOLBF = 1;
pub const _IONBF = 2;
pub const BUFSIZ = 8192;
pub const EOF = -1;
pub const SEEK_SET = 0;
pub const SEEK_CUR = 1;
pub const SEEK_END = 2;
pub const P_tmpdir = "/tmp";
pub const _BITS_STDIO_LIM_H = 1;
pub const L_tmpnam = 20;
pub const TMP_MAX = 238328;
pub const FILENAME_MAX = 4096;
pub const L_ctermid = 9;
pub const FOPEN_MAX = 16;
pub const __HAVE_FLOAT128 = 0;
pub const __HAVE_DISTINCT_FLOAT128 = 0;
pub const __HAVE_FLOAT64X = 1;
pub const __HAVE_FLOAT64X_LONG_DOUBLE = 1;
pub const __HAVE_FLOAT16 = 0;
pub const __HAVE_FLOAT32 = 1;
pub const __HAVE_FLOAT64 = 1;
pub const __HAVE_FLOAT32X = 1;
pub const __HAVE_FLOAT128X = 0;
pub const __HAVE_DISTINCT_FLOAT16 = __HAVE_FLOAT16;
pub const __HAVE_DISTINCT_FLOAT32 = 0;
pub const __HAVE_DISTINCT_FLOAT64 = 0;
pub const __HAVE_DISTINCT_FLOAT32X = 0;
pub const __HAVE_DISTINCT_FLOAT64X = 0;
pub const __HAVE_DISTINCT_FLOAT128X = __HAVE_FLOAT128X;
pub const __HAVE_FLOAT128_UNLIKE_LDBL = (__HAVE_DISTINCT_FLOAT128 != 0) and (__LDBL_MANT_DIG__ != 113);
pub const __HAVE_FLOATN_NOT_TYPEDEF = 0;
pub inline fn __f64(x: anytype) @TypeOf(x) {
    return x;
}
pub inline fn __f32x(x: anytype) @TypeOf(x) {
    return x;
}
pub inline fn __builtin_nanf32(x: anytype) @TypeOf(__builtin_nanf(x)) {
    return __builtin_nanf(x);
}
pub inline fn __builtin_nansf32(x: anytype) @TypeOf(__builtin_nansf(x)) {
    return __builtin_nansf(x);
}
pub inline fn __builtin_nanf64(x: anytype) @TypeOf(__builtin_nan(x)) {
    return __builtin_nan(x);
}
pub inline fn __builtin_nansf64(x: anytype) @TypeOf(__builtin_nans(x)) {
    return __builtin_nans(x);
}
pub inline fn __builtin_nanf32x(x: anytype) @TypeOf(__builtin_nan(x)) {
    return __builtin_nan(x);
}
pub inline fn __builtin_nansf32x(x: anytype) @TypeOf(__builtin_nans(x)) {
    return __builtin_nans(x);
}
pub inline fn __builtin_nanf64x(x: anytype) @TypeOf(__builtin_nanl(x)) {
    return __builtin_nanl(x);
}
pub inline fn __builtin_nansf64x(x: anytype) @TypeOf(__builtin_nansl(x)) {
    return __builtin_nansl(x);
}
pub const _BITS_STDIO_H = 1;
pub const __STDIO_INLINE = __extern_inline;
pub const STBI_VERSION = 1;
pub const _STDLIB_H = 1;
pub const WNOHANG = 1;
pub const WUNTRACED = 2;
pub const WSTOPPED = 2;
pub const WEXITED = 4;
pub const WCONTINUED = 8;
pub const WNOWAIT = 0x01000000;
pub const __WNOTHREAD = 0x20000000;
pub const __WALL = 0x40000000;
pub const __WCLONE = 0x80000000;
pub inline fn __WEXITSTATUS(status: anytype) @TypeOf((status & 0xff00) >> 8) {
    return (status & 0xff00) >> 8;
}
pub inline fn __WTERMSIG(status: anytype) @TypeOf(status & 0x7f) {
    return status & 0x7f;
}
pub inline fn __WSTOPSIG(status: anytype) @TypeOf(__WEXITSTATUS(status)) {
    return __WEXITSTATUS(status);
}
pub inline fn __WIFEXITED(status: anytype) @TypeOf(__WTERMSIG(status) == 0) {
    return __WTERMSIG(status) == 0;
}
pub inline fn __WIFSIGNALED(status: anytype) @TypeOf(((@import("std").meta.cast(i8, (status & 0x7f) + 1)) >> 1) > 0) {
    return ((@import("std").meta.cast(i8, (status & 0x7f) + 1)) >> 1) > 0;
}
pub inline fn __WIFSTOPPED(status: anytype) @TypeOf((status & 0xff) == 0x7f) {
    return (status & 0xff) == 0x7f;
}
pub inline fn __WIFCONTINUED(status: anytype) @TypeOf(status == __W_CONTINUED) {
    return status == __W_CONTINUED;
}
pub inline fn __WCOREDUMP(status: anytype) @TypeOf(status & __WCOREFLAG) {
    return status & __WCOREFLAG;
}
pub inline fn __W_EXITCODE(ret: anytype, sig: anytype) @TypeOf((ret << 8) | sig) {
    return (ret << 8) | sig;
}
pub inline fn __W_STOPCODE(sig: anytype) @TypeOf((sig << 8) | 0x7f) {
    return (sig << 8) | 0x7f;
}
pub const __W_CONTINUED = 0xffff;
pub const __WCOREFLAG = 0x80;
pub inline fn WEXITSTATUS(status: anytype) @TypeOf(__WEXITSTATUS(status)) {
    return __WEXITSTATUS(status);
}
pub inline fn WTERMSIG(status: anytype) @TypeOf(__WTERMSIG(status)) {
    return __WTERMSIG(status);
}
pub inline fn WSTOPSIG(status: anytype) @TypeOf(__WSTOPSIG(status)) {
    return __WSTOPSIG(status);
}
pub inline fn WIFEXITED(status: anytype) @TypeOf(__WIFEXITED(status)) {
    return __WIFEXITED(status);
}
pub inline fn WIFSIGNALED(status: anytype) @TypeOf(__WIFSIGNALED(status)) {
    return __WIFSIGNALED(status);
}
pub inline fn WIFSTOPPED(status: anytype) @TypeOf(__WIFSTOPPED(status)) {
    return __WIFSTOPPED(status);
}
pub inline fn WIFCONTINUED(status: anytype) @TypeOf(__WIFCONTINUED(status)) {
    return __WIFCONTINUED(status);
}
pub const __ldiv_t_defined = 1;
pub const __lldiv_t_defined = 1;
pub const RAND_MAX = 2147483647;
pub const EXIT_FAILURE = 1;
pub const EXIT_SUCCESS = 0;
pub const _SYS_TYPES_H = 1;
pub const __clock_t_defined = 1;
pub const __clockid_t_defined = 1;
pub const __time_t_defined = 1;
pub const __timer_t_defined = 1;
pub const _BITS_STDINT_INTN_H = 1;
pub const __BIT_TYPES_DEFINED__ = 1;
pub const _ENDIAN_H = 1;
pub const _BITS_ENDIAN_H = 1;
pub const __LITTLE_ENDIAN = 1234;
pub const __BIG_ENDIAN = 4321;
pub const __PDP_ENDIAN = 3412;
pub const _BITS_ENDIANNESS_H = 1;
pub const __BYTE_ORDER = __LITTLE_ENDIAN;
pub const __FLOAT_WORD_ORDER = __BYTE_ORDER;
pub inline fn __LONG_LONG_PAIR(HI: anytype, LO: anytype) @TypeOf(HI) {
    return blk: {
        _ = LO;
        break :blk HI;
    };
}
pub const LITTLE_ENDIAN = __LITTLE_ENDIAN;
pub const BIG_ENDIAN = __BIG_ENDIAN;
pub const PDP_ENDIAN = __PDP_ENDIAN;
pub const BYTE_ORDER = __BYTE_ORDER;
pub const _BITS_BYTESWAP_H = 1;
pub inline fn __bswap_constant_16(x: anytype) @TypeOf((@import("std").meta.cast(__uint16_t, ((x >> 8) & 0xff) | ((x & 0xff) << 8)))) {
    return (@import("std").meta.cast(__uint16_t, ((x >> 8) & 0xff) | ((x & 0xff) << 8)));
}
pub inline fn __bswap_constant_32(x: anytype) @TypeOf(((((x & @as(c_uint, 0xff000000)) >> 24) | ((x & @as(c_uint, 0x00ff0000)) >> 8)) | ((x & @as(c_uint, 0x0000ff00)) << 8)) | ((x & @as(c_uint, 0x000000ff)) << 24)) {
    return ((((x & @as(c_uint, 0xff000000)) >> 24) | ((x & @as(c_uint, 0x00ff0000)) >> 8)) | ((x & @as(c_uint, 0x0000ff00)) << 8)) | ((x & @as(c_uint, 0x000000ff)) << 24);
}
pub inline fn __bswap_constant_64(x: anytype) @TypeOf(((((((((x & @as(c_ulonglong, 0xff00000000000000)) >> 56) | ((x & @as(c_ulonglong, 0x00ff000000000000)) >> 40)) | ((x & @as(c_ulonglong, 0x0000ff0000000000)) >> 24)) | ((x & @as(c_ulonglong, 0x000000ff00000000)) >> 8)) | ((x & @as(c_ulonglong, 0x00000000ff000000)) << 8)) | ((x & @as(c_ulonglong, 0x0000000000ff0000)) << 24)) | ((x & @as(c_ulonglong, 0x000000000000ff00)) << 40)) | ((x & @as(c_ulonglong, 0x00000000000000ff)) << 56)) {
    return ((((((((x & @as(c_ulonglong, 0xff00000000000000)) >> 56) | ((x & @as(c_ulonglong, 0x00ff000000000000)) >> 40)) | ((x & @as(c_ulonglong, 0x0000ff0000000000)) >> 24)) | ((x & @as(c_ulonglong, 0x000000ff00000000)) >> 8)) | ((x & @as(c_ulonglong, 0x00000000ff000000)) << 8)) | ((x & @as(c_ulonglong, 0x0000000000ff0000)) << 24)) | ((x & @as(c_ulonglong, 0x000000000000ff00)) << 40)) | ((x & @as(c_ulonglong, 0x00000000000000ff)) << 56);
}
pub const _BITS_UINTN_IDENTITY_H = 1;
pub inline fn htobe16(x: anytype) @TypeOf(__bswap_16(x)) {
    return __bswap_16(x);
}
pub inline fn htole16(x: anytype) @TypeOf(__uint16_identity(x)) {
    return __uint16_identity(x);
}
pub inline fn be16toh(x: anytype) @TypeOf(__bswap_16(x)) {
    return __bswap_16(x);
}
pub inline fn le16toh(x: anytype) @TypeOf(__uint16_identity(x)) {
    return __uint16_identity(x);
}
pub inline fn htobe32(x: anytype) @TypeOf(__bswap_32(x)) {
    return __bswap_32(x);
}
pub inline fn htole32(x: anytype) @TypeOf(__uint32_identity(x)) {
    return __uint32_identity(x);
}
pub inline fn be32toh(x: anytype) @TypeOf(__bswap_32(x)) {
    return __bswap_32(x);
}
pub inline fn le32toh(x: anytype) @TypeOf(__uint32_identity(x)) {
    return __uint32_identity(x);
}
pub inline fn htobe64(x: anytype) @TypeOf(__bswap_64(x)) {
    return __bswap_64(x);
}
pub inline fn htole64(x: anytype) @TypeOf(__uint64_identity(x)) {
    return __uint64_identity(x);
}
pub inline fn be64toh(x: anytype) @TypeOf(__bswap_64(x)) {
    return __bswap_64(x);
}
pub inline fn le64toh(x: anytype) @TypeOf(__uint64_identity(x)) {
    return __uint64_identity(x);
}
pub const _SYS_SELECT_H = 1;
pub inline fn __FD_ISSET(d: anytype, s: anytype) @TypeOf((__FDS_BITS(s)[__FD_ELT(d)] & __FD_MASK(d)) != 0) {
    return (__FDS_BITS(s)[__FD_ELT(d)] & __FD_MASK(d)) != 0;
}
pub const __sigset_t_defined = 1;
pub const __timeval_defined = 1;
pub const _STRUCT_TIMESPEC = 1;
pub const __NFDBITS = 8 * (@import("std").meta.cast(c_int, @import("std").meta.sizeof(__fd_mask)));
pub inline fn __FD_ELT(d: anytype) @TypeOf(d / __NFDBITS) {
    return d / __NFDBITS;
}
pub inline fn __FD_MASK(d: anytype) @TypeOf((@import("std").meta.cast(__fd_mask, @as(c_ulong, 1) << (d % __NFDBITS)))) {
    return (@import("std").meta.cast(__fd_mask, @as(c_ulong, 1) << (d % __NFDBITS)));
}
pub inline fn __FDS_BITS(set: anytype) @TypeOf(set.*.__fds_bits) {
    return set.*.__fds_bits;
}
pub const FD_SETSIZE = __FD_SETSIZE;
pub const NFDBITS = __NFDBITS;
pub inline fn FD_SET(fd: anytype, fdsetp: anytype) @TypeOf(__FD_SET(fd, fdsetp)) {
    return __FD_SET(fd, fdsetp);
}
pub inline fn FD_CLR(fd: anytype, fdsetp: anytype) @TypeOf(__FD_CLR(fd, fdsetp)) {
    return __FD_CLR(fd, fdsetp);
}
pub inline fn FD_ISSET(fd: anytype, fdsetp: anytype) @TypeOf(__FD_ISSET(fd, fdsetp)) {
    return __FD_ISSET(fd, fdsetp);
}
pub inline fn FD_ZERO(fdsetp: anytype) @TypeOf(__FD_ZERO(fdsetp)) {
    return __FD_ZERO(fdsetp);
}
pub const _BITS_PTHREADTYPES_COMMON_H = 1;
pub const _THREAD_SHARED_TYPES_H = 1;
pub const _BITS_PTHREADTYPES_ARCH_H = 1;
pub const __SIZEOF_PTHREAD_MUTEX_T = 40;
pub const __SIZEOF_PTHREAD_ATTR_T = 56;
pub const __SIZEOF_PTHREAD_RWLOCK_T = 56;
pub const __SIZEOF_PTHREAD_BARRIER_T = 32;
pub const __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
pub const __SIZEOF_PTHREAD_COND_T = 48;
pub const __SIZEOF_PTHREAD_CONDATTR_T = 4;
pub const __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
pub const __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
pub const _THREAD_MUTEX_INTERNAL_H = 1;
pub const __PTHREAD_MUTEX_HAVE_PREV = 1;
pub inline fn __PTHREAD_RWLOCK_INITIALIZER(__flags: anytype) @TypeOf(__flags) {
    return blk: {
        _ = 0;
        _ = 0;
        _ = 0;
        _ = 0;
        _ = 0;
        _ = 0;
        _ = 0;
        _ = 0;
        _ = __PTHREAD_RWLOCK_ELISION_EXTRA;
        _ = 0;
        break :blk __flags;
    };
}
pub const __have_pthread_attr_t = 1;
pub const _ALLOCA_H = 1;
pub const _G_fpos_t = struct__G_fpos_t;
pub const _G_fpos64_t = struct__G_fpos64_t;
pub const _IO_marker = struct__IO_marker;
pub const _IO_codecvt = struct__IO_codecvt;
pub const _IO_wide_data = struct__IO_wide_data;
pub const _IO_FILE = struct__IO_FILE;
pub const __va_list_tag = struct___va_list_tag;
pub const timeval = struct_timeval;
pub const timespec = struct_timespec;
pub const __pthread_internal_list = struct___pthread_internal_list;
pub const __pthread_internal_slist = struct___pthread_internal_slist;
pub const __pthread_mutex_s = struct___pthread_mutex_s;
pub const __pthread_rwlock_arch_t = struct___pthread_rwlock_arch_t;
pub const __pthread_cond_s = struct___pthread_cond_s;
pub const random_data = struct_random_data;
pub const drand48_data = struct_drand48_data;
