main :: () {
    ok, data, lines := get_input_file_as_lines("input1.txt");
    assert(ok);
    
    #run {
        lines : []string = .[
            "Card  1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
            "Card  2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
            "Card  3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
            "Card  4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
            "Card  5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
            "Card  6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11",
        ];
        cards: [..]Card;
        array_reserve(*cards, lines.count);
        for line : lines {
            ok, card := parse_card(line);
            if !ok continue;
            array_add(*cards, card);
        }
        
        print("%\n", part1(cards));
        print("%\n", part2(cards));
    };
    
    cards: [..]Card;
    array_reserve(*cards, lines.count);
    for line : lines {
        ok, card := parse_card(line);
        if !ok continue;
        array_add(*cards, card);
    }
    
    print("Part 1: %\n", part1(cards));
    print("Part 2: %\n", part2(cards));
}

Card :: struct {
    matches: s32;
    instances: u32 = 1;
}

part1 :: (cards: []Card) -> u64 {
    ret : u64 = 0;
    for card : cards {
        ret += score_card(*card);
    }
    return ret;
}

part2 :: (cards: []Card) -> u64 {
    ret := cast(u64) 0;
    for card, idx : cards {
        ret += card.instances;
        for (idx+1)..(idx+card.matches) {
            cards[it].instances += card.instances * (ifx card.matches then cast(u32) 1 else 0);
        }
    }
    return ret;
}

score_card :: inline (card: *Card) -> u64 {
    return ifx card.matches then (cast(u64)1 << (card.matches - 1)) else cast(u64)0;
}

parse_card :: (line: string) -> success: bool, card: Card {
    card: Card;
    
    card_parts := split(line, ":");
    if card_parts.count != 2 return false, .{};
   
    list_parts := split(card_parts[1], " | ");
    if list_parts.count != 2 return false, .{};

    winning_numbers: [2]u64;    
    numbers_s := split(trim(list_parts[0]), " ");
    for numbers_s {
        if !it continue;
        n := string_to_int(it, T=u64);
        set_bit(*winning_numbers, n);
    }

    numbers_i_have: [2]u64;
    numbers_s = split(trim(list_parts[1]), " ");
    for numbers_s {
        if !it continue;
        n := string_to_int(it, T=u64);
        set_bit(*numbers_i_have, n);
    }
    
    card.matches = popcount(winning_numbers[0] & numbers_i_have[0]) + popcount(winning_numbers[1] & numbers_i_have[1]);
    
    return true, card;
}

set_bit :: inline (bits: *[2]u64, number: u64) {
    idx := number / 64;
    bit := number % 64;
    bits.*[idx] |= (cast(u64) 1 << bit);
}

check_bit :: inline (bits: *[2]u64, number: u64) -> bool {
    idx := number / 64;
    bit := number % 64;
    return (bits.*[idx] & (cast(u64) 1 << bit)) != 0;
}

#import "Bit_Operations";
#import "Basic";
#import "String";
#import "AoC";
