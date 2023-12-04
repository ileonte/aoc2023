get_input_file_as_lines :: (file_name: string) -> success: bool, data: string, lines: []string {
    data, ok := read_entire_file(file_name);
    if !ok return false, "", .[];
    
    lines := split(data, "\n");
    for * lines it.* = trim(it.*);
    if lines.count && lines[lines.count - 1] == "" lines.count -= 1;
    
    return true, data, lines;
}

#scope_module
#import "File";
#import "String";
