function [ListMoves] = c64_listmoves(Board, PlayingPlayer)


LastJump = Board(end-4); 
Castlings = Board(end-3:end);

Board=(reshape(Board(1:end-5), 8, 8))';
LBoard=Board'; LBoard=[(LBoard(:))', 0 0 0 0 0];
OppAttacks = c64_listattacks(LBoard, -PlayingPlayer);
K=find(Board == 10);

if any(OppAttacks(:,K) ~= 0)
    KingInCheck = 1;
else
    KingInCheck = 0;
end

if PlayingPlayer == -1 %%%flip board
    Board = -flipud(Board);
    if LastJump ~= 0
        LastJump= 9 - LastJump;
    end
end

ListMoves=[];

%%%look for pawns
[L,C]=ind2sub(size(Board), find(Board==1));
for p=1:size(L,1)
    %%%can pawns go forward 2 steps
    if L(p)==7
        if isequal([Board(5,C(p)); Board(6,C(p))], [0;0])
            Move=zeros(8);
            Move(7, C(p))=-1; Move(5, C(p))=1;
            thisJump=C(p);
            if PlayingPlayer == -1 %%%flip moves
               Move = -flipud(Move);
               thisJump= 9 - C(p);
            end
            Move= Move';
            Move1D=[(Move(:))', thisJump, 0 0 0 0];
            ListMoves=[ListMoves;Move1D];
        end
    end
    %%%can pawns move forward 1 step
    if Board(L(p)-1,C(p)) == 0
        Move = zeros(8);
        Move(L(p), C(p)) = -1; Move(L(p)-1, C(p)) = 1;
        if PlayingPlayer == -1 %%%flip moves
           Move = -flipud(Move);
        end
        Move= Move';
        Move1D=[(Move(:))', 0 0 0 0 0];
        ListMoves=[ListMoves;Move1D];
    end
    %%%can pawns take
    if C(p)>1
        if Board(L(p)-1,C(p)-1) < 0 %left
            Move = zeros(8);
            Move(L(p)-1,C(p)-1) = -Board(L(p)-1, C(p)-1) + 1; Move(L(p),C(p)) = -1;
            if PlayingPlayer == -1 %%%flip moves
               Move = -flipud(Move);
            end
            Move= Move';
            Move1D=[(Move(:))', 0 0 0 0 0];
            ListMoves=[ListMoves;Move1D];
        end
    end
    if C(p)<8
        if Board(L(p)-1,C(p)+1) < 0 %right
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
    
    %%%can pawns take en passant
    if LastJump~=0
        if LastJump<8
            if Board(4, LastJump+1)==1 %if can take en passant on left
                Move=zeros(8);
                Move(4,LastJump+1) = -1; Move(4,LastJump) = 1; Move(3,LastJump) = 1;
                if PlayingPlayer == -1 %%%flip moves
                   Move = -flipud(Move);
                end
                Move= Move';
                Move1D=[(Move(:))', 0 0 0 0 0];
                ListMoves=[ListMoves;Move1D];
            end
        end
        if LastJump>1
            if Board(4, LastJump-1) == 1 %if can take en passant on right
                Move = zeros(8);
                Move(4,LastJump-1) = -1; Move(4,LastJump) = 1; Move(3,LastJump) = 1;
                if PlayingPlayer== -1 %%%flip moves
                   Move = -flipud(Move);
                end
                Move= Move';
                Move1D=[(Move(:))', 0 0 0 0 0];
                ListMoves=[ListMoves;Move1D];
            end
        end
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
        isFree=1; isOnBoard=1;
        NewL = L(p); NewC = C(p);
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
                elseif Board(NewL, NewC) <0
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
                else
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
        isFree=1; isOnBoard=1;
        NewL = L(p); NewC = C(p);
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
                elseif Board(NewL, NewC) <0
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
                else
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
        isFree=1; isOnBoard=1;
        NewL = L(p); NewC = C(p);
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
                elseif Board(NewL, NewC) <0
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
                else
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
                isAttacked = OppAttacks((NewL-1)*8 + NewC) == 1;
                if ~isAttacked
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
                end
            elseif Board(NewL, NewC) <0
                if ~isAttacked
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
                isFree = 0;
            end
        else
            isOnBoard = 0;
        end
    end
end

if (PlayingPlayer == 1 && Castlings(1) > 0) || (PlayingPlayer == -1 && Castlings(3) > 0)
    %%%kingside
    if isequal(Board(8,5:8),[10 0 0 5])
        Move = zeros(8);
        Move(8,5:8) = [-10 5 10 -5];
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
    end
end
        
if (PlayingPlayer == 1 && Castlings(2) > 0) || (PlayingPlayer == -1 && Castlings(4) > 0)
    %%%queenside
    if isequal(Board(8,1:5),[5 0 0 0 10])
        Move = zeros(8);
        Move(8,1:5) = [-5 0 10 -5 -10];
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
    end
end
    

end