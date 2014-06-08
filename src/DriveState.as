package{
    import org.flixel.*;

    public class DriveState extends FlxState{
        [Embed(source="../assets/planet.png")] private var Planet2:Class;
        [Embed(source="../assets/gametruck.png")] private var Truck:Class;
        [Embed(source="../assets/space1.png")] private var Bg:Class;
        public var now:Date;
        public var startTime:Date;
        public var planets_visited:Number;
        public var plushies_delivered:Number;

        public var planet:FlxSprite;
        public var truck:FlxSprite;
        public var bg:FlxSprite;
        public var black_bg:FlxSprite;

        public function DriveState(planet_count:Number, plushie_count:Number):void{
            planets_visited = planet_count;
            plushies_delivered = plushie_count;
        }

        override public function create():void{
            FlxG.mouse.hide();
            startTime = new Date();

            bg = new FlxSprite(0,0);
            bg.loadGraphic(Bg,false,false,640,480);
            add(bg);

            planet = new FlxSprite(210,65);
            planet.loadGraphic(Planet2,false,false,64,64);
            add(planet);
            planet.scale.x = .5;
            planet.scale.y = .5;

            planet = new FlxSprite(210,65);
            planet.loadGraphic(Planet2,false,false,64,64);
            add(planet);
            planet.scale.x = .5;
            planet.scale.y = .5;

            truck = new FlxSprite(100,20);
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
        }

        override public function update():void{
            super.update();
            bg.y -= .5;

            planet.scale.x += .05;
            planet.scale.y += .05;
            planet.x -= .5;
            planet.y += 2;

            if(planets_visited >= 3){
                FlxG.switchState(new OutroState());
            }

            if(new Date().valueOf() - startTime.valueOf() > 4000){
                black_bg.alpha += .1;
            }
            if(black_bg.alpha == 1){
                FlxG.switchState(new PlayState(planets_visited,plushies_delivered));
            }
        }
    }
}
