
clc, clear, %close all force
n=3;
Viz=0;
Disp=0;
MaxDepth=10;
Sort=0;

Board=[-ones(1,n), zeros(1, n*4), ones(1, n), 0];
depth=0;
PlayingPlayer=1;
Nodes=[];

p8_chessBoard(Board, n, PlayingPlayer), drawnow,
while p8_haswon(Board, n, PlayingPlayer, Sort)==0
    PlayingPlayer
    Best=p8_bestmove(Board, n, depth, MaxDepth, PlayingPlayer, Viz, Disp, Sort, Nodes)
    beep
    if size(Best,1)>1
        Best=Best(randi(size(Best,1)), :)
    end
    Board=[Board(1:end-1), 0]+Best;
    PlayingPlayer=1-PlayingPlayer;
    p8_chessBoard(Board, n, PlayingPlayer), drawnow,
    pause(1)
end
PlayingPlayer
disp(['Winning: ', num2str(p8_haswon(Board, n, PlayingPlayer, Sort))])