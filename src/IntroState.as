package{
    import org.flixel.*;

    public class IntroState extends FlxState{
        [Embed(source="../assets/road.png")] private var ImgRoad:Class;
        [Embed(source="../assets/trees1.png")] private var ImgTree:Class;
        [Embed(source="../assets/truck_top.png")] private var ImgTruck:Class;
        [Embed(source="../assets/wings.png")] private var ImgWings:Class;
        [Embed(source="../assets/boostflash.png")] private var ImgBoost:Class;

        public var road:FlxSprite;
        public var trees_left:FlxGroup;
        public var trees_right:FlxGroup;
        public var rand_tree:Number;
        public var left_tree_x:Number;
        public var right_tree_x:Number;
        public var tree_speed:Number = 3;
        public var tree:FlxSprite;
        public var i:Number = 0;

        public var truck:WigglySprite;
        public var truck_group:FlxGroup;
        public var truck_pos:FlxPoint;
        public var jiggle:Boolean = false;

        public var left_wing:FlxSprite;
        public var right_wing:FlxSprite;
        public var boost_flash:FlxSprite;

        override public function create():void{
            FlxG.mouse.hide();

            road = new FlxSprite(0,0);
            road.loadGraphic(ImgRoad,true,false,320,240);
            road.addAnimation("drive",[0,1,2],12,true);
            road.play("drive");
            this.add(road);

            truck_pos = new FlxPoint(145,30);

            left_wing = new WigglySprite(truck_pos.x-25,truck_pos.y+126);
            left_wing.loadGraphic(ImgWings,true,false,32,80);
            left_wing.addAnimation("leftwing",[0],12,false);
            left_wing.addAnimation("leftwing_flare",[1,2,3],12,true);
            left_wing.play("leftwing_flare");
            this.add(left_wing);

            right_wing = new WigglySprite(truck_pos.x+37,truck_pos.y+126);
            right_wing.loadGraphic(ImgWings,true,false,32,80);
            right_wing.addAnimation("rightwing",[4],12,false);
            right_wing.addAnimation("rightwing_flare",[5,6,7],12,true);
            right_wing.play("rightwing_flare");
            this.add(right_wing);

            truck_group = new FlxGroup();
            this.add(truck_group);

            for(i = 2; i >= 0; i--){
                truck = new WigglySprite(truck_pos.x,truck_pos.y);
                truck.loadGraphic(ImgTruck,true,false,42,186);
                truck.addAnimation("segment",[i],12,false);
                truck.play("segment");
                this.add(truck);
                truck_group.add(truck);
            }

            boost_flash = new WigglySprite(left_wing.x,left_wing.y);
            boost_flash.loadGraphic(ImgBoost,true,false,96,64);
            boost_flash.addAnimation("boost",[0],12,false);
            boost_flash.play("boost");
            //this.add(boost_flash);

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

            /*for(i = 0; i < truck_group.length; i++){
                if(truck_group.members[i].x > truck_pos.x+.5){
                    jiggle = true;
                } else if(truck_group.members[i].x < truck_pos.x-.5) {
                    jiggle = false;
                }

                if(jiggle){
                    truck_group.members[i].x -= .5;
                    truck_group.members[i].y -= .5;
                } else {
                    truck_group.members[i].x += .5;
                    truck_group.members[i].y += .5;
                }
            }*/

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
