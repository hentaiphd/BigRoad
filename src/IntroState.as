package{
    import org.flixel.*;

    public class IntroState extends FlxState{
        [Embed(source="../assets/road.png")] private var ImgRoad:Class;
        [Embed(source="../assets/trees1.png")] private var ImgTree:Class;
        [Embed(source="../assets/truck_top.png")] private var ImgTruck:Class;
        [Embed(source="../assets/wings.png")] private var ImgWings:Class;
        [Embed(source="../assets/boostflash.png")] private var ImgBoost:Class;
        [Embed(source="../assets/sparks.png")] private var ImgSparks:Class;
        [Embed(source="../assets/spacedad.mp3")] private var SndBGM:Class;
        [Embed(source="../assets/frontsteps.png")] private var ImgAptBg:Class;

        public var road:FlxSprite;
        public var trees_left:FlxGroup;
        public var trees_right:FlxGroup;
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

        public var sparks_l:FlxSprite;
        public var sparks_l_group:FlxGroup;
        public var spark_l_speed:Number;
        public var spark_l_speed_group:Array = new Array();

        public var sparks_r:FlxSprite;
        public var sparks_r_group:FlxGroup;
        public var spark_r_speed:Number;
        public var spark_r_speed_group:Array = new Array();

        public var black_bg:FlxSprite;
        public var apt_bg:FlxSprite;

        public var time_frame:Number = 0;
        public var time_sec:Number = 0;

        public var current_state:Number = 1;

        public var debug_text:FlxText;

        public var timer:Number = 3;

        override public function create():void{
            FlxG.mouse.hide();

            road = new FlxSprite(0,0);
            road.loadGraphic(ImgRoad,true,false,320,240);
            road.addAnimation("drive",[0,1,2],12,true);
            road.play("drive");
            this.add(road);

            truck_pos = new FlxPoint(145,10);

            left_wing = new WigglySprite(truck_pos.x-25,truck_pos.y+126);
            left_wing.loadGraphic(ImgWings,true,false,32,80);
            left_wing.addAnimation("leftwing",[0],12,false);
            left_wing.addAnimation("leftwing_flare",[1,2,3],12,true);
            left_wing.play("leftwing");
            this.add(left_wing);
            left_wing.alpha = 0;

            right_wing = new WigglySprite(truck_pos.x+37,truck_pos.y+126);
            right_wing.loadGraphic(ImgWings,true,false,32,80);
            right_wing.addAnimation("rightwing",[4],12,false);
            right_wing.addAnimation("rightwing_flare",[5,6,7],12,true);
            right_wing.play("rightwing");
            this.add(right_wing);
            right_wing.alpha = 0;

            truck_group = new FlxGroup();
            this.add(truck_group);

            for(i = 2; i >= 0; i--){
                truck = new WigglySprite(truck_pos.x,truck_pos.y);
                truck.loadGraphic(ImgTruck,true,false,42,186);
                truck.addAnimation("segment",[i],12,false);
                truck.addAnimation("segment_quicker",[i],15,false);
                truck.addAnimation("segment_more_quick",[i],20,false);
                truck.play("segment");
                this.add(truck);
                truck_group.add(truck);
            }

            boost_flash = new WigglySprite(left_wing.x,left_wing.y);
            boost_flash.loadGraphic(ImgBoost,true,false,96,64);
            boost_flash.addAnimation("boost",[0],12,false);
            boost_flash.play("boost");

            sparks_l_group = new FlxGroup();
            this.add(sparks_l_group);

            sparks_r_group = new FlxGroup();
            this.add(sparks_r_group);

            for(i = 0; i < 20; i++){
                sparks_l = new WigglySprite(left_wing.x+Math.random()*20,left_wing.y + (Math.random()*100)+20);
                sparks_l.loadGraphic(ImgSparks,true,false,16,16);
                sparks_l.addAnimation("spark",[Math.floor(Math.random()*7)],12,false);
                sparks_l.play("spark");
                sparks_l_group.add(sparks_l);
                sparks_l.alpha = 0;

                spark_l_speed = (Math.random()*5)+2;
                spark_l_speed_group.push(spark_l_speed);
            }

            for(i = 0; i < 20; i++){
                sparks_r = new WigglySprite(right_wing.x+Math.random()*20,right_wing.y + (Math.random()*100)+20);
                sparks_r.loadGraphic(ImgSparks,true,false,16,16);
                sparks_r.addAnimation("spark",[Math.floor(Math.random()*7)],12,false);
                sparks_r.play("spark");
                sparks_r_group.add(sparks_r);
                sparks_r.alpha = 0;

                spark_r_speed = (Math.random()*5)+2;
                spark_r_speed_group.push(spark_r_speed);
            }

            trees_left = new FlxGroup();
            this.add(trees_left);

            trees_right = new FlxGroup();
            this.add(trees_right);

            //left tress
            for(i = 0; i < 10; i++){
                var left_tree_y:Number;
                if(i > 0){
                    left_tree_y = trees_left.members[i-1].y+trees_left.members[i-1].height;
                } else {
                    left_tree_y = 0;
                }
                tree = new FlxSprite(getNewTreePos(false),left_tree_y);
                tree.loadGraphic(ImgTree,true,false,70,110);
                tree.addAnimation("tree",[Math.floor(Math.random()*3)+3],12,false);
                tree.play("tree");
                trees_left.add(tree);
                add(tree);
            }

            //right trees
            for(i = 0; i < 10; i++){
                var right_tree_y:Number;
                if(i > 0){
                    right_tree_y = trees_left.members[i-1].y+trees_left.members[i].height;
                } else {
                    right_tree_y = 0;
                }
                tree = new FlxSprite(getNewTreePos(true),right_tree_y);
                tree.loadGraphic(ImgTree,true,false,70,110);
                tree.addAnimation("tree",[Math.floor(Math.random()*3)],12,false);
                tree.play("tree");
                trees_right.add(tree);
                add(tree);
            }

            if(FlxG.music == null){
                FlxG.playMusic(SndBGM);
            } else {
                FlxG.music.resume();
                if(!FlxG.music.active){
                    FlxG.playMusic(SndBGM);
                }
            }

            apt_bg = new FlxSprite(0,0);
            apt_bg.loadGraphic(ImgAptBg,true,false,320,480);
            apt_bg.addAnimation("no_bubble",[0],12,false);
            apt_bg.addAnimation("friend_bubble",[1],12,false);
            apt_bg.addAnimation("girl_bubble",[2],12,false);
            this.add(apt_bg);
            apt_bg.play("no_bubble");

            black_bg = new FlxSprite(0,0);
            black_bg.makeGraphic(320,480,0xff000000);
            this.add(black_bg);
            black_bg.alpha = 0;

            debug_text = new FlxText(10,10,500,"");
            this.add(debug_text);
        }

        override public function update():void{
            super.update();
            time_frame++;
            if(time_frame%50 == 0){
                time_sec++;
            }
            debug_text.text = "State: " + current_state.toString() + " Timer: " + timer.toString() + " TimeSec: " + time_sec.toString();

            if(time_sec == timer){
                if(current_state == 1){
                    timer += 10;
                    current_state++;
                    apt_bg.play("friend_bubble");
                }
            }
            if(time_sec == timer){
                if(current_state == 2){
                    timer += 10;
                    current_state++;
                    apt_bg.play("girl_bubble");
                }
            }
            if(time_sec == timer){
                if(current_state == 3){
                    timer += 2;
                    current_state++;
                }
            }
            if(time_sec == timer){
                if(current_state == 4){
                    timer += 10;
                    current_state++;
                    apt_bg.alpha = 0;
                }
            }
            if(time_sec == timer){
                if(current_state == 5){
                    timer += 2;
                    current_state++;
                }
            }
            if(time_sec == timer){
                if(current_state == 6){
                    timer += 10;
                    apt_bg.alpha = 1;
                }
            }
            if(time_sec == timer){
                if(current_state == 7){
                    //apt_bg.alpha = 1;
                }
            }

            if(current_state == 1){
                //do nothing
            } else if(current_state == 2){
                //do nothing
            } else if(current_state == 3){
                black_bg.alpha += .01;
            } else if(current_state == 4){
                black_bg.alpha -= .01;
            } else if(current_state == 5){
                black_bg.alpha += .01;
            } else if(current_state == 6){
                black_bg.alpha -= .01;
            } else if(current_state == 7){
                //black_bg.alpha -= .01;
            }

            if(FlxG.mouse.pressed()){
                FlxG.switchState(new CloseUpIntroState());
            }

            /*if(timeFrame == 7*50){
                this.add(boost_flash);
                boost_speed(false);
            }
            if(timeFrame == 9*50){
                boost_flash.kill();
                left_wing.play("leftwing_flare");
                right_wing.play("rightwing_flare");
                this.add(sparks_r);
                this.add(sparks_l);
                boost_speed(true);
            }
            if(timeFrame == 13*50){
                boost_speed(true);
            }
            if(timeSec == 17 || FlxG.keys.SPACE || FlxG.mouse.pressed()){
                FlxG.switchState(new CloseUpIntroState());
            }

            for(i = 0; i < trees_left.length; i++){
                update_trees(i,trees_left, false);
            }

            for(i = 0; i < trees_right.length; i++){
                update_trees(i,trees_right, true);
            }

            for(i = 0; i < sparks_l_group.length; i++){
                sparks_l_group.members[i].y += spark_l_speed_group[i];
                sparks_r_group.members[i].y += spark_r_speed_group[i];
                if(sparks_l_group.members[i].y > FlxG.height){
                    sparks_l_group.members[i].y = left_wing.y + (Math.random()*30)+30;
                }
                if(sparks_r_group.members[i].y > FlxG.height){
                    sparks_r_group.members[i].y = right_wing.y + (Math.random()*30)+30;
                }
            }*/
        }

        public function update_trees(i:Number,trees:FlxGroup, _right:Boolean):void{
            trees.members[i].y += tree_speed;
            if(trees.members[i].y > FlxG.height){
                trees.members[i].y = -trees.members[i].height - Math.random()*500;

                if(!_right){
                    trees.members[i].x = getNewTreePos(false);
                    trees.members[i].addAnimation("tree",[Math.floor(Math.random()*3)+3],12,false);
                    trees.members[i].play("tree");
                } else {
                    trees.members[i].x = getNewTreePos(true);
                    trees.members[i].addAnimation("tree",[Math.floor(Math.random()*3)],12,false);
                    trees.members[i].play("tree");
                }
            }
        }

        public function getNewTreePos(dir:Boolean):Number{
            if(dir){
                return (Math.random()*50)+210;
            } else {
                return Math.random()*20;
            }

        }

        public function boost_speed(all:Boolean):void{
            if(all){
                tree_speed += 2;
                for(i = 0; i < sparks_l_group.length; i++){
                    spark_r_speed_group[i] += 2;
                    spark_l_speed_group[i] += 2;
                }
                truck.play("segment_more_quick");
            } else {
                tree_speed += 2;
                truck.play("segment_quicker");
            }
        }
    }
}
