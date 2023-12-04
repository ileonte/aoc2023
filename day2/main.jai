main :: () {
    ok, data, lines := get_input_file_as_lines("input1.txt");
    assert(ok);
    
    #run print("%\n", part1(.[
        "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
        "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
        "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
        "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
        "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
    ], 12, 13, 14));

    #run print("%\n", part2(.[
        "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
        "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
        "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
        "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
        "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
    ]));

    print("Part 1: %\n", part1(lines, 12, 13, 14));
    print("Part 2: %\n", part2(lines));
}

part1 :: (lines: []string, r_max: int, g_max: int, b_max: int) -> int {
    ret := 0;
    for line : lines {
        game: Game;
        if !parse_game(line, *game) continue;
        
        for round : game.rounds {
            if !((round.r <= r_max) && (round.g <= g_max) && (round.b <= b_max)) {
                continue line;
            }
        }
        
        ret += game.id;
    }
    return ret;
}

part2 :: (lines: []string) -> int {
    ret := 0;
    for line : lines {
        r: int;
        g: int;
        b: int;

        game: Game;
        if !parse_game(line, *game) continue;
        
        for round : game.rounds {
            r = max(r, round.r);
            g = max(g, round.g);
            b = max(b, round.b);
        }
        
        ret += r * g * b;
    }
    return ret;
}

Round :: struct {
    r: int;
    g: int;
    b: int;
}

Game :: struct {
    data: [16]Round;
    id: int;
    rounds: []Round;
}

parse_game :: (line: string, game: *Game) -> bool {
    game.rounds = array_view(game.data, 0, 0);
    
    game_parts := split(line, ":");
    if game_parts.count != 2 return false;
    
    id_parts := split(trim(game_parts[0]), " ");
    if id_parts.count != 2 return false;
    game.id = string_to_int(id_parts[1]);

    round_parts := split(game_parts[1], ";");
    for round_s : round_parts {
        if game.rounds.count >= game.data.count return false;

        round := *game.data[game.rounds.count];
        game.rounds.count += 1;

        color_parts := split(trim(round_s), ",");
        for color_s : color_parts {
            parts := split(trim(color_s), " ");
            if parts.count != 2 return false;
            value := string_to_int(parts[0]);

            if parts[1] == {
                case "red";   round.*.r = value;
                case "green"; round.*.g = value;
                case "blue";  round.*.b = value;
                case; assert(false);
            }
        }
    }

    return true;
}

#import "Basic";
#import "String";
#import "AoC";
