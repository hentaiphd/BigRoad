package{
    import org.flixel.*;

    public class CloseUpIntroState extends FlxState{
        [Embed(source="../assets/space1.png")] private var ImgBg:Class;
        [Embed(source="../assets/truckfront.png")] private var ImgTruck:Class;
        [Embed(source="../assets/holopres.png")] private var ImgDashPres:Class;
        [Embed(source="../assets/holopresface.png")] private var ImgPres:Class;
        public var now:Date;
        public var startTime:Date;

        public var bg:FlxSprite;
        public var truck:FlxSprite;
        public var dash_pres:FlxSprite;
        public var pres_icon:FlxSprite;
        public var pres_box:FlxSprite;

        override public function create():void{
            FlxG.mouse.hide();
            startTime = new Date();

            bg = new FlxSprite(0,0);
            bg.loadGraphic(ImgBg,false,false,320,480);
            this.add(bg);

            truck = new FlxSprite(0,0);
            truck.loadGraphic(ImgTruck,true,false,320,240);
            truck.addAnimation("looking",[1],12,false);
            truck.addAnimation("looking_away",[0],12,false);
            truck.play("looking_away");
            this.add(truck);

            dash_pres = new FlxSprite(50,40);
            dash_pres.loadGraphic(ImgDashPres,true,false,31,76);
            dash_pres.addAnimation("flicker",[0,1,2,3],12,true);
            dash_pres.play("flicker");
            this.add(dash_pres);
            dash_pres.alpha = 0;

            pres_box = new FlxSprite(20,160);
            pres_box.makeGraphic(270,63,0xff000000);
            this.add(pres_box);
            pres_box.alpha = 0;

            pres_icon = new FlxSprite(20,150);
            pres_icon.loadGraphic(ImgPres,false,false,63,73);
            this.add(pres_icon);
            pres_icon.alpha = 0;

        }

        override public function update():void{
            super.update();

            if(new Date().valueOf() - startTime.valueOf() > 2000){
                truck.play("looking");
                dash_pres.alpha += .01;
            }

            if(new Date().valueOf() - startTime.valueOf() > 4000){
                pres_icon.alpha += .01;
                if(pres_box.alpha < .75){
                    pres_box.alpha += .01;
                }
            }

            if(new Date().valueOf() - startTime.valueOf() > 10000){
                FlxG.switchState(new IntroState());
            }

        }
    }
}