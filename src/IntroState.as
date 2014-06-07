package{
    import org.flixel.*;

    public class IntroState extends FlxState{
        [Embed(source="../assets/road.png")] private var ImgRoad:Class;
        [Embed(source="../assets/trees1.png")] private var ImgTree:Class;

        public var road:FlxSprite;
        public var trees_left:FlxGroup;
        public var trees_right:FlxGroup;
        public var rand_tree:Number;
        public var left_tree_x:Number;
        public var right_tree_x:Number;
        public var tree_speed:Number = 3;
        public var tree:FlxSprite;
        public var i:Number = 0;

        override public function create():void{
            FlxG.mouse.hide();

            road = new FlxSprite(0,0);
            road.loadGraphic(ImgRoad,true,false,320,240);
            road.addAnimation("drive",[0,1,2],12,true);
            road.play("drive");
            this.add(road);

            trees_left = new FlxGroup();
            this.add(trees_left);

            trees_right = new FlxGroup();
            this.add(trees_right);

            //left tress
            for(i = 0; i < 10; i++){
                calculate_tree_vars();
                var left_tree_y:Number;
                if(i > 0){
                    left_tree_y = trees_left.members[i-1].y+trees_left.members[i-1].height;
                } else {
                    left_tree_y = 0;
                }
                tree = new FlxSprite(left_tree_x,left_tree_y);
                tree.loadGraphic(ImgTree,true,false,70,110);
                tree.addAnimation("tree",[rand_tree],12,false);
                tree.play("tree");
                trees_left.add(tree);
                add(tree);
            }

            //right trees
            for(i = 0; i < 10; i++){
                calculate_tree_vars();
                var right_tree_y:Number;

                if(i > 0){
                    right_tree_y = trees_left.members[i-1].y+trees_left.members[i].height;
                } else {
                    right_tree_y = 0;
                }
                tree = new FlxSprite(right_tree_x,right_tree_y);
                tree.loadGraphic(ImgTree,true,false,70,110);
                tree.addAnimation("tree",[rand_tree],12,false);
                tree.play("tree");
                trees_right.add(tree);
                add(tree);
            }
        }

        override public function update():void{
            super.update();

            for(i = 0; i < trees_left.length; i++){
                update_trees(i,trees_left);
                update_trees(i,trees_right);
            }

            if(FlxG.mouse.pressed()){
                FlxG.switchState(new PlayState());
            }
        }

        public function update_trees(i:Number,trees:FlxGroup):void{
            trees.members[i].y += tree_speed;
            if(trees.members[i].y > FlxG.height){
                trees.members[i].y = -trees.members[i].height - Math.random()*500;
                calculate_tree_vars();
                trees.members[i].addAnimation("tree",[rand_tree],12,false);
                trees.members[i].play("tree");

                if(i <= 2){
                    trees.members[i].x = left_tree_x;
                } else {
                    trees.members[i].x = right_tree_x;
                }
            }
        }

        public function calculate_tree_vars():void{
            rand_tree = Math.floor(Math.random()*6)
            right_tree_x = (Math.random()*50)+210;
            left_tree_x = Math.random()*20;
        }
    }
}
