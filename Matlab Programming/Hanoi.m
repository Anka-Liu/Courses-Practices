function Moves = Hanoi(N,showSolution)
% Hanoi tower with N discs
% Moves is a sequences of moves that moves the stack from Peg 1 to Peg 3

if nargin<1
    % Use 5 discs if no parameters are given
    N = 5;
end

% There are N discs (number corresponds to size)
% Initially, all discs are on peg 1
% The last disc in the array is at the top of the peg
state = {(N:-1:1), [], []};

% Draw initial state
DrawTower(state);
pause(0.5);

if nargin>1 && showSolution
    % Compute solution
    Moves = HanoiComputeSolution(1,3,N);    
    
    % Animate the solution    
    MoveStack(state,Moves);
else
    % Play Hanoi
    Moves = [];
    while true        
        
        Peg1 = input('Enter Peg1 (or ''0'' to quit): ');
        if (Peg1 < 1) || (Peg1>3)
            break;
        end
        DrawTower(state,Peg1);
        
        Peg2 = input('Enter Peg2: ');
        Moves = [Moves;[Peg1, Peg2]];  % Add move to list of Moves
        state = MoveDisc(state,Peg1,Peg2);
        DrawTower(state);
    end
end

disp('Done');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function state = MoveStack(state,Moves)
% Moves is an Nx2 array of [Peg1, Peg2] pairs
% Each move sends the disc on Peg1 to Peg2

PauseLength = 0.01;

DrawTower(state);

for m = 1:size(Moves,1)
    pause(PauseLength);
    DrawTower(state,Moves(m,1)); % highlight disc to be moved
        
    state = MoveDisc(state,Moves(m,1), Moves(m,2));  % Move the disc
    
    pause(PauseLength);
    DrawTower(state);  % draw new state    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function state = MoveDisc(state,Peg1,Peg2)
% Move top disc on Peg1 to Peg2 
% If the move is illegal, then an warning is displayed and the state is unchanged

if (Peg1<1) || (Peg1>3) || (Peg2<1) || (Peg2>3)
    % Peg number is invalid
    disp('ILLEGAL MOVE: Peg number is invalid!')
elseif isempty(state{Peg1})
    % Peg1 is empty
    disp('ILLEGAL MOVE: No discs on that peg!')   
elseif ~isempty(state{Peg2}) && (state{Peg2}(end)<state{Peg1}(end))
    % The disc on top of Peg1 is larger than the disc on top of Peg2
    disp('ILLEGAL MOVE: Cannot place a disc on top of a smaller disc!')
else
    % Move is valid    
    Disc = state{Peg1}(end);    % Disc to move
    state{Peg1}(end) = [];      % Remove Disc from Peg1
    state{Peg2}(end+1) = Disc;  % add Disc to Peg2
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function DrawTower(state,highlight)
% Draw the discs on the pegs
% If "highlight" is given as a parameter, then the disc at the top of that
% peg is drawn in red.

figure(1);
clf;

hold on;
% draw pegs
PegX = [-3, 0, 3];    % x-position of each Peg
pegW = 0.1; pegH = 5.5;

baseDiscW = 0.4;
discW     = 0.2;  % Width of Disc N will equal N*discW + baseDiscW
discH     = 0.5;  % height of each disc

% draw base
rectangle('Position',[-4.5, -0.1, 9, 0.1],'FaceColor','k');

for PegNum = 1:3
    % Draw Peg
    rectangle('Position',[PegX(PegNum)-pegW/2,0,pegW,pegH],'FaceColor','k');

    % Draw Discs on Peg1
    for DiscNum=1:length(state{PegNum})        
        w = discW*state{PegNum}(DiscNum)+baseDiscW;  % Width of the disc
        x = PegX(PegNum)-w/2;              % x-position of disc
        y = (DiscNum-1)*discH;             % y-position of disc
        
        if nargin>1 && (highlight == PegNum) && (DiscNum==length(state{PegNum}))
            % highlight the disc
            col = 'r';
        else            
            col = 'g';
        end
        
        % Draw disc
        rectangle('Position',[x,y,w,discH],'Curvature',0.8,'FaceColor',col,'EdgeColor','k','LineWidth',3);
    end
end

hold off;
axis([-5, 5, -1, 10]);
axis off;

function z=HanoiComputeSolution(x,y,n)
if n<1
    z=[];
else
    tower=[1,2,3];
    bridge=tower(tower~=x & tower~=y);
    z=HanoiComputeSolution(x,bridge,n-1);
    z=[z;[x,y]];
    z=[z;HanoiComputeSolution(bridge,y,n-1)];
end

