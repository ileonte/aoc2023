main :: () {
    ok, data, lines := get_input_file_as_lines("input1.txt");
    assert(ok);
    
    #run {
        p1, p2 := part1(.[
            "467..114..",
            "...*......",
            "..35..633.",
            "......#...",
            "617*......",
            ".....+.58.",
            "..592.....",
            "......755.",
            "...$.*....",
            ".664.598..",
        ]);
        print("%\n", p1);
        print("%\n", p2);
    };
        
    p1, p2 := part1(lines);
    print("Part 1: %\n", p1);
    print("Part 2: %\n", p2);
}

Gear :: struct {
    x: int;
    y: int;
    n1: int;
    n2: int;
}

part1 :: (lines: []string) -> int, int {
    p1 := 0;
    p2 := 0;
    gears: [..] Gear;

    for line, line_idx : lines {
        n, s, e := extract_next_number(line);
        while s >= 0 {
            p := s;
            while p <= e {
                ok, c, x, y := is_next_to_symbol(lines, p, line_idx);
                if ok {
                    p1 += n;
                    
                    if c == #char "*" {
                        gear: *Gear;
                        for * gears {
                            if it.x == x && it.y == y {
                                gear = it;
                                gear.n2 = n;
                                break;
                            }
                        }
                        if !gear {
                            gear = array_add(*gears);
                            gear.x = x;
                            gear.y = y;
                            gear.n1 = n;
                        }
                    }
                    
                    break;
                }
                p += 1;
            }
            n, s, e = extract_next_number(line, e + 1);
        }
    }
    
    for gears {
        p2 += it.n1 * it.n2;
    }

    return p1, p2;
}

extract_next_number :: (line: string, from := 0) -> number: int, start: int, end: int {
    ret := 0;
    
    pos := from;
    while pos < line.count {
        if is_digit(line[pos]) break;
        pos += 1;
    }
    if pos >= line.count return 0, -1, -1;
    
    start := pos;
    ret = ret * 10 + (line[pos] - #char "0");
    
    pos += 1;
    while pos < line.count {
        if !is_digit(line[pos]) break;
        ret = ret * 10 + (line[pos] - #char "0");
        pos += 1;
    }
    
    end := pos - 1;
    
    return ret, start, end;
}

is_next_to_symbol :: inline (lines: []string, x: int, y: int) -> bool, u8, int, int {
    check_position :: inline (lines: []string, x: int, y: int) -> bool, u8, int, int {
        if !(x >= 0 && y >= 0 && x < lines[0].count && y < lines.count) return false, 0, -1, -1;
        if !is_digit(lines[y][x]) && lines[y][x] != #char "." return true, lines[y][x], x, y;
        return false, 0, -1, -1;
    }
    
    ok, c, cx, cy := check_position(lines, x - 1, y - 1);
    if ok return true, c, cx, cy;
    ok, c, cx, cy = check_position(lines, x,     y - 1);
    if ok return true, c, cx, cy;
    ok, c, cx, cy = check_position(lines, x + 1, y - 1);
    if ok return true, c, cx, cy;
    ok, c, cx, cy = check_position(lines, x - 1, y);
    if ok return true, c, cx, cy;
    ok, c, cx, cy = check_position(lines, x + 1, y);
    if ok return true, c, cx, cy;
    ok, c, cx, cy = check_position(lines, x - 1, y + 1);
    if ok return true, c, cx, cy;
    ok, c, cx, cy = check_position(lines, x,     y + 1);
    if ok return true, c, cx, cy;
    ok, c, cx, cy = check_position(lines, x + 1, y + 1);
    if ok return true, c, cx, cy;
    
    return false, 0, -1, -1;
}

#import "Basic";
#import "String";
#import "AoC";
