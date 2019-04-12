function [Board] = c64_manualmove(Board, PlayingPlayer, LetterMove)


%%% TODO: include castlings

switch LetterMove(1)
    case 'a'
        C1=1;
    case 'b'
        C1=2;
    case 'c'
        C1=3;
    case 'd'
        C1=4;
    case 'e'
        C1=5;
    case 'f'
        C1=6;
    case 'g'
        C1=7;
    case 'h'
        C1=8;
end

switch LetterMove(3)
    case 'a'
        C2=1;
    case 'b'
        C2=2;
    case 'c'
        C2=3;
    case 'd'
        C2=4;
    case 'e'
        C2=5;
    case 'f'
        C2=6;
    case 'g'
        C2=7;
    case 'h'
        C2=8;
end

L1 = 9 - str2double(LetterMove(2));
L2 = 9 - str2double(LetterMove(4));

Coord = sub2ind([8 8], [C1, C2], [L1, L2]);

Moves = c64_listmoves(Board, PlayingPlayer);

SMoves = Moves ~= 0;

Board(end-4)=0;
Board = Board + Moves(sum(SMoves(:, Coord), 2) >= 2, :);

    




end