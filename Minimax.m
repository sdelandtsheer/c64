% function minimax(node, depth, maximizingPlayer) is
%     if depth = 0 or node is a terminal node then
%         return the heuristic value of node
%     if maximizingPlayer then
%         value := ??
%         for each child of node do
%             value := max(value, minimax(child, depth ? 1, FALSE))
%         return value
%     else (* minimizing player *)
%         value := +?
%         for each child of node do
%             value := min(value, minimax(child, depth ? 1, TRUE))
%         return value
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%%% initialize board

function [Value] = Minimax(Board, n, depth, PlayingPlayer)
% p8_visualizeBoard(Board, n), drawnow

if depth==0 || ttt_haswon(Board, n, PlayingPlayer)~=0 || sum(Board==0)==0
    Value=ttt_haswon(Board);
    disp(['Reaching the end... value = ', num2str(Value)])    
else
    if PlayingPlayer
        if ttt_haswon(Board)==-1
            disp('Player 2 has won')
        else
            Value=-Inf;
            ListMoves=ttt_listmoves(Board, 1);
            NMoves=size(ListMoves, 1);
            disp(['Looking into player 1 moves: there are ', num2str(NMoves), ' moves'])
            pBoard=Board;
            for move=1:NMoves
                Board=pBoard;
                disp(['Trying player 1 move at depth ', num2str(depth),' on position ', num2str(find(ListMoves(move,:)))])
                Board=Board+ListMoves(move,:);
                Value = max(Value, Minimax(Board, depth-1, 0));
            end
        end
    elseif ~PlayingPlayer
        if ttt_haswon(Board)==1
            disp('Player 1 has won')
        else
            Value=Inf;
            ListMoves=ttt_listmoves(Board, -1);
            NMoves=size(ListMoves, 1);
            disp(['Looking into player 2 moves, there are ', num2str(NMoves), ' moves'])
            pBoard=Board;
            for move=1:NMoves
                Board=pBoard;
                disp(['Trying player 2 move at depth ', num2str(depth),' on position ', num2str(find(ListMoves(move,:)))])
                Board=Board+ListMoves(move,:);
                Value = min(Value, Minimax(Board, depth-1, 1));
            end
        end
    end

end