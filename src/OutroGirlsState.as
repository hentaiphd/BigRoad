package{
    import org.flixel.*;

    public class OutroGirlsState extends FlxState{
        [Embed(source="../assets/frontsteps.png")] private var ImgAptBg:Class;
        [Embed(source="../assets/ambience.mp3")] private var SndAmbience:Class;
        [Embed(source="../assets/outro_text_1.png")] private var ImgText:Class;

        public var apt_bg:FlxSprite;
        public var outro_text_1:FlxSprite;

        public var startTime:Date;

        public function OutroGirlsState():void{
            //make variable ending
        }

        override public function create():void{
            FlxG.mouse.hide();
            startTime = new Date();

            apt_bg = new FlxSprite(0,0);
            apt_bg.loadGraphic(ImgAptBg,true,false,320,480);
            apt_bg.addAnimation("no_bubble",[0],12,false);
            apt_bg.addAnimation("friend_bubble",[1],12,false);
            apt_bg.addAnimation("girl_bubble",[2],12,false);
            this.add(apt_bg);
            apt_bg.play("no_bubble");

            outro_text_1 = new FlxSprite(95,82);
            outro_text_1.loadGraphic(ImgText,false,false,209,11);
            this.add(outro_text_1);
            outro_text_1.alpha = 0;

            FlxG.music.stop();
            FlxG.play(SndAmbience, .7);
        }

        override public function update():void{
            super.update();
            if(new Date().valueOf() - startTime.valueOf() > 2000){
                apt_bg.play("girl_bubble");
                outro_text_1.alpha += .01;
            }
            if(new Date().valueOf() - startTime.valueOf() > 10000){
                FlxG.switchState(new MenuState());
            }
        }
    }
}
