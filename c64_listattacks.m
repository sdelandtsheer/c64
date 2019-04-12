function [ListMoves] = c64_listattacks(Board, PlayingPlayer)

Board=(reshape(Board(1:end-5), 8, 8))';

if PlayingPlayer == -1 %%%flip board
    Board = -flipud(Board);
end

ListMoves=[];

%%%look for pawns
[L,C]=ind2sub(size(Board), find(Board==1));
for p=1:size(L,1)
    
    %%%can pawns take
    if C(p)>1
        Move = zeros(8);
        Move(L(p)-1,C(p)-1) = -Board(L(p)-1, C(p)-1) + 1; Move(L(p),C(p)) = -1;
        if PlayingPlayer == -1 %%%flip moves
           Move = -flipud(Move);
        end
        Move= Move';
        Move1D=[(Move(:))', 0 0 0 0 0];
        ListMoves=[ListMoves;Move1D];
    end
    if C(p)<8
        Move=zeros(8);
        Move(L(p)-1,C(p)+1) = -Board(L(p)-1, C(p)+1) + 1; Move(L(p),C(p)) = -1;
        if PlayingPlayer == -1 %%%flip moves
           Move = -flipud(Move);
        end
        Move= Move';
        Move1D=[(Move(:))', 0 0 0 0 0];
        ListMoves=[ListMoves;Move1D];
    end
    
end

%%%look for knights
[L,C]=ind2sub(size(Board), find(Board==2.9));
ListL= [-2 -2 -1 -1  1  1  2  2];
ListC= [-1  1 -2  2 -2  2 -1  1];
for p=1:size(L,1)
    for trial = 1:8
        NewL = L(p)+ListL(trial); NewC = C(p)+ListC(trial);
        if NewL > 0 && NewL < 9 && NewC > 0 && NewC < 9 && Board(NewL, NewC)<=0
            Move = zeros(8);
            Move(L(p), C(p)) = -2.9; Move(NewL, NewC) = -Board(NewL, NewC)+2.9;
            if PlayingPlayer == -1 %%%flip moves
               Move = -flipud(Move);
            end
            Move= Move';
            Move1D=[(Move(:))', 0 0 0 0 0];
            ListMoves=[ListMoves;Move1D];
        end
    end
end

%%%look for bishops
[L,C]=ind2sub(size(Board), find(Board==3.1));
for p=1:size(L,1)
    ListSteps=[-1 -1; -1 1; 1 1; 1 -1];
    for Step=1:4
        NewL = L(p); NewC = C(p);
        isFree=1; isOnBoard=1;
        while isFree && isOnBoard
            NewL = NewL+ListSteps(Step, 1); NewC = NewC+ListSteps(Step, 2);
            if NewL > 0 && NewC > 0 && NewL < 9 && NewC < 9
                if Board(NewL, NewC) == 0
                    Move = zeros(8);
                    Move(L(p), C(p)) = -3.1;
                    Move(NewL, NewC) = 3.1;
                    if PlayingPlayer == -1 %%%flip moves
                       Move = -flipud(Move);
                    end
                    Move= Move';
                    Move1D=[(Move(:))', 0 0 0 0 0];
                    ListMoves=[ListMoves;Move1D];
                elseif Board(NewL, NewC) ~= 0
                    Move = zeros(8);
                    Move(L(p), C(p)) = -3.1;
                    Move(NewL, NewC) = -Board(NewL, NewC) + 3.1;
                    if PlayingPlayer == -1 %%%flip moves
                       Move = -flipud(Move);
                    end
                    Move= Move';
                    Move1D=[(Move(:))', 0 0 0 0 0];
                    ListMoves=[ListMoves;Move1D];
                    isFree = 0;
                end
            else
                isOnBoard = 0;
            end
        end
    end
    
end

%%%look for rooks
[L,C]=ind2sub(size(Board), find(Board==5));
for p=1:size(L,1)
    ListSteps=[-1 0; 1 0; 0 1; 0 -1];
    for Step=1:4
        NewL = L(p); NewC = C(p);
        isFree=1; isOnBoard=1;
        while isFree && isOnBoard
            NewL = NewL+ListSteps(Step, 1); NewC = NewC+ListSteps(Step, 2);
            if NewL > 0 && NewC > 0 && NewL < 9 && NewC < 9
                if Board(NewL, NewC) == 0
                    Move = zeros(8);
                    Move(L(p), C(p)) = -5;
                    Move(NewL, NewC) = 5;
                    if NewL == 8 && NewC == 1
                        Cast = [0 -1 0 0];
                    elseif NewL == 8 && NewC == 8
                        Cast = [-1 0 0 0];
                    else
                        Cast = [0 0 0 0];
                    end
                    if PlayingPlayer == -1 %%%flip moves
                       Move = -flipud(Move);
                       if NewL == 8 && NewC == 1
                            Cast = [0 0 0 -1];
                        elseif NewL == 8 && NewC == 8
                            Cast = [0 0 -1 0];
                       else
                           Cast = [0 0 0 0];
                        end
                    end
                    Move= Move';
                    Move1D=[(Move(:))', 0, Cast];
                    ListMoves=[ListMoves;Move1D];
                elseif Board(NewL, NewC) ~= 0
                    Move = zeros(8);
                    Move(L(p), C(p)) = -5;
                    Move(NewL, NewC) = -Board(NewL, NewC) + 5;
                    if PlayingPlayer == -1 %%%flip moves
                       Move = -flipud(Move);
                    end
                    Move= Move';
                    Move1D=[(Move(:))', 0 0 0 0 0];
                    ListMoves=[ListMoves;Move1D];
                    isFree = 0;
                end
            else
                isOnBoard = 0;
            end
        end
    end
end

%%%look for queens
[L,C]=ind2sub(size(Board), find(Board==9));
for p=1:size(L,1)
    ListSteps=[-1 0; 1 0; 0 1; 0 -1; -1 -1; -1 1; 1 1; 1 -1];
    for Step=1:8
        NewL = L(p); NewC = C(p);
        isFree=1; isOnBoard=1;
        while isFree && isOnBoard
            NewL = NewL+ListSteps(Step, 1); NewC = NewC+ListSteps(Step, 2);
            if NewL > 0 && NewC > 0 && NewL < 9 && NewC < 9
                if Board(NewL, NewC) == 0
                    Move = zeros(8);
                    Move(L(p), C(p)) = -9;
                    Move(NewL, NewC) = 9;
                    if PlayingPlayer == -1 %%%flip moves
                       Move = -flipud(Move);
                    end
                    Move= Move';
                    Move1D=[(Move(:))', 0 0 0 0 0];
                    ListMoves=[ListMoves;Move1D];
                elseif Board(NewL, NewC) ~= 0
                    Move = zeros(8);
                    Move(L(p), C(p)) = -9;
                    Move(NewL, NewC) = -Board(NewL, NewC) + 9;
                    if PlayingPlayer == -1 %%%flip moves
                       Move = -flipud(Move);
                    end
                    Move= Move';
                    Move1D=[(Move(:))', 0 0 0 0 0];
                    ListMoves=[ListMoves;Move1D];
                    isFree = 0;
                end
            else
                isOnBoard = 0;
            end
        end
    end
end


%%%look for the king
[L,C]=ind2sub(size(Board), find(Board==10));

ListSteps=[-1 0; 1 0; 0 1; 0 -1; -1 -1; -1 1; 1 1; 1 -1];

for Step=1:8
    isFree=1; isOnBoard=1;
    NewL = L(p); NewC = C(p);
    while isFree && isOnBoard
        NewL = NewL+ListSteps(Step, 1); NewC = NewC+ListSteps(Step, 2);
        if NewL > 0 && NewC > 0 && NewL < 9 && NewC < 9
            if Board(NewL, NewC) == 0
                Move = zeros(8);
                Move(L(p), C(p)) = -10;
                Move(NewL, NewC) = 10;
                if PlayingPlayer == -1 %%%flip moves
                   Move = -flipud(Move);
                end
                Move= Move';
                if PlayingPlayer == 1
                    Move1D=[(Move(:))', 0 -1 -1 0 0];
                elseif PlayingPlayer == -1
                    Move1D=[(Move(:))', 0 0 0 -1 -1];
                end
                ListMoves=[ListMoves;Move1D];
            elseif Board(NewL, NewC) ~= 0
                Move = zeros(8);
                Move(L(p), C(p)) = -10;
                Move(NewL, NewC) = -Board(NewL, NewC) + 10;
                if PlayingPlayer == -1 %%%flip moves
                   Move = -flipud(Move);
                end
                Move= Move';
                if PlayingPlayer == 1
                    Move1D=[(Move(:))', 0 -1 -1 0 0];
                elseif PlayingPlayer == -1
                    Move1D=[(Move(:))', 0 0 0 -1 -1];
                end
                ListMoves=[ListMoves;Move1D];
                isFree = 0;
            end
        else
            isOnBoard = 0;
        end
    end
end

end