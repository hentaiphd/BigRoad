package{
    import org.flixel.*;

    public class MenuState extends FlxState{

        override public function create():void{
            FlxG.mouse.hide();

            var t2:FlxText;
            t2 = new FlxText(20,220,FlxG.width,"Click to play.");
            add(t2);
        }

        override public function update():void{
            super.update();

            if(FlxG.mouse.pressed()){
                FlxG.switchState(new PlayState());
            }
        }
    }
}
