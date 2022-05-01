let my_color = worker(0).color;
if "tick" in memory == false {
    info("NOT SET");
    memory.tick = 0;
} else {
    info(`${memory.tick}`);
    memory.tick += 1;
}

let row = [];
row.pad(40, true);
let matrix = [];
matrix.pad(40, row);

for w in map.workers{
    matrix[w.x][w.y] = false;
}
let moves1 = [[1, 0, 1], [-1, 0, 2], [0, 1, 3], [0, -1, 4]];
let moves2 = [[0, 1, 3], [0, -1, 4], [1, 0, 1], [-1, 0, 2]];

for w in 0..8 {
    let x = worker(w).x;
    let y = worker(w).y;
    let b = moves(moves1, x, y, my_color, matrix, map, w);
    if b == 0{
        let a = closest_exit(x, y,my_color, map);
        b = move(x, y, a, matrix);
    }
    switch b{
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

fn moves(moves1, x, y, my_color, matrix, map, w){
    let poss_pos = [];
    for move in moves1 {
        let x2 = x+move[0];
        let y2 = y+move[1];
        if valid_pos(x2, y2) && map[x2][y2] != my_color && matrix[x2][y2]{
            poss_pos += move[2];
        }
    }
    let m = [0, 0]; //0-> dist, 1-> pos
    info(`WORKER ${w} POSSIBLE POS: ${len(poss_pos)}`);
    for pos in poss_pos{
        let pp = [[1,0] , [-1,0] , [0,1] , [0,-1]];
        let min = min_dist([x + pp[pos-1][0], y + pp[pos-1][1]], map, my_color);
        if min >= m[0]{
            m = [min, pos];
        }
    }
    return m[1];
}

fn min_dist(pos, map, my_color){
    //distance between some position and the closest enemy square
    let min = 80;
    for w in map.workers{
        if w.color != my_color{
            let n = 0;
            n = distance(pos, w);
            if min > n{
                min = n;
            }
        }
    }
    info(`pos: ${pos}, min distance: ${min}`);
    return min;
}

fn distance(pos, w){
    return (pos[0] - w.x).abs() + (pos[1] - w.y).abs();
}

fn closest_exit(x, y, my_color, map){
    for n in 1..40{
        for i in range(-n, n+1){
            for j in range(-n, n+1){
                if valid_pos(x+i, y+j) && map[x+i][y+j] != my_color && (i).abs()+(j).abs() == n{
                    info(`${x+i}, ${y+j}`);
                    return [x+i, y+j];
                }
            }
        }
    }
}

fn move(x, y, a, matrix){
    if x < a[0] && matrix[x+1][y]{
        return 1;
    }
    if x > a[0] && matrix[x-1][y]{
        return 2;
    }if y < a[1] && matrix[x][y+1]{
        return 3;
    }if y > a[1] && matrix[x][y-1]{
        return 4;
    }
    return 0;
}

fn valid_pos(x, y){
    return x <= 39 && x >= 0 && y <= 39 && y>= 0;
}