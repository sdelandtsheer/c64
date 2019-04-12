function [Value] = c64_eval(Board, PlayingPlayer)

LastJump = Board(end-4); 
Castlings = Board(end-3:end);

Board2D=(reshape(Board(1:end-5), 8, 8))';

if PlayingPlayer == -1 %%%flip board
    Board2D = - flipud(Board2D);
    if LastJump ~= 0
        LastJump= 9 - LastJump;
    end
end

if PlayingPlayer == 1
    OwnKingside = Castlings(1);
	OwnQueenside = Castlings(2);
    OppKingside = Castlings(3);
    OppQueenside = Castlings(4);
elseif PlayingPlayer == -1
    OwnKingside = Castlings(3);
	OwnQueenside = Castlings(4);
    OppKingside = Castlings(1);
    OppQueenside = Castlings(2);
end

PosOwnP = find(Board2D == 1);
PosOwnN = find(Board2D == 2.9);
PosOwnB = find(Board2D == 3.1);
PosOwnR = find(Board2D == 5);
PosOwnQ = find(Board2D == 9);
PosOwnK = find(Board2D == 10);

PosOppP = find(Board2D == -1);
PosOppN = find(Board2D == -2.9);
PosOppB = find(Board2D == -3.1);
PosOppR = find(Board2D == -5);
PosOppQ = find(Board2D == -9);
PosOppK = find(Board2D == -10);

%%% material
M = sum(Board2D(:));

%%% double pawns
NOwnDP = 0; NOppDP = 0;
if numel(PosOwnP)>1
    NOwnDP = numel((PosOwnP(2:end)-PosOwnP(1:end-1))==8);
    NOppDP = numel((PosOppP(2:end)-PosOppP(1:end-1))==8);
end

%%% islands of pawns
NOwnIP = 0; NOppIP = 0;
if numel(PosOwnP)>1
    [I1, J1] = ind2sub([8 8], PosOwnP);
    J1=sort(J1, 'ascend');
    NOwnIP = sum((J1(2:end) - J1(1:end-1)) > 1);
elseif numel(PosOwnP) == 1
    NOwnIP = 1;
end
if numel(PosOppP)>1
    [I2, J2] = ind2sub([8 8], PosOppP);
    J2=sort(J2, 'ascend');
    NOppIP = sum((J2(2:end) - J2(1:end-1)) > 1);
elseif numel(PosOppP) == 1
    NOppIP = 1;
end

%%% passed pawns
NOwnPP = sum(I1<5); NOppPP = sum(I2>4);

%%% number of possible moves
OwnMoves = c64_listmoves(Board, PlayingPlayer);
OppMoves = c64_listmoves(Board, -PlayingPlayer);
NOwnMoves = size(OwnMoves, 1);
NOppMoves = size(OppMoves, 1);

%%% control of center
NOwnCenter = sum(sum(OwnMoves(:, [28, 29, 36, 37]) ~= 0));
NOppCenter = sum(sum(OppMoves(:, [28, 29, 36, 37]) ~= 0));

%%% king safety: TODO
NOwnKingSafe = 0;
NOppKingSafe = 0;


%%% castling possibilities
NOwnCastlings = OwnKingside + OwnQueenside;
NOppCastlings = OppKingside + OppQueenside;

%%% general formula

Value = M + ...
    0.01 * (NOppDP+1)/(NOwnDP+1) + ...
    0.01 * (NOppIP+1)/(NOwnIP+1) + ...
    0.01 * (NOwnPP+1)/(NOppPP+1) + ...
    0.01 * (NOwnCenter+1)/(NOppCenter+1) + ...
    0.01 * (NOwnMoves+1)/(NOppMoves+1) + ...
    0.01 * (NOwnKingSafe+1)/(NOppKingSafe+1) + ...
    0.01 * (NOwnCastlings+1)/(NOppCastlings+1);

Value = Value * PlayingPlayer;

end