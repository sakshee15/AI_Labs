#include <iostream>
#include <stdlib.h>
using namespace std;

char board[3][3] = {{' ',' ',' '},{' ',' ',' '},{' ',' ',' '}};
char currentPlayer = 'X';
char choice;

int row,column;

void display_board(){
    cout<<"\n\t------------------------------------";
    cout<<"\n\t\t AI[X]\t  Human[O]\n";
    cout<<"\t------------------------------------\n\n";
    cout<<"\t\t     |     |     \n";
    cout<<"\t\t  "<<board[0][0]<<"  |  "<<board[0][1]<<"  |  "<<board[0][2]<<" \n";
    cout<<"\t\t_____|_____|_____\n";
    cout<<"\t\t     |     |     \n";
    cout<<"\t\t  "<<board[1][0]<<"  |  "<<board[1][1]<<"  |  "<<board[1][2]<<" \n";
    cout<<"\t\t_____|_____|_____\n";
    cout<<"\t\t     |     |     \n";
    cout<<"\t\t  "<<board[2][0]<<"  |  "<<board[2][1]<<"  |  "<<board[2][2]<<" \n";
    cout<<"\t\t     |     |     \n";
}

bool checkResult(char letter) {
    // Check for the win in rows, columns, and diagonals
    for (int i = 0; i < 3; i++) {
        if ((board[i][0] == letter && board[i][1] == letter && board[i][2] == letter) ||
            (board[0][i] == letter && board[1][i] == letter && board[2][i] == letter)) {
            return true;
        }
    }

    if ((board[0][0] == letter && board[1][1] == letter && board[2][2] == letter) ||
        (board[0][2] == letter && board[1][1] == letter && board[2][0] == letter)) {
        return true;
    }
    return false;
}


void playerMove() {
    cout << "\n\n\t Place your move [O] : ";
    cin >> choice;

    switch (choice) {
        case '1': row = 0; column = 0; break;
        case '2': row = 0; column = 1; break;
        case '3': row = 0; column = 2; break;
        case '4': row = 1; column = 0; break;
        case '5': row = 1; column = 1; break;
        case '6': row = 1; column = 2; break;
        case '7': row = 2; column = 0; break;
        case '8': row = 2; column = 1; break;
        case '9': row = 2; column = 2; break;
        default:
            cout << "Invalid Move. Please choose a number between 1 and 9.\n";
            playerMove();
            return;
    }

    if (board[row][column] != 'X' && board[row][column] != 'O') {
        board[row][column] = 'O';
    } else {
        cout << "That cell has been already filled! Please choose another!!\n\n";
        playerMove();
        return;
    }

    display_board();
    
}

//
//bool checkWin() {
//    // Checking the win for rows and columns
//    for (int i = 0; i < 3; i++) {
//        if ((board[i][0] == board[i][1] && board[i][0] == board[i][2]) ||
//            (board[0][i] == board[1][i] && board[0][i] == board[2][i])) {
//            return true;
//        }
//    }
//
//    // Checking the win for both diagonals
//    if ((board[0][0] == board[1][1] && board[0][0] == board[2][2]) ||
//        (board[0][2] == board[1][1] && board[0][2] == board[2][0])) {
//        return true;
//    }
//    
//    return false;
//}

bool checkDraw() {
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            if (board[i][j] == ' ') {
                return false;
            }
        }
    }
    return true;
}

