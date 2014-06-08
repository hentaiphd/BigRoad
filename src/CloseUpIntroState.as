package{
    import org.flixel.*;

    public class CloseUpIntroState extends FlxState{
        [Embed(source="../assets/space1.png")] private var ImgBg:Class;
        [Embed(source="../assets/truckfront.png")] private var ImgTruck:Class;
        [Embed(source="../assets/holopres.png")] private var ImgDashPres:Class;
        [Embed(source="../assets/holopresface.png")] private var ImgPres:Class;
        [Embed(source="../assets/spacedad.mp3")] private var SndBGM:Class;
        [Embed(source="../assets/nulshock.ttf", fontFamily="nulshock", embedAsCFF="false")] public var FontHud:String;

        public var now:Date;
        public var startTime:Date;

        public var bg:FlxSprite;
        public var truck:FlxSprite;
        public var dash_pres:FlxSprite;
        public var pres_icon:FlxSprite;
        public var pres_box:FlxSprite;

        public var pres_text:FlxText;
        public var current_text:Number = 0;
        public var float:String = "up";

        public var debug_text:FlxText;

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

            if(FlxG.music == null){
                FlxG.playMusic(SndBGM);
            } else {
                FlxG.music.resume();
                if(!FlxG.music.active){
                    FlxG.playMusic(SndBGM);
                }
            }

            pres_text = new FlxText(pres_box.x+70,pres_box.y+3,190,"");
            //pres_text.setFormat("nulshock");
            pres_text.size = 8;
            pres_text.color = 0xffffffff;
            this.add(pres_text);
            pres_text.alpha = 0;

            debug_text = new FlxText(10,10,500,"");
            this.add(debug_text);
        }

        override public function update():void{
            super.update();
            debug_text.text = current_text + "";

            if(bg.y < -10){
                float = "down";
            } else if(bg.y > 10){
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
            }

            if(new Date().valueOf() - startTime.valueOf() > 4000){
                pres_icon.alpha += .01;
                if(pres_box.alpha < .75){
                    pres_box.alpha += .01;
                }
                if(current_text < 1){
                    current_text++;
                }
            }

            if(current_text >= 1){
                if(FlxG.mouse.justPressed()){
                    current_text++;
                }
            }

            if(current_text == 1){
                pres_text.alpha += .01;
                pres_text.text = "Space Dad... I have a very important mission for you.";
            } else if(current_text == 2){
                pres_text.text = "I have received secret intelligence that the Bee Empire is planning an assault.";
            } else if(current_text == 3){
                pres_text.text = "The people of our star system need encouragement and support during these trying times.";
            } else if(current_text == 4){
                pres_text.text = "Space Dad... these plushies are a symbol of hope and love. Please take them into your space truck, and deliver them to our people.";
            } else if(current_text == 5){
                FlxG.switchState(new PlayState());
            }
        }
    }
}
