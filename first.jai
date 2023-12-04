#run build();

build :: () {
    build_dir := "build_dir";
    make_directory_if_it_does_not_exist(build_dir);
    
    options := get_build_options();
    
    set_build_options_dc(.{do_output=false});
    set_working_directory(#filepath);
    
    import_path: [..] string;
    array_add(*import_path, "modules");
    array_add(*import_path, ..options.import_path);
    options.import_path = import_path;
    
    for days {
        options.output_path = build_dir;
        options.output_executable_name = it.name;
        
        w := compiler_create_workspace(it.name);
        set_build_options(options, w);
    
        compiler_begin_intercept(w);
    
        add_build_file(tprint("%/%", it.name, it.main), w);
    
        failed := false;
        while true {
            message := compiler_wait_for_message();
            if message.workspace != w continue;
            if message.kind == .COMPLETE {
                m := cast(*Message_Complete) message;
                if m.error_code == .COMPILATION_FAILED then failed = true;
                break;
            }
        }
    
        compiler_end_intercept(w);
    }
}

Day :: struct {
    name: string;
    main: string;
}

days :: Day.[
    .{ name = "day1", main = "main.jai" },
    .{ name = "day2", main = "main.jai" },
    .{ name = "day3", main = "main.jai" },
];

#import "Compiler";
#import "Basic";
#import "File";
