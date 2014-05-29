package{
    import org.flixel.*;

    public class IntroState extends FlxState{

        override public function create():void{
            FlxG.mouse.hide();

            var t2:FlxText;
            t2 = new FlxText(20,200,500,"You're a little girl. Your dad left you. You're sitting on the steps of your apartment building, wondering where he is and what he's doing. He's probably in space.\n\nHe'd come home if he ran out of money. Or if he was away for too long... right?\n\nLEFT or RIGHT to fly.");
            t2.size = 14;
            add(t2);
        }

        override public function update():void{
            super.update();

            if(FlxG.keys.LEFT || FlxG.keys.RIGHT){
                FlxG.switchState(new PlayState());
            }
        }
    }
}
