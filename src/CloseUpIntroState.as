package{
    import org.flixel.*;

    public class CloseUpIntroState extends FlxState{
        [Embed(source="../assets/space1.png")] private var ImgBg:Class;
        [Embed(source="../assets/truckfront.png")] private var ImgTruck:Class;
        [Embed(source="../assets/holopres.png")] private var ImgDashPres:Class;
        [Embed(source="../assets/holopresface.png")] private var ImgPres:Class;
        [Embed(source="../assets/spacedad.mp3")] private var SndBGM:Class;
        [Embed(source="../assets/hologram2.mp3")] private var SndHolo:Class;
        [Embed(source="../assets/pres_text_1.png")] private var ImgText1:Class;
        [Embed(source="../assets/pres_text_2.png")] private var ImgText2:Class;
        [Embed(source="../assets/pres_text_3.png")] private var ImgText3:Class;
        [Embed(source="../assets/pres_text_4.png")] private var ImgText4:Class;

        public var now:Date;
        public var startTime:Date;

        public var bg:FlxSprite;
        public var truck:FlxSprite;
        public var dash_pres:FlxSprite;
        public var pres_icon:FlxSprite;
        public var pres_box:FlxSprite;

        public static const _fps:Number = 50;
        public var last_switch_time:Number = 0;
        public var time_frame:Number = 0;

        public var pres_text_1:FlxSprite;
        public var pres_text_2:FlxSprite;
        public var pres_text_3:FlxSprite;
        public var pres_text_4:FlxSprite;
        public var current_text:Number = 0;
        public var float:String = "up";

        public var sndLock:Boolean = false;

        public var debug_text:FlxText;

        public var _screen:ScreenManager;

        override public function create():void{
            _screen = ScreenManager.getInstance();
            FlxG.mouse.hide();
            startTime = new Date();

            bg = new FlxSprite(_screen.zero_point.x, _screen.zero_point.y);
            bg.loadGraphic(ImgBg,false,false,320,480);
            this.add(bg);

            truck = new FlxSprite(_screen.zero_point.x, _screen.zero_point.y);
            truck.loadGraphic(ImgTruck,true,false,320,240);
            truck.addAnimation("looking",[1],12,false);
            truck.addAnimation("looking_away",[0],12,false);
            truck.play("looking_away");
            this.add(truck);

            dash_pres = new FlxSprite(_screen.zero_point.x+50, _screen.zero_point.y+40);
            dash_pres.loadGraphic(ImgDashPres,true,false,31,76);
            dash_pres.addAnimation("flicker",[0,1,2,3],12,true);
            dash_pres.play("flicker");
            this.add(dash_pres);
            dash_pres.alpha = 0;

            pres_box = new FlxSprite(_screen.zero_point.x+20, _screen.zero_point.y+160);
            pres_box.makeGraphic(290,63,0xff000000);
            this.add(pres_box);
            pres_box.alpha = 0;

            pres_icon = new FlxSprite(_screen.zero_point.x+20, _screen.zero_point.y+150);
            pres_icon.loadGraphic(ImgPres,false,false,63,73);
            this.add(pres_icon);
            pres_icon.alpha = 0;

            if(FlxG.music == null){
                FlxG.playMusic(SndBGM);
            } else {
                FlxG.music.resume();
                if(!FlxG.music.active){
                    FlxG.playMusic(SndBGM);
                }
            }

            pres_text_1 = new FlxSprite(pres_box.x+70,pres_box.y+3);
            pres_text_1.loadGraphic(ImgText1,false,false,198,40);
            this.add(pres_text_1);
            pres_text_1.alpha = 0;

            pres_text_2 = new FlxSprite(pres_box.x+70,pres_box.y+3);
            pres_text_2.loadGraphic(ImgText2,false,false,202,38);
            this.add(pres_text_2);
            pres_text_2.alpha = 0;

            pres_text_3 = new FlxSprite(pres_box.x+70,pres_box.y+3);
            pres_text_3.loadGraphic(ImgText3,false,false,212,40);
            this.add(pres_text_3);
            pres_text_3.alpha = 0;

            pres_text_4 = new FlxSprite(pres_box.x+70,pres_box.y+3);
            pres_text_4.loadGraphic(ImgText4,false,false,214,54);
            this.add(pres_text_4);
            pres_text_4.alpha = 0;

            debug_text = new FlxText(10,10,500,"");
            this.add(debug_text);

            _screen.addLetterbox();
        }

        override public function update():void{
            super.update();
            time_frame++;

            if(bg.y < _screen.zero_point.y-10){
                float = "down";
            } else if(bg.y > _screen.zero_point.y+10){
                float = "up";
            }

            if(float == "up"){
                bg.y -= .1;
            }
            if(float == "down"){
                bg.y += .1;
            }

            if(new Date().valueOf() - startTime.valueOf() > 2000){
                truck.play("looking");
                dash_pres.alpha += .01;
                if (!sndLock) {
                    FlxG.play(SndHolo);
                    sndLock = true;
                }
            }

            if(new Date().valueOf() - startTime.valueOf() > 4000){
                pres_icon.alpha += .01;
                if(pres_box.alpha < .75){
                    pres_box.alpha += .01;
                }
                if(current_text < 1){
                    current_text++;
                    last_switch_time = time_frame;
                }
            }

            if(current_text >= 1){
                if(FlxG.mouse.justPressed() || time_frame - last_switch_time > 5*_fps){
                    current_text++;
                    last_switch_time = time_frame;
                }
            }

            if(current_text == 1){
                pres_text_1.alpha += .1;
            } else if(current_text == 2){
                pres_text_1.alpha -= .1
                pres_text_2.alpha += .1;
            } else if(current_text == 3){
                pres_text_2.alpha -= .1;
                pres_text_3.alpha += .1;
            } else if(current_text == 4){
                pres_text_3.alpha -= .1;
                pres_text_4.alpha += .1;
            } else if(current_text == 5){
                FlxG.switchState(new DriveState(0,0,BigRoad.total_time));
            }
        }
    }
}
