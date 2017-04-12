class Main {
  static public function main():Void{
    for (i in 0...126) trace(i, get_shelled_point(i), get_shell(i));
  }
  static function get_shelled_point(i:Int){

    //Tom Blanchet (c) 2017

  	var ret_point = new haxe.ds.Vector(3);

    if(i == 0){
      //Edge case
      ret_point[0]=0;
      ret_point[1]=0;
      ret_point[2]=0;
    }else{
      //Find what shell we are on from i
      //and establish other useful variables.
    	var shell_num = get_shell(i);
    	var shell_size_below = 2*shell_num - 1;
    	var i_on_shell = i-(shell_size_below*shell_size_below*shell_size_below);

      //We remove two corners and reserve them for the first two indecies
      //We can then divide the cube surface into 6 equal parts.
      //Each part includes one corner point, 2 adjacent edges, and the shared side.
      //Therefore, each part is a 2*shell_num x 2*shell_num grid of points.
      //e.g. Using the following cube:
      //     e-------f
      //    /|      /|
      //   / |     / |
      //  a--|----b  |
      //  |  g----|--h
      //  | /     | /
      //  c-------d
      //
      //Let's assume we found that we need shell_num = 2.
      //We reserve the points at c and f for index 0 and 1.
      //Then, we split the remaining points into 6 parts
      //For the first part, look at side abcd, and take
      //the following points marked with o:
      // a . . . b            . . . . .
      // . . . . .            . o o o o
      // . . . . .    ====>   . o o o o
      // . . . . .            . o o o o
      // c . . . d            . o o o o
      //
      //We can then rotate the axies about the corner c
      //moving the ac edge to where cd is now)
      //or we can reflect across the origin (flip the sign) to get to a new,
      //completely separate part. The only two points that will not be in one
      //of these parts are exactly c and f.

      switch i_on_shell{
        case 0: {
          ret_point[0] = shell_num;
          ret_point[1] = shell_num;
          ret_point[2] = shell_num;

        };
        case 1:{
          ret_point[0] = -shell_num;
          ret_point[1] = -shell_num;
          ret_point[2] = -shell_num;
        };
        default:{
          //part number of shell
          var part = (i_on_shell-2)%6;

          //index on part
          var i_on_part = Std.int((i_on_shell - 2)/6);

          //2D coords on part
          var coord_size = 2*shell_num;
          var part_coords = [Std.int(i_on_part/(2*shell_num)), i_on_part%(2*shell_num)];

          //Pick which half (parts adjacent from a removed corner)
          //of the shell with sign
          var sign = 1 - 2*(part%2);

          //Then, pick which axis is perpendicular to the side.
          var p_axis = part%3;

          //rotate edges from removed corner, and flip if other corner.
          ret_point[p_axis] = sign*shell_num;
          ret_point[(p_axis+1)%3] = sign*(part_coords[0] - shell_num + 1);
          ret_point[(p_axis+2)%3] = sign*(part_coords[1] - shell_num);
        };
      };

    }
    return ret_point;
  }

  static function get_shell(i:Int):Int{
    var shell_number = 0;
    var shell_size = 1;
    while( (shell_size*shell_size*shell_size)<(i+1) ) {
      shell_size = shell_size + 2;
      shell_number = shell_number + 1;
    }
    return shell_number;
  }
}
