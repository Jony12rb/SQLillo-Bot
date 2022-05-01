let my_color = worker(0).color; //to track our team

//matrix with the positions wich we can and can't move in the actual tick
let row = [];
row.pad(40, true);
let matrix = [];
matrix.pad(40, row);

/*
We shouldn't move to a place already occupied, even if possible, 
given that we can't predict the next step of other team's workers.
*/
for w in map.workers{
    matrix[w.x][w.y] = false;
}

//just to have to kind of workers, with different priorities
//the last number identifies the move in each array.
let moves1 = [[1, 0, 1], [-1, 0, 2], [0, 1, 3], [0, -1, 4]];
let moves2 = [[0, 1, 3], [0, -1, 4], [1, 0, 1], [-1, 0, 2]];
let moves = [moves1, moves2];

for w in 0..8 {
    let x = worker(w).x;
    let y = worker(w).y;
    let b = moves(moves[w%2], x, y, my_color, matrix, map);
    //if we couldn't decide a move, we try to move to a more useful position.
    if b == 0{
        let a = closest_exit(x, y, my_color, map);
        b = move(x, y, a, matrix);
    //moves based on b.
    } switch b{
        1 => {
            worker(w).move_right();
            matrix[x+1][y] = false;
            info(`${w} right`);
        },
        2 => {
            worker(w).move_left();
            matrix[x-1][y] = false;
            info(`${w} left`);
        },
        3 => {
            worker(w).move_up();
            matrix[x][y+1] = false;
            info(`${w} up`);
        },
        4 => {
            worker(w).move_down();
            matrix[x][y-1] = false;
            info(`${w} down`);
        },
    }
}

fn moves(moves, x, y, my_color, matrix, map){
    /*
    Given a list of moves wich a representative numbre, a position, the color of the team, 
    a matrix with the accesible places and information about the current cituation, decides
    where to move the worker at x, y and returns the identification number of that move. 
    If there's not a good move, returns 0.
    */
    for move in moves {
        let x2 = x+move[0];
        let y2 = y+move[1];
        if not_conquered(x2, y2, map, my_color) && matrix[x2][y2]{
            return move[2];
        }
    }
    return 0;
}

fn closest_exit(x, y, my_color, map){
    /*
    Given a position, the team color and information about the map, determines
    one of the closest places to x, y that has a color wich is not the team color.
    */
    for n in 1..40{
        for i in range(-n, n+1){
            for j in range(-n, n+1){
                //if it's from a different color and has the wanted taxicab geometry's distance.
                if not_conquered(x+i, y+j, map, my_color) && (i).abs()+(j).abs() == n{
                    info(`${x+i}, ${y+j}`);
                    return [x+i, y+j];
                }
            }
        }
    }
}

fn not_conquered(x, y, map, my_color){
    /*
    Returns true if the position is valid and has a different color from the team color,
    false otherwise.
    */
    return valid_pos(x, y) && map[x][y] != my_color;
}

fn move(x, y, a, matrix){
    /*
    Given an origin, x,y, and a destination, a, in a matrix of possible moves, returns 
    the identification number for the move we should make to go from the origin to the destiny.
    */
    if x < a[0] && matrix[x+1][y]{
        return 1;
    }if x > a[0] && matrix[x-1][y]{
        return 2;
    }if y < a[1] && matrix[x][y+1]{
        return 3;
    }if y > a[1] && matrix[x][y-1]{
        return 4;
    }return 0;
}

fn valid_pos(x, y){
    /*
    Returns true if the cordinates are inside the map, false otherwise.
    */
    return x <= 39 && x >= 0 && y <= 39 && y>= 0;
}

