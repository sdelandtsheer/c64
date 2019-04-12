%%%
clear, close all force, clc,

Board=[-5 -2.9 -3.1 -9 -10 -3.1 -2.9 -5;...
        -1  -1  -1  -1  -1  -1  -1  -1;...
        0 0 0 0 0 0 0 0;...
        0 0 0 0 0 0 0 0;...
        0 0 0 0 0 0 0 0;...
        0 0 0 0 0 0 0 0;...
        1  1  1  1  1  1  1  1;...
        5 2.9 3.1 9 10 3.1 2.9 5];

Board = Board';
Board=[(Board(:))', 0 1 1 1 1];

X=c64_listmoves(Board, 1);
c64_eval(Board, 1)
c64_eval(Board, -1)

ListGame={'e2e4', 'c7c5', 'g1f3', 'b8c6', 'd2d4', 'c5d4', 'f3d4', 'c6d4', 'd1d4'}

PlayingPlayer=1;
for k = 1:length(ListGame)
    ListGame{k}
    Board = c64_manualmove(Board, PlayingPlayer, ListGame{k});
    c64_eval(Board, 1)
    c64_eval(Board, -1)
    PlayingPlayer=-PlayingPlayer;
end



