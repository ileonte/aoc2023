main :: () {
    ok, data, lines := get_input_file_as_lines("input1.txt");
    assert(ok);
      
    print("Part 1: %\n", part1(lines));
    print("Part 2: %\n", part2(lines));
}

part1 :: (lines: [] string) -> int {
    ret := 0;
    
    for line : lines {
        slice : []u8;
        slice.data = line.data;
        slice.count = line.count;

        first_digit := 0;
        last_digit := 0;
        first_set := false;
        for ch : slice {
            if ch < #char "0" || ch > #char "9" continue;
            if !first_set {
                first_digit = cast(int)ch - cast(int)(#char "0");
                last_digit  = cast(int)ch - cast(int)(#char "0");
                first_set = true;
            } else {
                last_digit = cast(int)ch - cast(int)(#char "0");
            }
        }
        
        ret += first_digit * 10 + last_digit;
    }
    
    return ret;
}

part2 :: (lines: []string) -> int {
    ret := 0;
    
    for line : lines {
        first_digit := 0;
        last_digit := 0;
        first_set := false;
        
        pos := 0;      
        while pos < line.count {
            digit: *Digit;
            for * digits {
                s := slice(line, pos, it.string_representation.count);
                if s == it.string_representation {
                    digit = it;
                    break;
                }
            }
            
            pos += 1;
            if !digit continue;
            
            if !first_set {
                first_digit = digit.value;
                last_digit  = digit.value;
                first_set = true;
            } else {
                last_digit = digit.value;
            }
        }
               
        ret += first_digit * 10 + last_digit;
    }
    
    return ret;
}

Digit :: struct {
    string_representation: string;
    value: int;
}

digits :: Digit.[
    .{ "1",     1 },
    .{ "2",     2 },
    .{ "3",     3 },
    .{ "4",     4 },
    .{ "5",     5 },
    .{ "6",     6 },
    .{ "7",     7 },
    .{ "8",     8 },
    .{ "9",     9 },
    .{ "one",   1 },
    .{ "two",   2 },
    .{ "three", 3 },
    .{ "four",  4 },
    .{ "five",  5 },
    .{ "six",   6 },
    .{ "seven", 7 },
    .{ "eight", 8 },
    .{ "nine",  9 },
];

#import "Basic";
#import "String";
#import "AoC";
