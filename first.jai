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
        
        slot := get_workspace_slot(w);

        compiler_begin_intercept(w, .SKIP_ALL);

        add_build_file(tprint("%/%", it.name, it.main), w);
    }

    completed := workspaces.count;
    failed := false;
    while completed > 0 {
        message := compiler_wait_for_message();
        slot := get_workspace_slot(message.workspace, false);
        if !slot continue;
        if message.kind == .COMPLETE {
            m := cast(*Message_Complete) message;
            if m.error_code == .COMPILATION_FAILED then failed = true;
            slot.workspace = 0;
            completed -= 1;
            compiler_end_intercept(message.workspace);
        }
    }
}

get_workspace_slot :: (w: Workspace, allocate := true) -> *Workspace_Data {
    assert(w != 0);
    slot: *Workspace_Data;
    for * workspaces {
        if !slot && !it.workspace slot = it;
        if it.workspace == w return it;
    }
    if allocate {
        assert(slot != null);
        slot.workspace = w;
    }
    return slot;
}

Day :: struct {
    name: string;
    main: string;
}

Workspace_Data :: struct {
    workspace: Workspace;
}

days :: Day.[
    .{ name = "day1", main = "main.jai" },
    .{ name = "day2", main = "main.jai" },
    .{ name = "day3", main = "main.jai" },
    .{ name = "day4", main = "main.jai" },
];

workspaces: [days.count] Workspace_Data;

#import "Compiler";
#import "Basic";
#import "File";
