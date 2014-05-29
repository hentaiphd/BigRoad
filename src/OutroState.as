package{
    import org.flixel.*;

    public class OutroState extends FlxState{

        override public function create():void{
            FlxG.mouse.hide();

            var t2:FlxText;
            t2 = new FlxText(20,200,FlxG.width,"You're still alone, sitting on the steps of your apartment building. Still daydreaming.\n SPACE to return to start screen.");
            t2.size = 14;
            add(t2);
        }

        override public function update():void{
            super.update();

            if(FlxG.keys.SPACE){
                FlxG.switchState(new PlayState());
            }
        }
    }
}