int heuristic(char b[3][3])
{
    // Checking for Rows for X or O victory.
    for (int row = 0; row<3; row++)
    {
        if (b[row][0]==b[row][1] &&
            b[row][1]==b[row][2])
        {
            if (b[row][0]=='X')
                return +10;
            else if (b[row][0]=='O')
                return -10;
        }
    }
  
    // Checking for Columns for X or O victory.
    for (int col = 0; col<3; col++)
    {
        if (b[0][col]==b[1][col] &&
            b[1][col]==b[2][col])
        {
            if (b[0][col]=='X')
                return +10;
  
            else if (b[0][col]=='O')
                return -10;
        }
    }
  
    // Checking for Diagonals for X or O victory.
    if (b[0][0]==b[1][1] && b[1][1]==b[2][2])
    {
        if (b[0][0]=='X')
            return +10;
        else if (b[0][0]=='O')
            return -10;
    }
  
    if (b[0][2]==b[1][1] && b[1][1]==b[2][0])
    {
        if (b[0][2]=='X')
            return +10;
        else if (b[0][2]=='O')
            return -10;
    }
  
    // Else if none of them have won then return 0
    return 0;
}
  
// This is the minmax function. It considers all
// the possible ways the game can go and returns
// the value of the board
int minmax(char board[3][3], int depth, bool isMax)
{
    int score = heuristic(board);
  
    // If Maximizer or Minimizer has won the game return his/her
    // evaluated score
    if (score == 10 || score == -10)
        return score;
  
    // If game is draw then score=0
    if (checkDraw()==true)
        return 0;
  
    // If this maximizer's move
    if (isMax)
    {
    	
        int best = -1000;
        // Traverse all cells
        for (int i = 0; i<3; i++)
        {
            for (int j = 0; j<3; j++)
            {
                // Check if cell is empty
                if (board[i][j]==' ')
                {
                    // Make the move
                    board[i][j] = 'X';
  
                    // Call minimax recursively and choose
                    // the maximum value
                    best = max( best,
                        minmax(board, depth+1, false) );
  
                    // Undo the move
                    board[i][j] = ' ';
                }
            }
        }
        return best;
    }
  
    // If this minimizer's move
    else
    {
        int best = 1000;
        // Traverse all cells
        for (int i = 0; i<3; i++)
        {
            for (int j = 0; j<3; j++)
            {
                // Check if cell is empty
                if (board[i][j]==' ')
                {
                    // Make the move
                    board[i][j] = 'O';
  
                    // Call minimax recursively and choose
                    // the minimum value
                    best = min(best,
                           minmax(board, depth+1, true));
  
                    // Undo the move
                    board[i][j] = ' ';
                }
            }
        }
        return best;
    }
}

int makeBestMove()
{
    int bestVal = -1000;
    int bestRow = -1;
    int bestCol = -1;
  
    // Traverse all cells, evaluate minimax function for
    // all empty cells, and return the cell with optimal
    // value.
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            // Check if cell is empty
            if (board[i][j] == ' ')
            {
                // Make the move
                board[i][j] = 'X';
  
                // Compute evaluation function for this move.
                int moveVal = minmax(board, 0,false);
  
                // Undo the move
                board[i][j] = ' ';
  
                // If the value of the current move is
                // more than the best value, then update best.
                if (moveVal > bestVal)
                {
                    bestRow = i;
                    bestCol = j;
                    bestVal = moveVal;
                }
            }
        }
    }
  
    // Place 'X' mark on the best move
    board[bestRow][bestCol] = 'X';
     display_board();
    return bestVal;
}

int main() {
    cout << "\t\t\t\t  W E L C O M E   T O ";
    cout << "\n\t\t\t T I C  -- T A C -- T O E -- G A M E\t\t\t";
    cout << "\n\t\t\t\t  AI(X) vs HUMAN(O)\n\t\t\t";
    display_board();
    //cout << "\n\t\tAI plays first\n\n";

    while (true) {
    	
        if (currentPlayer == 'X') {
            
            makeBestMove();
            
            if (checkResult('X')) {
                cout << "AI wins!" << endl;
                break;
            } else if (checkDraw()) {
                cout << "Draw!" << endl;
                break;
            }
        } else {
        	
            playerMove();
           
            if (checkResult('O')) {
                cout << "Player wins!" << endl;
                break;
            } else if (checkDraw()) {
                cout << "Draw!" << endl;
                break;
            }
        }
        
        currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
    }

    return 0;
}


