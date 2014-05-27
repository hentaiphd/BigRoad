package{
    import org.flixel.*;

    public class MenuState extends FlxState{

        override public function create():void{
            FlxG.mouse.hide();

            var t1:FlxText;
            t1 = new FlxText(20,140,FlxG.width/2,"Click on the box to grab a bulb. Click and drag potpourri to stuff it.");
            add(t1);

            var t2:FlxText;
            t2 = new FlxText(20,220,FlxG.width,"Click to play.");
            add(t2);
        }

        override public function update():void{
            super.update();
        }
    }
}
