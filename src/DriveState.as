package{
    import org.flixel.*;

    public class DriveState extends FlxState{
        [Embed(source="../assets/gametruck.png")] private var Truck:Class;
        [Embed(source="../assets/space1.png")] private var Bg:Class;
        [Embed(source="../assets/planet.png")] private var ImgPlanet:Class;
        [Embed(source="../assets/timertext.png")] private var ImgTimerText:Class;
        [Embed(source="../assets/sparks.png")] private var ImgSpark:Class;

        public var now:Date;
        public var startTime:Date;
        public var planets_visited:Number;
        public var plushies_delivered:Number;
        public var time_remaining:Number;
        public var timeFrame:Number = 0;

        public var planet:FlxSprite;
        public var truck:FlxSprite;
        public var bg:FlxSprite;
        public var time_bar:TimeCounter = null;
        public var black_bg:FlxSprite;
        public var timer_text:FlxSprite;

        public var sparks:Array;

        public function DriveState(planet_count:Number, plushie_count:Number, time_remaining:Number):void{
            planets_visited = planet_count;
            plushies_delivered = plushie_count;
            this.time_remaining = time_remaining;
        }

        override public function create():void{
            startTime = new Date();

            sparks = new Array();

            bg = new FlxSprite(0,0);
            bg.loadGraphic(Bg,false,false,640,480);
            add(bg);

            planet = new FlxSprite(210,65);
            planet.loadGraphic(ImgPlanet,true,false,64,64);
            planet.addAnimation("1",[0],1,false);
            planet.addAnimation("2",[1],1,false);
            planet.addAnimation("3",[2],1,false);
            planet.addAnimation("5",[3],1,false);
            planet.addAnimation("4",[4],1,false);
            if(planets_visited == 0){
                planet.play("2");
            } else if(planets_visited == 1){
                planet.play("3");
            } else if(planets_visited == 2){
                planet.play("4");
            } else if(planets_visited == 3){
                planet.play("5");
            } else if(planets_visited == 4){
                planet.play("1");
            }
            add(planet);
            planet.scale.x = .5;
            planet.scale.y = .5;

            planet = new FlxSprite(210,65);
            planet.loadGraphic(ImgPlanet,true,false,64,64);
            planet.addAnimation("1",[0],1,false);
            planet.addAnimation("2",[1],1,false);
            planet.addAnimation("3",[2],1,false);
            planet.addAnimation("5",[3],1,false);
            planet.addAnimation("4",[4],1,false);
            if(planets_visited == 1){
                planet.play("2");
            } else if(planets_visited == 2){
                planet.play("3");
            } else if(planets_visited == 3){
                planet.play("4");
            } else if(planets_visited == 4){
                planet.play("5");
            } else if(planets_visited == 5){
                planet.play("1");
            }
            add(planet);
            planet.scale.x = .5;
            planet.scale.y = .5;

            truck = new FloatySprite(100,20);
            truck.loadGraphic(Truck,true,false,100,64);
            truck.addAnimation("idle", [0], 1, false);
            truck.addAnimation("open", [1], 1, false);
            truck.addAnimation("boost", [2, 3, 4], 12, true);
            truck.play("boost");
            add(truck);

            black_bg = new FlxSprite(0,0);
            black_bg.makeGraphic(320,480,0xff000000);
            this.add(black_bg);
            black_bg.alpha = 0;

            if (planets_visited != 0 && planets_visited != BigRoad.total_planets) {
                time_bar = new TimeCounter(new FlxPoint(10, 20), 200);
                time_bar.set_time(time_remaining);
                time_bar.total_frames = BigRoad.total_time;
                timer_text = new FlxSprite(40,5);
                timer_text.loadGraphic(ImgTimerText,false,false,73,8);
                add(timer_text);
            }
        }

        override public function update():void{
            super.update();
            timeFrame++;
            bg.y -= .5;

            if (time_bar != null) {
                time_bar.update();
            }

            planet.scale.x += .05;
            planet.scale.y += .05;
            planet.x -= .5;
            planet.y += 2;

            if (timeFrame % 1 == 0) {
                var spark:FlxSprite = new FlxSprite(truck.x + Math.random()*60, truck.y + 35);
                spark.loadGraphic(ImgSpark, true, true, 16, 16);
                spark.addAnimation("spark",[Math.floor(Math.random()*7)],12,false);
                spark.play("spark");
                add(spark);
                sparks.push(spark);
            }

            for (var i:int = 0; i < sparks.length; i++) {
                var s:FlxSprite = sparks[i];
                s.x -= 4;
                s.y += 3;
                if (s.x < -10) {
                    s.visible = false;
                    sparks.splice(i, 1);
                }
            }

            if(new Date().valueOf() - startTime.valueOf() > 4000){
                if(planets_visited >= BigRoad.total_planets){
                    FlxG.switchState(new OutroState(plushies_delivered));
                } else {
                    FlxG.switchState(new PlayState(planets_visited,plushies_delivered, time_remaining - (planets_visited == 0 ? 0 : timeFrame)));
                }
            }
        }
    }
}
